import { initDatabase, updateSchemas } from '../utils/helpers';
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

import {
  makeApi,
  str,
  funcCall,
  any,
  and,
  or,
  equals,
  col
} from '../utils/helpers';
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
  const rlsFn = (group = false) => {
    return ast.FuncCall({
      funcname: [
        str(objs.database1.schemas.public.schema_name),
        str(group ? GET_CURRENT_GROUP_IDS : GET_CURRENT_ROLE_ID)
      ]
    });
  };

  const dbs = db.helper('collections_public');
  await initDatabase({ objs, dbs, dbname: 'dashboard' });
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
    statusTrigger,
    ownedFieldInSharedObject
  } = makeApi({ objs, dbs, db });

  await installModule('jobs_module');
  await updateSchemas({ objs, dbs, database_id: objs.database1.id });

  // utils
  await installModule('default_ids_module');
  await installModule('uuid_module', {
    seeded_uuid_seed: 'dashboard'
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
        type: 'image',
        description: 'user profile picture'
      },
      {
        name: 'bio',
        type: 'text',
        description: 'user biography'
      },
      {
        name: 'reputation',
        type: 'numeric',
        default_value: '0',
        description: 'user reputation'
      },
      {
        name: 'display_name',
        type: 'text',
        max: 128,
        description: 'user display name'
      },
      {
        name: 'tags',
        type: 'citext[]',
        description: 'user tags'
      },
      {
        name: 'desired',
        type: 'citext[]',
        description: 'user wanted tags'
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
    field_names: [object_key_id],
    omit: true
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
    policy_template_name: 'open'
  });

  // user settings
  await createTable({
    name: USER_SETTINGS_TABLE,
    fields: [
      {
        name: 'first_name',
        type: 'text',
        max: 64,
        description: 'user first name'
      },
      {
        name: 'last_name',
        type: 'text',
        max: 64,
        description: 'user surname'
      },
      {
        name: 'search_radius',
        type: 'numeric',
        description: 'search radius'
      },
      {
        name: 'zip',
        type: 'int',
        description: 'user zip code'
      },
      {
        name: 'location',
        type: 'geometry (Point, 4326)',
        description: 'user location stored as a GeoJSON object as 4326 lon/lat'
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
  // TODO uniques on user, I wonder if two things
  // 1. should we remove the ids and just user the user_id?
  // 2. just use manyToMany in omit?
  await addUnique({
    table_name: USER_SETTINGS_TABLE,
    field_names: [object_key_id],
    omit: true
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
      },
      {
        name: 'home_ownership',
        type: 'smallint',
        min: 1,
        max: 5
      },
      {
        name: 'tree_hugger_level',
        type: 'smallint',
        min: 1,
        max: 5
      },
      {
        name: 'diy_level',
        type: 'smallint',
        min: 1,
        max: 5
      },
      {
        name: 'gardener_level',
        type: 'smallint',
        min: 1,
        max: 5
      },
      {
        name: 'free_time',
        type: 'smallint',
        min: 1,
        max: 5
      },
      {
        name: 'research_to_doer',
        type: 'smallint',
        min: 1,
        max: 5
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
    field_names: [object_key_id],
    omit: true
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
        type: 'jsonb',
        description:
          'the VCF file for storing contact information for a person or business'
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
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'user_connections',
    field_name: 'responder_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addUnique({
    table_name: 'user_connections',
    field_names: ['requester_id', 'responder_id'],
    omit: true
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

  // await applyRLS({
  //   table_name: 'user_connections',
  //   privs: all,
  //   policy_template_name: 'own_records',
  //   policy_template_vars: {
  //     role_key: 'requester_id'
  //   }
  // });

  // locations
  // await createTable({
  //   name: 'locations',
  //   fields: [
  //     {
  //       name: 'location',
  //       type: 'geometry (Point, 4326)'
  //     }
  //   ]
  // });

  // await addIndexMigration({
  //   database_id: objs.database1.id,
  //   schema_name: objs.database1.schema_name,
  //   table_name: 'locations',
  //   index_name: 'locations_location_gist_idx',
  //   fields: ['location'],
  //   access_method: 'gist'
  // });

  // await applyRLS({
  //   table_name: 'locations',
  //   privs: [
  //     ['select', 'authenticated'],
  //     ['insert', 'authenticated']
  //   ],
  //   policy_template_name: 'open',
  //   policy_template_vars: {
  //     policy_text: 'TRUE'
  //   }
  // });

  // news_updates
  await createTable({
    name: 'news_updates',
    fields: [
      {
        name: 'name',
        type: 'text'
      },
      {
        name: 'description',
        type: 'text'
      },
      {
        name: 'link',
        type: 'url'
      },
      {
        name: 'published_at',
        type: 'timestamptz'
      },
      {
        name: 'photo',
        type: 'image'
      }
    ]
  });
  await applyRLS({
    table_name: 'news_updates',
    privs: [['select', 'authenticated']],
    policy_template_name: 'open'
  });

  // goals
  await createTable({
    name: 'goals',
    fields: [
      {
        name: 'name',
        type: 'text'
      },
      {
        name: 'slug',
        type: 'citext',
        max: 2048
      },
      {
        name: 'short_name',
        type: 'text'
      },
      {
        name: 'icon',
        type: 'text'
      },
      {
        name: 'sub_head',
        type: 'text'
      },
      {
        name: 'tags',
        type: 'citext[]'
      },
      {
        name: 'search',
        type: 'tsvector'
      }
    ]
  });

  await addFullTextSearch({
    table_name: 'goals',
    search_field: 'search',
    field_names: ['name', 'name', 'tags', 'sub_head'],
    weights: ['A', 'B', 'C', 'B'],
    langs: [
      'pg_catalog.simple',
      'pg_catalog.english',
      'pg_catalog.english',
      'pg_catalog.english'
    ]
  });

  await addUnique({
    table_name: 'goals',
    field_names: ['name']
  });

  await addUnique({
    table_name: 'goals',
    field_names: ['slug']
  });

  await slugifyField({
    table: 'goals',
    field: 'slug'
  });

  await addIndexMigration({
    database_id: objs.database1.id,
    schema_name: objs.database1.schema_name,
    table_name: 'goals',
    index_name: 'goals_vector_index',
    fields: ['search'],
    access_method: 'gin'
  });

  await applyRLS({
    table_name: 'goals',
    privs: [['select', 'authenticated']],
    policy_template_name: 'open'
  });

  // goal_explanations
  await createTable({
    name: 'goal_explanations',
    fields: [
      {
        name: 'audio',
        type: 'attachment'
      },
      {
        name: 'audio_duration',
        type: 'interval'
      },
      {
        name: 'explanation_title',
        type: 'text'
      },
      {
        name: 'explanation',
        type: 'text'
      }
    ]
  });

  await addForeignKey({
    table_name: 'goal_explanations',
    field_name: 'goal_id',
    ref_table: 'goals',
    index: true,
    is_required: true
  });

  await applyRLS({
    table_name: 'goal_explanations',
    privs: [['select', 'authenticated']],
    policy_template_name: 'open'
  });

  // actions
  await createTable({
    name: 'actions',
    fields: [
      {
        name: 'slug',
        type: 'citext',
        max: 2048
      },
      {
        name: 'photo',
        type: 'image'
      },
      {
        name: 'title',
        type: 'text'
      },
      {
        name: 'description',
        type: 'text'
      },
      {
        name: 'discovery_header',
        type: 'text'
      },
      {
        name: 'discovery_description',
        type: 'text'
      },
      {
        name: 'enable_notifications',
        type: 'boolean',
        default_value: 'FALSE'
      },
      {
        name: 'enable_notifications_text',
        type: 'text'
      },
      {
        name: 'search',
        type: 'tsvector'
      },
      {
        name: 'location',
        type: 'geometry (Point, 4326)'
      },
      {
        name: 'location_radius',
        type: 'numeric'
      },
      {
        name: 'time_required',
        type: 'interval'
      },
      {
        name: 'start_date',
        type: 'timestamptz'
      },
      {
        name: 'end_date',
        type: 'timestamptz'
      },
      {
        name: 'approved',
        type: 'boolean',
        default_value: 'false'
      },
      {
        name: 'reward_amount',
        type: 'numeric'
      },
      {
        name: 'activity_feed_text',
        type: 'text'
      },
      {
        name: 'call_to_action',
        type: 'text'
      },
      {
        name: 'completed_action_text',
        type: 'text'
      },
      {
        name: 'already_completed_action_text',
        type: 'text'
      },
      {
        name: 'tags',
        type: 'citext[]'
      }
    ]
  });

  await addUnique({
    table_name: 'actions',
    field_names: ['slug']
  });

  await slugifyField({
    table: 'actions',
    field: 'slug'
  });

  await addIndexMigration({
    database_id: objs.database1.id,
    schema_name: objs.database1.schema_name,
    table_name: 'actions',
    index_name: 'actions_location_gist_idx',
    fields: ['location'],
    access_method: 'gist'
  });

  await addForeignKey({
    table_name: 'actions',
    field_name: 'owner_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await applyRLS({
    table_name: 'actions',
    privs: edit,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });
  await applyRLS({
    table_name: 'actions',
    privs: [['select', 'authenticated']],
    policy_template_name: 'open'
  });

  await addFullTextSearch({
    table_name: 'actions',
    search_field: 'search',
    field_names: ['description', 'title', 'title', 'tags', 'tags'],
    weights: ['C', 'A', 'B', 'A', 'B'],
    langs: [
      'pg_catalog.english',
      'pg_catalog.simple',
      'pg_catalog.english',
      'pg_catalog.simple',
      'pg_catalog.english'
    ]
  });

  await addIndexMigration({
    database_id: objs.database1.id,
    schema_name: objs.database1.schema_name,
    table_name: 'actions',
    index_name: 'action_vector_index',
    fields: ['search'],
    access_method: 'gin'
  });

  await addIndexMigration({
    database_id: objs.database1.id,
    schema_name: objs.database1.schema_name,
    table_name: 'actions',
    index_name: 'action_tag_index',
    fields: ['tags'],
    access_method: 'gin'
  });

  // action_goals

  await createThroughTable({
    name: 'action_goals',
    fields: [],
    left_table_name: 'actions',
    left_table_field: 'action_id',
    left_field_name: 'actions',

    right_table_name: 'goals',
    right_table_field: 'goal_id',
    right_field_name: 'goals'
  });

  await addForeignKey({
    table_name: 'action_goals',
    field_name: 'owner_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });

  await applyRLS({
    table_name: 'action_goals',
    privs: [['select', 'authenticated']],
    policy_template_name: 'open'
  });
  await applyRLS({
    table_name: 'action_goals',
    privs: edit,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });

  // action_results
  await createTable({
    name: 'action_results',
    fields: []
  });
  await addForeignKey({
    table_name: 'action_results',
    field_name: 'action_id',
    ref_table: 'actions',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'action_results',
    field_name: 'owner_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await applyRLS({
    table_name: 'action_results',
    privs: edit,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });
  await applyRLS({
    table_name: 'action_results',
    privs: [['select', 'authenticated']],
    policy_template_name: 'open'
  });

  // action_items
  await createTable({
    name: 'action_items',
    fields: [
      {
        name: 'name',
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
        name: 'item_order',
        type: 'int'
      },
      {
        name: 'time_required',
        type: 'interval'
      },
      {
        name: 'is_required',
        type: 'boolean',
        is_required: true,
        default_value: 'TRUE'
      },
      {
        name: 'notification_text',
        type: 'text'
      },
      {
        name: 'embed_code',
        type: 'text'
      },
      {
        name: 'url',
        type: 'url'
      },
      {
        name: 'media',
        type: 'upload'
      },
      {
        name: 'owner_id',
        type: 'uuid',
        is_required: true
      }
    ]
  });
  await addForeignKey({
    table_name: 'action_items',
    field_name: 'action_id',
    ref_table: 'actions',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addUnique({
    table_name: 'action_items',
    field_names: ['action_id', 'name'],
    omit: true
  });

  // no need for foreign key.. just map to this
  await addIndex({
    table_name: 'action_items',
    field_names: ['owner_id']
  });

  await applyRLS({
    table_name: 'action_items',
    privs: edit,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });
  await applyRLS({
    table_name: 'action_items',
    privs: [['select', 'authenticated']],
    policy_template_name: 'open'
  });

  // user actions
  await createTable({
    name: 'user_actions',
    fields: [
      {
        name: 'action_started',
        type: 'timestamptz',
        default_value: 'NOW()'
      },
      {
        name: 'complete',
        type: 'boolean',
        default_value: 'false'
      },
      {
        name: 'verified',
        type: 'boolean',
        default_value: 'false'
      },
      {
        name: 'verified_date',
        type: 'timestamptz'
      },
      {
        name: 'user_rating',
        type: 'int'
      },
      {
        name: 'rejected',
        type: 'boolean',
        default_value: 'false'
      },
      {
        name: 'rejected_reason',
        type: 'text'
      }
    ]
  });
  await addForeignKey({
    table_name: 'user_actions',
    field_name: object_key_id,
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'user_actions',
    field_name: 'verifier_id',
    ref_table: USER_TABLE,
    index: true,
    omit: 'manyToMany'
  });
  await addIndex({
    table_name: 'user_actions',
    field_names: ['verified']
  });

  // todo remove fk here?
  // tag it as a no m2m?
  await addForeignKey({
    table_name: 'user_actions',
    field_name: 'action_id',
    ref_table: 'actions',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });

  await applyRLS({
    table_name: 'user_actions',
    policy_name: 'own',
    privs: [
      ['insert', 'authenticated'],
      ['delete', 'authenticated']
    ],
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'user_id'
    }
  });

  await applyRLS({
    table_name: 'user_actions',
    policy_name: 'verify',
    privs: [['update', 'authenticated']],
    policy_template_name: 'ast',
    policy_template_vars: or(
      and(
        equals(col('verified'), str('FALSE')),
        equals(col('user_id'), rlsFn())
      ),
      equals(col('verifier_id'), rlsFn())
    )
  });

  // const pol = await dbs.selectOne('policy', ['*'], {
  //   role_name: 'authenticated',
  //   privilege: 'UPDATE',
  //   permissive: true,
  //   policy_template_name: 'ast'
  // });

  const { qual } = await db.one(
    `SELECT qual FROM pg_policies
      WHERE
      schemaname=$1 AND
        tablename=$2 AND
        cmd='UPDATE'
  `,
    [objs.database1.schemas.public.schema_name, 'user_actions']
  );

  const pol = qual.replace(
    new RegExp(objs.database1.schemas.public.schema_name, 'g'),
    'app_public'
  );
  expect(pol).toMatchSnapshot();

  await applyRLS({
    table_name: 'user_actions',
    policy_name: 'multi',
    privs: [['select', 'authenticated']],
    policy_template_name: 'ast',
    policy_template_vars: or(
      equals(col('verified'), str('TRUE')),
      equals(col('user_id'), rlsFn()),
      equals(col('verifier_id'), rlsFn())
    )
  });

  // user_action_results
  await createTable({
    name: 'user_action_results',
    fields: [
      // {
      //   name: 'date',
      //   type: 'timestamptz',
      //   default_value: 'NOW()'
      // },
      // we can use date field created_at
      {
        name: 'value',
        type: 'jsonb'
      }
    ]
  });
  await addForeignKey({
    table_name: 'user_action_results',
    field_name: object_key_id,
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'user_action_results',
    field_name: 'action_id',
    ref_table: 'actions',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'user_action_results',
    field_name: 'user_action_id',
    ref_table: 'user_actions',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'user_action_results',
    field_name: 'action_result_id',
    ref_table: 'action_results',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });

  await addUnique({
    table_name: 'user_action_results',
    field_names: [object_key_id, 'user_action_id', 'action_result_id'],
    omit: true
  });

  // TODO how to make these public after you complete them?
  await applyRLS({
    table_name: 'user_action_results',
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: object_key_id
    }
  });

  // user_action_items
  await createTable({
    name: 'user_action_items',
    fields: [
      // {
      //   name: 'date',
      //   type: 'timestamptz',
      //   default_value: 'NOW()'
      // },
      // we can use created_at field
      {
        name: 'value',
        type: 'jsonb'
      },
      {
        name: 'status',
        type: 'text'
      }
    ]
  });
  await addForeignKey({
    table_name: 'user_action_items',
    field_name: object_key_id,
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'user_action_items',
    field_name: 'action_id',
    ref_table: 'actions',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'user_action_items',
    field_name: 'user_action_id',
    ref_table: 'user_actions',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'user_action_items',
    field_name: 'action_item_id',
    ref_table: 'action_items',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addUnique({
    table_name: 'user_action_items',
    field_names: [object_key_id, 'user_action_id', 'action_item_id'],
    omit: true
  });

  // TODO how to make these public after you complete them?
  await applyRLS({
    table_name: 'user_action_items',
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: object_key_id
    }
  });

  // zip_codes
  await createTable({
    name: 'zip_codes',
    fields: [
      {
        name: 'zip',
        type: 'int'
      },
      {
        name: 'location',
        type: 'geometry (Point, 4326)'
      },
      {
        name: 'bbox',
        type: 'geometry (Polygon, 4326)'
      }
    ]
  });
  await addUnique({
    table_name: 'zip_codes',
    field_names: ['zip']
  });

  await addIndexMigration({
    database_id: objs.database1.id,
    schema_name: objs.database1.schema_name,
    table_name: 'zip_codes',
    index_name: 'zip_idx',
    fields: ['zip']
  });

  await addIndexMigration({
    database_id: objs.database1.id,
    schema_name: objs.database1.schema_name,
    table_name: 'zip_codes',
    index_name: 'zip_location_gist_idx',
    fields: ['location'],
    access_method: 'gist'
  });
  await addIndexMigration({
    database_id: objs.database1.id,
    schema_name: objs.database1.schema_name,
    table_name: 'zip_codes',
    index_name: 'bbox_zip_gist_idx',
    fields: ['bbox'],
    access_method: 'gist'
  });

  await applyRLS({
    table_name: 'zip_codes',
    privs: [['select', 'anonymous']],
    policy_template_name: 'open'
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
      },
      {
        name: 'reputation',
        type: 'numeric',
        default_value: '0'
      },
      {
        name: 'tags',
        type: 'citext[]'
      }
    ]
  });
  await addForeignKey({
    table_name: ORG_PROFILES_TABLE,
    field_name: 'organization_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addUnique({
    table_name: ORG_PROFILES_TABLE,
    field_names: ['organization_id'],
    omit: true
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
    policy_template_name: 'open'
  });

  // user pass actions
  await createTable({
    name: 'user_pass_actions',
    fields: []
  });
  await addForeignKey({
    table_name: 'user_pass_actions',
    field_name: object_key_id,
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'user_pass_actions',
    field_name: 'action_id',
    ref_table: 'actions',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });

  await applyRLS({
    table_name: 'user_pass_actions',
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: object_key_id
    }
  });

  // user saved actions
  await createTable({
    name: 'user_saved_actions',
    fields: []
  });
  await addForeignKey({
    table_name: 'user_saved_actions',
    field_name: object_key_id,
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'user_saved_actions',
    field_name: 'action_id',
    ref_table: 'actions',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });

  await applyRLS({
    table_name: 'user_saved_actions',
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: object_key_id
    }
  });

  // user viewed actions
  await createTable({
    name: 'user_viewed_actions',
    fields: []
  });
  await addForeignKey({
    table_name: 'user_viewed_actions',
    field_name: object_key_id,
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'user_viewed_actions',
    field_name: 'action_id',
    ref_table: 'actions',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });

  await applyRLS({
    table_name: 'user_viewed_actions',
    privs: all,
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: object_key_id
    }
  });

  // user action reactions
  await createTable({
    name: 'user_action_reactions',
    fields: []
  });
  await addForeignKey({
    table_name: 'user_action_reactions',
    field_name: 'user_action_id',
    ref_table: 'user_actions',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'user_action_reactions',
    field_name: object_key_id,
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });

  await addForeignKey({
    table_name: 'user_action_reactions',
    field_name: 'reacter_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });

  await addUnique({
    table_name: 'user_action_reactions',
    field_names: ['reacter_id', 'user_action_id'],
    omit: true
  });

  await addForeignKey({
    table_name: 'user_action_reactions',
    field_name: 'action_id',
    ref_table: 'actions',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await applyRLS({
    table_name: 'user_action_reactions',
    privs: [['select', 'authenticated']],
    policy_template_name: 'open'
  });

  await applyRLS({
    table_name: 'user_action_reactions',
    privs: [
      ['insert', 'authenticated'],
      ['update', 'authenticated'],
      ['delete', 'authenticated']
    ],
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'reacter_id'
    }
  });

  // user_messages
  await createTable({
    name: 'user_messages',
    fields: [
      {
        name: 'type',
        type: 'text',
        is_required: true,
        default_value: "'text'"
      },
      {
        name: 'content',
        type: 'jsonb'
      },
      {
        name: 'upload',
        type: 'upload'
      },
      {
        name: 'received',
        type: 'boolean',
        default_value: 'false'
      },
      {
        name: 'receiver_read',
        type: 'boolean',
        default_value: 'false'
      },
      {
        name: 'sender_reaction',
        type: 'text'
      },
      {
        name: 'receiver_reaction',
        type: 'text'
      }
    ]
  });
  await addForeignKey({
    table_name: 'user_messages',
    field_name: 'sender_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'user_messages',
    field_name: 'receiver_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await applyRLS({
    table_name: 'user_messages',
    privs: [
      ['select', 'authenticated'],
      ['delete', 'authenticated']
    ],
    policy_template_name: 'multi_owners',
    policy_template_vars: {
      role_keys: ['receiver_id', 'sender_id']
    }
  });

  await applyRLS({
    table_name: 'user_messages',
    privs: [['update', 'authenticated']],
    policy_name: 'receiver',
    field_names: ['content', 'received', 'receiver_read'],
    policy_template_name: 'multi_owners',
    policy_template_vars: {
      role_keys: ['receiver_id', 'sender_id']
    }
  });

  await ownedFieldInSharedObject({
    table: 'user_messages',
    fields: ['content'],
    role_key: 'sender_id',
    rls_schema: objs.database1.schemas.public.schema_name,
    rls_func: GET_CURRENT_ROLE_ID
  });

  await ownedFieldInSharedObject({
    table: 'user_messages',
    fields: ['received', 'receiver_read'],
    role_key: 'receiver_id',
    rls_schema: objs.database1.schemas.public.schema_name,
    rls_func: GET_CURRENT_ROLE_ID
  });

  await applyRLS({
    table_name: 'user_messages',
    privs: [['insert', 'authenticated']],
    policy_name: 'sender_create',
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'sender_id'
    }
  });

  await applyRLS({
    table_name: 'user_messages',
    privs: [['delete', 'authenticated']],
    policy_name: 'sender_delete',
    policy_template_name: 'own_records',
    policy_template_vars: {
      role_key: 'sender_id'
    }
  });

  // message_groups
  await createTable({
    name: 'message_groups',
    fields: [
      {
        name: 'name',
        type: 'text'
      },
      {
        name: 'member_ids',
        type: 'uuid[]'
      }
    ]
  });

  await addIndex({ table_name: 'message_groups', field_names: ['member_ids'] });

  await applyRLS({
    table_name: 'message_groups',
    privs: [
      ['insert', 'authenticated'],
      ['update', 'authenticated'],
      ['select', 'authenticated'],
      ['delete', 'authenticated'] // TODO only if cardinality = 2
    ],
    policy_template_name: 'ast',
    policy_template_vars: any(rlsFn(), col('member_ids'))
  });

  // messages
  await createTable({
    name: 'messages',
    fields: [
      {
        name: 'type',
        type: 'text',
        is_required: true,
        default_value: "'text'"
      },
      {
        name: 'content',
        type: 'jsonb'
      },
      {
        name: 'upload',
        type: 'upload'
      }
    ]
  });
  await addForeignKey({
    table_name: 'messages',
    field_name: 'sender_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'messages',
    field_name: 'group_id',
    ref_table: 'message_groups',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });

  await applyRLS({
    table_name: 'messages',
    privs: [
      ['insert', 'authenticated'], // technically the sender needs to insert only!
      ['update', 'authenticated'],
      ['select', 'authenticated'],
      ['delete', 'authenticated']
    ],
    policy_template_name: 'owned_object_records_group_array',
    policy_template_vars: {
      owned_table_key: 'member_ids',
      owned_schema: objs.database1.schemas.public.schema_name,
      owned_table: 'message_groups',
      owned_table_ref_key: 'id', // groups_pkey
      this_object_key: 'group_id'
    }
  });

  await ownedFieldInSharedObject({
    table: 'messages',
    fields: ['content'],
    role_key: 'sender_id',
    rls_schema: objs.database1.schemas.public.schema_name,
    rls_func: GET_CURRENT_ROLE_ID
  });

  // status achievement triggers

  // const achievement = await db.one(
  //   `
  //   INSERT INTO "${objs.schemas.public}".user_achievement (name)
  //   VALUES ($1::citext)
  //   RETURNING *
  // `,
  //   ['profile_complete']
  // );

  // await db.any(
  //   `
  //   INSERT INTO "${objs.schemas.public}".user_task (name, achievement_id)
  //   VALUES ($1::citext, $2::uuid)
  //   RETURNING *
  // `,
  //   ['upload_profile_picture', achievement.id]
  // );
  // await db.any(
  //   `
  //   INSERT INTO "${objs.schemas.public}".user_task (name, achievement_id)
  //   VALUES ($1::citext, $2::uuid)
  //   RETURNING *
  // `,
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
