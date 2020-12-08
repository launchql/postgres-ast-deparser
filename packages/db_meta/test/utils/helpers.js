import { createHash } from 'uuid-hash';
import * as ast from 'pg-ast';
export const str = (str) => ast.String({ str });

export const funcCall = ({ schema_name, function_name, args }) => {
  return ast.FuncCall({
    funcname: [str(schema_name), str(function_name)],
    args
  });
};

export const and = (...args) =>
  ast.BoolExpr({
    boolop: 0,
    args
  });
export const or = (...args) =>
  ast.BoolExpr({
    boolop: 1,
    args
  });
export const equals = (lexpr, rexpr) =>
  ast.A_Expr({
    kind: 0,
    name: [str('=')],
    lexpr,
    rexpr
  });
export const any = (lexpr, rexpr) =>
  ast.A_Expr({
    kind: 1,
    name: [str('=')],
    lexpr,
    rexpr
  });
export const nequals = (lexpr, rexpr) =>
  ast.A_Expr({
    kind: 0,
    name: [str('<>')],
    lexpr,
    rexpr
  });

export const col = (name1, name2) =>
  name2
    ? ast.ColumnRef({
        fields: [str(name1), str(name2)]
      })
    : ast.ColumnRef({
        fields: [str(name1)]
      });

export const updateSchemas = async ({ objs, dbs, database_id }) => {
  const schemas = await dbs.select('schema', ['*'], {
    database_id
  });

  objs.database1.schemas = schemas.reduce((m, v) => {
    m[v.name] = v;
    return m;
  }, {});
  objs.schemas = schemas.reduce((m, v) => {
    m[v.name] = v.schema_name;
    return m;
  }, {});

  objs.database1.schemasById = schemas.reduce((m, v) => {
    m[v.id] = v;
    return m;
  }, {});
};

export const initExistingDatabase = async ({ objs, dbs, database_id }) => {
  objs.database1 = {
    id: database_id
  };

  await updateSchemas({ objs, dbs, database_id });

  // patch for refactoring tests
  objs.database1.schema_name = objs.database1.schemas.public.schema_name;
  objs.database1.private_schema_name =
    objs.database1.schemas.private.schema_name;

  objs.getSchemaFromTable = (table_name) => {
    const schema_id = objs.tables[table_name].schema_id;
    return objs.database1.schemasById[schema_id];
  };
};

export const initDatabase = async ({ objs, dbs, dbname = 'mydb' }) => {
  const id = createHash().update(dbname).digest();
  objs.database1 = await dbs.insertOne('database', {
    id,
    name: dbname
  });
  await initExistingDatabase({ objs, dbs, database_id: objs.database1.id });
};

export const makeApi = ({ objs, dbs, db }) => {
  const migrate = db.helper('db_migrate');

  const applyRLS = async ({
    table_name,
    privs,
    policy_template_name,
    policy_template_vars,
    field_names = [],
    policy_name = null,
    permissive = true
  }) => {
    const table_id = objs.tables[table_name].id;

    const ids = [];
    for (let f = 0; f < field_names.length; f++) {
      const { id } = await dbs.selectOne('field', ['id'], {
        table_id: objs.tables[table_name].id,
        name: field_names[f]
      });
      ids.push(id);
    }

    await db.any(
      `
      SELECT * FROM collections_public.apply_rls(
        table_id := $1::uuid,
        grants := $2::jsonb,
        template := $3::text,
        vars := $4::jsonb,
        field_ids := $5::uuid[],
        permissive := $6::bool,
        name := $7::text
      );
    `,
      [
        table_id,
        JSON.stringify(privs),
        policy_template_name,
        policy_template_vars,
        ids,
        permissive,
        policy_name
      ]
    );
  };

  const enablePeopleStamps = async (current_role_id_function) => {
    await migrate.call('migrate', {
      name: 'peoplestamps_trigger',

      database_id: objs.database1.id,
      trigger_schema: objs.database1.private_schema_name,
      trigger_name: 'tg_peoplestamps',
      current_role_fn_schema: objs.database1.schema_name,
      current_role_id_function,
      created_by_column: 'created_by',
      updated_by_column: 'updated_by'
    });
  };

  const addSearchVectorTrigger = async ({
    trigger_name,
    schema_name,
    table_name,
    tsvector_column_name,
    config_column_name,
    text_columns
  }) => {
    await migrate.call('migrate', {
      name: 'search_vector_trigger',
      database_id: objs.database1.id,
      trigger_name,
      schema_name,
      table_name,
      tsvector_column_name,
      config_column_name,
      text_columns
    });
  };

  const deparse = async (body) => {
    const [
      { expression: result }
    ] = await db.any(`select deparser.expression( $1::jsonb );`, [
      JSON.stringify(body)
    ]);
    return result;
  };

  const addTriggerFunction = async ({
    function_name,
    body,
    lang = 'plpgsql',
    volatility = null,
    security = null
  }) => {
    await db.any(
      `SELECT actions_public.create_trigger_function(
        v_database_id := $1::uuid,
        v_schema_name := $2::text,
        v_function_name := $3::text,
        v_body := $4::text,
        v_language := $5::text,
        v_volatility := $6::text,
        v_security := $7::int
      )`,
      [
        objs.database1.id,
        objs.database1.private_schema_name,
        function_name,
        body,
        lang,
        volatility,
        security
      ]
    );
  };

  const addTrigger = async ({
    trigger_name,
    schema_name,
    table_name,
    trigger_fn_name,
    params,
    fields,
    timing,
    events
  }) => {
    const eventsNum = events
      .map((s) => s.toUpperCase())
      .reduce((m, e) => {
        switch (e) {
          case 'INSERT':
            return m | 4;
          case 'UPDATE':
            return m | 16;
          case 'DELETE':
            return m | 8;
          default:
            throw new Error('not supported yet');
        }
      }, 0);

    const timingNum = timing.toUpperCase() === 'BEFORE' ? 2 : null;

    await db.any(
      `SELECT actions_public.create_trigger(
        v_database_id := $1::uuid,
        v_trigger_name := $2::text,
        v_schema_name := $3::text,
        v_table_name := $4::text,
        v_trigger_fn_schema := $5::text,
        v_trigger_fn_name := $6::text,
        v_fields := $7::text[],
        v_params := $8::text[],
        v_timing := $9::int,
        v_events := $10::int
        )`,
      [
        objs.database1.id,
        trigger_name,
        schema_name,
        table_name,
        objs.database1.private_schema_name,
        trigger_fn_name,
        fields,
        params,
        timingNum,
        eventsNum
      ]
    );
  };

  const slugifyField = async ({ field, table }) => {
    const schema = objs.getSchemaFromTable(table).schema_name;

    const slugSet = await deparse(
      equals(
        col('new', field),
        funcCall({
          schema_name: 'inflection',
          function_name: 'slugify',
          args: [col('new', field)]
        })
      )
    );

    const function_name = [table, 'slugify', field].join('_');
    await addTriggerFunction({
      function_name,
      body: `
    BEGIN
      ${slugSet};
      RETURN NEW;
    END;
    `
    });

    await addTrigger({
      trigger_name: [table, 'insert', 'slugify', field, 'tg'].join('_'),
      schema_name: schema,
      table_name: table,
      trigger_fn_name: function_name,
      fields: [],
      timing: 'BEFORE',
      events: ['INSERT']
    });

    await addTrigger({
      trigger_name: [table, 'update', 'slugify', field, 'tg'].join('_'),
      schema_name: schema,
      table_name: table,
      trigger_fn_name: function_name,
      fields: [field],
      timing: 'BEFORE',
      events: ['UPDATE']
    });
  };

  const updateOwnedFieldInSharedObject = async ({
    fields,
    table,
    role_key,
    rls_schema,
    rls_func
  }) => {
    const schema = objs.getSchemaFromTable(table).schema_name;

    const userIsOwnerOrRaise = await deparse(
      nequals(
        col('new', role_key),
        funcCall({
          schema_name: rls_schema,
          function_name: rls_func
        })
      )
    );

    const function_name = [table, 'owned_update', fields.join('_')].join('_');
    await addTriggerFunction({
      function_name,
      body: `
    BEGIN
      IF (${userIsOwnerOrRaise}) THEN 
        RAISE EXCEPTION 'OWNED_PROPS';
      END IF;
      RETURN NEW;
    END;
    `
    });

    // await addTrigger({
    //   trigger_name: [table, 'insert', 'owned', fields.join('_'), 'tg'].join(
    //     '_'
    //   ),
    //   schema_name: schema,
    //   table_name: table,
    //   trigger_fn_name: function_name,
    //   fields: [],
    //   timing: 'BEFORE',
    //   events: ['INSERT']
    // });

    await addTrigger({
      trigger_name: [table, 'update', 'owned', fields.join('_'), 'tg'].join(
        '_'
      ),
      schema_name: schema,
      table_name: table,
      trigger_fn_name: function_name,
      fields,
      timing: 'BEFORE',
      events: ['UPDATE']
    });
  };

  const ownedFieldInSharedObject = async ({
    fields,
    table,
    role_key,
    rls_schema,
    rls_func
  }) => {
    await updateOwnedFieldInSharedObject({
      fields,
      table,
      role_key,
      rls_schema,
      rls_func
    });
  };

  const statusTrigger = async ({
    field_name,
    table_name,
    task_name,
    toggle = true,
    boolean = false
    // needs_user_field = false,
    // user_field = null
  }) => {
    const schema_name = objs.getSchemaFromTable(table_name).schema_name;

    let trigger_name = 'tg_achievement';
    if (toggle) trigger_name = trigger_name + '_toggle';
    if (boolean) trigger_name = trigger_name + '_boolean';
    // if (needs_user_field) trigger_name = trigger_name + '_using_field';

    const getTriggerName = (type) =>
      [table_name, type, 'status', 'achievement', field_name, 'tg'].join('_');

    const params = [field_name, task_name];
    // if (user_field) params.push(user_field);

    await addTrigger({
      trigger_name: getTriggerName('insert'),
      schema_name,
      table_name,
      trigger_fn_name: trigger_name,
      params,
      fields: [],
      timing: 'BEFORE',
      events: ['INSERT']
    });

    await addTrigger({
      trigger_name: getTriggerName('update'),
      schema_name,
      table_name,
      trigger_fn_name: trigger_name,
      params,
      fields: [field_name],
      timing: 'BEFORE',
      events: ['UPDATE']
    });
  };

  const addSearchVectorTriggerFunction = async ({
    trigger_name,
    trigger_schema,
    schema_name,
    table_name,
    tsvector_column_name,
    fields
  }) => {
    let [{ expression: result }] = await db.any(
      `select deparser.expression( 
      ast.a_expr(
          v_kind  :=  0, 
          v_lexpr := ast.string('NEW.${tsvector_column_name}'),
          v_name  := to_jsonb(ARRAY[ast.string('=')]),
          v_rexpr := ast_helpers.tsvector_index($1::jsonb)
      )
    );`,
      [JSON.stringify(fields)]
    );

    result = result.trim();

    // https://www.freecodecamp.org/news/how-to-build-a-math-expression-tokenizer-using-javascript-3638d4e5fbe9/

    const function_body = `
    ${result};
    RETURN NEW;
    `;

    await migrate.call('migrate', {
      name: 'trigger_function',
      database_id: objs.database1.id,
      trigger_schema,
      trigger_name,
      function_body: function_body.replace(/\'/g, "''")
    });

    await migrate.call('migrate', {
      name: 'before_insert_or_update_trigger',
      database_id: objs.database1.id,
      trigger_name: table_name + '_tsv_' + tsvector_column_name,
      schema_name,
      table_name,
      trigger_function_schema: trigger_schema,
      trigger_function: trigger_name
    });
  };

  const addIndexMigration = async ({
    database_id,
    index_name,
    schema_name,
    table_name,
    fields,
    access_method = null
  }) => {
    await db.any(
      `
      SELECT actions_public.create_index(
        v_database_id := $1::uuid,
        v_index_name := $2::text,
        v_schema_name := $3::text,
        v_table_name := $4::text,
        v_fields := $5::text[],
        v_accessMethod := $6::text
      );
    `,
      [database_id, index_name, schema_name, table_name, fields, access_method]
    );
  };

  const addPeopleStamps = async ({ table_name }) => {
    const schema = objs.getSchemaFromTable(table_name);

    await migrate.call('migrate', {
      name: 'peoplestamps',

      database_id: objs.database1.id,
      schema_name: schema.schema_name,
      table_name,
      trigger_schema: objs.database1.private_schema_name,
      trigger_name: 'tg_peoplestamps',
      created_by_column: 'created_by',
      updated_by_column: 'updated_by'
    });
  };

  const enableTimestamps = async () => {
    await migrate.call('migrate', {
      name: 'timestamps_trigger',

      database_id: objs.database1.id,
      trigger_schema: objs.database1.private_schema_name,
      trigger_name: 'tg_timestamps',
      created_at_column: 'created_at',
      updated_at_column: 'updated_at'
    });
  };

  const addTimestamps = async ({ table_name }) => {
    const schema = objs.getSchemaFromTable(table_name);
    const schema_name = schema.schema_name;

    await migrate.call('migrate', {
      name: 'timestamps',

      database_id: objs.database1.id,
      schema_name,
      table_name,
      trigger_schema: objs.database1.private_schema_name,
      trigger_name: 'tg_timestamps',
      created_at_column: 'created_at',
      updated_at_column: 'updated_at'
    });
  };

  const createTable = async ({
    name,
    fields,
    stamps = {
      people: true,
      time: true
    },
    is_visible = true,
    add_id = true
  }) => {
    objs.tables[name] = await dbs.insertOne('table', {
      database_id: objs.database1.id,
      schema_id: is_visible
        ? objs.database1.schemas.public.id
        : objs.database1.schemas.private.id,
      name
    });

    if (add_id) {
      const pk_id = await dbs.insertOne('field', {
        table_id: objs.tables[name].id,
        name: 'id',
        type: 'uuid',
        is_required: true,
        default_value: 'uuid_generate_v4 ()'
      });

      await dbs.insertOne(
        'primary_key_constraint',
        {
          table_id: objs.tables[name].id,
          field_ids: [pk_id.id]
        },
        { field_ids: 'uuid[]' }
      );
    }

    for (let i = 0; i < fields.length; i++) {
      const field = fields[i];
      await dbs.insertOne('field', {
        table_id: objs.tables[name].id,
        ...field
      });
    }
    if (stamps.people) {
      await addPeopleStamps({ table_name: name });
    }
    if (stamps.time) {
      await addTimestamps({ table_name: name });
    }
  };

  const addForeignKey = async ({
    table_name,
    field_name,
    ref_table,
    ref_field = 'id',
    index = false,
    is_required = false,
    create = true,
    omit = false,
    smart_tags
  }) => {
    let fk_id;
    if (create) {
      fk_id = await dbs.insertOne('field', {
        table_id: objs.tables[table_name].id,
        name: field_name,
        type: 'uuid',
        is_required
      });
    } else {
      fk_id = await dbs.selectOne('field', ['id'], {
        table_id: objs.tables[table_name].id,
        name: field_name
      });
    }

    const field = await dbs.selectOne('field', ['id'], {
      table_id: objs.tables[ref_table].id,
      name: ref_field
    });

    await dbs.insertOne(
      'foreign_key_constraint',
      {
        table_id: objs.tables[table_name].id,
        field_ids: [fk_id.id],
        ref_table_id: objs.tables[ref_table].id,
        ref_field_ids: [field.id],
        smart_tags: smart_tags ? smart_tags : { omit }
      },
      {
        field_ids: 'uuid[]',
        ref_field_ids: 'uuid[]',
        smart_tags: 'jsonb'
      }
    );

    if (index) {
      await dbs.insertOne(
        'index',
        {
          table_id: objs.tables[table_name].id,
          field_ids: [fk_id.id]
        },
        { field_ids: 'uuid[]' }
      );
    }
    return fk_id;
  };

  const addIndex = async ({ table_name, field_names }) => {
    const ids = [];
    for (let f = 0; f < field_names.length; f++) {
      const { id } = await dbs.selectOne('field', ['id'], {
        table_id: objs.tables[table_name].id,
        name: field_names[f]
      });
      ids.push(id);
    }

    await dbs.insertOne(
      'index',
      {
        table_id: objs.tables[table_name].id,
        field_ids: ids
      },
      { field_ids: 'uuid[]' }
    );
  };

  const addUnique = async ({ table_name, field_names, omit = false }) => {
    const ids = [];
    for (let f = 0; f < field_names.length; f++) {
      const { id } = await dbs.selectOne('field', ['id'], {
        table_id: objs.tables[table_name].id,
        name: field_names[f]
      });
      ids.push(id);
    }

    await dbs.insertOne(
      'unique_constraint',
      {
        table_id: objs.tables[table_name].id,
        field_ids: ids,
        smart_tags: { omit }
      },
      { field_ids: 'uuid[]', smart_tags: 'jsonb' }
    );
  };

  const addFullTextSearch = async ({
    table_name,
    search_field,
    field_names,
    langs,
    weights
  }) => {
    const ids = [];
    for (let f = 0; f < field_names.length; f++) {
      const { id } = await dbs.selectOne('field', ['id'], {
        table_id: objs.tables[table_name].id,
        name: field_names[f]
      });
      ids.push(id);
    }
    const { id: search_field_id } = await dbs.selectOne('field', ['id'], {
      table_id: objs.tables[table_name].id,
      name: search_field
    });

    await dbs.insertOne(
      'full_text_search',
      {
        table_id: objs.tables[table_name].id,
        field_id: search_field_id,
        field_ids: ids,
        weights,
        langs
      },
      {
        field_ids: 'uuid[]',
        weights: 'text[]'
      }
    );
  };

  const createThroughTable = async ({
    name,
    fields = [],
    is_visible = true,
    left_table_name,
    left_table_field,
    right_table_name,
    right_table_field,
    left_field_name,
    right_field_name
  }) => {
    await createTable({
      name,
      fields,
      add_id: false,
      is_visible
    });

    if (left_field_name) {
      left_field_name = {
        manyToManyFieldName: left_field_name
      };
    }
    if (right_field_name) {
      right_field_name = {
        manyToManyFieldName: right_field_name
      };
    }

    const left_fk_field = await addForeignKey({
      table_name: name,
      field_name: left_table_field,
      ref_table: left_table_name,
      index: true,
      is_required: true,
      smart_tags: left_field_name
    });
    const right_fk_field = await addForeignKey({
      table_name: name,
      field_name: right_table_field,
      ref_table: right_table_name,
      index: true,
      is_required: true,
      smart_tags: right_field_name
    });
    await dbs.insertOne(
      'primary_key_constraint',
      {
        table_id: objs.tables[name].id,
        field_ids: [left_fk_field.id, right_fk_field.id]
      },
      { field_ids: 'uuid[]' }
    );
  };

  return {
    enablePeopleStamps,
    enableTimestamps,
    addIndex,
    addForeignKey,
    addUnique,
    addTimestamps,
    addPeopleStamps,
    createTable,
    createThroughTable,
    addSearchVectorTrigger,
    addSearchVectorTriggerFunction,
    addIndexMigration,
    addFullTextSearch,
    applyRLS,
    addTrigger,
    addTriggerFunction,
    slugifyField,
    statusTrigger,
    ownedFieldInSharedObject,
    deparse
  };
};
