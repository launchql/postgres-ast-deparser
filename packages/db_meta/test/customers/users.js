import { initDatabase, updateSchemas } from '../utils/helpers';
import * as ast from 'pg-ast';

export const USER_SECRETS_TABLE = 'user_secrets';
export const ORG_SETTINGS_TABLE = 'organization_settings';
export const USER_ENCRYPTED_SECRETS_TABLE = 'user_encrypted_secrets';
export const USER_TOKENS_TABLE = 'api_tokens';
export const EMAILS_TABLE = 'emails';
export const USER_TABLE = 'users';
export const GET_CURRENT_ROLE = 'get_current_user';
export const GET_CURRENT_ROLE_ID = 'get_current_user_id';
export const GET_CURRENT_GROUP_IDS = 'get_current_group_ids';
export const AUTH_FUNCTION = 'authenticate';
export const object_key_id = 'user_id';
export const object_key_ids = 'group_ids';

import { makeApi, str } from '../utils/helpers';
import modules from '../utils/modules';
const all = [
  ['select', 'authenticated'],
  ['insert', 'authenticated'],
  ['update', 'authenticated'],
  ['delete', 'authenticated']
];
const read = [['select', 'authenticated']];
const edit = [
  ['insert', 'authenticated'],
  ['update', 'authenticated'],
  ['delete', 'authenticated']
];

export default async ({ objs, db }) => {
  const dbs = db.helper('collections_public');
  await initDatabase({ objs, dbs, dbname: 'users' });
  const mods = {
    public: db.helper('modules_public'),
    private: db.helper('modules_private')
  };
  await modules({ objs, mods });
  const installModule = async (name, data) => {
    const [newmodule] = await mods.public.callAny('install_module', {
      database_id: objs.database1.id,
      module_defn_id: objs.modules[name].id,
      context: 'sql',
      data
    });
    return newmodule;
  };
  const registerTable = async (name) => {
    objs.tables[name] = await dbs.selectOne('table', ['*'], {
      name
    });
  };
  const { addForeignKey, addUnique, createTable, applyRLS } = makeApi({
    objs,
    dbs,
    db
  });

  await installModule('jobs_module', {
    use_extension: true
  });
  await updateSchemas({ objs, dbs, database_id: objs.database1.id });

  // utils
  await installModule('default_ids_module');
  await installModule('uuid_module', {
    seeded_uuid_seed: 'launchql'
  });
  // users
  await installModule('users_module', {
    users_table: USER_TABLE
  });
  await registerTable(USER_TABLE);
  await dbs.insertOne('field', {
    table_id: objs.tables[USER_TABLE].id,
    name: 'type',
    type: 'int',
    default_value: '0'
  });

  // await dbs.insertOne('field', {
  //   table_id: objs.tables[USER_TABLE].id,
  //   name: 'username',
  //   type: 'text',
  //   max: 128,
  //   description: 'username'
  // });

  // await addUnique({
  //   table_name: USER_TABLE,
  //   field_names: ['username'],
  //   omit: true
  // });

  // secrets
  await installModule('secrets_module', {
    secrets_table: USER_SECRETS_TABLE,
    owned_table_id: objs.tables[USER_TABLE].id
  });
  await registerTable(USER_SECRETS_TABLE);

  // tokens
  await installModule('tokens_module', {
    tokens_table: USER_TOKENS_TABLE,
    tokens_default_expiration: '30 days'
  });
  await registerTable(USER_TOKENS_TABLE);

  // encrypted
  await installModule('encrypted_secrets_module', {
    secrets_table: USER_ENCRYPTED_SECRETS_TABLE,
    owned_table_id: objs.tables[USER_TABLE].id
  });
  await registerTable(USER_ENCRYPTED_SECRETS_TABLE);

  // utils
  await installModule('immutable_field_utils_module');

  // rls
  await installModule('rls_module', {
    authenticate: AUTH_FUNCTION,
    current_role: GET_CURRENT_ROLE,
    current_role_id: GET_CURRENT_ROLE_ID,
    current_group_ids: GET_CURRENT_GROUP_IDS,
    role_key: object_key_id,
    role_keys: object_key_ids
  });

  // stamps
  await installModule('peoplestamps_module');
  await installModule('timestamps_module');

  // await installModule('user_status_module');

  // users
  await applyRLS({
    table_name: USER_TABLE,
    privs: edit,
    policy_template_name: 'own_records', // may need to be owned_records!!!
    policy_template_vars: {
      role_key: 'id'
    }
  });

  await applyRLS({
    table_name: USER_TABLE,
    privs: read,
    policy_template_name: 'open'
  });

  await applyRLS({
    table_name: USER_ENCRYPTED_SECRETS_TABLE,
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });
  await applyRLS({
    table_name: USER_SECRETS_TABLE,
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });

  await applyRLS({
    table_name: USER_TOKENS_TABLE,
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'user_id'
    }
  });

  // emails
  await installModule('emails_module', {
    emails_table: EMAILS_TABLE
  });
  await registerTable(EMAILS_TABLE);
  await applyRLS({
    table_name: EMAILS_TABLE,
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });

  // TODO why not key here?
  await addForeignKey({
    table_name: EMAILS_TABLE,
    field_name: 'owner_id',
    ref_table: USER_TABLE,
    index: true,
    create: false
  });

  // trigger for new accounts
  await installModule('jobs_trigger_module', {
    table_id: objs.tables[EMAILS_TABLE].id,
    job_name: 'new-user-email'
  });

  // user auth
  await installModule('user_auth_module');
};
