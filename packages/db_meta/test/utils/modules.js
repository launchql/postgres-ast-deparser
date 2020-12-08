export default async ({ objs, mods }) => {
  objs.modules = {};

  // immutable_field_utils_module

  objs.modules.immutable_field_utils_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'immutable_field_utils_module',
      context: 'sql',
      mods: [],
      exec: {
        schema: 'modules_private',
        function: 'immutable_field_utils_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  // immutable_field_module

  objs.modules.immutable_field_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'immutable_field_module',
      context: 'sql',
      mods: [objs.modules.immutable_field_utils_module.id],
      exec: {
        schema: 'modules_private',
        function: 'immutable_field_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.immutable_field_module.id,
    name: 'trigger_function',
    type: 'uuid',
    is_required: true,
    default_module_id: objs.modules.immutable_field_utils_module.id,
    default_module_value: 'trigger_function'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.immutable_field_module.id,
    name: 'trigger_schema',
    type: 'uuid',
    is_required: true,
    default_module_id: objs.modules.immutable_field_utils_module.id,
    default_module_value: 'trigger_schema'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.immutable_field_module.id,
    name: 'field_id',
    type: 'uuid',
    is_required: true
  });

  // encrypted_secrets_utils_module

  objs.modules.encrypted_secrets_utils_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'encrypted_secrets_utils_module',
      context: 'sql',
      mods: [],
      exec: {
        schema: 'modules_private',
        function: 'encrypted_secrets_utils_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  // encrypted_secrets_getter_module

  objs.modules.encrypted_secrets_getter_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'encrypted_secrets_getter_module',
      context: 'sql',
      mods: [],
      exec: {
        schema: 'modules_private',
        function: 'encrypted_secrets_getter_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.encrypted_secrets_getter_module.id,
    name: 'table_id',
    type: 'uuid',
    is_required: true
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.encrypted_secrets_getter_module.id,
    name: 'owned_field',
    type: 'text',
    is_required: true
  });

  // encrypted_secrets_setter_module

  objs.modules.encrypted_secrets_setter_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'encrypted_secrets_setter_module',
      context: 'sql',
      mods: [],
      exec: {
        schema: 'modules_private',
        function: 'encrypted_secrets_setter_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.encrypted_secrets_setter_module.id,
    name: 'table_id',
    type: 'uuid',
    is_required: true
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.encrypted_secrets_setter_module.id,
    name: 'owned_field',
    type: 'text',
    is_required: true
  });

  // encrypted_secrets_verify_module

  objs.modules.encrypted_secrets_verify_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'encrypted_secrets_verify_module',
      context: 'sql',
      mods: [],
      exec: {
        schema: 'modules_private',
        function: 'encrypted_secrets_verify_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.encrypted_secrets_verify_module.id,
    name: 'table_id',
    type: 'uuid',
    is_required: true
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.encrypted_secrets_verify_module.id,
    name: 'owned_field',
    type: 'text',
    is_required: true
  });

  // encrypted_secrets_encrypt_field_module

  objs.modules.encrypted_secrets_encrypt_field_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'encrypted_secrets_encrypt_field_module',
      context: 'sql',
      mods: [objs.modules.encrypted_secrets_utils_module.id],
      exec: {
        schema: 'modules_private',
        function: 'encrypted_secrets_encrypt_field_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.encrypted_secrets_encrypt_field_module.id,
    name: 'field_id',
    type: 'uuid',
    is_required: true
  });
  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.encrypted_secrets_encrypt_field_module.id,
    name: 'encode_field_id',
    type: 'uuid',
    is_required: false
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.encrypted_secrets_encrypt_field_module.id,
    name: 'encrypted_schema',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.encrypted_secrets_utils_module.id,
    default_module_value: 'encrypted_schema'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.encrypted_secrets_encrypt_field_module.id,
    name: 'encryption_type',
    type: 'text',
    is_required: true,
    default_value: 'pgp'
  });

  // jobs_module

  objs.modules.jobs_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'jobs_module',
      context: 'sql',
      mods: [],
      exec: {
        schema: 'modules_private',
        function: 'jobs_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.jobs_module.id,
    name: 'use_extension',
    type: 'boolean',
    is_required: true,
    default_value: 'false'
  });

  // jobs_trigger_module

  objs.modules.jobs_trigger_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'jobs_trigger_module',
      context: 'sql',
      mods: [objs.modules.jobs_module.id],
      exec: {
        schema: 'modules_private',
        function: 'jobs_trigger_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.jobs_trigger_module.id,
    name: 'jobs_schema',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.jobs_module.id,
    default_module_value: 'jobs_schema'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.jobs_trigger_module.id,
    name: 'table_id',
    type: 'uuid',
    is_required: true
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.jobs_trigger_module.id,
    name: 'event_type',
    type: 'text',
    is_required: true,
    default_value: 'insert'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.jobs_trigger_module.id,
    name: 'job_name',
    type: 'text',
    is_required: true
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.jobs_trigger_module.id,
    name: 'include_fields',
    type: 'bool',
    is_required: true,
    default_value: true
  });

  // default_ids_module

  objs.modules.default_ids_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'default_ids_module',
      context: 'sql',
      mods: [],
      exec: {
        schema: 'modules_private',
        function: 'default_ids_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.default_ids_module.id,
    name: 'default_type',
    type: 'text',
    is_required: true,
    // serial or uuid only
    default_value: 'uuid'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.default_ids_module.id,
    name: 'default_name',
    type: 'text',
    is_required: true,
    default_value: 'id'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.default_ids_module.id,
    name: 'default_value',
    type: 'text',
    is_required: false,
    // uuid only
    default_value: 'uuid_generate_v4()'
  });

  // create_table_module

  objs.modules.create_table_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'create_table_module',
      context: 'sql',
      mods: [objs.modules.default_ids_module.id],
      exec: {
        schema: 'modules_private',
        function: 'create_table_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.create_table_module.id,
    name: 'table_name',
    type: 'text',
    is_required: true
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.create_table_module.id,
    name: 'is_visible',
    type: 'bool',
    is_required: true,
    default_value: true
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.create_table_module.id,
    name: 'pk_type',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.default_ids_module.id,
    default_module_value: 'default_type'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.create_table_module.id,
    name: 'pk_name',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.default_ids_module.id,
    default_module_value: 'default_name'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.create_table_module.id,
    name: 'pk_default_value',
    type: 'text',
    is_required: false,
    default_module_id: objs.modules.default_ids_module.id,
    default_module_value: 'default_value'
  });

  // uuid_module

  objs.modules.uuid_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'uuid_module',
      context: 'sql',
      mods: [],
      exec: {
        schema: 'modules_private',
        function: 'uuid_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.uuid_module.id,
    name: 'seeded_uuid_function',
    type: 'text',
    is_required: true,
    default_value: 'uuid_generate_v4'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.uuid_module.id,
    name: 'seeded_uuid_function_with_args',
    type: 'text',
    is_required: true,
    default_value: 'uuid_generate_seeded_uuid'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.uuid_module.id,
    name: 'seeded_uuid_related_trigger',
    type: 'text',
    is_required: true,
    default_value: 'seeded_uuid_related_trigger'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.uuid_module.id,
    name: 'seeded_uuid_seed',
    type: 'text'
  });

  // USER

  objs.modules.users_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'users_module',
      context: 'sql',
      exec: {
        schema: 'modules_private',
        function: 'users_module'
      }
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.users_module.id,
    name: 'table_name',
    type: 'text',
    is_required: true,
    default_value: 'users'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.users_module.id,
    name: 'table_id',
    type: 'uuid',
    is_required: false
  });

  // TOKENs

  objs.modules.tokens_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'tokens_module',
      context: 'sql',
      mods: [objs.modules.users_module.id],
      exec: {
        schema: 'modules_private',
        function: 'tokens_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.tokens_module.id,
    name: 'tokens_table',
    type: 'text',
    is_required: true,
    default_value: 'tokens'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.tokens_module.id,
    name: 'tokens_default_expiration',
    type: 'interval',
    is_required: true,
    default_value: '6 hours'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.tokens_module.id,
    name: 'owned_table_id',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.users_module.id,
    default_module_value: 'table_id'
  });

  // SECRETS

  objs.modules.secrets_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'secrets_module',
      context: 'sql',
      mods: [],
      exec: {
        schema: 'modules_private',
        function: 'secrets_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.secrets_module.id,
    name: 'secrets_table',
    type: 'text',
    is_required: true
  });
  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.secrets_module.id,
    name: 'owned_table_id',
    type: 'text',
    is_required: true
  });

  // CRYPTO AUTH

  objs.modules.crypto_auth_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'crypto_auth_module',
      context: 'sql',
      mods: [
        objs.modules.users_module.id,
        objs.modules.tokens_module.id,
        objs.modules.secrets_module.id
      ],
      exec: {
        schema: 'modules_private',
        function: 'crypto_auth_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.crypto_auth_module.id,
    name: 'user_table_id',
    type: 'uuid',
    is_required: false,
    default_module_id: objs.modules.users_module.id,
    default_module_value: 'table_id'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.crypto_auth_module.id,
    name: 'user_field',
    type: 'uuid',
    is_required: true,
    default_value: 'address'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.crypto_auth_module.id,
    name: 'tokens_table_id',
    type: 'uuid',
    is_required: false,
    default_module_id: objs.modules.tokens_module.id,
    default_module_value: 'table_id'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.crypto_auth_module.id,
    name: 'secrets_table_id',
    type: 'uuid',
    is_required: false,
    default_module_id: objs.modules.secrets_module.id,
    default_module_value: 'table_id'
  });

  // functions

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.crypto_auth_module.id,
    name: 'crypto_network',
    type: 'uuid',
    is_required: true,
    default_value: 'BTC'
  });
  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.crypto_auth_module.id,
    name: 'sign_in_request_challenge',
    type: 'uuid',
    is_required: true,
    default_value: 'sign_in_request_challenge'
  });
  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.crypto_auth_module.id,
    name: 'sign_in_record_failure',
    type: 'uuid',
    is_required: true,
    default_value: 'sign_in_record_failure'
  });
  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.crypto_auth_module.id,
    name: 'sign_up_unique_key',
    type: 'uuid',
    is_required: true,
    default_value: 'sign_up_with_address'
  });
  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.crypto_auth_module.id,
    name: 'sign_in_with_challenge',
    type: 'uuid',
    is_required: true,
    default_value: 'sign_in_with_challenge'
  });

  // RLS

  objs.modules.rls_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'rls_module',
      context: 'sql',
      mods: [objs.modules.users_module.id, objs.modules.tokens_module.id],
      exec: {
        schema: 'modules_private',
        function: 'rls_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.rls_module.id,
    name: 'authenticate',
    type: 'text',
    is_required: true,
    default_value: 'authenticate'
  });
  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.rls_module.id,
    name: 'current_role',
    type: 'text',
    is_required: true,
    default_value: 'current_user'
  });
  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.rls_module.id,
    name: 'users_table_id',
    type: 'uuid',
    is_required: true,
    default_module_id: objs.modules.users_module.id,
    default_module_value: 'table_id'
  });
  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.rls_module.id,
    name: 'current_role_id',
    type: 'text',
    is_required: true,
    default_value: 'current_user_id'
  });
  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.rls_module.id,
    name: 'current_group_ids',
    type: 'text',
    is_required: true,
    default_value: 'current_group_ids'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.rls_module.id,
    name: 'tokens_table_id',
    type: 'uuid',
    is_required: false,
    default_module_id: objs.modules.tokens_module.id,
    default_module_value: 'table_id'
  });

  // People Stamps

  objs.modules.peoplestamps_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'peoplestamps_module',
      context: 'sql',
      mods: [objs.modules.rls_module.id],
      exec: {
        schema: 'modules_private',
        function: 'peoplestamps_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.peoplestamps_module.id,
    name: 'current_role_id',
    type: 'text',
    is_required: false,
    default_module_id: objs.modules.rls_module.id,
    default_module_value: 'current_role_id'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.peoplestamps_module.id,
    name: 'role_schema',
    type: 'text',
    is_required: false,
    default_module_id: objs.modules.rls_module.id,
    default_module_value: 'role_schema'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.peoplestamps_module.id,
    name: 'trigger_name',
    type: 'text',
    is_required: false,
    default_value: 'tg_peoplestamps'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.peoplestamps_module.id,
    name: 'created_by_column',
    type: 'text',
    is_required: false,
    default_value: 'created_by'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.peoplestamps_module.id,
    name: 'updated_by_column',
    type: 'text',
    is_required: false,
    default_value: 'updated_by'
  });

  // timestamps

  objs.modules.timestamps_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'timestamps_module',
      context: 'sql',
      mods: [],
      exec: {
        schema: 'modules_private',
        function: 'timestamps_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.timestamps_module.id,
    name: 'trigger_name',
    type: 'text',
    is_required: false,
    default_value: 'tg_timestamps'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.timestamps_module.id,
    name: 'created_at_column',
    type: 'text',
    is_required: false,
    default_value: 'created_at'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.timestamps_module.id,
    name: 'updated_at_column',
    type: 'text',
    is_required: false,
    default_value: 'updated_at'
  });

  // timestamps table

  objs.modules.table_timestamps_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'table_timestamps_module',
      context: 'sql',
      mods: [objs.modules.timestamps_module.id],
      exec: {
        schema: 'modules_private',
        function: 'table_timestamps_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.table_timestamps_module.id,
    name: 'table_id',
    type: 'uuid',
    is_required: true
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.table_timestamps_module.id,
    name: 'trigger_name',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.timestamps_module.id,
    default_module_value: 'trigger_name'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.table_timestamps_module.id,
    name: 'trigger_schema',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.timestamps_module.id,
    default_module_value: 'trigger_schema'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.table_timestamps_module.id,
    name: 'created_at_column',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.timestamps_module.id,
    default_module_value: 'created_at_column'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.table_timestamps_module.id,
    name: 'updated_at_column',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.timestamps_module.id,
    default_module_value: 'updated_at_column'
  });

  // peoplestamps table

  objs.modules.table_peoplestamps_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'table_peoplestamps_module',
      context: 'sql',
      mods: [objs.modules.peoplestamps_module.id],
      exec: {
        schema: 'modules_private',
        function: 'table_peoplestamps_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.table_peoplestamps_module.id,
    name: 'table_id',
    type: 'uuid',
    is_required: true
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.table_peoplestamps_module.id,
    name: 'trigger_name',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.peoplestamps_module.id,
    default_module_value: 'trigger_name'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.table_peoplestamps_module.id,
    name: 'trigger_schema',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.peoplestamps_module.id,
    default_module_value: 'trigger_schema'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.table_peoplestamps_module.id,
    name: 'created_by_column',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.peoplestamps_module.id,
    default_module_value: 'created_by_column'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.table_peoplestamps_module.id,
    name: 'updated_by_column',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.peoplestamps_module.id,
    default_module_value: 'updated_by_column'
  });

  // emails_module

  objs.modules.emails_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'emails_module',
      context: 'sql',
      mods: [objs.modules.users_module.id],
      exec: {
        schema: 'modules_private',
        function: 'emails_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.emails_module.id,
    name: 'emails_table',
    type: 'text',
    is_required: true,
    default_value: 'emails'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.emails_module.id,
    name: 'multiple_emails',
    type: 'boolean',
    is_required: true,
    default_value: false
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.emails_module.id,
    name: 'emails_owned_field',
    type: 'text',
    is_required: false
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.emails_module.id,
    name: 'owned_table_id',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.users_module.id,
    default_module_value: 'table_id'
  });

  // invites_module

  objs.modules.invites_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'invites_module',
      context: 'sql',
      mods: [
        objs.modules.users_module.id,
        objs.modules.emails_module.id,
        objs.modules.rls_module.id
      ],
      exec: {
        schema: 'modules_private',
        function: 'invites_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.invites_module.id,
    name: 'invites_table',
    type: 'text',
    is_required: true,
    default_value: 'invites'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.invites_module.id,
    name: 'claimed_invites_table',
    type: 'text',
    is_required: true,
    default_value: 'claimed_invites'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.invites_module.id,
    name: 'submit_invite_code_function',
    type: 'text',
    is_required: true,
    default_value: 'submit_invite_code'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.invites_module.id,
    name: 'users_table_id',
    type: 'uuid',
    is_required: true,
    default_module_id: objs.modules.users_module.id,
    default_module_value: 'table_id'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.invites_module.id,
    name: 'emails_table_id',
    type: 'uuid',
    is_required: true,
    default_module_id: objs.modules.emails_module.id,
    default_module_value: 'table_id'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.invites_module.id,
    name: 'current_role_id',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.rls_module.id,
    default_module_value: 'current_role_id'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.invites_module.id,
    name: 'role_schema',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.rls_module.id,
    default_module_value: 'role_schema'
  });

  // encrypted_secrets_module

  objs.modules.encrypted_secrets_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'encrypted_secrets_module',
      context: 'sql',
      mods: [objs.modules.users_module.id],
      exec: {
        schema: 'modules_private',
        function: 'encrypted_secrets_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.encrypted_secrets_module.id,
    name: 'secrets_table',
    type: 'text',
    is_required: true,
    default_value: 'encrypted_secrets'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.encrypted_secrets_module.id,
    name: 'allow_public_upserts',
    type: 'bool',
    is_required: true,
    default_value: 'false'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.encrypted_secrets_module.id,
    name: 'owned_table_id',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.users_module.id,
    default_module_value: 'table_id'
  });

  // user_auth_module

  objs.modules.user_auth_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'user_auth_module',
      context: 'sql',
      mods: [
        objs.modules.users_module.id,
        objs.modules.encrypted_secrets_module.id,
        objs.modules.secrets_module.id,
        objs.modules.tokens_module.id,
        objs.modules.rls_module.id,
        objs.modules.emails_module.id,
        objs.modules.jobs_module.id
      ],
      exec: {
        schema: 'modules_private',
        function: 'user_auth_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'sign_in_function',
    type: 'text',
    is_required: true,
    default_value: 'login'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'sign_up_function',
    type: 'text',
    is_required: true,
    default_value: 'register'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'set_password_function',
    type: 'text',
    is_required: true,
    default_value: 'set_password'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'reset_password_function',
    type: 'text',
    is_required: true,
    default_value: 'reset_password'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'forgot_password_function',
    type: 'text',
    is_required: true,
    default_value: 'forgot_password'
  });
  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'send_verification_email_function',
    type: 'text',
    is_required: true,
    default_value: 'send_verification_email'
  });
  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'verify_email_function',
    type: 'text',
    is_required: true,
    default_value: 'verify_email'
  });

  // jobs (user_auth_module)

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'jobs_schema',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.jobs_module.id,
    default_module_value: 'jobs_schema'
  });

  // tokens (user_auth_module)

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'tokens_table_id',
    type: 'uuid',
    is_required: true,
    default_module_id: objs.modules.tokens_module.id,
    default_module_value: 'table_id'
  });

  // emails (user_auth_module)

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'emails_table_id',
    type: 'uuid',
    is_required: true,
    default_module_id: objs.modules.emails_module.id,
    default_module_value: 'table_id'
  });

  // secrets (user_auth_module)

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'secrets_table_id',
    type: 'uuid',
    is_required: true,
    default_module_id: objs.modules.secrets_module.id,
    default_module_value: 'table_id'
  });

  // RLS (user_auth_module)

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'role_schema',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.rls_module.id,
    default_module_value: 'role_schema'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'current_role_id',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.rls_module.id,
    default_module_value: 'current_role_id'
  });

  // users (user_auth_module)

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'users_table_id',
    type: 'uuid',
    is_required: true,
    default_module_id: objs.modules.users_module.id,
    default_module_value: 'table_id'
  });

  // encrypted_secrets (user_auth_module)

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'encrypted_upsert_schema',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.encrypted_secrets_module.id,
    default_module_value: 'upsert_schema'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'encrypted_schema',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.encrypted_secrets_module.id,
    default_module_value: 'encrypt_schema'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_auth_module.id,
    name: 'encrypted_secrets_table',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.encrypted_secrets_module.id,
    default_module_value: 'secrets_table'
  });

  // user_status_module

  objs.modules.user_status_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'user_status_module',
      context: 'sql',
      mods: [
        objs.modules.users_module.id,
        objs.modules.timestamps_module.id,
        objs.modules.rls_module.id
      ],
      exec: {
        schema: 'modules_private',
        function: 'user_status_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_status_module.id,
    name: 'users_table_id',
    type: 'uuid',
    is_required: true,
    default_module_id: objs.modules.users_module.id,
    default_module_value: 'table_id'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_status_module.id,
    name: 'trigger_name',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.timestamps_module.id,
    default_module_value: 'trigger_name'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_status_module.id,
    name: 'trigger_schema',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.timestamps_module.id,
    default_module_value: 'trigger_schema'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_status_module.id,
    name: 'created_at_column',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.timestamps_module.id,
    default_module_value: 'created_at_column'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_status_module.id,
    name: 'updated_at_column',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.timestamps_module.id,
    default_module_value: 'updated_at_column'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_status_module.id,
    name: 'role_schema',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.rls_module.id,
    default_module_value: 'role_schema'
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.user_status_module.id,
    name: 'current_role_id',
    type: 'text',
    is_required: true,
    default_module_id: objs.modules.rls_module.id,
    default_module_value: 'current_role_id'
  });

  // subdomain_module

  // TODO how to make it a svc context...

  objs.modules.subdomain_module = await mods.public.insertOne(
    'module_definitions',
    {
      name: 'subdomain_module',
      context: 'sql',
      mods: [],
      exec: {
        schema: 'modules_private',
        function: 'subdomain_module'
      }
    },
    {
      mods: 'uuid[]'
    }
  );

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.subdomain_module.id,
    name: 'subdomain',
    type: 'text',
    is_required: true
  });

  await mods.public.insertOne('module_field', {
    module_defn_id: objs.modules.subdomain_module.id,
    name: 'is_public',
    type: 'bool',
    is_required: true
  });
};
