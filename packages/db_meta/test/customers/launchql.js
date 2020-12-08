export const ORG_PROFILES_TABLE = 'organization_profiles';
export const ORG_SETTINGS_TABLE = 'organization_settings';
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

import { makeApi, initExistingDatabase } from '../utils/helpers';
import modules from '../utils/modules';

export default async ({ database_id, objs, db }) => {
  const dbs = db.helper('collections_public');

  const mods = {
    public: db.helper('modules_public'),
    private: db.helper('modules_private')
  };
  await modules({ objs, mods });
  const installModule = async (name, data) => {
    const [newmodule] = await mods.public.callAny('install_module', {
      database_id,
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
    addSearchVectorTrigger,
    addFullTextSearch,
    addSearchVectorTriggerFunction,
    addIndexMigration,
    statusTrigger
  } = makeApi({ objs, dbs, db });

  await initExistingDatabase({ objs, dbs, database_id });

  await installModule('jobs_module', {
    use_extension: true
  });

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

  await installModule('user_status_module');

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
        name: 'display_name',
        type: 'text'
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

  // addresses
  await createTable({
    name: 'addresses',
    fields: [
      {
        name: 'address_line_1',
        type: 'text',
        max: 120
      },
      {
        name: 'address_line_2',
        type: 'text',
        max: 120
      },
      {
        name: 'address_line_3',
        type: 'text',
        max: 120
      },
      {
        name: 'city',
        type: 'text',
        max: 120
      },
      {
        name: 'state',
        type: 'text',
        max: 120
      },
      {
        name: 'county_province',
        type: 'text',
        max: 120
      },
      {
        name: 'postcode', // NOT using INT because you can have 22162-1010
        type: 'text',
        max: 24
      },
      {
        name: 'other',
        type: 'text',
        max: 120
      }
    ]
  });
  await addForeignKey({
    table_name: 'addresses',
    field_name: 'owner_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });

  // businesses
  await createTable({
    name: ORG_SETTINGS_TABLE,
    fields: [
      {
        name: 'legal_name',
        type: 'text'
      },
      {
        name: 'address_line_one',
        type: 'text'
      },
      {
        name: 'address_line_two',
        type: 'text'
      },
      {
        name: 'state',
        type: 'text'
      },
      {
        name: 'city',
        type: 'text'
      }
    ]
  });
  await addForeignKey({
    table_name: ORG_SETTINGS_TABLE,
    field_name: 'organization_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addUnique({
    table_name: ORG_SETTINGS_TABLE,
    field_names: ['organization_id'],
    omit: true
  });
  await applyRLS({
    table_name: ORG_SETTINGS_TABLE,
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'organization_id'
    }
  });

  // user settings
  await createTable({
    name: USER_SETTINGS_TABLE,
    fields: [
      {
        name: 'first_name',
        type: 'text',
        max: 64
      },
      {
        name: 'last_name',
        type: 'text',
        max: 64
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
        name: 'dob',
        type: 'date'
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
        type: 'text',
        max: 120,
        description: 'full name of the person or business'
      },
      {
        name: 'emails',
        type: 'email[]'
      },
      {
        name: 'device',
        type: 'text',
        description: 'originating device type or id'
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

  const achievement = await db.one(
    `
    INSERT INTO "${objs.schemas.public}".user_achievement (name)
    VALUES ($1::citext)
    RETURNING *
  `,
    ['profile_complete']
  );

  await db.any(
    `
    INSERT INTO "${objs.schemas.public}".user_task (name, achievement_id)
    VALUES ($1::citext, $2::uuid)
    RETURNING *
  `,
    ['upload_profile_picture', achievement.id]
  );
  await db.any(
    `
    INSERT INTO "${objs.schemas.public}".user_task (name, achievement_id)
    VALUES ($1::citext, $2::uuid)
    RETURNING *
  `,
    ['email_verified', achievement.id]
  );

  await statusTrigger({
    table_name: USER_PROFILES_TABLE,
    field_name: 'profile_picture',
    task_name: 'upload_profile_picture'
  });

  await statusTrigger({
    table_name: EMAILS_TABLE,
    field_name: 'is_verified',
    task_name: 'email_verified',
    toggle: false,
    boolean: true
  });

  // DO THE GOOD STUFF

  const ALL = [
    'database',
    'schema',
    'table',
    'foreign_key_constraint',
    'full_text_search',
    'index',
    'rls_function',
    'policy',
    'primary_key_constraint',
    'procedure',
    'schema_grant',
    'table_grant',
    'trigger',
    'trigger_function',
    'unique_constraint',
    'field'
  ];

  for (const tbl of ALL) {
    await registerTable(tbl);
  }

  await applyRLS({
    table_name: 'database',
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });

  for (const tbl of ALL.filter((n) => n != 'database' && n != 'table')) {
    await applyRLS({
      table_name: tbl,
      privs: all,
      policy_template_name: 'owned_object_records',
      policy_template_vars: {
        owned_schema: 'collections_public', // WOAH
        owned_table: 'database',
        owned_table_ref_key: 'id',
        owned_table_key: 'owner_id',
        this_object_key: 'database_id'
      }
    });
  }
  // BUG
  // need to set on TABLE!! we can't ALTER TABLE collections_public."table" DURING
  // this transaction since it's being used! we'll have to find a better way....
};
