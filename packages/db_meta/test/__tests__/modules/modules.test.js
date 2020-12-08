import { getConnections } from '../../utils';
import { initDatabase } from '../../utils/helpers';
import modules from '../../utils/modules';
import { snapshot } from '../../utils/snaps';

let db, dbs, conn, mods, admin, api, sup, teardown;
const objs = {
  tables: {},
  modules: {}
};

const getOutputs = async (newmodule) =>
  (
    await mods.public.select('module_output', ['name', 'value'], {
      module_id: newmodule.id
    })
  ).reduce((m, v) => {
    m[v.name] = v.value;
    return m;
  }, {});

const checkOutputs = async (newmodule) => {
  const outputs = await getOutputs(newmodule);
  expect(snapshot(outputs)).toMatchSnapshot();
};

const installModule = async (name, data) => {
  const [newmodule] = await mods.public.callAny('install_module', {
    database_id: objs.database1.id,
    module_defn_id: objs.modules[name].id,
    context: 'sql',
    data
  });
  return newmodule;
};

beforeAll(async () => {
  ({ db, conn, teardown } = await getConnections());
  await db.begin();
  await db.savepoint('db');
  dbs = db.helper('collections_public');
  await initDatabase({ objs, dbs, dbname: 'simpledb' });

  admin = {
    public: db.helper('collections_public'),
    private: db.helper('collections_private')
  };
  mods = {
    public: db.helper('modules_public'),
    private: db.helper('modules_private')
  };

  await modules({ objs, mods });

  api = {
    public: conn.helper(objs.database1.schema_name),
    private: conn.helper(objs.database1.private_schema_name)
  };
  sup = {
    public: db.helper(objs.database1.schema_name),
    private: db.helper(objs.database1.private_schema_name)
  };
});

afterAll(async () => {
  try {
    await db.rollback('db');
    await db.commit();
    await teardown();
  } catch (e) {
    console.log(e);
  }
});

beforeEach(async () => {
  await db.savepoint('each');
});
afterEach(async () => {
  await db.rollback('each');
});

it('list deps', async () => {
  const deps = await mods.private.callAny('get_all_module_deps', {
    module_defn_id: objs.modules.crypto_auth_module.id
  });
  const ds = deps.map((dep) => dep.name).sort();
  expect(ds).toMatchSnapshot();
});

it('cannot install w/o deps', async () => {
  await db.savepoint('error1');
  let failed = false;
  let message = '';
  try {
    await mods.public.insertOne('modules', {
      database_id: objs.database1.id,
      module_defn_id: objs.modules.tokens_module.id,
      context: 'sql'
    });
  } catch (e) {
    message = e.message;
    failed = true;
  }
  expect(failed).toBe(true);
  expect(message).toEqual('MISSING_REQUIRED_MODULE: users_module');
  await db.rollback('error1');
});

it('immutable_field_utils_module', async () => {
  const mod = await installModule('immutable_field_utils_module');
  await checkOutputs(mod);
});

it('immutable_field_module', async () => {
  await installModule('immutable_field_utils_module');
  const tbl = await admin.public.insertOne('table', {
    database_id: objs.database1.id,
    schema_id: objs.database1.schemas.public.id,
    name: 'immutable_fields_table'
  });
  await admin.public.insertOne('field', {
    table_id: tbl.id,
    name: 'id',
    type: 'serial'
  });
  const value_on_insert = await admin.public.insertOne('field', {
    table_id: tbl.id,
    name: 'value_on_insert',
    type: 'text'
  });
  const null_on_insert = await admin.public.insertOne('field', {
    table_id: tbl.id,
    name: 'null_on_insert',
    type: 'text'
  });

  await installModule('immutable_field_module', {
    field_id: value_on_insert.id
  });

  await installModule('immutable_field_module', {
    field_id: null_on_insert.id
  });

  await sup.public.insertOne('immutable_fields_table', {
    value_on_insert: 'test-immutable',
    null_on_insert: null
  });

  // NOTE
  // we may still need the verify function

  const rows1 = await sup.public.select('immutable_fields_table', ['*']);
  expect(rows1).toMatchSnapshot();
  await sup.public.update(
    'immutable_fields_table',
    {
      null_on_insert: 'updated-value'
    },
    {
      id: 1
    }
  );
  const rows2 = await sup.public.select('immutable_fields_table', ['*']);
  expect(rows2).toMatchSnapshot();
  let fail = false;
  let message;
  await db.savepoint('error2');
  try {
    await sup.public.update(
      'immutable_fields_table',
      {
        null_on_insert: 'updated-value2'
      },
      {
        id: 1
      }
    );
  } catch (e) {
    fail = true;
    message = e.message;
  }
  expect(fail).toBe(true);
  expect(message).toEqual('IMMUTABLE_PROPERTY null_on_insert');
  await db.rollback('error2');
  await db.savepoint('error3');
  fail = false;
  message = '';
  try {
    await sup.public.update(
      'immutable_fields_table',
      {
        value_on_insert: 'updated-value2'
      },
      {
        id: 1
      }
    );
  } catch (e) {
    fail = true;
    message = e.message;
  }
  expect(fail).toBe(true);
  expect(message).toEqual('IMMUTABLE_PROPERTY value_on_insert');
  await db.rollback('error3');
});

it('encrypted_secrets_utils_module', async () => {
  const mod = await installModule('encrypted_secrets_utils_module');
  await checkOutputs(mod);
});

it('encrypted_secrets_encrypt_field_module', async () => {
  await installModule('encrypted_secrets_utils_module');
  /*

NOTES:

currently it's BEST if

* crypt uses text fields
* pgp uses bytea fields

** pgp can technically use both, but bytea is more "Natural"

** crypt as bytea will not be able to verify yet until we make a verify fn that uses

    prv.encrypt_field_bytea_to_text(crypt_bytea_field) =
    crypt($1::bytea::text, prv.encrypt_field_bytea_to_text(crypt_bytea_field)) as result

WHICH IS WAYYY TO COMPLEX.

So, for now, just force crypt = text, pgp = bytea ;)

*/

  const tbl = await admin.public.insertOne('table', {
    database_id: objs.database1.id,
    schema_id: objs.database1.schemas.public.id,
    name: 'new_secrets_tbl'
  });
  const pgp_field = await admin.public.insertOne('field', {
    table_id: tbl.id,
    name: 'pgp_field',
    type: 'bytea'
  });
  const pgp_text_field = await admin.public.insertOne('field', {
    table_id: tbl.id,
    name: 'pgp_text_field',
    type: 'text'
  });
  const crypt_field = await admin.public.insertOne('field', {
    table_id: tbl.id,
    name: 'crypt_field',
    type: 'text'
  });
  const crypt_bytea_field = await admin.public.insertOne('field', {
    table_id: tbl.id,
    name: 'crypt_bytea_field',
    // type: 'bytea'
    type: 'text'
  });
  const owner_id = await admin.public.insertOne('field', {
    table_id: tbl.id,
    name: 'owner_id',
    type: 'uuid'
  });

  await installModule('encrypted_secrets_getter_module', {
    table_id: tbl.id,
    owned_field: 'owner_id'
  });

  await installModule('encrypted_secrets_setter_module', {
    table_id: tbl.id,
    owned_field: 'owner_id'
  });

  await installModule('encrypted_secrets_verify_module', {
    table_id: tbl.id,
    owned_field: 'owner_id'
  });

  await installModule('encrypted_secrets_encrypt_field_module', {
    field_id: pgp_field.id,
    encode_field_id: owner_id.id,
    encryption_type: 'pgp'
  });

  await installModule('encrypted_secrets_encrypt_field_module', {
    field_id: pgp_text_field.id,
    encode_field_id: owner_id.id,
    encryption_type: 'pgp'
  });

  await installModule('encrypted_secrets_encrypt_field_module', {
    field_id: crypt_field.id,
    encryption_type: 'crypt'
  });

  await installModule('encrypted_secrets_encrypt_field_module', {
    field_id: crypt_bytea_field.id,
    encryption_type: 'crypt'
  });

  await sup.public.insertOne('new_secrets_tbl', {
    pgp_field: 'hello-encryption',
    pgp_text_field: 'hello-encryption',
    crypt_field: 'hello-encryption',
    crypt_bytea_field: 'hello-encryption',
    owner_id: objs.database1.id // any uuid
  });

  const [{ result: res1 }] = await db.any(
    `SELECT
    crypt_field = crypt($1, crypt_field) as result
       FROM
       "${objs.database1.schema_name}".new_secrets_tbl`,
    ['hello-encryption']
  );

  expect(res1).toBe(true);

  // const [{result: res2}] = await db.any(`SELECT
  // "${objs.database1.private_schema_name}".encrypt_field_bytea_to_text(crypt_bytea_field) = crypt($1::bytea::text, "${objs.database1.private_schema_name}".encrypt_field_bytea_to_text(crypt_bytea_field)) as result
  //    FROM
  //    "${objs.database1.schema_name}".new_secrets_tbl`, ['hello-encryption']);

  // expect(res2).toBe(true);

  const [{ encrypt_field_pgp_get: pgpres1 }] = await db.any(`SELECT
      "${objs.database1.private_schema_name}".encrypt_field_pgp_get(pgp_field, owner_id::text)
       FROM
       "${objs.database1.schema_name}".new_secrets_tbl`);

  expect(pgpres1).toMatchSnapshot();

  const [{ encrypt_field_pgp_get: pgpres2 }] = await db.any(`SELECT
      "${objs.database1.private_schema_name}".encrypt_field_pgp_get(pgp_text_field::bytea, owner_id::text)
       FROM
       "${objs.database1.schema_name}".new_secrets_tbl`);

  expect(pgpres2).toMatchSnapshot();
});

it('default_ids_module', async () => {
  const mod = await installModule('default_ids_module');
  await getOutputs(mod);
});

it('create_table_module', async () => {
  await installModule('default_ids_module');
  const mod = await installModule('create_table_module', {
    table_name: 'table_with_uuid'
  });
  await getOutputs(mod);
});

it('create_serial_table_module', async () => {
  await installModule('default_ids_module');
  const mod = await installModule('create_table_module', {
    table_name: 'table_with_serial',
    pk_type: 'serial'
  });
  await sup.public.insertOne('table_with_serial');
  await sup.public.insertOne('table_with_serial');
  const val = await sup.public.insertOne('table_with_serial');
  expect(val).toMatchSnapshot();
  await getOutputs(mod);
});

it('uuid_module', async () => {
  const newmodule = await installModule('uuid_module');
  await checkOutputs(newmodule);
});

it('users_modules', async () => {
  const newmodule = await installModule('users_module', {
    table_name: 'users'
  });
  await checkOutputs(newmodule);
});

it('secrets_module', async () => {
  const usermodule = await installModule('users_module', {
    table_name: 'users'
  });
  const userouts = await getOutputs(usermodule);
  const secretsmodule = await installModule('secrets_module', {
    secrets_table: 'user_secrets',
    owned_table_id: userouts.table_id
  });
  await checkOutputs(secretsmodule);
});

it('tokens_module', async () => {
  await installModule('users_module');
  const tokensmod = await installModule('tokens_module');
  await checkOutputs(tokensmod);
});

it('crypto_module', async () => {
  const usermodule = await installModule('users_module', {
    table_name: 'users'
  });
  const userouts = await getOutputs(usermodule);
  await installModule('tokens_module');
  await installModule('secrets_module', {
    owned_table_id: userouts.table_id,
    secrets_table: 'user_secrets'
  });
  const cryptomod = await installModule('crypto_auth_module', {
    user_field: 'bitg_address',
    crypto_network: 'BITG',
    sign_up_unique_key: 'sign_up_with_bitg_address'
  });
  await checkOutputs(cryptomod);
});

it('rls', async () => {
  await installModule('users_module');
  await installModule('tokens_module');
  const rlsmod = await installModule('rls_module');
  await checkOutputs(rlsmod);
});

it('peoplestamps', async () => {
  await installModule('users_module');
  await installModule('tokens_module');
  await installModule('rls_module');
  const mod = await installModule('peoplestamps_module');
  await checkOutputs(mod);
});

it('peoplestamps table', async () => {
  await installModule('users_module');
  await installModule('tokens_module');
  await installModule('rls_module');
  await installModule('peoplestamps_module');
  const tbl = await admin.public.insertOne('table', {
    database_id: objs.database1.id,
    schema_id: objs.database1.schemas.public.id,
    name: 'peoplestamped_table'
  });
  const mod = await installModule('table_peoplestamps_module', {
    table_id: tbl.id
  });
  await checkOutputs(mod);
});

it('timestamps', async () => {
  const mod = await installModule('timestamps_module');
  await checkOutputs(mod);
});

it('timestamps table', async () => {
  await installModule('timestamps_module');
  const tbl = await admin.public.insertOne('table', {
    database_id: objs.database1.id,
    schema_id: objs.database1.schemas.public.id,
    name: 'timestamped_table'
  });
  const mod = await installModule('table_timestamps_module', {
    table_id: tbl.id
  });
  await checkOutputs(mod);
});

it('emails_module', async () => {
  await installModule('users_module');
  const mod = await installModule('emails_module');
  await checkOutputs(mod);
});

it('encrypted_secrets_module', async () => {
  await installModule('users_module');
  const mod = await installModule('encrypted_secrets_module');
  await checkOutputs(mod);
});

it('user_auth_module', async () => {
  await installModule('jobs_module');
  const usermod = await installModule('users_module');
  await installModule('tokens_module');
  await installModule('rls_module');
  const userouts = await getOutputs(usermod);
  await installModule('secrets_module', {
    secrets_table: 'user_secrets',
    owned_table_id: userouts.table_id
  });
  await installModule('encrypted_secrets_module');
  await installModule('emails_module');

  const mod = await installModule('user_auth_module');
  await checkOutputs(mod);
});

it('jobs_module', async () => {
  const mod = await installModule('jobs_module');
  await checkOutputs(mod);
});

it('jobs_trigger_module', async () => {
  await installModule('jobs_module');

  const tbl = await admin.public.insertOne('table', {
    database_id: objs.database1.id,
    schema_id: objs.database1.schemas.public.id,
    name: 'jobs_trigger_table'
  });

  const mod = await installModule('jobs_trigger_module', {
    table_id: tbl.id,
    job_name: 'my-custom-fn'
  });
  await checkOutputs(mod);
});

it('invites_module', async () => {
  await installModule('jobs_module');
  await installModule('users_module');
  await installModule('emails_module');
  await installModule('tokens_module');
  await installModule('rls_module');
  const mod = await installModule('invites_module');
  await checkOutputs(mod);
});
