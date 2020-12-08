import { initDatabase, updateSchemas } from '../utils/helpers';

export const USER_SECRETS_TABLE = 'user_secrets';
export const USER_ENCRYPTED_SECRETS_TABLE = 'user_encrypted_secrets';
export const USER_TOKENS_TABLE = 'api_tokens';
export const USER_TABLE = 'users';
export const GET_CURRENT_ROLE = 'get_current_user';
export const GET_CURRENT_ROLE_ID = 'get_current_user_id';
export const GET_CURRENT_GROUP_IDS = 'get_current_group_ids';
export const AUTH_FUNCTION = 'authenticate';

const object_key_id = 'user_id';
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

import { makeApi } from '../utils/helpers';
import modules from '../utils/modules';

export default async ({ objs, db, conn }) => {
  const dbs = db.helper('collections_public');
  const utils = db.helper('db_migrate');
  const text = db.helper('db_text');
  await initDatabase({ objs, dbs, dbname: 'bitg' });
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

  const {
    enablePeopleStamps,
    enableTimestamps,
    addIndex,
    addForeignKey,
    addUnique,
    addTimestamps,
    addPeopleStamps,
    createTable,
    applyRLS
  } = makeApi({ objs, dbs, db });

  await installModule('jobs_module');
  await updateSchemas({ objs, dbs, database_id: objs.database1.id });

  await installModule('subdomain_module', {
    subdomain: 'api.bitg',
    is_public: true
  });

  await installModule('subdomain_module', {
    subdomain: 'admin.bitg',
    is_public: false
  });

  // utils
  await installModule('default_ids_module');
  await installModule('uuid_module', {
    seeded_uuid_seed: 'bitg'
  });

  // users
  await installModule('users_module', {
    users_table: USER_TABLE
  });
  await registerTable(USER_TABLE);

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

  await (async () => {
    // TODO make creation of the field optional?
    const username = await dbs.insertOne('field', {
      table_id: objs.tables[USER_TABLE].id,
      name: 'username',
      type: 'text'
    });

    await dbs.insertOne(
      'unique_constraint',
      {
        table_id: objs.tables[USER_TABLE].id,
        field_ids: [username.id]
      },
      { field_ids: 'uuid[]' }
    );
  })();

  await installModule('crypto_auth_module', {
    crypto_network: 'BITG',
    user_field: 'bitg_address',
    sign_up_unique_key: 'sign_up_with_bitg_address'
  });

  const bitgAddress = await dbs.selectOne('field', ['*'], {
    table_id: objs.tables[USER_TABLE].id,
    name: 'bitg_address'
  });

  // utils
  await installModule('immutable_field_utils_module');
  await installModule('immutable_field_module', {
    field_id: bitgAddress.id
  });

  // rls
  await installModule('rls_module', {
    authenticate: AUTH_FUNCTION,
    current_role: GET_CURRENT_ROLE,
    current_role_id: GET_CURRENT_ROLE_ID,
    current_group_ids: GET_CURRENT_GROUP_IDS
  });

  // stamps
  await installModule('peoplestamps_module');
  await installModule('timestamps_module');

  //   RLS template (requires current_role_id)

  await applyRLS({
    table_name: USER_TABLE,
    privs: edit,
    policy_template_name: 'own_records',
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

  // END RLS

  //   http://patorjk.com/software/taag/#p=display&f=Big&t=Users

  // LOGIN with this
  // https://github.com/bitcoinjs/bitcoinjs-message/blob/master/index.js

  //   _    _
  //  | |  | |
  //  | |  | |___  ___ _ __ ___
  //  | |  | / __|/ _ \ '__/ __|
  //  | |__| \__ \  __/ |  \__ \
  //   \____/|___/\___|_|  |___/

  await createTable({
    name: 'permissions',
    fields: [
      {
        name: 'name',
        type: 'text'
      }
    ],
    is_visible: false
  });

  await addIndex({ table_name: 'permissions', field_names: ['name'] });

  await addForeignKey({
    table_name: 'permissions',
    field_name: 'user_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true
  });

  await applyRLS({
    table_name: 'permissions',
    privs: [['select', 'public']],
    policy_template_name: 'open'
  });

  //                    _
  //                   | |
  //   _ __   __ _ _ __| |_ _ __   ___ _ __ ___
  //  | '_ \ / _` | '__| __| '_ \ / _ \ '__/ __|
  //  | |_) | (_| | |  | |_| | | |  __/ |  \__ \
  //  | .__/ \__,_|_|   \__|_| |_|\___|_|  |___/
  //  | |
  //  |_|

  await createTable({
    name: 'partners',
    fields: [
      {
        name: 'name',
        type: 'text'
      },
      {
        name: 'logo',
        type: 'text'
      },
      {
        name: 'image',
        type: 'text'
      },
      {
        name: 'description',
        type: 'text'
      },
      {
        name: 'bitg_address',
        type: 'text'
      },
      {
        name: 'owner_id',
        type: 'uuid',
        is_required: true
      }
    ]
  });

  await applyRLS({
    table_name: 'partners',
    privs: edit,
    policy_template_name: 'owned_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });

  await applyRLS({
    table_name: 'partners',
    privs: read,
    policy_template_name: 'open'
  });

  await applyRLS({
    table_name: 'partners',
    privs: [['select', 'anonymous']],
    policy_name: 'open',
    policy_template_name: 'open'
  });

  await applyRLS({
    table_name: 'partners',
    privs: [['insert', 'authenticated']],
    policy_name: 'perms',
    policy_template_name: 'permission_name',
    policy_template_vars: {
      permission_schema: objs.database1.private_schema_name,
      permission_table: 'permissions',
      permission_name_key: 'name',
      permission_role_key: 'user_id',
      this_value: 'can_create_partner'
    },
    permissive: false
  });

  //                                   _
  //                                  (_)
  //    ___ __ _ _ __ ___  _ __   __ _ _  __ _ _ __  ___
  //   / __/ _` | '_ ` _ \| '_ \ / _` | |/ _` | '_ \/ __|
  //  | (_| (_| | | | | | | |_) | (_| | | (_| | | | \__ \
  //   \___\__,_|_| |_| |_| .__/ \__,_|_|\__, |_| |_|___/
  //                      | |             __/ |
  //                      |_|            |___/

  await createTable({
    name: 'campaigns',
    fields: [
      {
        name: 'name',
        type: 'text'
      },
      {
        name: 'logo',
        type: 'text'
      },
      {
        name: 'image',
        type: 'text'
      },
      {
        name: 'description',
        type: 'text'
      },
      {
        name: 'start_date',
        type: 'timestamptz'
      },
      {
        name: 'end_date',
        type: 'timestamptz'
      }
    ]
  });

  await addForeignKey({
    table_name: 'campaigns',
    field_name: 'partner_id',
    ref_table: 'partners',
    index: true,
    is_required: true
  });

  await applyRLS({
    table_name: 'campaigns',
    privs: read,
    policy_template_name: 'open'
  });

  await applyRLS({
    table_name: 'campaigns',
    privs: [['select', 'anonymous']],
    policy_template_name: 'open'
  });

  await applyRLS({
    table_name: 'campaigns',
    privs: edit,
    policy_template_name: 'owned_object_records',
    policy_template_vars: {
      owned_schema: objs.database1.schema_name,
      owned_table: 'partners',
      owned_table_ref_key: 'id',
      owned_table_key: 'owner_id',
      this_object_key: 'partner_id'
    }
  });

  /*
                 _   _
                | | (_)
       __ _  ___| |_ _  ___  _ __  ___
      / _` |/ __| __| |/ _ \| '_ \/ __|
     | (_| | (__| |_| | (_) | | | \__ \
      \__,_|\___|\__|_|\___/|_| |_|___/

    */

  await createTable({
    name: 'campaign_actions',
    fields: [
      {
        name: 'name',
        type: 'text',
        is_required: true
      },
      {
        name: 'description',
        type: 'text'
      },
      {
        name: 'image',
        type: 'text'
      },
      {
        name: 'reward_unit',
        type: 'text'
      },
      {
        name: 'reward_amount',
        type: 'numeric'
      },
      {
        name: 'total_bitg_limit',
        type: 'numeric'
      },
      {
        name: 'action_weekly_limit',
        type: 'int'
      },
      {
        name: 'action_daily_limit',
        type: 'int'
      },
      {
        name: 'user_total_limit',
        type: 'int'
      },
      {
        name: 'user_weekly_limit',
        type: 'int'
      },
      {
        name: 'user_daily_limit',
        type: 'int'
      },
      {
        name: 'start_date',
        type: 'timestamptz'
      },
      {
        name: 'end_date',
        type: 'timestamptz'
      }
    ]
  });

  await addUnique({
    table_name: 'campaign_actions',
    field_names: ['name']
  });

  await addForeignKey({
    table_name: 'campaign_actions',
    field_name: 'campaign_id',
    ref_table: 'campaigns',
    index: true,
    is_required: true
  });

  await addForeignKey({
    table_name: 'campaign_actions',
    field_name: 'partner_id',
    ref_table: 'partners',
    index: true,
    is_required: true
  });

  await applyRLS({
    table_name: 'campaign_actions',
    privs: read,
    policy_template_name: 'open'
  });

  await applyRLS({
    table_name: 'campaign_actions',
    privs: [['select', 'anonymous']],
    policy_template_name: 'open'
  });

  await applyRLS({
    table_name: 'campaign_actions',
    privs: edit,
    policy_template_name: 'child_of_owned_object_records_with_ownership',
    policy_template_vars: {
      owned_schema: objs.database1.schema_name,
      owned_table: 'partners',
      owned_table_key: 'owner_id',
      owned_table_ref_key: 'id',

      object_schema: objs.database1.schema_name,
      object_table: 'campaigns',
      object_table_owned_key: 'partner_id',
      object_table_ref_key: 'id',

      this_owned_key: 'partner_id',
      this_object_key: 'campaign_id'
    }
  });

  //      _____                      _      _           _
  //     / ____|                    | |    | |         | |
  //    | |     ___  _ __ ___  _ __ | | ___| |_ ___  __| |
  //    | |    / _ \| '_ ` _ \| '_ \| |/ _ \ __/ _ \/ _` |
  //    | |___| (_) | | | | | | |_) | |  __/ ||  __/ (_| |
  //     \_____\___/|_| |_| |_| .__/|_|\___|\__\___|\__,_|
  //                          | |
  //                          |_|

  await createTable({
    name: 'completed_actions',
    fields: [
      {
        name: 'date_completed',
        type: 'timestamptz'
      },
      {
        name: 'txid',
        type: 'text'
      }
    ]
  });

  await addForeignKey({
    table_name: 'completed_actions',
    field_name: 'user_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true
  });

  await addForeignKey({
    table_name: 'completed_actions',
    field_name: 'action_id',
    ref_table: 'campaign_actions',
    index: true,
    is_required: true
  });

  await applyRLS({
    table_name: 'completed_actions',
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'user_id'
    }
  });

  //      _____                 _
  //     / ____|               (_)
  //    | (___   ___ _ ____   ___  ___ ___
  //     \___ \ / _ \ '__\ \ / / |/ __/ _ \
  //     ____) |  __/ |   \ V /| | (_|  __/
  //    |_____/ \___|_|    \_/ |_|\___\___|

  await createTable({
    name: 'services',
    fields: [
      {
        name: 'name',
        type: 'text'
      },
      {
        name: 'image',
        type: 'text'
      },
      {
        name: 'description',
        type: 'text'
      },
      {
        name: 'type',
        type: 'text'
      },
      {
        name: 'data',
        type: 'json'
      }
    ]
  });

  await addForeignKey({
    table_name: 'services',
    field_name: 'campaign_action_id',
    ref_table: 'campaign_actions',
    index: true
  });

  //                         | |               | |
  //  _ __ ___   ___ _ __ ___| |__   __ _ _ __ | |_ ___
  // | '_ ` _ \ / _ \ '__/ __| '_ \ / _` | '_ \| __/ __|
  // | | | | | |  __/ | | (__| | | | (_| | | | | |_\__ \
  // |_| |_| |_|\___|_|  \___|_| |_|\__,_|_| |_|\__|___/

  // https://docs.google.com/spreadsheets/d/11W_WTa0asFSdH70PZg12A2hvyNQHN7qAEU0czGblAg4/edit#gid=1192413871
  await createTable({
    name: 'merchants',
    fields: [
      {
        name: 'name',
        type: 'text'
      },
      {
        name: 'url',
        type: 'text'
      },
      {
        name: 'image',
        type: 'text'
      },
      {
        name: 'logo',
        type: 'text'
      },
      {
        name: 'description',
        type: 'text'
      },
      {
        name: 'owner_id',
        type: 'uuid',
        is_required: true
      }
    ]
  });

  await applyRLS({
    table_name: 'merchants',
    privs: edit,
    policy_template_name: 'owned_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });
  await applyRLS({
    table_name: 'merchants',
    privs: read,
    policy_template_name: 'open'
  });
  await applyRLS({
    table_name: 'merchants',
    privs: [['select', 'anonymous']],
    policy_template_name: 'open'
  });
  await applyRLS({
    table_name: 'merchants',
    privs: [['insert', 'authenticated']],
    policy_name: 'perms',
    policy_template_name: 'permission_name',
    policy_template_vars: {
      permission_schema: objs.database1.private_schema_name,
      permission_table: 'permissions',
      permission_name_key: 'name',
      permission_role_key: 'user_id',
      this_value: 'can_create_merchant'
    },
    permissive: false
  });

  //                     _            _
  //                     | |          | |
  //  _ __  _ __ ___   __| |_   _  ___| |_ ___
  // | '_ \| '__/ _ \ / _` | | | |/ __| __/ __|
  // | |_) | | | (_) | (_| | |_| | (__| |_\__ \
  // | .__/|_|  \___/ \__,_|\__,_|\___|\__|___/
  // | |
  // |_|

  await createTable({
    name: 'products',
    fields: [
      {
        name: 'name',
        type: 'text'
      },
      {
        name: 'image',
        type: 'text'
      },
      {
        name: 'url',
        type: 'text'
      }
    ]
  });

  await addForeignKey({
    table_name: 'products',
    field_name: 'merchant_id',
    ref_table: 'merchants',
    index: true,
    is_required: true
  });

  await applyRLS({
    table_name: 'products',
    privs: read,
    policy_template_name: 'open'
  });
  await applyRLS({
    table_name: 'products',
    privs: [['select', 'anonymous']],
    policy_template_name: 'open'
  });

  await applyRLS({
    table_name: 'products',
    privs: edit,
    policy_template_name: 'owned_object_records',
    policy_template_vars: {
      owned_schema: objs.database1.schema_name,
      owned_table: 'merchants',
      owned_table_ref_key: 'id',
      owned_table_key: 'owner_id',
      this_object_key: 'merchant_id'
    }
  });

  /*

                 _   _      _
                | | (_)    | |
       __ _ _ __| |_ _  ___| | ___  ___
      / _` | '__| __| |/ __| |/ _ \/ __|
     | (_| | |  | |_| | (__| |  __/\__ \
      \__,_|_|   \__|_|\___|_|\___||___/

    */

  // https://medium.com/bitgreen/appendix-to-the-bitgreen-ecosystem-whitepaper-79921e99a5a6
  // Image, header, description, link (no text, no content)

  await createTable({
    name: 'articles',
    fields: [
      {
        name: 'header',
        type: 'text'
      },
      {
        name: 'description',
        type: 'text'
      },
      {
        name: 'url',
        type: 'text'
      },
      {
        name: 'image',
        type: 'text'
      },
      {
        name: 'date_published',
        type: 'timestamptz'
      },
      {
        name: 'owner_id',
        type: 'uuid',
        is_required: true
      }
    ]
  });

  await applyRLS({
    table_name: 'articles',
    privs: read,
    policy_template_name: 'open'
  });

  await applyRLS({
    table_name: 'articles',
    privs: edit,
    policy_template_name: 'owned_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });

  await applyRLS({
    table_name: 'articles',
    privs: [['insert', 'authenticated']],
    policy_template_name: 'permission_name',
    policy_name: 'perms',
    policy_template_vars: {
      permission_schema: objs.database1.private_schema_name,
      permission_table: 'permissions',
      permission_name_key: 'name',
      permission_role_key: 'user_id',
      this_value: 'can_create_article'
    },
    permissive: false
  });

  await applyRLS({
    table_name: 'articles',
    privs: [['select', 'anonymous']],
    policy_template_name: 'open'
  });

  /*

      _            _
     | |          | |
     | |_ ___  ___| | __ _
     | __/ _ \/ __| |/ _` |
     | ||  __/\__ \ | (_| |
      \__\___||___/_|\__,_|

    */

  await createTable({
    name: 'tesla_accounts',
    fields: [
      {
        name: 'status',
        type: 'text'
      },
      {
        name: 'active',
        type: 'bool',
        is_required: true,
        default_value: 'false'
      }
    ]
  });

  await addForeignKey({
    table_name: 'tesla_accounts',
    field_name: 'owner_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true
  });

  await applyRLS({
    table_name: 'tesla_accounts',
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });

  await createTable({
    name: 'tesla_secrets',
    fields: [
      {
        name: 'access_token',
        type: 'bytea'
      },
      {
        name: 'refresh_token',
        type: 'bytea'
      }
    ],
    is_visible: false
  });

  await addForeignKey({
    table_name: 'tesla_secrets',
    field_name: 'account_id',
    ref_table: 'tesla_accounts',
    index: true,
    is_required: true
  });

  await addUnique({
    table_name: 'tesla_secrets',
    field_names: ['account_id']
  });

  await applyRLS({
    table_name: 'tesla_secrets',
    privs: all,
    policy_template_name: 'owned_object_records',
    policy_template_vars: {
      owned_schema: objs.database1.schema_name,
      owned_table: 'tesla_accounts',
      owned_table_ref_key: 'id',
      owned_table_key: 'owner_id',
      this_object_key: 'account_id'
    }
  });

  await installModule('jobs_trigger_module', {
    event_type: 'insert',
    include_fields: false,
    table_id: objs.tables['tesla_secrets'].id,
    job_name: 'tesla-create-account'
  });

  await installModule('jobs_trigger_module', {
    event_type: 'update',
    include_fields: false,
    table_id: objs.tables['tesla_secrets'].id,
    job_name: 'tesla-update-account'
  });

  // secret field triggers

  const account_id_field = await dbs.selectOne('field', ['*'], {
    table_id: objs.tables['tesla_secrets'].id,
    name: 'account_id'
  });

  const access_token_field = await dbs.selectOne('field', ['*'], {
    table_id: objs.tables['tesla_secrets'].id,
    name: 'access_token'
  });

  const refresh_token_field = await dbs.selectOne('field', ['*'], {
    table_id: objs.tables['tesla_secrets'].id,
    name: 'refresh_token'
  });

  // this is the extension
  // installs:
  // * encrypt_field_bytea_to_text
  // * encrypt_field_pgp_get
  // * encrypt_field_set
  await installModule('encrypted_secrets_utils_module');

  // installs:
  // * encrypt_field_pgp_getter
  await installModule('encrypted_secrets_getter_module', {
    table_id: objs.tables['tesla_secrets'].id,
    owned_field: 'account_id'
  });

  // installs:
  // * secrets_table_upsert
  await installModule('encrypted_secrets_setter_module', {
    table_id: objs.tables['tesla_secrets'].id,
    owned_field: 'account_id'
  });

  // installs:
  // * encrypt_field_crypt_verify
  await installModule('encrypted_secrets_verify_module', {
    table_id: objs.tables['tesla_secrets'].id,
    owned_field: 'account_id'
  });

  // installs either:
  // * encrypt_field_crypt
  // * encrypt_field_pgp
  await installModule('encrypted_secrets_encrypt_field_module', {
    field_id: access_token_field.id,
    encode_field_id: account_id_field.id,
    encryption_type: 'pgp'
  });
  await installModule('encrypted_secrets_encrypt_field_module', {
    field_id: refresh_token_field.id,
    encode_field_id: account_id_field.id,
    encryption_type: 'pgp'
  });

  /*
    _            _                   _     _      _
   | |          | |                 | |   (_)    | |
   | |_ ___  ___| | __ _  __   _____| |__  _  ___| | ___  ___
   | __/ _ \/ __| |/ _` | \ \ / / _ \ '_ \| |/ __| |/ _ \/ __|
   | ||  __/\__ \ | (_| |  \ V /  __/ | | | | (__| |  __/\__ \
    \__\___||___/_|\__,_|   \_/ \___|_| |_|_|\___|_|\___||___/

    */

  await createTable({
    name: 'tesla_vehicles',
    fields: [
      {
        name: 'tesla_id',
        type: 'text',
        is_required: true
      },
      {
        name: 'status',
        type: 'text'
      },
      {
        name: 'battery_level',
        type: 'numeric'
      },
      {
        name: 'charge_cycles',
        type: 'int'
      },
      {
        name: 'total_earned',
        type: 'numeric'
      }
    ],
    is_visible: true
  });

  await addForeignKey({
    table_name: 'tesla_vehicles',
    field_name: 'account_id',
    ref_table: 'tesla_accounts',
    index: true,
    is_required: true
  });

  await addUnique({
    table_name: 'tesla_vehicles',
    field_names: ['tesla_id']
  });

  await applyRLS({
    table_name: 'tesla_vehicles',
    privs: all,
    policy_template_name: 'owned_object_records',
    policy_template_vars: {
      owned_schema: objs.database1.schema_name,
      owned_table: 'tesla_accounts',
      owned_table_ref_key: 'id',
      owned_table_key: 'owner_id',
      this_object_key: 'account_id'
    }
  });

  /*
    _            _                                    _
   | |          | |                                  | |
   | |_ ___  ___| | __ _   _ __ ___  ___ ___  _ __ __| |___
   | __/ _ \/ __| |/ _` | | '__/ _ \/ __/ _ \| '__/ _` / __|
   | ||  __/\__ \ | (_| | | | |  __/ (_| (_) | | | (_| \__ \
    \__\___||___/_|\__,_| |_|  \___|\___\___/|_|  \__,_|___/

  */

  await createTable({
    name: 'tesla_records',
    fields: [
      {
        name: 'battery_level',
        type: 'numeric'
      },
      {
        name: 'charge_cycles',
        type: 'int'
      }
    ],
    is_visible: false
  });

  await addForeignKey({
    table_name: 'tesla_records',
    field_name: 'vehicle_id',
    ref_table: 'tesla_vehicles',
    index: true,
    is_required: true
  });

  await addForeignKey({
    table_name: 'tesla_records',
    field_name: 'account_id',
    ref_table: 'tesla_accounts',
    index: true,
    is_required: true
  });

  await applyRLS({
    table_name: 'tesla_records',
    privs: all,
    policy_template_name: 'owned_object_records',
    policy_template_vars: {
      owned_schema: objs.database1.schema_name,
      owned_table: 'tesla_accounts',
      owned_table_ref_key: 'id',
      owned_table_key: 'owner_id',
      this_object_key: 'account_id'
    }
  });

  /*
          _                 _  __
         | |               (_)/ _|
      ___| |__   ___  _ __  _| |_ _   _
     / __| '_ \ / _ \| '_ \| |  _| | | |
     \__ \ | | | (_) | |_) | | | | |_| |
     |___/_| |_|\___/| .__/|_|_|  \__, |
                     | |           __/ |
                     |_|          |___/
    */

  await createTable({
    name: 'shopify_account',
    fields: [
      {
        name: 'name',
        type: 'text'
      },
      {
        name: 'image',
        type: 'text'
      },
      {
        name: 'shop_link',
        type: 'text'
      },
      {
        name: 'status',
        type: 'text'
      },
      {
        name: 'active',
        type: 'bool',
        is_required: true,
        default_value: 'false'
      }
    ]
  });

  await addForeignKey({
    table_name: 'shopify_account',
    field_name: 'partner_id',
    ref_table: 'partners',
    index: true,
    is_required: true
  });

  await applyRLS({
    table_name: 'shopify_account',
    privs: [...read, ...edit],
    policy_template_name: 'owned_object_records',
    policy_template_vars: {
      owned_schema: objs.database1.schema_name,
      owned_table: 'partners',
      owned_table_ref_key: 'id',
      owned_table_key: 'owner_id',
      this_object_key: 'partner_id'
    }
  });

  /*
        _                 _  __                                _
       | |               (_)/ _|                              | |
    ___| |__   ___  _ __  _| |_ _   _   ___  ___  ___ _ __ ___| |_ ___
   / __| '_ \ / _ \| '_ \| |  _| | | | / __|/ _ \/ __| '__/ _ \ __/ __|
   \__ \ | | | (_) | |_) | | | | |_| | \__ \  __/ (__| | |  __/ |_\__ \
   |___/_| |_|\___/| .__/|_|_|  \__, | |___/\___|\___|_|  \___|\__|___/
                   | |           __/ |
                   |_|          |___/
  */

  const SHOPIFY_SECRETS_TABLE = 'shopify_secrets';

  await createTable({
    name: SHOPIFY_SECRETS_TABLE,
    fields: [
      {
        name: 'api_key',
        type: 'text'
      },
      {
        name: 'access_token',
        type: 'bytea'
      },
      {
        name: 'refresh_token',
        type: 'bytea'
      }
    ],
    is_visible: false
  });

  await addForeignKey({
    table_name: SHOPIFY_SECRETS_TABLE,
    field_name: 'account_id',
    ref_table: 'shopify_account',
    index: true,
    is_required: true
  });

  await addUnique({
    table_name: SHOPIFY_SECRETS_TABLE,
    field_names: ['account_id']
  });

  await registerTable(SHOPIFY_SECRETS_TABLE);

  await applyRLS({
    table_name: SHOPIFY_SECRETS_TABLE,
    privs: [...read, ...edit],
    policy_template_name: 'child_of_owned_object_records',
    policy_template_vars: {
      owned_schema: objs.database1.schema_name,
      owned_table: 'partners',
      owned_table_key: 'owner_id',
      owned_table_ref_key: 'id',

      object_schema: objs.database1.schema_name,
      object_table: 'shopify_account',
      object_table_owned_key: 'partner_id',
      object_table_ref_key: 'id',

      this_object_key: 'account_id'
    }
  });

  await installModule('jobs_trigger_module', {
    event_type: 'insert',
    include_fields: false,
    table_id: objs.tables[SHOPIFY_SECRETS_TABLE].id,
    job_name: 'shopify-create-account'
  });

  await installModule('jobs_trigger_module', {
    event_type: 'update',
    include_fields: false,
    table_id: objs.tables[SHOPIFY_SECRETS_TABLE].id,
    job_name: 'shopify-update-account'
  });

  // secret field triggers

  const shopify_account_id_field = await dbs.selectOne('field', ['*'], {
    table_id: objs.tables[SHOPIFY_SECRETS_TABLE].id,
    name: 'account_id'
  });

  const shopify_access_token_field = await dbs.selectOne('field', ['*'], {
    table_id: objs.tables[SHOPIFY_SECRETS_TABLE].id,
    name: 'access_token'
  });

  const shopify_refresh_token_field = await dbs.selectOne('field', ['*'], {
    table_id: objs.tables[SHOPIFY_SECRETS_TABLE].id,
    name: 'refresh_token'
  });

  await installModule('encrypted_secrets_getter_module', {
    table_id: objs.tables[SHOPIFY_SECRETS_TABLE].id,
    owned_field: 'account_id'
  });

  await installModule('encrypted_secrets_setter_module', {
    table_id: objs.tables[SHOPIFY_SECRETS_TABLE].id,
    owned_field: 'account_id'
  });

  await installModule('encrypted_secrets_encrypt_field_module', {
    field_id: shopify_access_token_field.id,
    encode_field_id: shopify_account_id_field.id,
    encryption_type: 'pgp'
  });

  await installModule('encrypted_secrets_encrypt_field_module', {
    field_id: shopify_refresh_token_field.id,
    encode_field_id: shopify_account_id_field.id,
    encryption_type: 'pgp'
  });

  /*
          _                 _  __                       _
         | |               (_)/ _|                     | |
      ___| |__   ___  _ __  _| |_ _   _    ___  _ __ __| | ___ _ __ ___
     / __| '_ \ / _ \| '_ \| |  _| | | |  / _ \| '__/ _` |/ _ \ '__/ __|
     \__ \ | | | (_) | |_) | | | | |_| | | (_) | | | (_| |  __/ |  \__ \
     |___/_| |_|\___/| .__/|_|_|  \__, |  \___/|_|  \__,_|\___|_|  |___/
                     | |           __/ |
                     |_|          |___/
    */

  await createTable({
    name: 'shopify_order',
    fields: [
      {
        name: 'order_id',
        type: 'int'
      },
      {
        name: 'email',
        type: 'citext'
      },
      {
        name: 'order_status',
        type: 'text'
      },
      {
        name: 'financial_status',
        type: 'text'
      },
      {
        name: 'subtotal_price',
        type: 'numeric'
      },
      {
        name: 'order_created_at',
        type: 'timestamptz'
      },
      {
        name: 'order_closed_at',
        type: 'timestamptz'
      },
      {
        name: 'bitg_updated_at',
        type: 'timestamptz'
      },
      {
        name: 'bitg_rebate',
        type: 'numeric'
      },
      {
        name: 'bitg_address',
        type: 'text'
      },
      {
        name: 'paid_date',
        type: 'timestamptz'
      },
      {
        name: 'transaction_id',
        type: 'text'
      }
    ]
  });

  await addForeignKey({
    table_name: 'shopify_order',
    field_name: 'partner_id',
    ref_table: 'partners',
    index: true,
    is_required: true
  });

  await addForeignKey({
    table_name: 'shopify_order',
    field_name: 'shopify_account_id',
    ref_table: 'shopify_account',
    index: true,
    is_required: true
  });

  await addUnique({
    table_name: 'shopify_order',
    field_names: ['order_id', 'shopify_account_id', 'email']
  });

  await applyRLS({
    table_name: 'shopify_order',
    privs: [...read, ...edit],
    policy_template_name: 'child_of_owned_object_records',
    policy_template_vars: {
      owned_schema: objs.database1.schema_name,
      owned_table: 'partners',
      owned_table_key: 'owner_id',
      owned_table_ref_key: 'id',

      object_schema: objs.database1.schema_name,
      object_table: 'shopify_account',
      object_table_owned_key: 'partner_id',
      object_table_ref_key: 'id',

      this_object_key: 'shopify_account_id'
    }
  });

  /*
       _____       _     _
      / ____|     | |   | |
     | |  __  ___ | | __| | ___ _ __
     | | |_ |/ _ \| |/ _` |/ _ \ '_ \
     | |__| | (_) | | (_| |  __/ | | |
      \_____|\___/|_|\__,_|\___|_| |_|

    */

  await createTable({
    name: 'initiatives_golden_records',
    fields: [
      {
        name: 'name',
        type: 'text'
      },
      {
        name: 'email',
        type: 'text'
      },
      {
        name: 'bitg_address',
        type: 'text'
      },
      {
        name: 'date',
        type: 'timestamptz'
      },
      {
        name: 'actions_completed',
        type: 'int'
      }
    ],
    is_visible: false
  });

  await addForeignKey({
    table_name: 'initiatives_golden_records',
    field_name: 'action_id',
    ref_table: 'campaign_actions',
    index: true,
    is_required: true
  });
};
