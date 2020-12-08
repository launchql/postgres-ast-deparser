import { initDatabase, updateSchemas } from './helpers';
import * as ast from 'pg-ast';

export const ORG_PROFILES_TABLE = 'organization_profiles';
export const USER_PROFILES_TABLE = 'user_profiles';
export const USER_SETTINGS_TABLE = 'user_settings';
export const USER_CHARACTERISTICS_TABLE = 'user_characteristics';
export const USER_SECRETS_TABLE = 'user_secrets';
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

import { makeApi, str, funcCall, and, or, equals, col } from '../utils/helpers';
import modules from './modules';
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
  const rlsFn = (group = false) => {
    return ast.FuncCall({
      funcname: [
        str(objs.database1.schemas.public.schema_name),
        str(group ? GET_CURRENT_GROUP_IDS : GET_CURRENT_ROLE_ID)
      ]
    });
  };

  const dbs = db.helper('collections_public');
  await initDatabase({ objs, dbs, dbname: '3daet' });
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
    createThroughTable,
    applyRLS,
    addFullTextSearch,
    addIndexMigration,
    slugifyField,
    statusTrigger
  } = makeApi({ objs, dbs, db });

  const [jobsmodule] = await mods.public.callAny('install_module_by_name', {
    database_id: objs.database1.id,
    name: 'jobs_module',
    context: 'sql',
    data: {}
  });
  const [joboutput] = await mods.public.select(
    'module_output',
    ['name', 'value'],
    {
      module_id: jobsmodule.id,
      name: 'jobs_schema'
    }
  );

  await updateSchemas({ objs, dbs, database_id: objs.database1.id });

  // utils
  await installModule('default_ids_module');
  await installModule('uuid_module', {
    seeded_uuid_seed: 'generic'
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

  //   await installModule('user_status_module');

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
    policy_template_name: 'open',
    policy_template_vars: {
      policy_text: 'TRUE'
    }
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

  await updateSchemas({ objs, dbs, database_id: objs.database1.id });

  // emails
  await installModule('emails_module', {
    emails_table: EMAILS_TABLE
  });
  await registerTable(EMAILS_TABLE);

  await installModule('invites_module');

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

  // user profiles
  await createTable({
    name: USER_PROFILES_TABLE,
    fields: [
      {
        name: 'profile_picture',
        type: 'image'
      },
      {
        name: 'bio',
        type: 'text'
      },
      {
        name: 'first_name',
        type: 'text'
      },
      {
        name: 'last_name',
        type: 'text'
      },
      {
        name: 'tags',
        type: 'citext[]'
      },
      {
        name: 'desired',
        type: 'citext[]'
      }
    ]
  });
  await addForeignKey({
    table_name: USER_PROFILES_TABLE,
    field_name: object_key_id,
    ref_table: USER_TABLE,
    index: true,
    is_required: true
  });
  await addUnique({
    table_name: USER_PROFILES_TABLE,
    field_names: [object_key_id]
  });
  await applyRLS({
    table_name: USER_PROFILES_TABLE,
    privs: edit,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: object_key_id
    }
  });
  await applyRLS({
    table_name: USER_PROFILES_TABLE,
    privs: read,
    policy_template_name: 'open',
    policy_template_vars: {
      policy_text: 'TRUE'
    }
  });

  // user settings
  await createTable({
    name: USER_SETTINGS_TABLE,
    fields: [
      {
        name: 'search_radius',
        type: 'numeric'
      },
      {
        name: 'zip',
        type: 'int'
      },
      {
        name: 'location',
        type: 'geometry (Point, 4326)'
      }
    ]
  });
  await addForeignKey({
    table_name: USER_SETTINGS_TABLE,
    field_name: object_key_id,
    ref_table: USER_TABLE,
    index: true,
    is_required: true
  });
  await addUnique({
    table_name: USER_SETTINGS_TABLE,
    field_names: [object_key_id]
  });
  await addIndexMigration({
    database_id: objs.database1.id,
    schema_name: objs.database1.schema_name,
    table_name: USER_SETTINGS_TABLE,
    index_name: 'user_location_gist_idx',
    fields: ['location'],
    access_method: 'gist'
  });
  await applyRLS({
    table_name: USER_SETTINGS_TABLE,
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: object_key_id
    }
  });

  // user characteristics
  await createTable({
    name: USER_CHARACTERISTICS_TABLE,
    fields: [
      {
        name: 'income',
        type: 'numeric'
      },
      {
        name: 'gender',
        type: 'char'
      },
      {
        name: 'race',
        type: 'text'
      },
      {
        name: 'age',
        type: 'int'
      },
      {
        name: 'dob',
        type: 'date'
      },
      {
        name: 'education',
        type: 'text'
      }
    ]
  });
  await addForeignKey({
    table_name: USER_CHARACTERISTICS_TABLE,
    field_name: object_key_id,
    ref_table: USER_TABLE,
    index: true,
    is_required: true
  });
  await addUnique({
    table_name: USER_CHARACTERISTICS_TABLE,
    field_names: [object_key_id]
  });
  await applyRLS({
    table_name: USER_CHARACTERISTICS_TABLE,
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: object_key_id
    }
  });

  // user_contacts
  await createTable({
    name: 'user_contacts',
    fields: [
      {
        name: 'vcf',
        type: 'jsonb'
      },
      {
        name: 'full_name',
        type: 'text'
      },
      {
        name: 'emails',
        type: 'email[]'
      },
      {
        name: 'device',
        type: 'text'
      }
    ]
  });
  await addForeignKey({
    table_name: 'user_contacts',
    field_name: object_key_id,
    ref_table: USER_TABLE,
    index: true,
    is_required: true
  });
  await applyRLS({
    table_name: 'user_contacts',
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: object_key_id
    }
  });

  // user_connections
  await createTable({
    name: 'user_connections',
    fields: [
      {
        name: 'accepted',
        type: 'bool'
      }
    ]
  });
  await addForeignKey({
    table_name: 'user_connections',
    field_name: 'requester_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true
  });
  await addForeignKey({
    table_name: 'user_connections',
    field_name: 'responder_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true
  });
  await addUnique({
    table_name: 'user_connections',
    field_names: ['requester_id', 'responder_id']
  });
  await applyRLS({
    table_name: 'user_connections',
    privs: [
      ['select', 'authenticated'],
      ['delete', 'authenticated']
    ],
    policy_template_name: 'multi_owners',
    policy_template_vars: {
      role_keys: ['responder_id', 'requester_id']
    }
  });

  await applyRLS({
    table_name: 'user_connections',
    privs: [['update', 'authenticated']],
    field_names: ['accepted'],
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'responder_id'
    }
  });
  await applyRLS({
    table_name: 'user_connections',
    privs: [['insert', 'authenticated']],
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'requester_id'
    }
  });

  // org profiles
  await createTable({
    name: ORG_PROFILES_TABLE,
    fields: [
      {
        name: 'name',
        type: 'text'
      },
      {
        name: 'profile_picture',
        type: 'image'
      },
      {
        name: 'description',
        type: 'text'
      },
      {
        name: 'website',
        type: 'url'
      }
    ]
  });
  await addForeignKey({
    table_name: ORG_PROFILES_TABLE,
    field_name: 'organization_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true
  });
  await addUnique({
    table_name: ORG_PROFILES_TABLE,
    field_names: ['organization_id']
  });
  await applyRLS({
    table_name: ORG_PROFILES_TABLE,
    privs: edit,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'organization_id'
    }
  });
  await applyRLS({
    table_name: ORG_PROFILES_TABLE,
    privs: read,
    policy_template_name: 'open',
    policy_template_vars: {
      policy_text: 'TRUE'
    }
  });

  // status achievement triggers
  // const achievement = await db.one(
  //   `
  //     INSERT INTO "${objs.schemas.public}".user_achievement (name)
  //     VALUES ($1::citext)
  //     RETURNING *
  //   `,
  //   ['profile_complete']
  // );

  // await db.any(
  //   `
  //     INSERT INTO "${objs.schemas.public}".user_task (name, achievement_id)
  //     VALUES ($1::citext, $2::uuid)
  //     RETURNING *
  //   `,
  //   ['upload_profile_picture', achievement.id]
  // );
  // await db.any(
  //   `
  //     INSERT INTO "${objs.schemas.public}".user_task (name, achievement_id)
  //     VALUES ($1::citext, $2::uuid)
  //     RETURNING *
  //   `,
  //   ['email_verified', achievement.id]
  // );

  // await statusTrigger({
  //   table_name: USER_PROFILES_TABLE,
  //   field_name: 'profile_picture',
  //   task_name: 'upload_profile_picture'
  // });

  // await statusTrigger({
  //   table_name: EMAILS_TABLE,
  //   field_name: 'is_verified',
  //   task_name: 'email_verified',
  //   toggle: false,
  //   boolean: true
  // });
};
