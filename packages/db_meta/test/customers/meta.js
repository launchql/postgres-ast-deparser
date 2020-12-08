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
  await initDatabase({ objs, dbs, dbname: 'meta' });
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
    seeded_uuid_seed: 'meta'
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
  await applyRLS({
    table_name: 'addresses',
    privs: all,
    policy_template_name: 'owned_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });

  // phone_numbers
  await createTable({
    name: 'phone_numbers',
    fields: [
      {
        name: 'country_code',
        type: 'int',
        is_required: true
      },
      {
        name: 'number',
        type: 'int',
        is_required: true
      }
    ]
  });
  await addForeignKey({
    table_name: 'phone_numbers',
    field_name: 'owner_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await applyRLS({
    table_name: 'phone_numbers',
    privs: all,
    policy_template_name: 'owned_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });

  // businesses
  await createTable({
    name: ORG_SETTINGS_TABLE,
    fields: [
      {
        name: 'legal_name',
        type: 'text',
        max: 255
      },
      {
        name: 'dba',
        type: 'text',
        max: 255
      },
      {
        name: 'industry',
        type: 'text',
        max: 255
      },
      {
        name: 'description',
        type: 'text',
        max: 1024
      },
      {
        // different from profile website, this is the legal one we need for verification
        name: 'website',
        type: 'url'
      },
      {
        name: 'business_type',
        type: 'text'
        // Corporation
        // Individual, sole proprietor, or single-member LLC
        // Nonprofit Organization
        // Partnership
        // Limited liability company (LLC)
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
  await addForeignKey({
    table_name: ORG_SETTINGS_TABLE,
    field_name: 'address_id',
    ref_table: 'addresses',
    index: true,
    is_required: false,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: ORG_SETTINGS_TABLE,
    field_name: 'phone_id',
    ref_table: 'phone_numbers',
    index: true,
    is_required: false,
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
    policy_template_name: 'owned_records',
    policy_template_vars: {
      role_key: 'organization_id'
    }
  });

  // domains
  await createTable({
    name: 'domains',
    fields: [
      {
        name: 'database_id',
        type: 'uuid'
      },
      {
        name: 'subdomain',
        type: 'hostname'
      },
      {
        name: 'domain',
        type: 'hostname'
      }
    ]
  });
  await addForeignKey({
    table_name: 'domains',
    field_name: 'owner_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addUnique({
    table_name: 'domains',
    field_names: ['subdomain', 'domain']
  });
  await applyRLS({
    table_name: 'domains',
    privs: all,
    policy_template_name: 'owned_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });

  // api
  await createTable({
    name: 'apis',
    fields: [
      {
        name: 'schemas',
        type: 'text[]',
        is_required: true
      },
      {
        name: 'dbname',
        type: 'text',
        default_value: 'current_database()',
        is_required: true
      },
      {
        name: 'role_name',
        type: 'text',
        is_required: true,
        default_value: `'authenticated'`
      },
      {
        name: 'anon_role',
        type: 'text',
        is_required: true,
        default_value: `'anonymous'`
      }
    ]
  });
  await addForeignKey({
    table_name: 'apis',
    field_name: 'owner_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addForeignKey({
    table_name: 'apis',
    field_name: 'domain_id',
    ref_table: 'domains',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addUnique({ table_name: 'apis', field_names: ['domain_id'] });
  await applyRLS({
    table_name: 'apis',
    privs: all,
    policy_template_name: 'owned_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });

  // sites
  await createTable({
    name: 'sites',
    fields: [
      {
        name: 'title',
        type: 'text',
        max: 120
      },
      {
        name: 'description',
        type: 'text',
        max: 120
      },
      {
        name: 'og_image',
        type: 'image'
      },
      {
        name: 'favicon',
        type: 'upload' // so we can support ico? or can image do this?
      },
      {
        name: 'apple_touch_icon',
        type: 'image'
      },
      {
        name: 'logo',
        type: 'image'
      },
      {
        // TODO should we move this?
        // it is only here for when we do verification email, etc or any modules
        name: 'dbname',
        type: 'text',
        default_value: 'current_database()',
        is_required: true
      }
    ]
  });
  await addForeignKey({
    table_name: 'sites',
    field_name: 'domain_id',
    ref_table: 'domains',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addUnique({ table_name: 'sites', field_names: ['domain_id'] });
  await addForeignKey({
    table_name: 'sites',
    field_name: 'owner_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await applyRLS({
    table_name: 'sites',
    privs: all,
    policy_template_name: 'owned_records',
    policy_template_vars: {
      role_key: 'owner_id'
    }
  });

  // api_modules
  await createTable({
    name: 'api_modules',
    fields: [
      {
        name: 'name',
        type: 'text',
        is_required: true
      },
      {
        name: 'data',
        type: 'json',
        is_required: true
      }
    ]
  });
  await addForeignKey({
    table_name: 'api_modules',
    field_name: 'api_id',
    ref_table: 'apis',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });

  await applyRLS({
    table_name: 'api_modules',
    privs: all,
    policy_template_name: 'owned_object_records',
    policy_template_vars: {
      owned_schema: objs.database1.schema_name,
      owned_table: 'apis',
      owned_table_ref_key: 'id',
      owned_table_key: 'owner_id',
      this_object_key: 'api_id'
    }
  });

  // site_modules
  await createTable({
    name: 'site_modules',
    fields: [
      {
        name: 'name',
        type: 'text',
        is_required: true
      },
      {
        name: 'data',
        type: 'json',
        is_required: true
      }
    ]
  });
  await addForeignKey({
    table_name: 'site_modules',
    field_name: 'site_id',
    ref_table: 'sites',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });

  await applyRLS({
    table_name: 'site_modules',
    privs: all,
    policy_template_name: 'owned_object_records',
    policy_template_vars: {
      owned_schema: objs.database1.schema_name,
      owned_table: 'sites',
      owned_table_ref_key: 'id',
      owned_table_key: 'owner_id',
      this_object_key: 'site_id'
    }
  });

  // site_themes
  await createTable({
    name: 'site_themes',
    fields: [
      {
        name: 'theme',
        type: 'jsonb',
        is_required: true
      }
    ]
  });
  await addForeignKey({
    table_name: 'site_themes',
    field_name: 'site_id',
    ref_table: 'sites',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });

  await applyRLS({
    table_name: 'site_themes',
    privs: all,
    policy_template_name: 'owned_object_records',
    policy_template_vars: {
      owned_schema: objs.database1.schema_name,
      owned_table: 'sites',
      owned_table_ref_key: 'id',
      owned_table_key: 'owner_id',
      this_object_key: 'site_id'
    }
  });

  // site_metadata
  // how to best associate with objects?
  // - [ ] include follow/nofollow
  await createTable({
    name: 'site_metadata',
    fields: [
      {
        name: 'title',
        type: 'text',
        max: 120
      },
      {
        name: 'description',
        type: 'text',
        max: 120
      },
      {
        name: 'og_image',
        type: 'image'
      }
    ]
  });
  await addForeignKey({
    table_name: 'site_metadata',
    field_name: 'site_id',
    ref_table: 'sites',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });

  await applyRLS({
    table_name: 'site_metadata',
    privs: all,
    policy_template_name: 'owned_object_records',
    policy_template_vars: {
      owned_schema: objs.database1.schema_name,
      owned_table: 'sites',
      owned_table_ref_key: 'id',
      owned_table_key: 'owner_id',
      this_object_key: 'site_id'
    }
  });

  // app
  await createTable({
    name: 'apps',
    fields: [
      {
        name: 'name',
        type: 'text'
      },
      {
        name: 'app_image',
        type: 'image'
      },
      {
        name: 'app_store_link',
        type: 'url'
      },
      {
        name: 'app_store_id',
        type: 'text'
      },
      {
        name: 'app_id_prefix',
        type: 'text'
      },
      {
        name: 'play_store_link',
        type: 'url'
      }
    ]
  });
  await addForeignKey({
    table_name: 'apps',
    field_name: 'site_id',
    ref_table: 'sites',
    index: true,
    is_required: true,
    omit: 'manyToMany'
  });
  await addUnique({ table_name: 'apps', field_names: ['site_id'] });
  await applyRLS({
    table_name: 'apps',
    privs: all,
    policy_template_name: 'owned_object_records',
    policy_template_vars: {
      owned_schema: objs.database1.schema_name,
      owned_table: 'sites',
      owned_table_ref_key: 'id',
      owned_table_key: 'owner_id',
      this_object_key: 'site_id'
    }
  });
};
