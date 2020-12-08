\echo Use "CREATE EXTENSION dbs" to load this file. \quit
CREATE SCHEMA collections_private;

CREATE SCHEMA collections_public;

SELECT db_utils.migrate('timestamps_trigger', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE TABLE collections_public.database (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	owner_id uuid,
	schema_hash text,
	schema_name text,
	private_schema_name text,
	name text,
	UNIQUE ( schema_hash ),
	UNIQUE ( schema_name ),
	UNIQUE ( private_schema_name ) 
);

ALTER TABLE collections_public.database ADD CONSTRAINT db_namechk CHECK ( char_length(name) > 2 );

COMMENT ON COLUMN collections_public.database.schema_hash IS E'@omit';

SELECT db_utils.migrate('timestamps', 'collections_public', 'database', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE TABLE collections_public.schema (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	name text NOT NULL,
	schema_name text NOT NULL,
	description text,
	UNIQUE ( database_id, name ),
	UNIQUE ( schema_name ) 
);

ALTER TABLE collections_public.schema ADD CONSTRAINT schema_namechk CHECK ( char_length(name) > 2 );

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'schema', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'schema', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE TABLE collections_public."table" (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	schema_id uuid NOT NULL REFERENCES collections_public.schema ( id ) ON DELETE CASCADE,
	name text NOT NULL,
	description text,
	smart_tags jsonb,
	is_system boolean DEFAULT ( FALSE ),
	use_rls boolean NOT NULL DEFAULT ( FALSE ),
	plural_name text,
	singular_name text,
	UNIQUE ( database_id, name ) 
);

ALTER TABLE collections_public."table" ADD COLUMN  inherits_id uuid NULL REFERENCES collections_public."table" ( id );

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'table', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'table', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE TABLE collections_public.field (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	table_id uuid NOT NULL REFERENCES collections_public."table" ( id ) ON DELETE CASCADE,
	name text NOT NULL,
	description text,
	smart_tags jsonb,
	is_required boolean NOT NULL DEFAULT ( FALSE ),
	default_value text NULL DEFAULT ( NULL ),
	is_hidden boolean NOT NULL DEFAULT ( FALSE ),
	type citext NOT NULL,
	field_order int NOT NULL DEFAULT ( 0 ),
	regexp text DEFAULT ( NULL ),
	chk jsonb DEFAULT ( NULL ),
	chk_expr jsonb DEFAULT ( NULL ),
	min pg_catalog.float8 DEFAULT ( NULL ),
	max pg_catalog.float8 DEFAULT ( NULL ),
	UNIQUE ( table_id, name ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'field', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'field', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE FUNCTION collections_private.build_check_for_field ( field collections_public.field ) RETURNS jsonb AS $EOFCODE$
DECLARE
  asts jsonb[];
BEGIN

  -- custom
  IF (field.chk IS NOT NULL) THEN 
    asts = array_append(asts, field.chk);
  END IF; 

  -- TEXT min
  IF (field.min IS NOT NULL) THEN 
      IF ( field.type = 'text' OR field.type = 'citext' ) THEN 
        asts = array_append(asts, ast_helpers.gte(
          ast.func_call(
            v_funcname := to_jsonb(ARRAY[
              ast.string('character_length')
            ]),
            v_args := to_jsonb(ARRAY[
              ast_helpers.col(field.name)
            ])
          ),
          ast.a_const(
            v_val := ast.integer(
              v_ival := field.min::int
            )
          )
        ));
      ELSEIF ( field.type = 'integer' OR field.type = 'int' OR field.type = 'smallint' OR field.type = 'bigint' ) THEN 
        asts = array_append(asts, ast_helpers.gte(
          ast_helpers.col(field.name),
          ast.a_const(
            v_val := ast.integer(
              v_ival := field.min::int
            )
          )
        ));
      ELSEIF ( field.type = 'float' OR field.type = 'real' ) THEN 
        asts = array_append(asts, ast_helpers.gte(
          ast_helpers.col(field.name),
          ast.a_const(
            v_val := ast.float(
              v_str := field.min::text
            )
          )
        ));
      END IF;
  END IF;

  -- TEXT max
  IF (field.max IS NOT NULL) THEN 
      IF ( field.type = 'text' OR field.type = 'citext' ) THEN 
        asts = array_append(asts, ast_helpers.lte(
          ast.func_call(
            v_funcname := to_jsonb(ARRAY[
              ast.string('character_length')
            ]),
            v_args := to_jsonb(ARRAY[
              ast_helpers.col(field.name)
            ])
          ),
          ast.a_const(
            v_val := ast.integer(
              v_ival := field.max::int
            )
          )
        ));
      ELSEIF ( field.type = 'integer' OR field.type = 'int' OR field.type = 'smallint' OR field.type = 'bigint' ) THEN 
        asts = array_append(asts, ast_helpers.lte(
          ast_helpers.col(field.name),
          ast.a_const(
            v_val := ast.integer(
              v_ival := field.max::int
            )
          )
        ));
      ELSEIF ( field.type = 'float' OR field.type = 'real' ) THEN 
        asts = array_append(asts, ast_helpers.lte(
          ast_helpers.col(field.name),
          ast.a_const(
            v_val := ast.float(
              v_str := field.max::text
            )
          )
        ));
      END IF;
  END IF;

  -- TEXT regexp
  IF (field.regexp IS NOT NULL) THEN 
      IF ( field.type = 'text' OR field.type = 'citext' ) THEN 
        asts = array_append(asts, ast_helpers.matches(
            ast_helpers.col( field.name ),
            field.regexp
        ));
      END IF;
  END IF;

  IF (asts IS NULL OR cardinality(asts) = 0) THEN 
    RETURN NULL;
  END IF;

  IF (cardinality(asts) = 1) THEN 
    RETURN asts[1];
  END IF;

  RETURN ast_helpers.and( variadic nodes := asts );
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION collections_private.create_profiles_table ( database_id uuid, table_name text, table_is_visible boolean DEFAULT TRUE ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;
  
  pk_id uuid;
  name_id uuid;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  -- profiles table
  INSERT INTO collections_public.table 
    (database_id, name, is_visible, is_system)
    VALUES (database_id, table_name, table_is_visible, true)
  RETURNING * INTO tb;

  -- pk_id
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'id', 'uuid', true, 'uuid_generate_v4 ()')
  RETURNING id INTO pk_id;

  -- name
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required)
  VALUES 
    (tb.id, 'name', 'text', true)
  RETURNING id INTO name_id;

  -- description
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required)
  VALUES 
    (tb.id, 'description', 'text', false);

  -- constraint  
  INSERT INTO collections_public.primary_key_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[pk_id]);

  -- constraint
  INSERT INTO collections_public.unique_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[name_id]);

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE FUNCTION collections_private.get_available_schema_hash (  ) RETURNS text AS $EOFCODE$
DECLARE
  v_bytes text;
  v_schema_hash text;
  v_exists boolean;
  v_private_schema_hash text;
BEGIN
  SELECT
    encode(gen_random_bytes(5), 'hex') INTO v_bytes;
  SELECT
    inflection_db.get_schema_name (ARRAY['zz', v_bytes]) INTO v_schema_hash;
  
  IF (
    SELECT
      1
    FROM
      collections_public.database
    WHERE
      collections_public.database.schema_hash = v_schema_hash) THEN
    RETURN collections_private.get_available_schema_hash ();
  END IF;
  
  RETURN v_schema_hash;
END
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.get_schema_name_by_database_id_and_name ( database_id uuid, schema_name text ) RETURNS text AS $EOFCODE$
DECLARE
  schema_name text;
BEGIN

  SELECT s.schema_name FROM collections_public.schema s
    WHERE
    s.name = get_schema_name_by_database_id_and_name.schema_name
    AND s.database_id = get_schema_name_by_database_id_and_name.database_id
  INTO schema_name;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  RETURN schema_name;

END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION collections_private.get_schema_name_by_database_id ( database_id uuid, schema_id uuid ) RETURNS text AS $EOFCODE$
DECLARE
  schema_name text;
BEGIN

  SELECT s.schema_name FROM collections_public.schema s
    WHERE
    s.id = get_schema_name_by_database_id.schema_id
    AND s.database_id = get_schema_name_by_database_id.database_id
  INTO schema_name;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  RETURN schema_name;

END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION collections_private.get_schema_name_by_table_id ( table_id uuid ) RETURNS text AS $EOFCODE$
DECLARE
  schema_name text;
BEGIN

  SELECT s.schema_name FROM collections_public.schema s
    JOIN collections_public.table t ON (t.schema_id = s.id AND t.database_id = s.database_id)
    WHERE t.id = table_id
  INTO schema_name;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  RETURN schema_name;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION collections_private.introspect_schemas ( db_id uuid, schema_names text[] ) RETURNS void AS $EOFCODE$
DECLARE
 namesp pg_catalog.pg_namespace;
 s collections_public.schema;
BEGIN

  FOR namesp IN
  SELECT * FROM
      pg_catalog.pg_namespace as nsp
  WHERE
      nspname = ANY (schema_names)
  LOOP
    INSERT INTO collections_public.schema (
      database_id,
      name,
      schema_name
    ) values (
      db_id,
      namesp.nspname,
      namesp.nspname
    ) ON CONFLICT (schema_name)
    -- old schemas still there... since we're looking at ALL schemas currently...
    DO UPDATE SET schema_name = EXCLUDED.schema_name
    RETURNING * INTO s;

    PERFORM collections_private.introspect_schema_tables(
      db_id,
      s.id,
      s.schema_name
    );

  END LOOP;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.introspect_schema_tables ( db_id uuid, sc_id uuid, schema_name text ) RETURNS void AS $EOFCODE$
DECLARE
 cls pg_catalog.pg_class;
 t collections_public.table;
BEGIN

  FOR cls IN
    SELECT * FROM 
    collections_private.get_all_tables_of_schema(schema_name)
  LOOP

      INSERT INTO collections_public.table (
        database_id,
        schema_id,
        name
      ) values (
        db_id,
        sc_id,
        cls.relname
      ) ON CONFLICT (database_id, name)
      -- old schemas still there... since we're looking at ALL schemas currently...
      DO UPDATE SET name = EXCLUDED.name
      RETURNING * INTO t;

      PERFORM collections_private.introspect_table_attributes(
        db_id,
        t.id,
        cls.oid
      );

      PERFORM collections_private.introspect_table_primary_key_constraints(
        db_id,
        t.id,
        cls.oid
      );

  END LOOP;

  -- ONLY after you get all primary keys, can you do foreign, so let's just do all of them after...

  FOR cls IN
    SELECT * FROM 
    collections_private.get_all_tables_of_schema(schema_name)
  LOOP

      SELECT * FROM collections_public.table tt
        WHERE tt.name = cls.relname::text
        AND tt.database_id = db_id
      INTO t;

      -- fkey, unique, etc
      PERFORM collections_private.introspect_table_constraints(
        db_id,
        t.id,
        cls.oid
      );

  END LOOP;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.get_all_tables_of_schema ( schema_name text ) RETURNS SETOF pg_catalog.pg_class AS $EOFCODE$
  select
    rel.*
  from
    pg_catalog.pg_class as rel
    left join pg_catalog.pg_namespace as nsp on nsp.oid = rel.relnamespace
  where
    rel.relpersistence in ('p') and
    -- We don't want classes that will clash with GraphQL (treat them as private)
    rel.relname not like E'\\\\_\\\\_%' and
    rel.relkind in ('r', 'v', 'm', 'c', 'f') and 
    nsp.nspname = schema_name;
$EOFCODE$ LANGUAGE sql STABLE;

CREATE FUNCTION collections_private.introspect_table_attributes ( db_id uuid, t_id uuid, tableoid oid ) RETURNS void AS $EOFCODE$
DECLARE
 attr pg_catalog.pg_attribute;
BEGIN

  FOR attr IN
    SELECT * FROM
      pg_catalog.pg_attribute as att
    where
      att.attrelid = introspect_table_attributes.tableoid and
      att.attnum > 0 and
      -- We don't want attributes that will clash with GraphQL (treat them as private)
      att.attname not like E'\\\\_\\\\_%' and
      not att.attisdropped
    order by
      att.attnum
  LOOP 
    
    INSERT INTO collections_public.field (
      database_id,
      table_id,
      name,
      type,
      field_order
    ) values (
      db_id,
      t_id,
      attr.attname,
      -- TODO look at typmods... FOR complex types this will not cut it!
      (select typname FROM pg_catalog.pg_type WHERE oid = attr.atttypid),
      attr.attnum
    );

  END LOOP;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.introspect_table_primary_key_constraint ( db_id uuid, t_id uuid, tableoid oid, constoid oid, conname name, conkey smallint[] ) RETURNS void AS $EOFCODE$
DECLARE
  field_names text[];
  field_ids uuid[];
BEGIN

  SELECT array (
    SELECT a.attname FROM pg_catalog.pg_attribute a
      WHERE a.attnum = ANY ( conkey ) 
      AND a.attrelid = introspect_table_primary_key_constraint.tableoid
  ) INTO field_names;

  SELECT array (
    SELECT f.id FROM collections_public.field f 
      WHERE f.name = ANY ( field_names )
      AND f.table_id = t_id
  ) INTO field_ids;

  INSERT INTO collections_public.primary_key_constraint
  (database_id, table_id, name, type, field_ids) VALUES 
  (
    db_id,
    t_id,
    conname,
    'p',
    field_ids
  );

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.introspect_table_unique_constraint ( db_id uuid, t_id uuid, tableoid oid, constoid oid, conname name, conkey smallint[] ) RETURNS void AS $EOFCODE$
DECLARE
  field_names text[];
  field_ids uuid[];
BEGIN

  SELECT array (
    SELECT a.attname FROM pg_catalog.pg_attribute a
      WHERE a.attnum = ANY ( introspect_table_unique_constraint.conkey ) 
      AND a.attrelid = introspect_table_unique_constraint.tableoid
  ) INTO field_names;

  SELECT array (
    SELECT f.id FROM collections_public.field f 
      WHERE f.name = ANY ( field_names )
      AND f.table_id = t_id
  ) INTO field_ids;

  IF (cardinality(field_names) != cardinality(field_ids)) THEN
    RAISE LOG 'UNIQ % % %', constoid, field_names, field_ids;
    RETURN;
  END IF;

  INSERT INTO collections_public.unique_constraint
  (database_id, table_id, name, type, field_ids) VALUES 
  (
    db_id,
    t_id,
    conname,
    'u',
    field_ids
  );

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.introspect_table_foreign_key_constraint ( db_id uuid, t_id uuid, tableoid oid, reftableoid oid, constoid oid, conname name, conkey smallint[], confkey smallint[], confdeltype "char", confupdtype "char" ) RETURNS void AS $EOFCODE$
DECLARE
  rt collections_public.table;
  rcls pg_catalog.pg_class;
  field_names text[];
  field_ids uuid[];
  ref_field_names text[];
  ref_field_ids uuid[];
BEGIN

  SELECT array (
    SELECT a.attname FROM pg_catalog.pg_attribute a
      WHERE a.attnum = ANY ( conkey ) 
      AND a.attrelid = introspect_table_foreign_key_constraint.tableoid
  ) INTO field_names;

  SELECT array (
    SELECT f.id FROM collections_public.field f 
      WHERE f.name = ANY ( field_names )
      AND f.table_id = t_id
  ) INTO field_ids;

  SELECT array (
    SELECT a.attname FROM pg_catalog.pg_attribute a
      WHERE a.attnum = ANY ( confkey ) 
      AND a.attrelid = introspect_table_foreign_key_constraint.reftableoid
  ) INTO ref_field_names;

  -- get other table info
  SELECT * FROM pg_catalog.pg_class k
    WHERE k.oid = introspect_table_foreign_key_constraint.reftableoid
  INTO rcls;

  SELECT * FROM collections_public.table tb
    WHERE tb.database_id = db_id AND tb.name = rcls.relname
  INTO rt;

  SELECT array (
    SELECT f.id FROM collections_public.field f 
      WHERE f.name = ANY ( ref_field_names )
      AND f.table_id = rt.id
  ) INTO ref_field_ids;

  IF (cardinality(field_names) != cardinality(field_ids)) THEN
    RAISE LOG 'FKEY this % % % %', conname, conkey, field_names, field_ids;
    RETURN;
  END IF;

  IF (cardinality(ref_field_names) != cardinality(ref_field_ids)) THEN
    RAISE LOG 'FKEY ref % % % %', conname, confkey, ref_field_names, ref_field_ids;
    RETURN;
  END IF;

  INSERT INTO collections_public.foreign_key_constraint
  (
    database_id,
    table_id,
    name,
    type,
    field_ids,
    ref_table_id,
    ref_field_ids,
    delete_action,
    update_action
  ) VALUES 
  (
    db_id,
    t_id,
    conname,
    'f',
    field_ids,
    rt.id,
    ref_field_ids,
    confdeltype,
    confupdtype
  );

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.introspect_table_primary_key_constraints ( db_id uuid, t_id uuid, tableoid oid ) RETURNS void AS $EOFCODE$
DECLARE
  const pg_catalog.pg_constraint;
BEGIN

  FOR const IN
  SELECT DISTINCT ON (con.conrelid, con.conkey, con.confrelid, con.confkey)
    con.*
  FROM
    pg_catalog.pg_constraint AS con
  WHERE
    con.contype IN ('p')
    AND con.conrelid = introspect_table_primary_key_constraints.tableoid
  ORDER BY
    con.conrelid, con.conkey, con.confrelid, con.confkey, con.conname
  LOOP 

    PERFORM collections_private.introspect_table_primary_key_constraint(
      db_id,
      t_id,
      tableoid,
      const.oid,
      const.conname,
      const.conkey
    );

  END LOOP;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.introspect_table_constraints ( db_id uuid, t_id uuid, tableoid oid ) RETURNS void AS $EOFCODE$
DECLARE
  const pg_catalog.pg_constraint;
BEGIN
  FOR const IN
  SELECT DISTINCT ON (con.conrelid, con.conkey, con.confrelid, con.confkey)
    con.*
  FROM
    pg_catalog.pg_constraint AS con
  WHERE
    con.contype IN ('f','u')
    -- con.contype IN ('f','u', 'c')
    AND con.conrelid = introspect_table_constraints.tableoid
  ORDER BY
    con.conrelid, con.conkey, con.confrelid, con.confkey, con.conname
  LOOP 
    IF (const.contype = 'f') THEN 
      PERFORM collections_private.introspect_table_foreign_key_constraint(
        db_id,
        t_id,
        tableoid,
        const.confrelid,
        const.oid,
        const.conname,
        const.conkey,
        const.confkey,
        const.confdeltype,
        const.confupdtype
      );
    ELSEIF (const.contype = 'u') THEN 
      PERFORM collections_private.introspect_table_unique_constraint(
        db_id,
        t_id,
        tableoid,
        const.oid,
        const.conname,
        const.conkey
      );
    END IF;
  END LOOP;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.introspect_reset ( dbname text, schema_names text[] ) RETURNS uuid AS $EOFCODE$
DECLARE
 db collections_public.database;
BEGIN

SET session_replication_role TO replica;

-- TRUNCATE
--   collections_public.database,
--   collections_public.schema,
--   collections_public.table,
--   collections_public.foreign_key_constraint,
--   collections_public.full_text_search,
--   collections_public.index,
--   collections_public.rls_function,
--   collections_public.policy,
--   collections_public.primary_key_constraint,
--   collections_public.procedure,
--   collections_public.schema_grant,
--   collections_public.table_grant,
--   collections_public.trigger_function,
--   collections_public.trigger,
--   collections_public.trigger_function,
--   collections_public.unique_constraint,
--   collections_public.field
--  CASCADE;

  INSERT INTO collections_public.database (
    name
  ) values (
    dbname
  )
  RETURNING * INTO db;

  PERFORM collections_private.introspect_schemas(
    db.id,
    schema_names
  );

  SET session_replication_role TO DEFAULT;

  -- TODO full txs_public integration
  PERFORM txs_public.init_empty_repo(
    db.id
  );

  -- 1 set a schema hash
  UPDATE collections_public.database d
    SET schema_hash = collections_private.get_available_schema_hash()
  WHERE d.id = db.id;

  -- 2  for now we just assume you aren't pulling in these sames...
  INSERT INTO collections_public.schema (database_id, name)
     VALUES (db.id, 'public'), (db.id, 'private');

  RETURN db.id;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.is_valid_type ( type citext ) RETURNS boolean AS $EOFCODE$
BEGIN
  IF (type = 'serial' OR type = 'bigserial' OR type = 'smallserial') THEN
    RETURN TRUE;
  END IF;
  RETURN pg_type_is_visible(type::regtype);
exception
  WHEN OTHERS THEN
    RETURN FALSE;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE VIEW collections_private.collections AS SELECT * FROM information_schema.tables WHERE table_schema <> 'pg_catalog' AND table_schema <> 'information_schema';

CREATE RULE collections_ins_protect AS ON INSERT TO collections_private.collections DO INSTEAD NOTHING;

CREATE RULE collections_upd_protect AS ON UPDATE TO collections_private.collections DO INSTEAD NOTHING;

CREATE RULE collections_del_protect AS ON DELETE TO collections_private.collections DO INSTEAD NOTHING;

CREATE TABLE collections_public.table_grant (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	table_id uuid NOT NULL REFERENCES collections_public."table" ( id ) ON DELETE CASCADE,
	privilege text NOT NULL,
	role_name text NOT NULL,
	field_ids uuid[],
	UNIQUE ( table_id, privilege, role_name ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'table_grant', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'table_grant', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE TABLE collections_public.policy (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	table_id uuid NOT NULL REFERENCES collections_public."table" ( id ) ON DELETE CASCADE,
	name text,
	role_name text,
	privilege text,
	permissive boolean DEFAULT ( TRUE ),
	policy_template_name text,
	policy_template_vars json,
	UNIQUE ( table_id, name ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'policy', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'policy', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE FUNCTION collections_public.upsert_table_grant ( db_id uuid, tb_id uuid, priv text, rolename text, field_ids uuid[] DEFAULT NULL ) RETURNS void AS $EOFCODE$
BEGIN

    INSERT INTO collections_public.table_grant (
      database_id,
      table_id,
      privilege,
      role_name,
      field_ids
    ) VALUES (
      db_id,
      tb_id,
      priv,
      rolename,
      field_ids
    ) ON CONFLICT (table_id, privilege, role_name)
    DO NOTHING;
    -- TODO look at how update triggers are handled for table_grants...
    --UPDATE SET field_ids = EXCLUDED.field_ids;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_public.apply_rls ( table_id uuid, grants jsonb, template text, vars jsonb, field_ids uuid[] DEFAULT NULL, permissive bool DEFAULT TRUE, name text DEFAULT NULL ) RETURNS void AS $EOFCODE$
DECLARE
  tbl collections_public.table;

  item jsonb;

  privilege text;
  role_name text;

  proper_privs text[] = ARRAY['insert', 'select', 'update', 'delete'];
  proper_roles text[] = ARRAY['public', 'anonymous', 'authenticated', 'administrator'];

BEGIN
  SELECT * FROM collections_public.table t
    WHERE t.id = table_id
  INTO tbl;

  -- use RLS

  IF (tbl.use_rls IS FALSE) THEN 
    UPDATE collections_public.table t
      SET use_rls = TRUE
    WHERE t.id = table_id
    RETURNING * INTO tbl;
  END IF;

  -- apply policies

  FOR item IN 
  SELECT * FROM jsonb_array_elements(grants)
  LOOP 
    IF (jsonb_typeof (item) != 'array' OR jsonb_array_length(item) != 2) THEN
      RAISE EXCEPTION 'APPLY_RLS_BAD_ARGS';
    END IF;

    privilege = item->>0;
    role_name = item->>1;

    INSERT INTO collections_public.policy (
      database_id,
      table_id,
      name,
      role_name,
      privilege,
      permissive,
      policy_template_name,
      policy_template_vars
    ) VALUES (
      tbl.database_id,
      tbl.id,
      name,
      role_name,
      privilege,
      permissive,
      template,
      vars
    );

  END LOOP;

  -- insert grants

  FOR item IN 
  SELECT * FROM jsonb_array_elements(grants)
  LOOP 
    IF (jsonb_typeof (item) != 'array' OR jsonb_array_length(item) != 2) THEN
      RAISE EXCEPTION 'APPLY_RLS_BAD_ARGS';
    END IF;

    privilege = lower(item->>0);
    role_name = lower(item->>1);
    
    IF (NOT (privilege = ANY(proper_privs))) THEN 
      RAISE EXCEPTION 'APPLY_RLS (bad privs) %', privilege;
    END IF;

    IF (NOT (role_name = ANY(proper_roles))) THEN 
      RAISE EXCEPTION 'APPLY_RLS (bad roles) %', role_name;
    END IF;

    PERFORM collections_public.upsert_table_grant (
      tbl.database_id,
      tbl.id,
      privilege,
      role_name,
      field_ids
    );

  END LOOP;


END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TABLE collections_public.check_constraint (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	table_id uuid NOT NULL REFERENCES collections_public."table" ( id ) ON DELETE CASCADE,
	name text,
	type text,
	field_ids uuid[] NOT NULL,
	expr jsonb,
	UNIQUE ( database_id, name ),
	CHECK ( field_ids <> '{}' ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'check_constraint', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'check_constraint', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE FUNCTION collections_private.tg_ensure_check_constraint_database_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    db_id uuid;
BEGIN
    SELECT t.database_id FROM collections_public.table t
        WHERE NEW.table_id = t.id 
    INTO db_id;
    NEW.database_id = db_id;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER _0000_ensure_check_constraint_database_id 
 BEFORE INSERT ON collections_public.check_constraint 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_ensure_check_constraint_database_id (  );

CREATE FUNCTION collections_private.tg_on_insert_check_constraint (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;
  constraint_name text;
  fields text[];
BEGIN
    NEW.type = 'c';

    schema_name = collections_private.get_schema_name_by_table_id(NEW.table_id);
    
    SELECT collections_public.table.database_id
        INTO database_id
        FROM collections_public.table
        WHERE id=NEW.table_id;

    SELECT collections_public.table.name
        INTO table_name
        FROM collections_public.table
        WHERE id=NEW.table_id;

    SELECT array (SELECT f.name FROM collections_public.field f WHERE f.id = ANY ( NEW.field_ids ) AND f.database_id = NEW.database_id) INTO fields;

    constraint_name = inflection_db.get_check_constraint_name(table_name, fields);
    NEW.name = constraint_name;

    IF (NEW.expr IS NOT NULL) THEN 
        PERFORM actions_public.create_check_constraint(
            v_database_id := NEW.database_id,
            v_schema_name := schema_name,
            v_table_name := table_name,
            v_constraint_name := constraint_name,
            v_constraint_expr := NEW.expr
        );
    END IF;

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_insert_check_constraint 
 BEFORE INSERT ON collections_public.check_constraint 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_on_insert_check_constraint (  );

CREATE FUNCTION collections_private.tg_on_delete_check_constraint (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;
  fields text[];
BEGIN

    schema_name = collections_private.get_schema_name_by_table_id(OLD.table_id);
    
    SELECT collections_public.table.database_id
        INTO database_id
        FROM collections_public.table
        WHERE id=OLD.table_id;

    SELECT collections_public.table.name
        INTO table_name
        FROM collections_public.table
        WHERE id=OLD.table_id;

        PERFORM actions_public.drop_constraint(
            v_database_id := OLD.database_id,
            v_schema_name := schema_name,
            v_table_name := table_name,
            v_constraint_name := OLD.name
        );

 RETURN OLD;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.tg_on_update_check_constraint (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;
  fields text[];
BEGIN
    NEW.type = 'c';

    schema_name = collections_private.get_schema_name_by_table_id(NEW.table_id);
    
    SELECT collections_public.table.database_id
        INTO database_id
        FROM collections_public.table
        WHERE id=NEW.table_id;

    SELECT collections_public.table.name
        INTO table_name
        FROM collections_public.table
        WHERE id=NEW.table_id;

    IF (NEW.expr IS NOT NULL) THEN 
        PERFORM actions_public.modify_check_constraint(
            v_database_id := NEW.database_id,
            v_schema_name := schema_name,
            v_table_name := table_name,
            v_constraint_name := NEW.name,
            v_constraint_expr := NEW.expr,
            v_old_constraint_expr := OLD.expr
        );
    ELSE 
        PERFORM actions_public.drop_constraint(
            v_database_id := NEW.database_id,
            v_schema_name := schema_name,
            v_table_name := table_name,
            v_constraint_name := NEW.name
        );
    END IF;

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_update_check_constraint 
 BEFORE UPDATE ON collections_public.check_constraint 
 FOR EACH ROW
 WHEN ( NEW.expr IS DISTINCT FROM OLD.expr ) 
 EXECUTE PROCEDURE collections_private. tg_on_update_check_constraint (  );

CREATE TRIGGER on_delete_check_constraint 
 BEFORE DELETE ON collections_public.check_constraint 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_on_delete_check_constraint (  );

CREATE FUNCTION collections_private.database_name_hash ( name text ) RETURNS bytea AS $EOFCODE$
  SELECT
    DECODE(MD5(LOWER(inflection.plural (name))), 'hex');
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE UNIQUE INDEX databases_database_unique_name_idx ON collections_public.database ( owner_id, collections_private.database_name_hash(name) );

CREATE FUNCTION collections_private.before_create_database_trigger (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  IF tg_op = 'INSERT' THEN

    -- NOTE use this for now while our test env is our prod env... for deployment. You know what I'm talking about. Hopefully your future self removes this laughing!
    -- NEW.schema_hash = collections_private.get_available_schema_hash();
    NEW.schema_hash = inflection_db.get_schema_name (ARRAY['zz', SUBSTRING(uuid_generate_v5 (uuid_ns_url (), NEW.name)::text FROM 1 FOR 8)]);

    -- TODO soon deprecate these!
    NEW.schema_name = inflection_db.get_schema_name (ARRAY[NEW.schema_hash, 'public']);
    NEW.private_schema_name = inflection_db.get_schema_name (ARRAY[NEW.schema_hash, 'private']);

    PERFORM txs_public.init_empty_repo(
      NEW.id
    );

  END IF;
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql;

CREATE FUNCTION collections_private.create_database_trigger (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  IF tg_op = 'INSERT' THEN
     INSERT INTO collections_public.schema (database_id, name)
      VALUES (NEW.id, 'public'), (NEW.id, 'private');
  END IF;
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql;

CREATE TRIGGER before_create_database_trigger 
 BEFORE INSERT ON collections_public.database 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. before_create_database_trigger (  );

CREATE TRIGGER create_database_trigger 
 AFTER INSERT ON collections_public.database 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. create_database_trigger (  );

CREATE UNIQUE INDEX databases_field_uniq_names_idx ON collections_public.field ( table_id, decode(md5(lower(regexp_replace(name, '^(.+?)(_row_id|_id|_uuid|_fk|_pk)$', '\1', 'i'))), 'hex') );

CREATE FUNCTION collections_private.tg_00001_ensure_no_sql_injection (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  matches int;
BEGIN
    matches = array_length(regexp_split_to_array(NEW.default_value, ';'), 1) - 1;
    IF (matches > 0) THEN
        -- TODO track this user...
        RAISE EXCEPTION 'BAD_FIELD_INPUT';
    END IF;
 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE TRIGGER _00001_ensure_no_sql_injection 
 BEFORE INSERT OR UPDATE ON collections_public.field 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_00001_ensure_no_sql_injection (  );

CREATE FUNCTION collections_private.after_insert_field_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;
BEGIN
  IF tg_op = 'INSERT' THEN

    schema_name = collections_private.get_schema_name_by_table_id(NEW.table_id);

    SELECT collections_public.table.database_id
      INTO database_id
      FROM collections_public.table
      WHERE id=NEW.table_id;

    SELECT collections_public.table.name
      INTO table_name
      FROM collections_public.table
      WHERE id=NEW.table_id;

    PERFORM
        db_migrate.migrate('alter_table_add_column',
          database_id::text,
          schema_name,
          table_name,
          NEW.name,
          NEW.type
        );

    IF (NEW.is_required) THEN
      PERFORM db_migrate.migrate('alter_table_set_column_not_null', database_id::text, schema_name, table_name, NEW.name);
    END IF;

    IF (NEW.default_value IS NOT NULL) THEN
      PERFORM db_migrate.migrate('alter_table_set_column_default', database_id::text, schema_name, table_name, NEW.name, NEW.default_value);
    END IF;

    -- check constraints
    NEW.chk_expr = collections_private.build_check_for_field( NEW );
    IF (NEW.chk_expr IS NOT NULL) THEN 
      INSERT INTO collections_public.check_constraint 
        (database_id, table_id, field_ids, expr)
      VALUES 
        (NEW.database_id, NEW.table_id, ARRAY[NEW.id], NEW.chk_expr)
      ;
    END IF;

    IF (NEW.is_hidden) THEN
      -- PERFORM db_utils.set_hidden_smart_comment(schema_name, table_name, NEW.name);
    END IF;

    RETURN NEW;
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER after_insert_field_trigger 
 AFTER INSERT ON collections_public.field 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. after_insert_field_trigger (  );

CREATE FUNCTION collections_private.tg_before_delete_field (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;

BEGIN
    SELECT collections_public.table.name
      INTO table_name
      FROM collections_public.table
      WHERE id=OLD.table_id;

    IF (NOT FOUND) THEN
      -- probably delete cascade...
      RETURN OLD;
    END IF;


    schema_name = collections_private.get_schema_name_by_table_id(OLD.table_id);

    SELECT collections_public.table.database_id
      INTO database_id
      FROM collections_public.table
      WHERE id=OLD.table_id;

    PERFORM db_migrate.migrate('alter_table_drop_column',
        database_id::text,
        schema_name,
        table_name,
        OLD.name, 
        OLD.type
    );

    RETURN OLD;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_delete_field 
 BEFORE DELETE ON collections_public.field 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_before_delete_field (  );

CREATE FUNCTION collections_private.before_insert_field_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  using_uuid boolean = FALSE;
  private_schema text;
BEGIN
  IF tg_op = 'INSERT' THEN
    NEW.name = inflection_db.get_field_name (NEW.name);
    -- strip off the [] if it exists at the end, and set is_array prop
--    IF (ARRAY_LENGTH(REGEXP_MATCHES(trim(NEW.type), '(.*)\s*(\[\s*?\])$', 'i'), 1) > 0) THEN
--      NEW.type = REGEXP_REPLACE(trim(NEW.type), '(.*)\s*(\[\s*?\])$', '\1', 'i');
--      NEW.is_array = TRUE;
--    END IF;
    NEW.type = trim(NEW.type);

    -- this should move into a less hard-coded, more smart system...
    IF (NEW.default_value IS NOT NULL) THEN
      NEW.default_value = trim(NEW.default_value);

      -- ewwwwww
      NEW.default_value = migrations_private.quoted_text(NEW.default_value);

      SELECT
        count(s) > 0
      FROM
        REGEXP_MATCHES(NEW.default_value, 'uuid_generate_v4') AS s INTO using_uuid;

      IF (using_uuid AND NEW.type = 'uuid') THEN

      -- TODO cleanup, perhaps just get schema_id off of function
      -- that matches name uuid_generate_v4
      
        SELECT s.schema_name FROM collections_public.schema s
        JOIN collections_public.table t ON (t.database_id = s.database_id)
          WHERE s.database_id = NEW.database_id
          AND s.name = 'private'
          AND t.id = NEW.table_id
          INTO private_schema;

        IF (NOT FOUND) THEN
          RAISE EXCEPTION 'NOT_FOUND';
        END IF;

        IF (
          SELECT
            EXISTS (
            SELECT
              *
            FROM
              pg_proc p
              JOIN pg_namespace n ON (n.oid = p.pronamespace)
          WHERE
            n.nspname = private_schema AND proname = 'uuid_generate_v4')) THEN
          NEW.default_value = '"' || private_schema || '"' || '.uuid_generate_v4()';
        END IF;
        
      END IF;
    END IF;
  END IF;
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_field_trigger 
 BEFORE INSERT ON collections_public.field 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. before_insert_field_trigger (  );

CREATE FUNCTION collections_private.tg_before_insert_set_field_order (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  NEW.field_order = 
    (SELECT count(1) FROM collections_public.field mf
        WHERE mf.table_id = NEW.table_id);
 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_insert_set_field_order 
 BEFORE INSERT ON collections_public.field 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_before_insert_set_field_order (  );

CREATE FUNCTION collections_private.tg_ensure_field_database_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    db_id uuid;
BEGIN
    SELECT t.database_id FROM collections_public.table t
        WHERE NEW.table_id = t.id 
    INTO db_id;
    NEW.database_id = db_id;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER _0000_ensure_field_database_id 
 BEFORE INSERT ON collections_public.field 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_ensure_field_database_id (  );

CREATE FUNCTION collections_private.tg_ensure_field_not_reserved_word (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    singular_name text;
BEGIN
    singular_name = inflection_db.get_field_name(NEW.name);
    -- https://www.graphile.org/postgraphile/reserved-keywords/
    IF (singular_name = ANY (ARRAY['order_by', 'primary_key'])) THEN
        RAISE EXCEPTION 'DATABASE_FIELD_RESERVED_WORD';
    END IF;

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE TRIGGER ensure_field_not_reserved_word 
 BEFORE INSERT OR UPDATE ON collections_public.field 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_ensure_field_not_reserved_word (  );

CREATE FUNCTION collections_private.tg_ensure_valid_type (  ) RETURNS trigger AS $EOFCODE$
BEGIN
 IF (collections_private.is_valid_type(NEW.type)) THEN
     RETURN NEW;
 END IF;
 RAISE EXCEPTION 'NONEXISTENT_TYPE';
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE TRIGGER ensure_valid_type_on_insert 
 BEFORE INSERT ON collections_public.field 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_ensure_valid_type (  );

CREATE TRIGGER ensure_valid_type_on_update 
 BEFORE UPDATE ON collections_public.field 
 FOR EACH ROW
 WHEN ( NEW.type IS DISTINCT FROM OLD.type ) 
 EXECUTE PROCEDURE collections_private. tg_ensure_valid_type (  );

CREATE FUNCTION collections_private.tg_on_update_field_constraints (  ) RETURNS trigger AS $EOFCODE$
DECLARE
   existing collections_public.check_constraint;

BEGIN
    IF (NEW.type IS DISTINCT FROM OLD.type) THEN 
        RAISE EXCEPTION 'CONST_TYPE_FIELDS_IMMUTABLE';
    END IF;
    
    NEW.chk_expr = collections_private.build_check_for_field( NEW );

    SELECT * FROM collections_public.check_constraint c
    WHERE 
        c.database_id = NEW.database_id
        AND c.table_id = NEW.table_id 
        AND c.field_ids = ARRAY[NEW.id]::uuid[]
    INTO existing;        

    IF (FOUND) THEN 
        IF (NEW.chk_expr IS NULL) THEN 
            DELETE FROM collections_public.check_constraint c
            WHERE 
                c.database_id = NEW.database_id
                AND c.table_id = NEW.table_id 
                AND c.field_ids = ARRAY[NEW.id]::uuid[]
            ;
        ELSE 
            UPDATE collections_public.check_constraint c
            SET 
                expr = NEW.chk_expr
            WHERE 
                c.database_id = NEW.database_id
                AND c.table_id = NEW.table_id 
                AND c.field_ids = ARRAY[NEW.id]::uuid[]
            ;
        END IF;

    ELSEIF (NEW.chk_expr IS NOT NULL) THEN 
        INSERT INTO collections_public.check_constraint 
            (database_id, table_id, field_ids, expr)
        VALUES 
            (NEW.database_id, NEW.table_id, ARRAY[NEW.id], NEW.chk_expr)
        ;
    END IF;

    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.tg_on_update_field_type_rm_constraints (  ) RETURNS trigger AS $EOFCODE$
BEGIN
    
    IF (
    NEW.chk IS DISTINCT FROM OLD.chk OR
    NEW.regexp IS DISTINCT FROM OLD.regexp OR
    NEW.min IS DISTINCT FROM OLD.min OR
    NEW.max IS DISTINCT FROM OLD.max
    ) THEN 
        RAISE EXCEPTION 'CONST_TYPE_FIELDS_IMMUTABLE';
    END IF;

    NEW.chk_expr = NULL;
    NEW.chk = NULL;
    NEW.regexp = NULL;
    NEW.min = NULL;
    NEW.max = NULL;

    DELETE FROM collections_public.check_constraint c
    WHERE 
        c.database_id = NEW.database_id
        AND c.table_id = NEW.table_id 
        AND c.field_ids = ARRAY[NEW.id]::uuid[]
    ;

    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_update_field_constraints 
 BEFORE UPDATE ON collections_public.field 
 FOR EACH ROW
 WHEN ( new.chk IS DISTINCT FROM old.chk OR new.regexp IS DISTINCT FROM old.regexp OR new.min IS DISTINCT FROM old.min OR new.max IS DISTINCT FROM old.max ) 
 EXECUTE PROCEDURE collections_private. tg_on_update_field_constraints (  );

CREATE TRIGGER on_update_field_type_constraints 
 BEFORE UPDATE ON collections_public.field 
 FOR EACH ROW
 WHEN ( NEW.type IS DISTINCT FROM OLD.type ) 
 EXECUTE PROCEDURE collections_private. tg_on_update_field_type_rm_constraints (  );

CREATE FUNCTION collections_private.tg_update_default_value (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;
BEGIN
    schema_name = collections_private.get_schema_name_by_table_id(NEW.table_id);

    SELECT collections_public.table.database_id
      INTO database_id
      FROM collections_public.table
      WHERE id=NEW.table_id;

    SELECT collections_public.table.name
      INTO table_name
      FROM collections_public.table
      WHERE id=NEW.table_id;

    IF (NEW.default_value IS NULL) THEN
        PERFORM db_migrate.migrate('alter_table_drop_column_default', database_id::text, schema_name, table_name, NEW.name);
    ELSE
        -- ewwwwwwwwww
        NEW.default_value = migrations_private.quoted_text(NEW.default_value);
        PERFORM db_migrate.migrate('alter_table_set_column_default', database_id::text, schema_name, table_name, NEW.name, NEW.default_value);
    END IF;

    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER update_default_value 
 BEFORE UPDATE ON collections_public.field 
 FOR EACH ROW
 WHEN ( NEW.default_value IS DISTINCT FROM OLD.default_value ) 
 EXECUTE PROCEDURE collections_private. tg_update_default_value (  );

CREATE FUNCTION collections_private.tg_update_field_name (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;

BEGIN
    schema_name = collections_private.get_schema_name_by_table_id(NEW.table_id);

    SELECT collections_public.table.database_id
      INTO database_id
      FROM collections_public.table
      WHERE id=NEW.table_id;

    SELECT collections_public.table.name
      INTO table_name
      FROM collections_public.table
      WHERE id=NEW.table_id;

    PERFORM db_migrate.migrate('alter_table_rename_column',
        database_id::text,
        schema_name,
        table_name,
        OLD.name,
        NEW.name
    );

    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER update_field_name 
 BEFORE UPDATE ON collections_public.field 
 FOR EACH ROW
 WHEN ( NEW.name IS DISTINCT FROM OLD.name ) 
 EXECUTE PROCEDURE collections_private. tg_update_field_name (  );

CREATE FUNCTION collections_private.tg_update_field_smart_tags (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;
  field_name text;
BEGIN

  schema_name = collections_private.get_schema_name_by_table_id(NEW.table_id);
  database_id = NEW.database_id;
  field_name = NEW.name;

  SELECT collections_public.table.name
    INTO table_name
    FROM collections_public.table
    WHERE id=NEW.table_id;

  IF (
      ( NEW.smart_tags IS NOT NULL OR NEW.description IS NOT NULL
        AND 
        TG_OP = 'INSERT'
      ) OR (
        TG_OP != 'INSERT'
      )
    ) THEN 
    PERFORM actions_public.set_comment(
      v_database_id := database_id,
      v_objtype := ast_constants.object_type('OBJECT_COLUMN'),
      v_tags := NEW.smart_tags,
      v_description := NEW.description,
      variadic v_name := ARRAY[
        schema_name,
        table_name,
        field_name
      ]
    );
  END IF;

  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER zzz_update_field_smart_tags 
 BEFORE UPDATE ON collections_public.field 
 FOR EACH ROW
 WHEN ( new.smart_tags IS DISTINCT FROM old.smart_tags OR new.description IS DISTINCT FROM old.description ) 
 EXECUTE PROCEDURE collections_private. tg_update_field_smart_tags (  );

CREATE TRIGGER zzz_insert_field_add_comments 
 AFTER INSERT ON collections_public.field 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_update_field_smart_tags (  );

CREATE FUNCTION collections_private.tg_update_field_type (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;

BEGIN
    schema_name = collections_private.get_schema_name_by_table_id(NEW.table_id);

    SELECT collections_public.table.database_id
      INTO database_id
      FROM collections_public.table
      WHERE id=NEW.table_id;

    SELECT collections_public.table.name
      INTO table_name
      FROM collections_public.table
      WHERE id=NEW.table_id;

    PERFORM db_migrate.migrate('alter_table_set_data_type',
        database_id::text,
        schema_name,
        table_name,
        NEW.name, -- BUG could be a race condition, we should order update triggers
        OLD.type,
        NEW.type
    );

    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER update_field_type 
 BEFORE UPDATE ON collections_public.field 
 FOR EACH ROW
 WHEN ( NEW.type IS DISTINCT FROM OLD.type ) 
 EXECUTE PROCEDURE collections_private. tg_update_field_type (  );

CREATE FUNCTION collections_private.tg_update_is_hidden (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;
BEGIN
    schema_name = collections_private.get_schema_name_by_table_id(NEW.table_id);

    SELECT collections_public.table.database_id
      INTO database_id
      FROM collections_public.table
      WHERE id=NEW.table_id;

    SELECT collections_public.table.name
      INTO table_name
      FROM collections_public.table
      WHERE id=NEW.table_id;

    -- PERFORM db_utils.set_hidden_smart_comment(schema_name, table_name, NEW.name, NEW.is_hidden);

    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER update_is_hidden 
 BEFORE UPDATE ON collections_public.field 
 FOR EACH ROW
 WHEN ( NEW.is_hidden IS DISTINCT FROM OLD.is_hidden ) 
 EXECUTE PROCEDURE collections_private. tg_update_is_hidden (  );

CREATE FUNCTION collections_private.tg_update_is_required (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;
BEGIN
    schema_name = collections_private.get_schema_name_by_table_id(NEW.table_id);

    SELECT collections_public.table.database_id
      INTO database_id
      FROM collections_public.table
      WHERE id=NEW.table_id;

    SELECT collections_public.table.name
      INTO table_name
      FROM collections_public.table
      WHERE id=NEW.table_id;

    IF (NEW.is_required) THEN
        PERFORM db_migrate.migrate('alter_table_set_column_not_null', database_id::text, schema_name, table_name, NEW.name);
    ELSE
        PERFORM db_migrate.migrate('alter_table_drop_column_not_null', database_id::text, schema_name, table_name, NEW.name);
    END IF;

    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER update_is_required 
 BEFORE UPDATE ON collections_public.field 
 FOR EACH ROW
 WHEN ( NEW.is_required IS DISTINCT FROM OLD.is_required ) 
 EXECUTE PROCEDURE collections_private. tg_update_is_required (  );

CREATE TABLE collections_public.foreign_key_constraint (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	table_id uuid NOT NULL REFERENCES collections_public."table" ( id ) ON DELETE CASCADE,
	name text,
	description text,
	smart_tags jsonb,
	type text,
	field_ids uuid[] NOT NULL,
	ref_table_id uuid NOT NULL REFERENCES collections_public."table" ( id ) ON DELETE CASCADE,
	ref_field_ids uuid[] NOT NULL,
	delete_action char(1) DEFAULT ( 'a' ),
	update_action char(1) DEFAULT ( 'a' ),
	UNIQUE ( database_id, name ),
	CHECK ( field_ids <> '{}' ),
	CHECK ( ref_field_ids <> '{}' ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'foreign_key_constraint', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'foreign_key_constraint', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE FUNCTION collections_private.tg_ensure_fkey_database_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    db_id uuid;
BEGIN
    SELECT t.database_id FROM collections_public.table t
        WHERE NEW.table_id = t.id 
    INTO db_id;
    NEW.database_id = db_id;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER _0000_ensure_fkey_database_id 
 BEFORE INSERT ON collections_public.foreign_key_constraint 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_ensure_fkey_database_id (  );

CREATE FUNCTION collections_private.tg_on_insert_foreign_key_constraint (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    v_table collections_public.table;
    v_ref_table collections_public.table;
    --
    schema_name text;
    table_name text;
    column_name text;
    ref_schema_name text;
    ref_table_name text;
    ref_column_name text;
    constraint_name text;
    --
    fields text[];
    ref_fields text[];
    --
    _del text;
    _upd text;
BEGIN

    NEW.type = 'f';
   
    SELECT *
        INTO v_ref_table
        FROM collections_public.table
        WHERE id=NEW.ref_table_id;

    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'NOT_FOUND';
    END IF; 

    SELECT *
        INTO v_table
        FROM collections_public.table
        WHERE id=NEW.table_id;

    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'NOT_FOUND';
    END IF;

    -- schema names

    schema_name = collections_private.get_schema_name_by_table_id(NEW.table_id);
    ref_schema_name = collections_private.get_schema_name_by_table_id(NEW.ref_table_id);
    
    -- db integrity

    IF (v_table.database_id != v_ref_table.database_id) THEN
        RAISE EXCEPTION 'CROSS_DATABASE_REF';
    END IF;

    -- -- table names
    
    table_name = v_table.name;
    ref_table_name = v_ref_table.name;

    -- -- column names
    SELECT array (SELECT f.name FROM collections_public.field f WHERE f.id = ANY ( NEW.field_ids ) AND f.database_id = NEW.database_id) INTO fields;
    SELECT array (SELECT f.name FROM collections_public.field f WHERE f.id = ANY ( NEW.ref_field_ids ) AND f.database_id = NEW.database_id) INTO ref_fields;

    column_name = array_to_string(fields, ',');
    ref_column_name = array_to_string(ref_fields, ',');

    constraint_name = inflection_db.get_foreign_key_index_name(table_name, array_to_string(fields, '_'));
    NEW.name = constraint_name;
    
    -- actions

      SELECT (CASE 
    WHEN NEW.delete_action = 'r' THEN
      'RESTRICT'
      
    WHEN NEW.delete_action = 'c' THEN
      'CASCADE'
      
    WHEN NEW.delete_action = 'n' THEN
      'SET NULL'
      
    WHEN NEW.delete_action = 'd' THEN
      'SET DEFAULT'
    ELSE
      'NO ACTION'
  END) INTO _del;

  SELECT (CASE 
    WHEN NEW.update_action = 'r' THEN
      'RESTRICT'
      
    WHEN NEW.update_action = 'c' THEN
      'CASCADE'
      
    WHEN NEW.update_action = 'n' THEN
      'SET NULL'
      
    WHEN NEW.update_action = 'd' THEN
      'SET DEFAULT'
    ELSE
      'NO ACTION'
  END) INTO _upd;
    
    PERFORM db_migrate.migrate('alter_table_add_foreign_key', 
         v_table.database_id::text,
         schema_name,
         table_name,
         column_name,
         ref_schema_name,
         ref_table_name,
         ref_column_name,
         constraint_name,
         _del,
         _upd
        );
 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_insert_foreign_key_constraint 
 BEFORE INSERT ON collections_public.foreign_key_constraint 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_on_insert_foreign_key_constraint (  );

CREATE FUNCTION collections_private.tg_update_fkey_smart_tags (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;
  fkey_name text;
BEGIN

  schema_name = collections_private.get_schema_name_by_table_id(NEW.table_id);

  database_id = NEW.database_id;
  fkey_name = NEW.name;

  SELECT collections_public.table.name
    INTO table_name
    FROM collections_public.table
    WHERE id=NEW.table_id;

  IF (
      ( NEW.smart_tags IS NOT NULL OR NEW.description IS NOT NULL
        AND 
        TG_OP = 'INSERT'
      ) OR (
        TG_OP != 'INSERT'
      )
    ) THEN 
    PERFORM actions_public.set_comment(
      v_database_id := database_id,
      v_objtype := ast_constants.object_type('OBJECT_TABCONSTRAINT'),
      v_tags := NEW.smart_tags,
      v_description := NEW.description,
      variadic v_name := ARRAY[
        schema_name,
        table_name,
        fkey_name
      ]
    );
  END IF;

  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER zzz_update_fkey_smart_tags 
 BEFORE UPDATE ON collections_public.foreign_key_constraint 
 FOR EACH ROW
 WHEN ( new.smart_tags IS DISTINCT FROM old.smart_tags OR new.description IS DISTINCT FROM old.description ) 
 EXECUTE PROCEDURE collections_private. tg_update_fkey_smart_tags (  );

CREATE TRIGGER zzz_insert_fkey_smart_tags 
 AFTER INSERT ON collections_public.foreign_key_constraint 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_update_fkey_smart_tags (  );

CREATE TABLE collections_public.full_text_search (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	table_id uuid NOT NULL REFERENCES collections_public."table" ( id ) ON DELETE CASCADE,
	field_id uuid NOT NULL,
	field_ids uuid[] NOT NULL,
	weights text[] NOT NULL,
	langs text[] NOT NULL,
	CHECK ( cardinality(field_ids) = cardinality(weights) AND cardinality(weights) = cardinality(langs) ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'full_text_search', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'full_text_search', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE FUNCTION collections_private.tg_ensure_full_text_search_database_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    db_id uuid;
BEGIN
    SELECT t.database_id FROM collections_public.table t
        WHERE NEW.table_id = t.id 
    INTO db_id;
    NEW.database_id = db_id;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER _0000_ensure_full_text_search_database_id 
 BEFORE INSERT ON collections_public.full_text_search 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_ensure_full_text_search_database_id (  );

CREATE FUNCTION collections_private.tg_full_text_search_sql_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    table_name text;
    schema_name text;
    private_schema text;
    fld collections_public.field;
    tbl collections_public.table;
  
    field text;
    vfield text;
    vtype text;

    fields text[] = ARRAY[]::text[];

    base_type text;
    
    i int;

    fieldsWithWeights jsonb[];

    ast_expr jsonb;
    json_field jsonb;

    trigger_fn_name text;
BEGIN

    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        SELECT * FROM collections_public.table WHERE id = NEW.table_id INTO tbl;
        table_name = tbl.name;
        SELECT collections_private.get_schema_name_by_table_id (NEW.table_id) INTO schema_name;
    ELSEIF (TG_OP = 'DELETE') THEN
        SELECT * FROM collections_public.table WHERE id = OLD.table_id INTO tbl;
          IF (NOT FOUND) THEN
            -- probably delete cascade...
            RETURN OLD;
          END IF;

        table_name = tbl.name;
        SELECT collections_private.get_schema_name_by_table_id (OLD.table_id) INTO schema_name;
    END IF;

    SELECT s.schema_name FROM collections_public.schema s
        WHERE s.database_id = tbl.database_id
        AND s.name = 'private'
    INTO private_schema;

    SELECT f.name FROM collections_public.field f WHERE f.id = NEW.field_id AND f.database_id = NEW.database_id INTO field;

    FOR i IN 
    SELECT * FROM generate_series(1, cardinality(NEW.field_ids))
    LOOP

        SELECT f.name, f.type
            FROM collections_public.field f WHERE f.id = NEW.field_ids[i] AND f.database_id = NEW.database_id
        INTO vfield, vtype;
        
        IF NOT ( vfield = ANY (fields) ) THEN 
            fields = array_append(fields, vfield);
        END IF;

        -- fields: [{lang, field, weight, [ type, array ]}]
        json_field = '{"lang":"","field":"", "weight":""}'::jsonb;
        -- TODO 'NEW.' is hacky... you can do better
        json_field = jsonb_set(json_field, '{field}', to_jsonb('NEW.' || vfield));
        json_field = jsonb_set(json_field, '{lang}', to_jsonb(NEW.langs[i]));
        json_field = jsonb_set(json_field, '{weight}', to_jsonb(NEW.weights[i]));

        IF (ARRAY_LENGTH(REGEXP_MATCHES(trim(vtype), '(.*)\s*(\[\s*?\])$', 'i'), 1) > 0) THEN
            base_type = REGEXP_REPLACE(trim(vtype), '(.*)\s*(\[\s*?\])$', '\1', 'i');
            json_field = jsonb_set(json_field, '{type}', to_jsonb(base_type));
            json_field = jsonb_set(json_field, '{array}', to_jsonb(TRUE));
        END IF;

        -- TODO check if field is an array.... maybe use some magic?
        fieldsWithWeights = array_append(fieldsWithWeights, json_field);
    END LOOP;

    -- set NEW.searchfield = TSV(magic);
    ast_expr = ast.raw_stmt(
        v_stmt := ast_helpers.equals(
            -- TODO 'NEW.' is hacky... you can do better
            v_lexpr := ast.string('NEW' || '.' || field),
            v_rexpr := ast_helpers.tsvector_index(to_jsonb(fieldsWithWeights))
        ),
        v_stmt_len := 1
    );
    
    -- you can use field only, this way
    -- you can delete it, etc., across updates, etc
    SELECT
        inflection_db.get_identifier
        (inflection.underscore (
            array_to_string(ARRAY[
                inflection_db.get_table_name (tbl.name)
            ] || ARRAY[field, 'tsv'], '_'))
    ) INTO trigger_fn_name;


    IF (TG_OP = 'INSERT') THEN

        PERFORM actions_public.create_trigger_function(
            v_database_id := tbl.database_id,
            v_schema_name := private_schema,
            v_function_name := trigger_fn_name,
            v_body := ( ''
                || E'\nBEGIN\n'
                || deparser.deparse(ast_expr)
                || E'\nRETURN NEW;'
                || E'\nEND;'
            ),
            v_language := 'plpgsql',
            v_volatility := 'VOLATILE'
        );

        -- yea maybe GENERATED columns is way to go...
        PERFORM actions_public.create_trigger(
            v_database_id := tbl.database_id,
            v_trigger_name := trigger_fn_name || '_insert_tg',
            v_schema_name := schema_name,
            v_table_name := tbl.name,
            v_trigger_fn_schema := private_schema,
            v_trigger_fn_name := trigger_fn_name,
            v_timing := 2,
            v_events := 4
        );

        PERFORM actions_public.create_trigger(
            v_database_id := tbl.database_id,
            v_trigger_name := trigger_fn_name || '_update_tg',
            v_schema_name := schema_name,
            v_table_name := tbl.name,
            v_trigger_fn_schema := private_schema,
            v_trigger_fn_name := trigger_fn_name,
            v_fields := fields,
            v_timing := 2,
            v_events := 16
        );

    ELSEIF (TG_OP = 'UPDATE') THEN
        -- juggle both OLD/NEW
        RAISE EXCEPTION 'FULLTEXT needs UPDATE implementation';

    ELSEIF (TG_OP = 'DELETE') THEN
        -- delete it, return OLD

        RETURN OLD;
    END IF;
    RETURN NEW;
 
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER b4_insert_full_text_search_sql_trigger 
 BEFORE INSERT ON collections_public.full_text_search 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_full_text_search_sql_trigger (  );

CREATE TRIGGER b4_update_full_text_search_sql_trigger 
 BEFORE UPDATE ON collections_public.full_text_search 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_full_text_search_sql_trigger (  );

CREATE TRIGGER b4_delete_full_text_search_sql_trigger 
 BEFORE DELETE ON collections_public.full_text_search 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_full_text_search_sql_trigger (  );

CREATE TABLE collections_public.index (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	table_id uuid NOT NULL REFERENCES collections_public."table" ( id ) ON DELETE CASCADE,
	name text NOT NULL,
	field_ids uuid[],
	UNIQUE ( database_id, name ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'index', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'index', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE FUNCTION collections_private.tg_ensure_index_database_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    db_id uuid;
BEGIN
    SELECT t.database_id FROM collections_public.table t
        WHERE NEW.table_id = t.id 
    INTO db_id;
    NEW.database_id = db_id;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER _0000_ensure_index_database_id 
 BEFORE INSERT ON collections_public.index 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_ensure_index_database_id (  );

CREATE TABLE collections_public.rls_function (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	name text NOT NULL,
	function_template_name text,
	function_template_vars json,
	label text,
	description text,
	UNIQUE ( function_template_name, database_id ),
	UNIQUE ( database_id, name ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'rls_function', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'rls_function', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE FUNCTION collections_private.tg_insert_index_sql_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    schema_name text;
    table_name text;
    fields text[];
    tbl collections_public.table;
BEGIN

    SELECT * FROM collections_public.table
        WHERE id = NEW.table_id
    INTO tbl;
    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'OBJECT_NOT_FOUND';
    END IF;

    NEW.database_id = tbl.database_id;

    table_name = tbl.name;
    schema_name = collections_private.get_schema_name_by_table_id (tbl.id);
    SELECT array (SELECT f.name FROM collections_public.field f WHERE f.id = ANY ( NEW.field_ids ) AND f.database_id = NEW.database_id) INTO fields;
    NEW.name = inflection_db.get_index_name(table_name, fields);
    PERFORM db_migrate.migrate('create_index', tbl.database_id::text, schema_name, table_name, NEW.name, array_to_string(fields, ','));

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.tg_update_index_sql_trigger (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  RAISE EXCEPTION 'DELETE_FIRST';
 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.tg_delete_index_sql_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    schema_name text;
    tbl collections_public.table;
BEGIN
    SELECT * FROM collections_public.table
        WHERE id = OLD.table_id
    INTO tbl;
    IF (NOT FOUND) THEN
      -- probably delete cascade...
      RETURN OLD;
    END IF;

    schema_name = collections_private.get_schema_name_by_table_id (OLD.table_id);
    PERFORM db_migrate.migrate('drop_index', tbl.database_id::text, schema_name, OLD.name);
 RETURN OLD;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_insert_index 
 BEFORE INSERT ON collections_public.index 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_insert_index_sql_trigger (  );

CREATE TRIGGER before_update_index 
 BEFORE UPDATE ON collections_public.index 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_update_index_sql_trigger (  );

CREATE TRIGGER before_delete_index 
 BEFORE DELETE ON collections_public.index 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_delete_index_sql_trigger (  );

CREATE FUNCTION collections_private.tg_ensure_policy_database_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    db_id uuid;
BEGIN
    SELECT t.database_id FROM collections_public.table t
        WHERE NEW.table_id = t.id 
    INTO db_id;
    NEW.database_id = db_id;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER _0000_ensure_policy_database_id 
 BEFORE INSERT ON collections_public.policy 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_ensure_policy_database_id (  );

CREATE FUNCTION collections_private.tg_insert_policy_sql_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    schema_name text;
    table_name text;
    policy_name text;

    policy_ast jsonb;

    tbl collections_public.table;
    db collections_public.database;

    rls_schema text;

    current_role_id_fn collections_public.rls_function;
    current_group_ids_fn collections_public.rls_function;
BEGIN
    SELECT * FROM collections_public.table
        WHERE id = NEW.table_id
    INTO tbl;

    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'NOT_FOUND';
    END IF;
    
    table_name = tbl.name;

    -- get DB so we can get a schema for RLS FNs
    -- currently set to public schema
    
    SELECT * FROM collections_public.database
        WHERE id = tbl.database_id
    INTO db;

    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'NOT_FOUND';
    END IF;

    SELECT s.schema_name FROM collections_public.schema s
        WHERE s.database_id = db.id
        AND s.name = 'public'
    INTO rls_schema;

    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'NOT_FOUND';
    END IF;

    -- get RLS functions

    SELECT * FROM collections_public.rls_function f
        WHERE 
            f.database_id=db.id
            AND f.function_template_name = 'current_role_id'
    INTO current_role_id_fn;

    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'RLS_FUNC_NOT_FOUND';
    END IF;

    SELECT * FROM collections_public.rls_function f
        WHERE 
            f.database_id=db.id
            AND f.function_template_name = 'current_group_ids'
    INTO current_group_ids_fn;

    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'RLS_FUNC_NOT_FOUND';
    END IF;

    -- thank you RLS functions!

    NEW.role_name = trim(NEW.role_name);
    NEW.privilege = upper(NEW.privilege);

    schema_name = collections_private.get_schema_name_by_table_id (NEW.table_id);
    
    -- we need a better solution to this
    IF (NEW.name IS NULL) THEN 
        policy_name = inflection_db.get_identifier_name(ARRAY[lower(NEW.role_name), 'can', lower(NEW.privilege), 'on', table_name]);
    ELSE
        policy_name = inflection_db.get_identifier_name(ARRAY[lower(NEW.role_name), 'can', lower(NEW.privilege), 'on', table_name, NEW.name]);
    END IF;

    NEW.name = policy_name;

    IF (NEW.privilege NOT IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE')) THEN
        RAISE EXCEPTION 'BAD_PRIVILEGE_FOR_POLICY';
    END IF;

    -- Tag some functions, allow them to be "RLS functions"
    -- so they show up in the RLS UI

    IF (NEW.policy_template_name = 'ast') THEN 
        policy_ast = NEW.policy_template_vars;
    ELSE
        policy_ast = ast_helpers.create_policy_template(
            rls_schema,
            current_role_id_fn.name,
            current_group_ids_fn.name,
            NEW.policy_template_name,
            NEW.policy_template_vars::jsonb
        );
    END IF;

-- For INSERT and UPDATE statements, WITH CHECK expressions are enforced after BEFORE triggers are fired, and before any actual data modifications are made. Thus a BEFORE ROW trigger may modify the data to be inserted, affecting the result of the security policy check. WITH CHECK expressions are enforced before any other constraints.

-- When a USING expression returns true for a given row then that row is visible to the user, while if false or null is returned then the row is not visible. When a WITH CHECK expression returns true for a row then that row is inserted or updated, while if false or null is returned then an error occurs.

-- For policies that can have both USING and WITH CHECK expressions (ALL and UPDATE), if no WITH CHECK expression is defined, then the USING expression will be used both to determine which rows are visible (normal USING case) and which new rows will be allowed to be added (WITH CHECK case).

    IF (NEW.privilege = 'INSERT') THEN 
        PERFORM actions_public.create_policy(
            v_database_id :=  NEW.database_id,
            v_policy_name :=  policy_name,
            v_schema_name := schema_name,
            v_table_name :=  table_name,
            v_roles := ARRAY[NEW.role_name],
            v_cmd_name :=  NEW.privilege,
            v_with_check :=  policy_ast,
            v_permissive :=  NEW.permissive
        );
        -- expr_type = 'WITH CHECK';
        -- NEW.check_expression = policy_text;

    ELSE
        -- NEW.using_expression = policy_text;
        -- expr_type = 'USING';
        PERFORM actions_public.create_policy(
            v_database_id :=  NEW.database_id,
            v_policy_name :=  policy_name,
            v_schema_name := schema_name,
            v_table_name :=  table_name,
            v_roles := ARRAY[NEW.role_name],
            v_qual :=  policy_ast,
            v_cmd_name :=  NEW.privilege,
            v_permissive :=  NEW.permissive
        );
    END IF;

    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.tg_update_policy_sql_trigger (  ) RETURNS trigger AS $EOFCODE$
BEGIN
    RAISE EXCEPTION 'CANNOT_UPDATE_POLICY_YET';
    -- because you have to query OLD
    -- then you have to query NEW
    -- wait to you abstract the INSERT TRIGGER into a function,
    -- then you can easily make update/insert triggers ;)
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.tg_delete_policy_sql_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    schema_name text;
    table_name text;
    expr_type text;
    policy_text text;

    tbl collections_public.table;
    db collections_public.database;
BEGIN
    SELECT * FROM collections_public.table
        WHERE id = OLD.table_id
    INTO tbl;

    IF (NOT FOUND) THEN
      -- probably delete cascade...
      RETURN OLD;
    END IF;

    table_name = tbl.name;

    SELECT * FROM collections_public.database
        WHERE id = tbl.database_id
    INTO db;

    IF (NOT FOUND) THEN
          -- probably delete cascade...
      RETURN OLD;
    END IF;

    OLD.role_name = trim(OLD.role_name);
    OLD.privilege = upper(OLD.privilege);

    schema_name = collections_private.get_schema_name_by_table_id (OLD.table_id);

    IF (TG_OP = 'DELETE') THEN 
        PERFORM db_migrate.migrate('drop_policy', 
            db.id::text,
            OLD.name,
            schema_name,
            table_name
        );
        RETURN OLD;
    END IF;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_insert_policy 
 BEFORE INSERT ON collections_public.policy 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_insert_policy_sql_trigger (  );

CREATE TRIGGER before_update_policy 
 BEFORE UPDATE ON collections_public.policy 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_insert_policy_sql_trigger (  );

CREATE TRIGGER before_delete_policy 
 BEFORE DELETE ON collections_public.policy 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_delete_policy_sql_trigger (  );

CREATE TABLE collections_public.primary_key_constraint (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	table_id uuid NOT NULL REFERENCES collections_public."table" ( id ) ON DELETE CASCADE,
	name text,
	type text,
	field_ids uuid[] NOT NULL,
	UNIQUE ( database_id, name ),
	CHECK ( field_ids <> '{}' ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'primary_key_constraint', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'primary_key_constraint', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE FUNCTION collections_private.tg_ensure_pkey_database_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    db_id uuid;
BEGIN
    SELECT t.database_id FROM collections_public.table t
        WHERE NEW.table_id = t.id 
    INTO db_id;
    NEW.database_id = db_id;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER _0000_ensure_pkey_database_id 
 BEFORE INSERT ON collections_public.primary_key_constraint 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_ensure_pkey_database_id (  );

CREATE FUNCTION collections_private.tg_on_insert_primary_key_constraint (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;
  constraint_name text;
  fields text[];
BEGIN

    NEW.type = 'p';

    schema_name = collections_private.get_schema_name_by_table_id(NEW.table_id);

    SELECT collections_public.table.database_id
        INTO database_id
        FROM collections_public.table
        WHERE id=NEW.table_id;

    SELECT collections_public.table.name
        INTO table_name
        FROM collections_public.table
        WHERE id=NEW.table_id;

    constraint_name = inflection_db.get_primary_key_index_name(table_name);
    NEW.name = constraint_name;
    
    SELECT array (SELECT f.name FROM collections_public.field f WHERE f.id = ANY ( NEW.field_ids ) AND f.database_id = NEW.database_id) INTO fields;
    
    PERFORM db_migrate.migrate('alter_table_add_primary_key', database_id::text, schema_name, table_name, constraint_name, array_to_string(fields, ','));
 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_insert_primary_key_constraint 
 BEFORE INSERT ON collections_public.primary_key_constraint 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_on_insert_primary_key_constraint (  );

CREATE TABLE collections_public.procedure (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	name text NOT NULL,
	argnames text[],
	argtypes text[],
	argdefaults text[],
	lang_name text,
	definition text,
	UNIQUE ( database_id, name ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'procedure', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'procedure', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE TABLE collections_public.rls_expression (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	expr json 
);

CREATE FUNCTION collections_private.tg_rls_function_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    v_schema_name text;
BEGIN

    -- TODO deprecate in favor of USING modules
    -- you could query for modules of type rls_function and get this info.

    -- use public for these RLS functions
    SELECT s.schema_name
    FROM collections_public.schema s
    JOIN collections_public.database d ON (s.database_id = d.id)
    WHERE d.id = NEW.database_id AND s.name = 'public'
    INTO v_schema_name;

    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'OBJECT_NOT_FOUND';
    END IF;

    NEW.name = inflection_db.get_identifier_name(NEW.name);

    IF (NEW.function_template_name = 'current_role_id') THEN
        PERFORM db_migrate.migrate('current_role_id', 
            NEW.database_id::text,
            v_schema_name,
            NEW.name
        );
    ELSEIF (NEW.function_template_name = 'current_group_ids') THEN
        PERFORM db_migrate.migrate('current_group_ids', 
            NEW.database_id::text,
            v_schema_name,
            NEW.name
        );
    ELSE
        RAISE EXCEPTION 'UNSUPPORTED RLS FUNCTION';
    END IF;

    -- these can have hard coded grants for now
    PERFORM db_migrate.migrate('grant_execute_on_function', 
        NEW.database_id::text,
        v_schema_name,
        NEW.name,
        'authenticated'        
    );

    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER rls_function_trigger 
 BEFORE INSERT ON collections_public.rls_function 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_rls_function_trigger (  );

CREATE TABLE collections_public.schema_grant (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	schema_id uuid NOT NULL REFERENCES collections_public.schema ( id ),
	grantee_name text NOT NULL 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'schema_grant', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'schema_grant', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE FUNCTION collections_private.tg_ensure_schema_grant_database_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    db_id uuid;
BEGIN
    SELECT s.database_id FROM collections_public.schema s
        WHERE NEW.schema_id = s.id 
    INTO db_id;
    NEW.database_id = db_id;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER _0000_ensure_schema_grant_database_id 
 BEFORE INSERT ON collections_public.schema_grant 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_ensure_schema_grant_database_id (  );

CREATE FUNCTION collections_private.tg_schema_grant_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  schema_name text;
  scma collections_public.schema;
BEGIN
 IF (TG_OP = 'INSERT') THEN
    SELECT * FROM collections_public.schema WHERE id = NEW.schema_id
      INTO scma;
    PERFORM db_migrate.migrate('grant_usage', scma.database_id::text, schema_name, NEW.role_name);
 ELSEIF (TG_OP = 'DELETE') THEN
    SELECT * FROM collections_public.schema WHERE id = OLD.schema_id
       INTO scma;
    PERFORM db_migrate.migrate('revoke_usage', scma.database_id::text, schema_name, OLD.role_name);
    RETURN OLD;
 END IF;

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.tg_no_update_schema_grants (  ) RETURNS trigger AS $EOFCODE$
BEGIN
    RAISE EXCEPTION 'OBJECT_NO_UPDATE';
 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE TRIGGER before_insert_schema_grant 
 BEFORE INSERT ON collections_public.schema_grant 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_schema_grant_trigger (  );

CREATE TRIGGER before_update_schema_grant 
 BEFORE UPDATE ON collections_public.schema_grant 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_no_update_schema_grants (  );

CREATE TRIGGER before_delete_schema_grant 
 BEFORE DELETE ON collections_public.schema_grant 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_schema_grant_trigger (  );

CREATE FUNCTION collections_private.tg_before_delete_schema_trigger (  ) RETURNS trigger AS $EOFCODE$
BEGIN
    PERFORM db_migrate.migrate('drop_schema', OLD.database_id::text, OLD.schema_name);
    RETURN OLD;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_delete_schema_trigger 
 BEFORE DELETE ON collections_public.schema 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_before_delete_schema_trigger (  );

CREATE FUNCTION collections_private.tg_after_create_schema_trigger (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  PERFORM db_migrate.migrate('create_schema', NEW.database_id::text, NEW.schema_name);
  PERFORM db_migrate.migrate('grant_usage', NEW.database_id::text, NEW.schema_name, 'authenticated');
  PERFORM db_migrate.migrate('grant_usage', NEW.database_id::text, NEW.schema_name, 'anonymous');
 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION collections_private.tg_before_create_schema_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
   hash text;
BEGIN
  SELECT schema_hash FROM collections_public.database
    WHERE id = NEW.database_id
  INTO hash;

  IF tg_op = 'INSERT' THEN
     NEW.schema_name = inflection_db.get_schema_name (ARRAY[hash, NEW.name]);
  END IF;
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_create_schema_trigger 
 BEFORE INSERT ON collections_public.schema 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_before_create_schema_trigger (  );

CREATE TRIGGER after_create_schema_trigger 
 AFTER INSERT ON collections_public.schema 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_after_create_schema_trigger (  );

CREATE FUNCTION collections_private.tg_ensure_table_grant_database_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    db_id uuid;
BEGIN
    SELECT t.database_id FROM collections_public.table t
        WHERE NEW.table_id = t.id 
    INTO db_id;
    NEW.database_id = db_id;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER _0000_ensure_table_grant_database_id 
 BEFORE INSERT ON collections_public.table_grant 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_ensure_table_grant_database_id (  );

CREATE FUNCTION collections_private.tg_table_grant_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    table_name text;
    schema_name text;
    tbl collections_public.table;
  
    fields text[];
BEGIN


    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        SELECT * FROM collections_public.table WHERE id = NEW.table_id INTO tbl;
        table_name = tbl.name;
        SELECT collections_private.get_schema_name_by_table_id (NEW.table_id) INTO schema_name;
    ELSEIF (TG_OP = 'DELETE') THEN
        SELECT * FROM collections_public.table WHERE id = OLD.table_id INTO tbl;
          IF (NOT FOUND) THEN
            -- probably delete cascade...
            RETURN OLD;
          END IF;

        table_name = tbl.name;
        SELECT collections_private.get_schema_name_by_table_id (OLD.table_id) INTO schema_name;
    END IF;

    SELECT array (SELECT f.name FROM collections_public.field f WHERE f.id = ANY ( NEW.field_ids ) AND f.database_id = NEW.database_id) INTO fields;

    IF (TG_OP = 'INSERT') THEN
        PERFORM actions_public.table_grant(
            v_database_id := tbl.database_id,
            v_schema_name := schema_name,
            v_table_name := table_name,
            v_priv_name := NEW.privilege,
            v_is_grant := TRUE,
            v_role_name := NEW.role_name,
            v_cols := fields
        );
    ELSEIF (TG_OP = 'UPDATE') THEN
        PERFORM actions_public.table_grant(
            v_database_id := tbl.database_id,
            v_schema_name := schema_name,
            v_table_name := table_name,
            v_priv_name := OLD.privilege,
            v_is_grant := FALSE,
            v_role_name := OLD.role_name,
            v_cols := fields
        );
        PERFORM actions_public.table_grant(
            v_database_id := tbl.database_id,
            v_schema_name := schema_name,
            v_table_name := table_name,
            v_priv_name := NEW.privilege,
            v_is_grant := TRUE,
            v_role_name := NEW.role_name,
            v_cols := fields
        );
    ELSEIF (TG_OP = 'DELETE') THEN
        PERFORM actions_public.table_grant(
            v_database_id := tbl.database_id,
            v_schema_name := schema_name,
            v_table_name := table_name,
            v_priv_name := OLD.privilege,
            v_is_grant := FALSE,
            v_role_name := OLD.role_name,
            v_cols := fields
        );
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_insert_table_grant 
 BEFORE INSERT ON collections_public.table_grant 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_table_grant_trigger (  );

CREATE TRIGGER before_update_table_grant 
 BEFORE UPDATE ON collections_public.table_grant 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_table_grant_trigger (  );

CREATE TRIGGER before_delete_table_grant 
 BEFORE DELETE ON collections_public.table_grant 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_table_grant_trigger (  );

CREATE FUNCTION collections_private.table_name_hash ( name text ) RETURNS bytea AS $EOFCODE$
  SELECT
    DECODE(MD5(LOWER(inflection.plural (name))), 'hex');
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE UNIQUE INDEX databases_table_unique_name_idx ON collections_public."table" ( database_id, collections_private.table_name_hash(name) );

CREATE FUNCTION collections_private.after_insert_table_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  schema_name text;
BEGIN
  IF tg_op = 'INSERT' THEN

    schema_name = collections_private.get_schema_name_by_database_id(NEW.database_id, NEW.schema_id);

    -- PERFORM
    --   db_migrate.migrate('create_table', NEW.database_id::text, schema_name, NEW.name);
    PERFORM actions_public.create_table(
      v_database_id := NEW.database_id,
      v_schema_name := schema_name,
      v_table_name := NEW.name
    );

    RETURN NEW;
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER after_insert_table_trigger 
 AFTER INSERT ON collections_public."table" 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. after_insert_table_trigger (  );

CREATE FUNCTION collections_private.tg_before_delete_table_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    pschema collections_public.schema;
BEGIN
    SELECT * FROM collections_public.schema WHERE id = OLD.schema_id INTO pschema;
    IF (FOUND) THEN
        PERFORM db_migrate.migrate('drop_table', OLD.database_id::text, pschema.schema_name, OLD.name);
    END IF;
    RETURN OLD;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_delete_table_trigger 
 BEFORE DELETE ON collections_public."table" 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_before_delete_table_trigger (  );

CREATE FUNCTION collections_private.before_insert_table_trigger (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  IF tg_op = 'INSERT' THEN
    NEW.singular_name = inflection_db.get_table_singular_name(NEW.name);
    NEW.plural_name = inflection_db.get_table_plural_name(NEW.name);
    NEW.name = inflection_db.get_identifier(inflection.underscore(NEW.name));
    RETURN NEW;
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_table_trigger 
 BEFORE INSERT ON collections_public."table" 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. before_insert_table_trigger (  );

CREATE FUNCTION collections_private.tg_ensure_table_not_reserved_word (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    singular_name text;
BEGIN
    singular_name = inflection_db.get_table_singular_name (NEW.name);

    -- https://www.graphile.org/postgraphile/reserved-keywords/
    IF (singular_name = ANY (ARRAY['query', 'mutation', 'subscription', 'node'])) THEN
        RAISE EXCEPTION 'DATABASE_TABLE_RESERVED_WORD';
    END IF;

    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE TRIGGER ensure_table_not_reserved_word 
 BEFORE INSERT ON collections_public."table" 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_ensure_table_not_reserved_word (  );

CREATE FUNCTION collections_private.tg_on_inherits_id_changed (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    schema_name text;
    inherits_schema text;
    inherits_table text;
    old_inherits_schema text;
    old_inherits_table text;
BEGIN

    IF (TG_OP = 'UPDATE' AND OLD.inherits_id IS NOT NULL) THEN
        schema_name = collections_private.get_schema_name_by_table_id (OLD.id);
        old_inherits_schema = collections_private.get_schema_name_by_table_id (OLD.inherits_id);
        old_inherits_table = (
            SELECT
                name
            FROM
                collections_public.table t
            WHERE
                t.id = OLD.inherits_id
                AND t.database_id = NEW.database_id);
        PERFORM
            db_migrate.migrate('alter_table_no_inherits', NEW.database_id::text, schema_name, NEW.name, old_inherits_schema, old_inherits_table);
    END IF;
    IF (NEW.inherits_id IS NOT NULL) THEN
        schema_name = collections_private.get_schema_name_by_table_id (NEW.id);
        inherits_schema = collections_private.get_schema_name_by_table_id (NEW.inherits_id);
        inherits_table = (
            SELECT
                name
            FROM
                collections_public.table t
            WHERE
                t.id = NEW.inherits_id
                AND t.database_id = NEW.database_id);
        PERFORM
            db_migrate.migrate('alter_table_inherits', NEW.database_id::text, schema_name, NEW.name, inherits_schema, inherits_table);
    END IF;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_inherits_id_created 
 AFTER INSERT ON collections_public."table" 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_on_inherits_id_changed (  );

CREATE TRIGGER on_inherits_id_changed 
 BEFORE UPDATE ON collections_public."table" 
 FOR EACH ROW
 WHEN ( NEW.inherits_id IS DISTINCT FROM OLD.inherits_id ) 
 EXECUTE PROCEDURE collections_private. tg_on_inherits_id_changed (  );

CREATE FUNCTION collections_private.tg_on_use_rls_changed (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    schema_name text;
BEGIN
    schema_name = collections_private.get_schema_name_by_table_id (NEW.id);

    IF (NEW.use_rls) THEN
      PERFORM
        db_migrate.migrate('enable_row_level_security', 
          NEW.database_id::text,
          schema_name,
          NEW.name
        );
    ELSE 
      PERFORM
        db_migrate.migrate('disable_row_level_security', 
          NEW.database_id::text,
          schema_name,
          NEW.name
        );
    END IF;

    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_update_use_rls_changed 
 BEFORE UPDATE ON collections_public."table" 
 FOR EACH ROW
 WHEN ( NEW.use_rls IS DISTINCT FROM OLD.use_rls ) 
 EXECUTE PROCEDURE collections_private. tg_on_use_rls_changed (  );

CREATE TRIGGER on_insert_use_rls_created 
 AFTER INSERT ON collections_public."table" 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_on_use_rls_changed (  );

CREATE FUNCTION collections_private.tg_update_is_visible_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    schema_name text;
    old_schema_name text;
BEGIN
    schema_name = collections_private.get_schema_name_by_database_id (NEW.database_id, NEW.schema_id);
    old_schema_name = collections_private.get_schema_name_by_database_id (NEW.database_id, OLD.schema_id);
    PERFORM db_utils.migrate('alter_table_set_schema', 
        old_schema_name,
        NEW.name,
        schema_name
    );
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER update_is_visible_trigger 
 BEFORE UPDATE ON collections_public."table" 
 FOR EACH ROW
 WHEN ( NEW.schema_id IS DISTINCT FROM OLD.schema_id ) 
 EXECUTE PROCEDURE collections_private. tg_update_is_visible_trigger (  );

CREATE FUNCTION collections_private.tg_update_table_smart_tags (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;
BEGIN

  schema_name = collections_private.get_schema_name_by_database_id(NEW.database_id, NEW.schema_id);
  database_id = NEW.database_id;
  table_name = NEW.name;

  IF (
      ( NEW.smart_tags IS NOT NULL OR NEW.description IS NOT NULL
        AND 
        TG_OP = 'INSERT'
      ) OR (
        TG_OP != 'INSERT'
      )
    ) THEN 
    PERFORM actions_public.set_comment(
      v_database_id := database_id,
      v_objtype := ast_constants.object_type('OBJECT_TABLE'),
      v_tags := NEW.smart_tags,
      v_description := NEW.description,
      variadic v_name := ARRAY[
        schema_name,
        table_name
      ]
    );
  END IF;

  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER zzz_update_table_smart_tags 
 BEFORE UPDATE ON collections_public."table" 
 FOR EACH ROW
 WHEN ( new.smart_tags IS DISTINCT FROM old.smart_tags OR new.description IS DISTINCT FROM old.description ) 
 EXECUTE PROCEDURE collections_private. tg_update_table_smart_tags (  );

CREATE TRIGGER zzz_insert_table_smart_tags 
 AFTER INSERT ON collections_public."table" 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_update_table_smart_tags (  );

CREATE TABLE collections_public.trigger_function (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	name text NOT NULL,
	code text,
	UNIQUE ( database_id, name ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'trigger_function', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'trigger_function', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE TABLE collections_public.trigger (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	table_id uuid NOT NULL REFERENCES collections_public."table" ( id ) ON DELETE CASCADE,
	name text NOT NULL,
	event text,
	function_name text,
	UNIQUE ( table_id, name ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'trigger', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'trigger', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE FUNCTION collections_private.tg_ensure_trigger_database_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    db_id uuid;
BEGIN
    SELECT t.database_id FROM collections_public.table t
        WHERE NEW.table_id = t.id 
    INTO db_id;
    NEW.database_id = db_id;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER _0000_ensure_trigger_database_id 
 BEFORE INSERT ON collections_public.trigger 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_ensure_trigger_database_id (  );

CREATE TABLE collections_public.unique_constraint (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	table_id uuid NOT NULL REFERENCES collections_public."table" ( id ) ON DELETE CASCADE,
	name text,
	description text,
	smart_tags jsonb,
	type text,
	field_ids uuid[] NOT NULL,
	UNIQUE ( database_id, name ),
	CHECK ( field_ids <> '{}' ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'collections_public', 'unique_constraint', 'uuids', 'trigger_set_uuid_related_field', 'id', 'database_id');

SELECT db_utils.migrate('timestamps', 'collections_public', 'unique_constraint', 'collections_private', 'timestamps_tg', 'created_at', 'updated_at');

CREATE FUNCTION collections_private.tg_ensure_unique_constraint_database_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    db_id uuid;
BEGIN
    SELECT t.database_id FROM collections_public.table t
        WHERE NEW.table_id = t.id 
    INTO db_id;
    NEW.database_id = db_id;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER _0000_ensure_unique_constraint_database_id 
 BEFORE INSERT ON collections_public.unique_constraint 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_ensure_unique_constraint_database_id (  );

CREATE FUNCTION collections_private.tg_on_insert_unique_constraint (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;
  constraint_name text;
  fields text[];
BEGIN

    NEW.type = 'u';

    schema_name = collections_private.get_schema_name_by_table_id(NEW.table_id);

    SELECT collections_public.table.database_id
        INTO database_id
        FROM collections_public.table
        WHERE id=NEW.table_id;

    SELECT collections_public.table.name
        INTO table_name
        FROM collections_public.table
        WHERE id=NEW.table_id;

    SELECT array (SELECT f.name FROM collections_public.field f WHERE f.id = ANY ( NEW.field_ids ) AND f.database_id = NEW.database_id) INTO fields;

    constraint_name = inflection_db.get_unique_index_name(table_name, fields);
    NEW.name = constraint_name;
    
    PERFORM db_migrate.migrate('alter_table_add_unique_constraint', database_id::text, schema_name, table_name, constraint_name, array_to_string(fields, ','));

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_insert_unique_constraint 
 BEFORE INSERT ON collections_public.unique_constraint 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_on_insert_unique_constraint (  );

CREATE FUNCTION collections_private.tg_update_ukey_smart_tags (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  database_id uuid;
  schema_name text;
  table_name text;
  fkey_name text;
BEGIN

  schema_name = collections_private.get_schema_name_by_table_id(NEW.table_id);
  database_id = NEW.database_id;
  fkey_name = NEW.name;

  SELECT collections_public.table.name
    INTO table_name
    FROM collections_public.table
    WHERE id=NEW.table_id;

  IF (
      ( NEW.smart_tags IS NOT NULL OR NEW.description IS NOT NULL
        AND 
        TG_OP = 'INSERT'
      ) OR (
        TG_OP != 'INSERT'
      )
    ) THEN 
    PERFORM actions_public.set_comment(
      v_database_id := database_id,
      v_objtype := ast_constants.object_type('OBJECT_TABCONSTRAINT'),
      v_tags := NEW.smart_tags,
      v_description := NEW.description,
      variadic v_name := ARRAY[
        schema_name,
        table_name,
        fkey_name
      ]
    );
  END IF;

  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER zzz_update_ukey_smart_tags 
 BEFORE UPDATE ON collections_public.unique_constraint 
 FOR EACH ROW
 WHEN ( new.smart_tags IS DISTINCT FROM old.smart_tags OR new.description IS DISTINCT FROM old.description ) 
 EXECUTE PROCEDURE collections_private. tg_update_ukey_smart_tags (  );

CREATE TRIGGER zzz_insert_ukey_smart_tags 
 AFTER INSERT ON collections_public.unique_constraint 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_update_ukey_smart_tags (  );

CREATE SCHEMA modules_private;

CREATE SCHEMA modules_public;

CREATE TABLE modules_public.module_definitions (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	name text NOT NULL,
	context text NOT NULL,
	exec jsonb NOT NULL,
	defn jsonb NOT NULL DEFAULT ( '{}'::jsonb ),
	mls text,
	mods uuid[],
	data jsonb NULL,
	UNIQUE ( name, context ) 
);

COMMENT ON COLUMN modules_public.module_definitions.exec IS E'@omit';

CREATE TABLE modules_public.modules (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ) ON DELETE CASCADE,
	module_defn_id uuid NOT NULL REFERENCES modules_public.module_definitions ( id ),
	context text NOT NULL,
	active boolean DEFAULT ( FALSE ),
	data jsonb NOT NULL DEFAULT ( '{}'::jsonb ),
	executed boolean DEFAULT ( FALSE ),
	debug jsonb,
	mods uuid[] 
);

COMMENT ON COLUMN modules_public.modules.executed IS E'@omit';

COMMENT ON COLUMN modules_public.modules.active IS E'@omit';

CREATE TABLE modules_public.module_output (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	module_id uuid NOT NULL REFERENCES modules_public.modules ( id ) ON DELETE CASCADE,
	name text NOT NULL,
	value text NOT NULL,
	UNIQUE ( module_id, name ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'modules_public', 'module_output', 'uuids', 'trigger_set_uuid_related_field', 'id', 'module_id');

CREATE TABLE modules_public.module_input (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	module_id uuid NOT NULL REFERENCES modules_public.modules ( id ) ON DELETE CASCADE,
	name text NOT NULL,
	value text NOT NULL,
	UNIQUE ( module_id, name ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'modules_public', 'module_input', 'uuids', 'trigger_set_uuid_related_field', 'id', 'module_id');

CREATE TABLE modules_public.module_field (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	module_defn_id uuid NOT NULL REFERENCES modules_public.module_definitions ( id ) ON DELETE CASCADE,
	name text NOT NULL,
	description text,
	is_required boolean NOT NULL DEFAULT ( FALSE ),
	default_value text NULL DEFAULT ( NULL ),
	is_array boolean NOT NULL DEFAULT ( FALSE ),
	default_module_id uuid NULL REFERENCES modules_public.module_definitions ( id ) ON DELETE SET NULL,
	default_module_value text NULL,
	type citext NOT NULL,
	field_order int NOT NULL DEFAULT ( 0 ),
	UNIQUE ( module_defn_id, name ) 
);

SELECT db_utils.migrate('before_insert_seeded_uuid_trigger', '_0001_insert_id', 'modules_public', 'module_field', 'uuids', 'trigger_set_uuid_related_field', 'id', 'module_defn_id');

CREATE FUNCTION modules_private.get_module_input ( module_id uuid, name text, throws boolean DEFAULT TRUE ) RETURNS text AS $EOFCODE$
DECLARE
  val text;
  db_id uuid;
  modl modules_public.modules;
  defn modules_public.module_definitions;
  defn_field modules_public.module_field;
BEGIN
  SELECT * FROM modules_public.module_definitions md 
    JOIN modules_public.modules ms ON (ms.module_defn_id = md.id)
    WHERE ms.id = get_module_input.module_id
  INTO defn;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NO_MODULE_EXISTS';
  END IF;

  SELECT * FROM modules_public.module_field mf 
    WHERE mf.module_defn_id = defn.id 
    AND mf.name = get_module_input.name
   INTO defn_field;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NO_MODULE_FIELD_EXISTS %', get_module_input.name;
  END IF;

  SELECT value FROM modules_public.module_input mi 
    WHERE mi.module_id = get_module_input.module_id 
    AND mi.name = get_module_input.name INTO val;

  IF (NOT FOUND) THEN
    IF (
      defn_field.default_module_id IS NOT NULL 
      AND defn_field.default_module_value IS NOT NULL
    ) THEN

      SELECT database_id FROM modules_public.modules m
        WHERE m.id = get_module_input.module_id
      INTO db_id;

      SELECT mo.value FROM modules_public.modules m
        JOIN modules_public.module_output mo
        ON (mo.module_id = m.id AND mo.name = defn_field.default_module_value)
        WHERE m.module_defn_id = defn_field.default_module_id
        AND m.database_id = db_id
      INTO val;

    ELSIF (defn_field.default_value IS NOT NULL) THEN
      val = defn_field.default_value;
    END IF;
  END IF;

  IF (val IS NULL AND throws AND defn_field.is_required) THEN
    RAISE EXCEPTION 'MISSING_INPUT %', name;
  END IF;

  RETURN val;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION modules_private.create_table_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;

  table_name text;
  is_visible bool;
  pk_type text;
  pk_name text;
  pk_default_value text;
  pk_id uuid;

  schema_id uuid;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = create_table_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  table_name = modules_private.get_module_input(module_id, 'table_name');
  is_visible = modules_private.get_module_input(module_id, 'is_visible');
  pk_type = modules_private.get_module_input(module_id, 'pk_type');
  pk_name = modules_private.get_module_input(module_id, 'pk_name');
  pk_default_value = modules_private.get_module_input(module_id, 'pk_default_value');


 SELECT id FROM collections_public.schema s
    WHERE s.database_id = create_table_module.database_id
    AND s.name = (case when is_visible then 'public' else 'private' end)
    INTO schema_id;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  -- table
  INSERT INTO collections_public.table 
    (database_id, schema_id, name, is_system)
    VALUES (database_id, schema_id, table_name, false)
  RETURNING * INTO tb;

  IF (pk_type = 'uuid') THEN
    IF (pk_default_value IS NULL) THEN
      RAISE EXCEPTION 'INVALID_UUID_DEFAULT';
    END IF;

    -- pk_id
    INSERT INTO collections_public.field 
      (table_id, name, type, is_required, default_value)
    VALUES 
      (tb.id, pk_name, pk_type, true, pk_default_value)
    RETURNING id INTO pk_id;

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (create_table_module.module_id, 'pk_default_value', pk_default_value)
    ;

  ELSIF (pk_type = 'serial') THEN

    -- pk_id
    INSERT INTO collections_public.field 
      (table_id, name, type, is_required)
    VALUES 
      (tb.id, pk_name, pk_type, true)
    RETURNING id INTO pk_id;

  ELSE 
    RAISE EXCEPTION 'INVALID_ID_TYPE';
  END IF;

  -- p constraint 
  INSERT INTO collections_public.primary_key_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[pk_id]);


  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (create_table_module.module_id, 'pk_type', pk_type),
    (create_table_module.module_id, 'pk_name', pk_name),
    (create_table_module.module_id, 'table_id', tb.id)
    ;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.crypto_auth_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;

  user_table_id uuid;
  tokens_table_id uuid;
  secrets_table_id uuid;
  
  user_field text;


  user_table text;
  tokens_table text;
  secrets_table text;

  secrets_field text;
  secrets_owned_field text;

  crypto_network text;

  sign_in_request_challenge text;
  sign_in_record_failure text;
  sign_up_unique_key text;
  sign_in_with_challenge text;

  user_field_id uuid;
  user_field_name text;

  fid uuid;

  private_schema text;

BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = crypto_auth_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = crypto_auth_module.database_id
    AND s.name = 'private'
    INTO private_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;


  user_table_id = modules_private.get_module_input(module_id, 'user_table_id', false);
  user_field = modules_private.get_module_input(module_id, 'user_field', false);
  secrets_field = modules_private.get_module_input(module_id, 'secrets_field', false);
  secrets_owned_field = modules_private.get_module_input(module_id, 'secrets_owned_field', false);
  tokens_table_id = modules_private.get_module_input(module_id, 'tokens_table_id', false);
  secrets_table_id = modules_private.get_module_input(module_id, 'secrets_table_id', false);
  sign_in_request_challenge = modules_private.get_module_input(module_id, 'sign_in_request_challenge', false);
  sign_in_record_failure = modules_private.get_module_input(module_id, 'sign_in_record_failure', false);
  sign_up_unique_key = modules_private.get_module_input(module_id, 'sign_up_unique_key', false);
  sign_in_with_challenge = modules_private.get_module_input(module_id, 'sign_in_with_challenge', false);
  crypto_network = modules_private.get_module_input(module_id, 'crypto_network', false);

  SELECT name FROM collections_public.table t
    WHERE t.id = user_table_id
      AND t.database_id = db.id
  INTO user_table;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT name FROM collections_public.table t
    WHERE t.id = tokens_table_id
      AND t.database_id = db.id
  INTO tokens_table;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT name FROM collections_public.table t
    WHERE t.id = secrets_table_id
      AND t.database_id = db.id
  INTO secrets_table;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  -- BEGIN EDIT FIELD
  INSERT INTO collections_public.field (table_id, name, type)
    VALUES (user_table_id, user_field, 'text')
  RETURNING id INTO fid;
  INSERT INTO collections_public.unique_constraint (table_id, field_ids)
    VALUES (user_table_id, ARRAY[fid]::uuid[]);
  -- END EDIT FIELD

  -- BEGIN FNS

  PERFORM db_migrate.migrate('sign_in_request_challenge', 
    db.id::text, 

    private_schema,
    sign_in_request_challenge,

    collections_private.get_schema_name_by_table_id(user_table_id),    
    user_table,
    user_field,

    collections_private.get_schema_name_by_table_id(secrets_table_id),
    secrets_table,
    secrets_field,
    secrets_owned_field
  );

  PERFORM db_migrate.migrate('grant_execute_on_function', 
    db.id::text,
    private_schema,
    sign_in_request_challenge,
    'anonymous'
  );

  -- 

  PERFORM db_migrate.migrate('sign_in_record_failure', 
    db.id::text, 

    private_schema,
    sign_in_record_failure,

    collections_private.get_schema_name_by_table_id(user_table_id),    
    user_table,
    user_field,

    collections_private.get_schema_name_by_table_id(secrets_table_id),
    secrets_table,
    secrets_field,
    secrets_owned_field
  );

  PERFORM db_migrate.migrate('grant_execute_on_function', 
    db.id::text,
    private_schema,
    sign_in_record_failure,
    'anonymous'
  );

  -- 

  PERFORM db_migrate.migrate('sign_up_unique_key', 
    db.id::text, 

    private_schema,
    sign_up_unique_key,

    collections_private.get_schema_name_by_table_id(user_table_id),    
    user_table,
    user_field
  );

  PERFORM db_migrate.migrate('grant_execute_on_function', 
    db.id::text,
    private_schema,
    sign_up_unique_key,
    'anonymous'
  );

  --

  PERFORM db_migrate.migrate('sign_in_with_challenge', 
    db.id::text, 

    private_schema,
    sign_in_with_challenge,

    collections_private.get_schema_name_by_table_id(user_table_id),    
    user_table,
    user_field,

    collections_private.get_schema_name_by_table_id(tokens_table_id),
    tokens_table,

    collections_private.get_schema_name_by_table_id(secrets_table_id),
    secrets_table,
    secrets_field,
    secrets_owned_field
  );

  PERFORM db_migrate.migrate('grant_execute_on_function', 
    db.id::text,
    private_schema,
    sign_in_with_challenge,
    'anonymous'
  );

  -- TODO AUTOMATE SERVICES
  -- UPDATE services_public.services s
  --   SET pubkey_challenge = ARRAY[
  --     crypto_network,
  --     private_schema,
  --     sign_up_unique_key,
  --     sign_in_request_challenge,
  --     sign_in_record_failure,
  --     sign_in_with_challenge
  --   ]
  --   WHERE s.database_id = crypto_auth_module.database_id
  --   AND s.is_public = TRUE;

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (crypto_auth_module.module_id, 'user_field', user_field),
    (crypto_auth_module.module_id, 'sign_in_request_challenge', sign_in_request_challenge),
    (crypto_auth_module.module_id, 'sign_in_record_failure', sign_in_record_failure),
    (crypto_auth_module.module_id, 'sign_up_unique_key', sign_up_unique_key),
    (crypto_auth_module.module_id, 'sign_in_with_challenge', sign_in_with_challenge),
    (crypto_auth_module.module_id, 'crypto_network', crypto_network);

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.default_ids_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  default_type text;
  default_value text;
  default_name text;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = default_ids_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  default_type = modules_private.get_module_input(module_id, 'default_type');
  default_value = modules_private.get_module_input(module_id, 'default_value');
  default_name = modules_private.get_module_input(module_id, 'default_name');

  IF (default_type = 'uuid') THEN

    IF (default_value IS NULL) THEN
      RAISE EXCEPTION 'INVALID_UUID_DEFAULT';
    END IF;

    INSERT INTO modules_public.module_output
      (module_id, name, value)
      VALUES
      (default_ids_module.module_id, 'default_type', default_type),
      (default_ids_module.module_id, 'default_name', default_name),
      (default_ids_module.module_id, 'default_value', default_value)
      ;

  ELSIF (default_type = 'serial') THEN

    INSERT INTO modules_public.module_output
        (module_id, name, value)
        VALUES
        (default_ids_module.module_id, 'default_type', default_type),
        (default_ids_module.module_id, 'default_name', default_name)
        ;

  ELSE 
    RAISE EXCEPTION 'INVALID_ID_TYPE';
  END IF;



END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.emails_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;

  emails_table text;
  emails_owned_field text;
  owned_table_id uuid;

  multiple_emails boolean;

  pk_id uuid;
  fk_id uuid;
  em_id uuid;

  schema_id uuid;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = emails_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  emails_table = modules_private.get_module_input(module_id, 'emails_table');
  emails_owned_field = modules_private.get_module_input(module_id, 'emails_owned_field');
  multiple_emails = modules_private.get_module_input(module_id, 'multiple_emails');

  IF (emails_owned_field IS NULL) THEN
    owned_table_id = modules_private.get_module_input(module_id, 'owned_table_id');
    SELECT inflection_db.get_foreign_key_field_name( name )
    FROM collections_public.table t 
      WHERE t.id = owned_table_id
        AND t.database_id = emails_module.database_id
    INTO emails_owned_field;
  ELSE
    emails_owned_field = inflection_db.get_field_name(emails_owned_field);
  END IF;

  SELECT id FROM collections_public.schema s
    WHERE s.database_id = emails_module.database_id
    AND s.name = 'public'
    INTO schema_id;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  -- emails table
  INSERT INTO collections_public.table 
    (database_id, schema_id, name, is_system)
    VALUES (database_id, schema_id, emails_table, true)
  RETURNING * INTO tb;

  -- pk_id
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'id', 'uuid', true, 'uuid_generate_v4 ()')
  RETURNING id INTO pk_id;

  -- fk_id
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required)
  VALUES 
    (tb.id, emails_owned_field, 'uuid', true)
  RETURNING id INTO fk_id;

  -- email
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required)
  VALUES 
    (tb.id, 'email', 'email', true)
  RETURNING id INTO em_id;

  -- is_verified
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'is_verified', 'boolean', true, 'false');

  -- p constraint 
  INSERT INTO collections_public.primary_key_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[pk_id]);

  -- u constraint
  INSERT INTO collections_public.unique_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[em_id]);

  IF (multiple_emails IS FALSE) THEN 
    -- constraint FOR users table 1-1 mapping
    -- ONLY 1 email per account
    INSERT INTO collections_public.unique_constraint
      (table_id, field_ids)
    VALUES (tb.id, ARRAY[fk_id]);
  END IF;

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (emails_module.module_id, 'table_id', tb.id),
    (emails_module.module_id, 'emails_owned_field', emails_owned_field),
    (emails_module.module_id, 'emails_table', emails_table);
    
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.encrypted_secrets_utils_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;

  private_schema text;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = encrypted_secrets_utils_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = encrypted_secrets_utils_module.database_id
    AND s.name = 'private'
    INTO private_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  PERFORM db_migrate.migrate('encrypt_field_bytea_to_text', 
    database_id::text,
    private_schema,
    'encrypt_field_bytea_to_text'
  );

  PERFORM db_migrate.migrate('encrypt_field_pgp_get', 
    database_id::text,
    private_schema,
    'encrypt_field_pgp_get'
  );

  PERFORM db_migrate.migrate('encrypt_field_set', 
    database_id::text,
    private_schema,
    'encrypt_field_set'
  );

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (encrypted_secrets_utils_module.module_id, 'encrypted_schema', private_schema)
  ;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.encrypted_secrets_encrypt_field_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;
  fd collections_public.field;
  efd collections_public.field;

  field_id uuid;
  encode_field_id uuid;
  table_name text;
  schema_name text;
  encrypted_schema text;
  encryption_type text;

  encrypt_this_field_fn text;
  update_tg_name text;
  insert_tg_name text;

BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = encrypted_secrets_encrypt_field_module.database_id
  INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  field_id = modules_private.get_module_input(module_id, 'field_id');
  encode_field_id = modules_private.get_module_input(module_id, 'encode_field_id');
  encrypted_schema = modules_private.get_module_input(module_id, 'encrypted_schema');
  encryption_type = modules_private.get_module_input(module_id, 'encryption_type');

  SELECT * FROM collections_public.field 
    WHERE id = field_id
  INTO fd;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT * FROM collections_public.table
    WHERE id = fd.table_id
  INTO tb;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  IF (encryption_type = 'pgp') THEN 

    SELECT * FROM collections_public.field 
      WHERE id = encode_field_id
    INTO efd;

    IF (NOT FOUND) THEN
      RAISE EXCEPTION 'ENCODE_FIELD_REQUIRED';
    END IF;

  END IF;

  table_name = tb.name;
  schema_name = collections_private.get_schema_name_by_table_id(tb.id);

  encrypt_this_field_fn = inflection_db.get_field_name(ARRAY[table_name, 'encrypt', fd.name]);
  insert_tg_name = inflection_db.get_field_name(ARRAY[table_name, 'ins', fd.name]);
  update_tg_name = inflection_db.get_field_name(ARRAY[table_name, 'upd', fd.name]);

  IF (encryption_type = 'crypt') THEN
    IF (fd.type != 'text') THEN
      RAISE EXCEPTION 'WRONG_TYPE crypt requires text storage';
    END IF;
    PERFORM db_migrate.migrate('encrypt_field_crypt', 
      database_id::text,
      encrypted_schema,
      encrypt_this_field_fn,
      fd.name
    );
  ELSIF (encryption_type = 'pgp') THEN
    IF (fd.type != 'bytea' AND fd.type != 'text') THEN
      RAISE EXCEPTION 'WRONG_TYPE pgp requires bytea or text storage';
    END IF;
    PERFORM db_migrate.migrate('encrypt_field_pgp', 
      database_id::text,
      encrypted_schema,
      encrypt_this_field_fn,
      fd.name,
      efd.name
    );
  END IF;

  PERFORM db_migrate.migrate('before_update_trigger_prop_changed', 
    database_id::text,
    update_tg_name,
    collections_private.get_schema_name_by_table_id(tb.id),
    tb.name,
    fd.name,
    encrypted_schema,
    encrypt_this_field_fn
  );

  PERFORM db_migrate.migrate('before_insert_trigger', 
    database_id::text,
    insert_tg_name,
    collections_private.get_schema_name_by_table_id(tb.id),
    tb.name,
    encrypted_schema,
    encrypt_this_field_fn
  );

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (encrypted_secrets_encrypt_field_module.module_id, 'encryption_type', encryption_type)
  ;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.encrypted_secrets_getter_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;

  table_id uuid;
  table_name text;
  schema_name text;
  getter_name text;
  owned_field text;

  out text;

  private_schema text;


BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = encrypted_secrets_getter_module.database_id
  INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = encrypted_secrets_getter_module.database_id
    AND s.name = 'private'
    INTO private_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;


  table_id = modules_private.get_module_input(module_id, 'table_id');
  owned_field = modules_private.get_module_input(module_id, 'owned_field');

  SELECT * FROM collections_public.table
    WHERE id = table_id
  INTO tb;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  table_name = tb.name;
  schema_name = collections_private.get_schema_name_by_table_id(tb.id);
  getter_name = inflection_db.get_field_name(ARRAY[table_name, 'get', 'pgp']);

  PERFORM db_migrate.migrate('encrypt_field_pgp_getter', 
    database_id::text,
    private_schema,
    getter_name,

    schema_name,
    table_name,

    owned_field
  );

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (encrypted_secrets_getter_module.module_id, 'schema_name', private_schema),
    (encrypted_secrets_getter_module.module_id, 'getter_name', getter_name)
  ;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.encrypted_secrets_setter_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;

  table_id uuid;
  table_name text;
  schema_name text;
  upsert_schema_name text;
  upsert_name text;
  owned_field text;

  out text;

BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = encrypted_secrets_setter_module.database_id
  INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  table_id = modules_private.get_module_input(module_id, 'table_id');
  owned_field = modules_private.get_module_input(module_id, 'owned_field');

  SELECT * FROM collections_public.table
    WHERE id = table_id
  INTO tb;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
      WHERE s.database_id = db.id
      AND s.name = 'public'
      INTO upsert_schema_name;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  table_name = tb.name;
  schema_name = collections_private.get_schema_name_by_table_id(tb.id);
  upsert_name = inflection_db.get_field_name(ARRAY['upsert', 'fields', table_name]);

  PERFORM db_migrate.migrate('secrets_table_upsert', 
    database_id::text,
    upsert_schema_name, 
    upsert_name,

    schema_name,
    table_name,

    owned_field
  );

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (encrypted_secrets_setter_module.module_id, 'schema_name', upsert_schema_name),
    (encrypted_secrets_setter_module.module_id, 'upsert_name', upsert_name)
  ;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.encrypted_secrets_verify_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;

  table_id uuid;
  table_name text;
  schema_name text;
  verify_name text;
  owned_field text;

  out text;

  private_schema text;

BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = encrypted_secrets_verify_module.database_id
  INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = encrypted_secrets_verify_module.database_id
    AND s.name = 'private'
    INTO private_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  table_id = modules_private.get_module_input(module_id, 'table_id');
  owned_field = modules_private.get_module_input(module_id, 'owned_field');

  SELECT * FROM collections_public.table
    WHERE id = table_id
  INTO tb;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  table_name = tb.name;
  schema_name = collections_private.get_schema_name_by_table_id(tb.id);
  verify_name = inflection_db.get_field_name(ARRAY[table_name, 'verify', 'crypt']);

  PERFORM db_migrate.migrate('encrypt_field_crypt_verify', 
    database_id::text,
    private_schema, 
    verify_name,

    schema_name,
    table_name,

    owned_field
  );

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (encrypted_secrets_verify_module.module_id, 'schema_name', private_schema),
    (encrypted_secrets_verify_module.module_id, 'verify_name', verify_name)
  ;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.encrypted_secrets_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;
  
  pk_id uuid;
  obj_key_id uuid;
  name_id uuid;

  secrets_table text;
  secrets_value_field text;
  secrets_enc_field text;
  secrets_owned_field text;
  owned_table_id uuid;

  allow_public_upserts bool;

  upsert_schema text;
  private_schema text;

  _trigger_hash_body text;
  _trigger_hash_fn_text text;

  _hashername text;
  _utriggername text;
  _itriggername text;

  schema_id uuid;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = encrypted_secrets_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  secrets_table = modules_private.get_module_input(module_id, 'secrets_table');
  secrets_value_field = modules_private.get_module_input(module_id, 'secrets_value_field');
  secrets_enc_field = modules_private.get_module_input(module_id, 'secrets_enc_field');
  secrets_owned_field = modules_private.get_module_input(module_id, 'secrets_owned_field');
  allow_public_upserts = modules_private.get_module_input(module_id, 'allow_public_upserts');

  IF (secrets_owned_field IS NULL) THEN
    owned_table_id = modules_private.get_module_input(module_id, 'owned_table_id');
    SELECT inflection_db.get_foreign_key_field_name( name )
    FROM collections_public.table t 
      WHERE t.id = owned_table_id
        AND t.database_id = encrypted_secrets_module.database_id
    INTO secrets_owned_field;
  ELSE
    secrets_owned_field = inflection_db.get_field_name(secrets_owned_field);
  END IF;

  secrets_value_field = inflection_db.get_field_name(secrets_value_field);
  secrets_enc_field = inflection_db.get_field_name(secrets_enc_field);

  -- SELECT schema_name, id FROM collections_public.schema s
  --   WHERE s.database_id = encrypted_secrets_module.database_id
  --   AND s.name = 'private'
  --   INTO private_schema, schema_id;

  -- TODO make the schema name a variable so we can have more than one
  INSERT INTO collections_public.schema
    (database_id, name) VALUES (db.id, 'encrypted_secrets')
  RETURNING id, schema_name INTO schema_id, private_schema;


  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  -- secrets table
  INSERT INTO collections_public.table 
    (database_id, schema_id, name, is_system)
    VALUES (database_id, schema_id, secrets_table, true)
  RETURNING * INTO tb;

  -- pk_id
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'id', 'uuid', true, 'uuid_generate_v4 ()')
  RETURNING id INTO pk_id;

  -- obj_key_id
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required)
  VALUES 
    (tb.id, secrets_owned_field, 'uuid', true)
  RETURNING id INTO obj_key_id;

  -- name
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required)
  VALUES 
    (tb.id, 'name', 'text', true)
  RETURNING id INTO name_id;

  -- fields

  INSERT INTO collections_public.field 
    (table_id, name, type, is_required)
  VALUES 
    (tb.id, secrets_value_field, 'bytea', false),
    (tb.id, secrets_enc_field, 'text', false)
  ;

  -- constraint 
  
  INSERT INTO collections_public.primary_key_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[pk_id]);

  -- constraint

  INSERT INTO collections_public.unique_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[obj_key_id, name_id]);

  -- END table creation

  -- setup trigger functions

  SELECT db_migrate.text('secrets_hash_password_tg_body', secrets_value_field, secrets_enc_field, secrets_owned_field)
    INTO _trigger_hash_body;

  SELECT inflection_db.get_field_name(ARRAY[tb.name, 'hash']) INTO _hashername;

  PERFORM db_migrate.migrate('trigger_function', db.id::text, private_schema, _hashername, _trigger_hash_body);

  INSERT INTO collections_public.trigger_function
    (database_id, name)
  VALUES (db.id, _hashername);

  -- setup triggers

  SELECT inflection_db.get_field_name(ARRAY[tb.name, 'update', 'tg']) INTO _utriggername;
  SELECT inflection_db.get_field_name(ARRAY[tb.name, 'insert', 'tg']) INTO _itriggername;

  INSERT INTO collections_public.trigger
    (table_id, name)
  VALUES (tb.id, _utriggername), (tb.id, _itriggername);

  PERFORM db_migrate.migrate('before_update_trigger_prop_changed', 
    database_id::text,
    _utriggername,
    private_schema,
    tb.name,
    secrets_value_field,
    private_schema,
    _hashername
  );

  PERFORM db_migrate.migrate('before_insert_trigger', 
    database_id::text,
    _itriggername,
    private_schema,
    tb.name,
    private_schema,
    _hashername
  );

  -- getters

  PERFORM db_migrate.migrate('secrets_get_fn', 
    database_id::text,
    private_schema,
    'get',
    private_schema,
    tb.name,
    secrets_value_field,
    secrets_enc_field,
    secrets_owned_field
  );

  -- verify

  PERFORM db_migrate.migrate('secrets_verify_fn', 
    database_id::text,
    private_schema,
    'verify',
    private_schema,
    tb.name,
    secrets_enc_field,
    secrets_owned_field,
    'get'
  );

  -- upsert

  -- SELECT s.schema_name FROM collections_public.schema s
  --     WHERE s.database_id = db.id
  --     AND s.name = (CASE WHEN allow_public_upserts THEN 'public' ELSE 'private' END)
  --     INTO upsert_schema;

  -- IF (NOT FOUND) THEN
  --   RAISE EXCEPTION 'NOT_FOUND';
  -- END IF;

  -- TODO if we have public, then we just make a 2nd function we still apply to private...
  -- FOR NOW we just accept this...

  upsert_schema = private_schema;

  PERFORM db_migrate.migrate('secrets_upsert_fn', 
    database_id::text,
    private_schema,
    'set',
    private_schema,
    tb.name,
    secrets_owned_field,
    secrets_value_field,
    secrets_enc_field
  );

  PERFORM db_migrate.migrate('secrets_remove_fn', 
    database_id::text,
    
    private_schema,
    'del',

    private_schema,
    tb.name,
    secrets_owned_field
  );

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (encrypted_secrets_module.module_id, 'owned_table_id', owned_table_id),
    (encrypted_secrets_module.module_id, 'upsert_schema', upsert_schema),
    (encrypted_secrets_module.module_id, 'encrypt_schema', private_schema),
    (encrypted_secrets_module.module_id, 'getter', 'get'),
    (encrypted_secrets_module.module_id, 'verify', 'verify'),
    (encrypted_secrets_module.module_id, 'delete', 'del'),
    (encrypted_secrets_module.module_id, 'upsert', 'set'),
    (encrypted_secrets_module.module_id, 'secrets_table', secrets_table),
    (encrypted_secrets_module.module_id, 'table_id', tb.id),
    (encrypted_secrets_module.module_id, 'secrets_value_field', secrets_value_field),
    (encrypted_secrets_module.module_id, 'secrets_enc_field', secrets_enc_field),
    (encrypted_secrets_module.module_id, 'secrets_owned_field', secrets_owned_field);

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.immutable_field_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;
  fd collections_public.field;

  field_id uuid;
  table_name text;
  schema_name text;
  trigger_name text;
  trigger_function text;
  trigger_schema text;

BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = immutable_field_module.database_id
  INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  field_id = modules_private.get_module_input(module_id, 'field_id');
  trigger_schema = modules_private.get_module_input(module_id, 'trigger_schema');
  trigger_function = modules_private.get_module_input(module_id, 'trigger_function');

  SELECT * FROM collections_public.field 
    WHERE id = field_id
  INTO fd;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT * FROM collections_public.table
    WHERE id = fd.table_id
  INTO tb;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  table_name = tb.name;
  schema_name = collections_private.get_schema_name_by_table_id(tb.id);
  trigger_name = inflection_db.get_field_name(ARRAY[table_name, fd.name, 'immutable', 'tg']);

  PERFORM db_migrate.migrate('immutable_field_trigger', 
    database_id::text,
    trigger_name,
    schema_name,
    table_name,
    fd.name,
    trigger_schema,
    trigger_function,
    fd.name
  );

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (immutable_field_module.module_id, 'trigger_name', trigger_name)
  ;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.immutable_field_utils_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;

  private_schema text;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = immutable_field_utils_module.database_id
  INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = immutable_field_utils_module.database_id
    AND s.name = 'private'
    INTO private_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  PERFORM db_migrate.migrate('immutable_field_trigger_fn', 
    database_id::text,
    private_schema,
    'immutable_field_tg'
  );

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (immutable_field_utils_module.module_id, 'trigger_function', 'immutable_field_tg'),
    (immutable_field_utils_module.module_id, 'trigger_schema', private_schema)
  ;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.invites_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;

  invites_schema text;
  invites_table text;
  claimed_invites_table text;

  emails_table_id uuid;
  emails_schema text;
  emails_table text;
  emails_owned_field text;

  users_schema text;
  users_table text;
  
  users_table_id uuid;

  user_fk uuid;
  user_field collections_public.field;

  currole text;
  role_schema text;
  current_role_id text;

  id_fd uuid;
  sender_id_fd uuid;
  receiver_id_fd uuid;
  email_fd uuid;
  invite_token_fd uuid;
  expires_at_fd uuid;
  multiple_fd uuid;
  invite_valid_fd uuid;
  invite_limit_fd uuid;

  schema_id uuid;

  public_schema text;
  submit_invite_code_function text;

BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = invites_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  submit_invite_code_function = modules_private.get_module_input(module_id, 'submit_invite_code_function');
  invites_table = modules_private.get_module_input(module_id, 'invites_table');
  claimed_invites_table = modules_private.get_module_input(module_id, 'claimed_invites_table');

  emails_table_id = modules_private.get_module_input(module_id, 'emails_table_id');
  emails_owned_field = modules_private.get_module_input(module_id, 'emails_owned_field');
  users_table_id = modules_private.get_module_input(module_id, 'users_table_id');

  SELECT name FROM collections_public.table t 
    WHERE t.id = emails_table_id
    AND t.database_id = invites_module.database_id
  INTO emails_table;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT name FROM collections_public.table t 
    WHERE t.id = users_table_id
    AND t.database_id = invites_module.database_id
  INTO users_table;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  emails_schema = collections_private.get_schema_name_by_table_id(emails_table_id);
  users_schema = collections_private.get_schema_name_by_table_id(users_table_id);

  role_schema = modules_private.get_module_input(module_id, 'role_schema');
  current_role_id = modules_private.get_module_input(module_id, 'current_role_id');
  currole = format('%I.%I()', role_schema, current_role_id);

  SELECT id, schema_name FROM collections_public.schema s
    WHERE s.database_id = invites_module.database_id
    AND s.name = 'public'
    INTO schema_id, invites_schema;

  public_schema = invites_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  -- invites table
  INSERT INTO collections_public.table 
    (database_id, schema_id, name, use_rls)
    VALUES (database_id, schema_id, invites_table, true)
  RETURNING * INTO tb;

  -- id_fd
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'id', 'uuid', true, 'uuid_generate_v4 ()')
  RETURNING id INTO id_fd;

  -- p constraint 
  INSERT INTO collections_public.primary_key_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[id_fd]);

  -- email
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required)
  VALUES 
    (tb.id, 'email', 'email', false)
  RETURNING id INTO email_fd;

  -- sender_id 
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'sender_id', 'uuid', true, currole)
  RETURNING id INTO sender_id_fd;

  -- invite_token
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'invite_token', 'text', true, 'encode( gen_random_bytes( 16 ), ''hex'' )')
  RETURNING id INTO invite_token_fd;

  -- invite_valid
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'invite_valid', 'boolean', true, 'TRUE')
  RETURNING id INTO invite_valid_fd;

  -- invite_limit
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'invite_limit', 'int', true, '-1')
  RETURNING id INTO invite_limit_fd;
  
  -- invite_count
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'invite_count', 'int', true, '0')
  ;

  -- multiple
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'multiple', 'boolean', true, 'FALSE')
  RETURNING id INTO multiple_fd;

  -- expires_at
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'expires_at', 'timestamptz', true, 'NOW() + interval ''3 months''')
  RETURNING id INTO expires_at_fd;

  -- created_at
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'created_at', 'timestamptz', true, 'NOW()')
  ;


  -- uniques
  INSERT INTO collections_public.unique_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[email_fd, sender_id_fd]);

  INSERT INTO collections_public.unique_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[invite_token_fd]);

  -- indexes
  INSERT INTO collections_public.index
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[expires_at_fd]);

  INSERT INTO collections_public.index
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[invite_valid_fd]);

  INSERT INTO collections_public.index
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[sender_id_fd]);

  -- get users(id) for fkey
  SELECT id FROM collections_public.field f
    INTO user_fk WHERE 
      f.table_id = users_table_id AND
      f.database_id = tb.database_id AND
      f.name = 'id' -- I suppose we hard code it (later make helper for getting pkey then field)
    ;

  -- fkey
  INSERT INTO collections_public.foreign_key_constraint
    (table_id, field_ids, ref_table_id, ref_field_ids, delete_action)
  VALUES (
    tb.id, ARRAY[sender_id_fd], users_table_id, ARRAY[user_fk], 'c'
  );

  -- policies
 PERFORM collections_public.apply_rls(
   table_id := tb.id,
   grants := '[["insert","authenticated"]]'::jsonb,
   template := 'own_records',
   vars := '{"role_key":"sender_id"}'::jsonb,
   field_ids := ARRAY[email_fd, expires_at_fd, multiple_fd, invite_limit_fd]
 );
 PERFORM collections_public.apply_rls(
   table_id := tb.id,
   grants := '[["update","authenticated"]]'::jsonb,
   template := 'own_records',
   vars := '{"role_key":"sender_id"}'::jsonb,
   field_ids := ARRAY[expires_at_fd]
 );
 PERFORM collections_public.apply_rls(
   table_id := tb.id,
   grants := '[["select","authenticated"]]'::jsonb,
   template := 'own_records',
   vars := '{"role_key":"sender_id"}'::jsonb
 );
 PERFORM collections_public.apply_rls(
   table_id := tb.id,
   grants := '[["delete","authenticated"]]'::jsonb,
   template := 'own_records',
   vars := '{"role_key":"sender_id"}'::jsonb
 );

  -- clear for sanity
  tb = NULL;
  id_fd = NULL;
  sender_id_fd = NULL;
  receiver_id_fd = NULL;

  -- claimed_invites table

  INSERT INTO collections_public.table 
    (database_id, schema_id, name, use_rls)
    VALUES (database_id, schema_id, claimed_invites_table, true)
  RETURNING * INTO tb;

  -- id_fd
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'id', 'uuid', true, 'uuid_generate_v4 ()')
  RETURNING id INTO id_fd;

  -- p constraint 
  INSERT INTO collections_public.primary_key_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[id_fd]);

  -- sender_id 
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required)
  VALUES 
    (tb.id, 'sender_id', 'uuid', true)
  RETURNING id INTO sender_id_fd;

  -- receiver_id 
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required)
  VALUES 
    (tb.id, 'receiver_id', 'uuid', true)
  RETURNING id INTO receiver_id_fd;

  -- created_at
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'created_at', 'timestamptz', true, 'NOW()')
  ;

  -- fkeys
  INSERT INTO collections_public.foreign_key_constraint
    (table_id, field_ids, ref_table_id, ref_field_ids, delete_action)
  VALUES (
    tb.id, ARRAY[sender_id_fd], users_table_id, ARRAY[user_fk], 'c'
  );

  INSERT INTO collections_public.foreign_key_constraint
    (table_id, field_ids, ref_table_id, ref_field_ids, delete_action)
  VALUES (
    tb.id, ARRAY[receiver_id_fd], users_table_id, ARRAY[user_fk], 'c'
  );

  -- indexes

  INSERT INTO collections_public.index
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[sender_id_fd]);

  INSERT INTO collections_public.index
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[receiver_id_fd]);

  -- policies
  PERFORM collections_public.apply_rls(
    table_id := tb.id,
    grants := '[["select","authenticated"]]'::jsonb,
    template := 'multi_owners',
    vars := '{"role_keys":["sender_id","receiver_id"]}'::jsonb
  );


  PERFORM db_migrate.migrate('submit_invite_code', 
    db.id::text,

    public_schema,
    submit_invite_code_function,

    users_schema,
    users_table,

    emails_schema,
    emails_table,
    emails_owned_field,

    invites_schema,
    invites_table,
    claimed_invites_table,

    role_schema,
    current_role_id
  );

  -- OUTPUTS
  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (invites_module.module_id, 'invites_schema', invites_schema),
    (invites_module.module_id, 'claimed_invites_table', claimed_invites_table),
    (invites_module.module_id, 'invites_table', invites_table);

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.jobs_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;
  scma collections_public.schema;

  jobs_schema text;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = jobs_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  INSERT INTO collections_public.schema
    (database_id, name) VALUES (db.id, 'jobs')
  RETURNING schema_name INTO jobs_schema;

  PERFORM db_migrate.migrate('jobs',
    db.id::text,
    jobs_schema
  );

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (jobs_module.module_id, 'jobs_schema', jobs_schema)
    ;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.jobs_trigger_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;

  event_type text;
  include_fields bool;
  job_name text;
  jobs_schema text;
  table_id uuid;
  table_name text;
  trigger_function text;
  trigger_name text;

  pk_id uuid;
  fk_id uuid;
  em_id uuid;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = jobs_trigger_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  table_id = modules_private.get_module_input(module_id, 'table_id');
  event_type = upper(modules_private.get_module_input(module_id, 'event_type'));
  jobs_schema = modules_private.get_module_input(module_id, 'jobs_schema');
  job_name = modules_private.get_module_input(module_id, 'job_name');
  include_fields = modules_private.get_module_input(module_id, 'include_fields');

  SELECT name FROM collections_public.table
    WHERE id = table_id
  INTO table_name;
  
  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  IF (include_fields) THEN
    trigger_function = 'tg_add_job_with_row';
  ELSE
    trigger_function = 'tg_add_job_with_row_id';
  END IF;

  trigger_name = inflection_db.get_field_name(ARRAY[table_name, lower(event_type), 'job', 'tg']);

  PERFORM db_migrate.migrate('jobs_trigger',
    db.id::text,
    trigger_name,
    collections_private.get_schema_name_by_table_id(table_id),
    table_name,
    jobs_schema,
    trigger_function,
    event_type,
    job_name
  );

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (jobs_trigger_module.module_id, 'trigger_function', trigger_function),
    (jobs_trigger_module.module_id, 'trigger_name', trigger_name),
    (jobs_trigger_module.module_id, 'event_type', event_type),
    (jobs_trigger_module.module_id, 'table_id', table_id)
    ;
    
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.peoplestamps_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  current_role_id text;
  updated_by_column text;
  created_by_column text;
  role_schema text;
  trigger_name text;

  private_schema text;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = peoplestamps_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = peoplestamps_module.database_id
    AND s.name = 'private'
    INTO private_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  trigger_name = modules_private.get_module_input(module_id, 'trigger_name');
  role_schema = modules_private.get_module_input(module_id, 'role_schema');
  updated_by_column = modules_private.get_module_input(module_id, 'created_by_column');
  created_by_column = modules_private.get_module_input(module_id, 'updated_by_column');
  current_role_id = modules_private.get_module_input(module_id, 'current_role_id');

  PERFORM db_migrate.migrate('peoplestamps_trigger',
    db.id::text,

    -- trigger_schema defaults to private
    private_schema,
    trigger_name,

    -- HARD coding the schema, kinda, using string names
    role_schema,
    current_role_id,

    created_by_column,
    updated_by_column
  );

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    
    (peoplestamps_module.module_id, 'trigger_schema', private_schema),
    (peoplestamps_module.module_id, 'updated_by_column', updated_by_column),
    (peoplestamps_module.module_id, 'created_by_column', created_by_column),
    (peoplestamps_module.module_id, 'trigger_name', trigger_name)
    
    ;


END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.rls_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;

  authenticate text;
  vcurrent_role text;
  current_role_id text;
  current_group_ids text;

  public_schema text;
  private_schema text;

  tokens_table text;
  tokens_table_id uuid;
  
  users_table text;
  users_table_id uuid;
  
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = rls_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = rls_module.database_id
    AND s.name = 'private'
    INTO private_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = rls_module.database_id
    AND s.name = 'public'
    INTO public_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  authenticate = modules_private.get_module_input(module_id, 'authenticate');
  vcurrent_role = modules_private.get_module_input(module_id, 'current_role');
  current_role_id = modules_private.get_module_input(module_id, 'current_role_id');
  users_table_id = modules_private.get_module_input(module_id, 'users_table_id');
  tokens_table_id = modules_private.get_module_input(module_id, 'tokens_table_id');
  current_group_ids = modules_private.get_module_input(module_id, 'current_group_ids');

  SELECT name FROM collections_public.table t
    WHERE t.id = tokens_table_id
      AND t.database_id = db.id
  INTO tokens_table;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  PERFORM db_migrate.migrate('authenticate', 
    db.id::text,
    private_schema,
    authenticate,

    collections_private.get_schema_name_by_table_id(tokens_table_id),
    tokens_table
  );

  -- role_schema = public by default for rls_functions
  INSERT INTO collections_public.rls_function (
    database_id,
    name,
    function_template_name
  ) VALUES (
    db.id,
    current_role_id,
    'current_role_id'
  );

  INSERT INTO collections_public.rls_function (
    database_id,
    name,
    function_template_name
  ) VALUES (
    db.id,
    current_group_ids,
    'current_group_ids'
  );

  SELECT name FROM collections_public.table t
    WHERE t.id = users_table_id
      AND t.database_id = db.id
  INTO users_table;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  vcurrent_role = inflection_db.get_identifier_name(vcurrent_role);

  PERFORM db_migrate.migrate('current_role', 
      db.id::text,

      public_schema,
      vcurrent_role,

      current_role_id,
    
      collections_private.get_schema_name_by_table_id(users_table_id),
      users_table
  );

  PERFORM db_migrate.migrate('grant_execute_on_function', 
    db.id::text,

    public_schema,
    vcurrent_role,

    'authenticated' -- just like the other RLS functions
  );

  -- TODO AUTOMATE SERVICES
  -- UPDATE services_public.services s
  --   SET auth = ARRAY[
  --     private_schema,
  --     authenticate
  --   ]
  --   WHERE s.database_id = rls_module.database_id
  --   AND s.is_public = TRUE;

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (rls_module.module_id, 'authenticate', authenticate),
    
    -- TODO consider changing the name convention to public/private 
    -- since should really not do raw schema names here
    (rls_module.module_id, 'authenticate_schema', private_schema),
    (rls_module.module_id, 'role_schema', public_schema),
    (rls_module.module_id, 'current_role', vcurrent_role),
    (rls_module.module_id, 'current_role_id', current_role_id),
    (rls_module.module_id, 'current_group_ids', current_group_ids);

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.secrets_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;

  secrets_getter text;
  secrets_delete text;
  secrets_setter text;

  secrets_schema text;
  secrets_table text;
  secrets_field text;
  secrets_owned_field text;
  owned_table_id uuid;

  pk_id uuid;
  obj_key_id uuid;
  name_id uuid;

  schema_id uuid;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = secrets_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  secrets_field = modules_private.get_module_input(module_id, 'secrets_field');
  secrets_field = inflection_db.get_field_name(secrets_field);

  secrets_table = modules_private.get_module_input(module_id, 'secrets_table');
  secrets_owned_field = modules_private.get_module_input(module_id, 'secrets_owned_field');
  
  IF (secrets_owned_field IS NULL) THEN
    owned_table_id = modules_private.get_module_input(module_id, 'owned_table_id');
    SELECT inflection_db.get_foreign_key_field_name( name )
    FROM collections_public.table t 
      WHERE t.id = owned_table_id
        AND t.database_id = secrets_module.database_id
    INTO secrets_owned_field;
  ELSE
    secrets_owned_field = inflection_db.get_field_name(secrets_owned_field);
  END IF;

  INSERT INTO collections_public.schema
    (database_id, name) VALUES (db.id, 'simple_secrets')
  RETURNING id, schema_name INTO schema_id, secrets_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  -- secrets table
  INSERT INTO collections_public.table 
    (database_id, schema_id, name, is_system)
    VALUES (database_id, schema_id, secrets_table, true)
  RETURNING * INTO tb;

  -- pk_id
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'id', 'uuid', true, 'uuid_generate_v4 ()')
  RETURNING id INTO pk_id;

  -- obj_key_id
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required)
  VALUES 
    (tb.id, secrets_owned_field, 'uuid', true)
  RETURNING id INTO obj_key_id;

  -- name
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required)
  VALUES 
    (tb.id, 'name', 'text', true)
  RETURNING id INTO name_id;

  -- fields
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required)
  VALUES 
    (tb.id, secrets_field, 'text', false)
  ;

  -- constraint 
  INSERT INTO collections_public.primary_key_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[pk_id]);

  -- constraint
  INSERT INTO collections_public.unique_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[obj_key_id, name_id]);

  PERFORM db_migrate.migrate('basic_secrets_getter', 
    database_id::text,
    
    secrets_schema,
    'get',

    secrets_schema,
    tb.name,
    secrets_field,
    secrets_owned_field
  );

  PERFORM db_migrate.migrate('basic_secrets_upsert', 
    database_id::text,
    
    secrets_schema,
    'set',

    secrets_schema,
    tb.name,
    secrets_field,
    secrets_owned_field
  );

  PERFORM db_migrate.migrate('basic_secrets_delete', 
    database_id::text,
    
    secrets_schema,
    'del',

    secrets_schema,
    tb.name,
    secrets_owned_field
  );

  -- outputs 
  
  INSERT INTO modules_public.module_output
    (module_id, name, value)
  VALUES
    (secrets_module.module_id, 'table_id', tb.id),
    (secrets_module.module_id, 'secrets_schema', secrets_schema),
    (secrets_module.module_id, 'secrets_table', secrets_table),
    (secrets_module.module_id, 'secrets_field', secrets_field),
    (secrets_module.module_id, 'secrets_owned_field', secrets_owned_field);


END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.subdomain_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  subdomain text;
  is_public bool;
  schemas text[] = ARRAY[]::text[];
  anon_role text = 'anonymous';
  role_name text = 'authenticated';

  public_schema text;
  private_schema text;

BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = subdomain_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = subdomain_module.database_id
    AND s.name = 'private'
    INTO private_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = subdomain_module.database_id
    AND s.name = 'public'
    INTO public_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  -- TODO deprecate this in favor of schema-based approach

  subdomain = modules_private.get_module_input(module_id, 'subdomain');
  is_public = modules_private.get_module_input(module_id, 'is_public');

  IF (is_public) THEN
    schemas = array_append(schemas, public_schema);
  ELSE
    anon_role = 'administrator';
    role_name = 'administrator';
    schemas = array_append(schemas, public_schema);
    schemas = array_append(schemas, private_schema);
  END IF;

-- INSERT INTO services_public.services (
--     database_id,
--     is_public,
--     subdomain,
--     dbname,
--     role_name,
--     anon_role,
--     schemas
-- )
--     VALUES (
--         subdomain_module.database_id,
--         is_public,
--         subdomain,
--         current_database(),
--         role_name,
--         anon_role,
--         schemas
--       );
  -- returning * into serv;

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (subdomain_module.module_id, 'subdomain', subdomain),
    (subdomain_module.module_id, 'is_public', is_public)
    ;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.table_peoplestamps_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  updated_by_column text;
  created_by_column text;
  trigger_schema text;
  trigger_name text;
  table_name text;
  table_id uuid;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = table_peoplestamps_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  table_id = modules_private.get_module_input(module_id, 'table_id');
  trigger_schema = modules_private.get_module_input(module_id, 'trigger_schema');
  trigger_name = modules_private.get_module_input(module_id, 'trigger_name');
  updated_by_column = modules_private.get_module_input(module_id, 'created_by_column');
  created_by_column = modules_private.get_module_input(module_id, 'updated_by_column');

  SELECT name FROM collections_public.table
    WHERE id = table_id INTO table_name;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  PERFORM db_migrate.migrate('peoplestamps', 
    db.id::text,

    collections_private.get_schema_name_by_table_id(table_id),
    table_name,

    -- trigger_schema defaults to private
    trigger_schema,
    trigger_name,

    created_by_column,
    updated_by_column
  );

  -- INSERT INTO modules_public.module_output
  --   (module_id, name, value)
  --   VALUES
    
  --   (table_peoplestamps_module.module_id, 'table_name', table_name),
  --   (table_peoplestamps_module.module_id, 'table_schema', collections_private.get_schema_name_by_table_id(table_id)),
  --   (table_peoplestamps_module.module_id, 'trigger_name', trigger_name),
  --   (table_peoplestamps_module.module_id, 'updated_by_column', updated_by_column),
  --   (table_peoplestamps_module.module_id, 'created_by_column', created_by_column)
    
  --   ;


END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.table_timestamps_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  updated_at_column text;
  created_at_column text;
  trigger_schema text;
  trigger_name text;
  table_name text;
  table_id uuid;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = table_timestamps_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  table_id = modules_private.get_module_input(module_id, 'table_id');
  trigger_schema = modules_private.get_module_input(module_id, 'trigger_schema');
  trigger_name = modules_private.get_module_input(module_id, 'trigger_name');
  created_at_column = modules_private.get_module_input(module_id, 'created_at_column');
  updated_at_column = modules_private.get_module_input(module_id, 'updated_at_column');

  SELECT name FROM collections_public.table
    WHERE id = table_id INTO table_name;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  PERFORM db_migrate.migrate('timestamps', 
    db.id::text,

    collections_private.get_schema_name_by_table_id(table_id),
    table_name,

    -- trigger_schema defaults to private
    trigger_schema,
    trigger_name,

    created_at_column,
    updated_at_column
  );

  -- INSERT INTO modules_public.module_output
  --   (module_id, name, value)
  --   VALUES
    
  --   (table_timestamps_module.module_id, 'table_name', table_name),
  --   (table_timestamps_module.module_id, 'table_schema', collections_private.get_schema_name_by_table_id(table_id)),
  --   (table_timestamps_module.module_id, 'trigger_name', trigger_name),
  --   (table_timestamps_module.module_id, 'updated_at_column', updated_at_column),
  --   (table_timestamps_module.module_id, 'created_at_column', created_at_column)
    
  --   ;


END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.timestamps_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  updated_at_column text;
  created_at_column text;
  trigger_name text;
  private_schema text;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = timestamps_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = timestamps_module.database_id
    AND s.name = 'private'
    INTO private_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  trigger_name = modules_private.get_module_input(module_id, 'trigger_name');
  created_at_column = modules_private.get_module_input(module_id, 'created_at_column');
  updated_at_column = modules_private.get_module_input(module_id, 'updated_at_column');

  PERFORM db_migrate.migrate('timestamps_trigger', 
    db.id::text,

    -- trigger_schema defaults to private
    private_schema,
    trigger_name,

    created_at_column,
    updated_at_column
  );

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    
    (timestamps_module.module_id, 'trigger_schema', private_schema),
    (timestamps_module.module_id, 'updated_at_column', updated_at_column),
    (timestamps_module.module_id, 'created_at_column', created_at_column),
    (timestamps_module.module_id, 'trigger_name', trigger_name)
    
    ;


END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.tokens_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;
  
  tokens_table text;
  tokens_default_expiration interval;
  owned_table_id uuid;

  pk_id uuid;
  at_id uuid;
  ob_id uuid;

  schema_id uuid;

BEGIN
  SELECT * FROM collections_public.database 
    WHERE id = database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;
  
  tokens_table = modules_private.get_module_input(module_id, 'tokens_table');
  tokens_default_expiration = modules_private.get_module_input(module_id, 'tokens_default_expiration');

  SELECT id FROM collections_public.schema s
    WHERE s.database_id = tokens_module.database_id
    AND s.name = 'private'
    INTO schema_id;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;


  -- BEGIN

  -- tokens table
  INSERT INTO collections_public.table 
    (database_id, schema_id, name, is_system)
    VALUES (database_id, schema_id, tokens_table, true)
  RETURNING * INTO tb;

  -- pk_id
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'id', 'uuid', true, 'uuid_generate_v4 ()')
  RETURNING id INTO pk_id;

  -- ob_id
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required)
  VALUES 
    (tb.id, 'user_id', 'uuid', true)
  RETURNING id INTO ob_id;

  -- access_token
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'access_token', 'text', true, 'encode( gen_random_bytes( 48 ), ''hex'' )')
  RETURNING id INTO at_id;

  -- access_token_expires_at
  INSERT INTO collections_public.field 
    (table_id, name, type, is_required, default_value)
  VALUES 
    (tb.id, 'access_token_expires_at', 'timestamptz', true, format('(NOW() + interval ''%s'')', tokens_default_expiration));

  -- p constraint 
  INSERT INTO collections_public.primary_key_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[pk_id]);

  -- u constraint
  INSERT INTO collections_public.unique_constraint
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[at_id]);

  -- index on owned_field
  INSERT INTO collections_public.index
    (table_id, field_ids)
  VALUES (tb.id, ARRAY[ob_id]);

  -- outputs

  INSERT INTO modules_public.module_output
    (module_id, name, value)
  VALUES
  (tokens_module.module_id, 'table_id', tb.id);


END;
$EOFCODE$ LANGUAGE plpgsql;

CREATE FUNCTION modules_private.user_auth_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;

  sign_in_function text;
  sign_up_function text;
  set_password_function text;
  reset_password_function text;
  forgot_password_function text;
  send_verification_email_function text;
  verify_email_function text;
  
  role_schema text;
  current_role_id text;

  jobs_schema text;

  secrets_schema text;
  secrets_table text;
  secrets_table_id uuid;
  secrets_value_field text;
  secrets_owned_field text;

  emails_schema text;
  emails_table text;
  emails_table_id uuid;
  emails_owned_field text;
  
  users_schema text;
  users_table text;
  users_table_id uuid;

  tokens_schema text;
  tokens_table text;
  tokens_table_id uuid;

  encrypted_secrets_schema text;
  encrypted_secrets_table text;
  encrypted_secrets_owned_field text;
  encrypted_upsert_schema text;
  encrypted_upsert_fn text;
  encrypted_verify_fn text;

  public_schema text;

BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = user_auth_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = user_auth_module.database_id
    AND s.name = 'public'
    INTO public_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  sign_in_function = modules_private.get_module_input(module_id, 'sign_in_function');
  sign_up_function = modules_private.get_module_input(module_id, 'sign_up_function');
  set_password_function = modules_private.get_module_input(module_id, 'set_password_function');
  reset_password_function = modules_private.get_module_input(module_id, 'reset_password_function');
  forgot_password_function = modules_private.get_module_input(module_id, 'forgot_password_function');
  send_verification_email_function = modules_private.get_module_input(module_id, 'send_verification_email_function');
  verify_email_function = modules_private.get_module_input(module_id, 'verify_email_function');
  
  role_schema = modules_private.get_module_input(module_id, 'role_schema');
  current_role_id = modules_private.get_module_input(module_id, 'current_role_id');
  
  secrets_table_id = modules_private.get_module_input(module_id, 'secrets_table_id');
  secrets_value_field = modules_private.get_module_input(module_id, 'secrets_value_field');
  secrets_owned_field = modules_private.get_module_input(module_id, 'secrets_owned_field');

  users_table_id = modules_private.get_module_input(module_id, 'users_table_id');
  
  jobs_schema = modules_private.get_module_input(module_id, 'jobs_schema');

  emails_table_id = modules_private.get_module_input(module_id, 'emails_table_id');
  emails_owned_field = modules_private.get_module_input(module_id, 'emails_owned_field');

  tokens_table_id = modules_private.get_module_input(module_id, 'tokens_table_id');
  
  encrypted_upsert_schema = modules_private.get_module_input(module_id, 'encrypted_upsert_schema');
  encrypted_upsert_fn = modules_private.get_module_input(module_id, 'encrypted_upsert_fn');

  encrypted_secrets_schema = modules_private.get_module_input(module_id, 'encrypted_schema');
  encrypted_secrets_table = modules_private.get_module_input(module_id, 'encrypted_secrets_table');
  encrypted_secrets_owned_field = modules_private.get_module_input(module_id, 'encrypted_secrets_owned_field');
  encrypted_verify_fn = modules_private.get_module_input(module_id, 'encrypted_verify_fn');

  SELECT name FROM collections_public.table t 
    WHERE t.id = emails_table_id
      AND t.database_id = user_auth_module.database_id
  INTO emails_table;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT name FROM collections_public.table t 
    WHERE t.id = tokens_table_id
      AND t.database_id = user_auth_module.database_id
  INTO tokens_table;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT name FROM collections_public.table t 
    WHERE t.id = secrets_table_id
      AND t.database_id = user_auth_module.database_id
  INTO secrets_table;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT name FROM collections_public.table t 
    WHERE t.id = users_table_id
      AND t.database_id = user_auth_module.database_id
  INTO users_table;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  tokens_schema = collections_private.get_schema_name_by_table_id(tokens_table_id);
  emails_schema = collections_private.get_schema_name_by_table_id(emails_table_id);
  secrets_schema = collections_private.get_schema_name_by_table_id(secrets_table_id);
  users_schema = collections_private.get_schema_name_by_table_id(users_table_id);

  PERFORM db_migrate.migrate('sign_in', 
    db.id::text,
    
    public_schema,
    sign_in_function,

    tokens_schema,
    tokens_table,

    emails_schema,
    emails_table,
    emails_owned_field,

    secrets_schema,
    secrets_table,
    secrets_value_field,
    secrets_owned_field,

    encrypted_secrets_schema,
    encrypted_verify_fn
  );

  PERFORM db_migrate.migrate('sign_up', 
    db.id::text,
    
    public_schema,
    sign_up_function,

    tokens_schema,
    tokens_table,

    emails_schema,
    emails_table,
    emails_owned_field,

    users_schema,
    users_table,

    encrypted_upsert_schema,
    encrypted_upsert_fn
  );

  PERFORM db_migrate.migrate('set_password', 
    db.id::text,
    
    public_schema,
    set_password_function,

    users_schema,
    users_table,
    
    role_schema,
    current_role_id,

    secrets_schema,
    secrets_table,
    secrets_owned_field,

    encrypted_secrets_schema,
    encrypted_secrets_table,
    encrypted_secrets_owned_field,

    encrypted_upsert_schema,
    encrypted_upsert_fn
  );

  PERFORM db_migrate.migrate('reset_password', 
    db.id::text,
    
    public_schema,
    reset_password_function,

    users_schema,
    users_table,
    
    secrets_schema,

    encrypted_secrets_schema,
    encrypted_secrets_table,
    encrypted_secrets_owned_field,
    encrypted_verify_fn,

    encrypted_upsert_schema,
    encrypted_upsert_fn
  );

  PERFORM db_migrate.migrate('forgot_password', 
    db.id::text,
    
    public_schema,
    forgot_password_function,

    users_schema,
    users_table,
    
    emails_schema,
    emails_table,
    emails_owned_field,

    secrets_schema,

    encrypted_upsert_schema,
    encrypted_upsert_fn,

    jobs_schema
  );

  PERFORM db_migrate.migrate('send_verification_email', 
    db.id::text,
    
    public_schema,
    send_verification_email_function,

    emails_schema,
    emails_table,
    emails_owned_field,

    secrets_schema,
    encrypted_secrets_schema,

    jobs_schema
  );

  PERFORM db_migrate.migrate('verify_email', 
    db.id::text,
    
    public_schema,
    verify_email_function,

    emails_schema,
    emails_table,
    emails_owned_field,

    secrets_schema,
    encrypted_secrets_schema
  );

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (user_auth_module.module_id, 'auth_schema', public_schema),
    (user_auth_module.module_id, 'set_password_function', set_password_function),
    (user_auth_module.module_id, 'reset_password_function', reset_password_function),
    (user_auth_module.module_id, 'forgot_password_function', forgot_password_function),
    (user_auth_module.module_id, 'sign_in_function', sign_in_function),
    (user_auth_module.module_id, 'sign_up_function', sign_up_function)
  ;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.user_status_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;

  users_table_id uuid;
  users_table text;

  users_schema text;

  public_schema text;
  private_schema text;

  updated_at_column text;
  created_at_column text;
  trigger_schema text;
  trigger_name text;

  role_schema text;
  current_role_id text;

BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = user_status_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = user_status_module.database_id
    AND s.name = 'public'
    INTO public_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = user_status_module.database_id
    AND s.name = 'private'
    INTO private_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  users_table_id = modules_private.get_module_input(module_id, 'users_table_id');
  users_schema = collections_private.get_schema_name_by_table_id(users_table_id);
  trigger_schema = modules_private.get_module_input(module_id, 'trigger_schema');
  trigger_name = modules_private.get_module_input(module_id, 'trigger_name');
  created_at_column = modules_private.get_module_input(module_id, 'created_at_column');
  updated_at_column = modules_private.get_module_input(module_id, 'updated_at_column');
  
  role_schema = modules_private.get_module_input(module_id, 'role_schema');
  current_role_id = modules_private.get_module_input(module_id, 'current_role_id');

  SELECT name FROM collections_public.table t 
    WHERE t.id = users_table_id
      AND t.database_id = user_status_module.database_id
  INTO users_table;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  PERFORM db_migrate.migrate('user_status', 
    db.id::text,
    
    public_schema,
    private_schema,

    users_schema,
    users_table,

    role_schema,
    current_role_id
  );

  PERFORM db_migrate.migrate('timestamps', 
    db.id::text,
    
    public_schema,
    'user_task_achievement',

    trigger_schema,
    trigger_name,

    created_at_column,
    updated_at_column
  );


  -- INSERT INTO modules_public.module_output
  --   (module_id, name, value)
  --   VALUES
  --   (user_status_module.module_id, 'public_schema', public_schema),
  --   (user_status_module.module_id, 'auth_schema', public_schema)
  -- ;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.users_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;
  tb collections_public.table;

  pk_id uuid;

  table_name text;
  table_id uuid;
  schema_id uuid;
BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  table_name = modules_private.get_module_input(module_id, 'table_name');
  table_id = modules_private.get_module_input(module_id, 'table_id');

  SELECT id FROM collections_public.schema s
    WHERE s.database_id = users_module.database_id
    AND s.name = 'public'
    INTO schema_id;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  -- GET ARGS

  IF (table_id IS NOT NULL) THEN
    
    -- SET OUTPUT
    INSERT INTO modules_public.module_output
      (module_id, name, value)
    VALUES (users_module.module_id, 'table_id', table_id);

  ELSIF (table_name IS NOT NULL) THEN

    -- users table
    INSERT INTO collections_public.table 
      (database_id, schema_id, name, is_system)
      VALUES (database_id, schema_id, table_name, true)
    RETURNING * INTO tb;

    -- SET OUTPUT
    INSERT INTO modules_public.module_output
      (module_id, name, value)
    VALUES (users_module.module_id, 'table_id', tb.id);

    -- pk_id
    INSERT INTO collections_public.field 
      (table_id, name, type, is_required, default_value)
    VALUES 
      (tb.id, 'id', 'uuid', true, 'uuid_generate_v4 ()')
    RETURNING id INTO pk_id;

    -- p constraint 
    INSERT INTO collections_public.primary_key_constraint
      (table_id, field_ids)
    VALUES (tb.id, ARRAY[pk_id]);

  ELSE 
    RAISE EXCEPTION 'BAD_MODULE_INPUT';
  END IF;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.uuid_module ( module_id uuid, database_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  db collections_public.database;

  seeded_uuid_function text;
  seeded_uuid_function_with_args text;
  seeded_uuid_related_trigger text;
  seeded_uuid_seed text;

  private_schema text;

BEGIN

  SELECT * FROM collections_public.database 
    WHERE id = uuid_module.database_id INTO db;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  SELECT s.schema_name FROM collections_public.schema s
    WHERE s.database_id = uuid_module.database_id
    AND s.name = 'private'
    INTO private_schema;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_FOUND';
  END IF;

  seeded_uuid_function = modules_private.get_module_input(module_id, 'seeded_uuid_function');
  seeded_uuid_function_with_args = modules_private.get_module_input(module_id, 'seeded_uuid_function_with_args');
  seeded_uuid_related_trigger = modules_private.get_module_input(module_id, 'seeded_uuid_related_trigger');
  seeded_uuid_seed = modules_private.get_module_input(module_id, 'seeded_uuid_seed');

  -- maybe? this could be public? to create IDs?
  PERFORM db_migrate.migrate('create_seeded_uuid_function', 
    db.id::text,
    private_schema,
    seeded_uuid_function,
    coalesce(seeded_uuid_seed, db.id::text)
  );

  PERFORM db_migrate.migrate('create_seeded_uuid_function_with_args', 
    db.id::text,
    private_schema,
    seeded_uuid_function_with_args
  );

  PERFORM db_migrate.migrate('create_seeded_uuid_related_trigger', 
    db.id::text,
    private_schema,
    seeded_uuid_related_trigger,

    private_schema,
    seeded_uuid_function_with_args
  );

  -- GRANTS

  PERFORM db_migrate.migrate('grant_execute_on_function', 
    db.id::text,
    private_schema,
    seeded_uuid_function,
    'public'
  );

  PERFORM db_migrate.migrate('grant_execute_on_function', 
    db.id::text,
    private_schema,
    seeded_uuid_function_with_args,
    'public'
  );

  PERFORM db_migrate.migrate('grant_execute_on_function', 
    db.id::text,
    private_schema,
    seeded_uuid_related_trigger,
    'public'
  );

  INSERT INTO modules_public.module_output
    (module_id, name, value)
    VALUES
    (uuid_module.module_id, 'uuid_schema', private_schema),
    (uuid_module.module_id, 'seeded_uuid_function', seeded_uuid_function),
    (uuid_module.module_id, 'seeded_uuid_function_with_args', seeded_uuid_function_with_args),
    (uuid_module.module_id, 'seeded_uuid_related_trigger', seeded_uuid_related_trigger)
    ;


END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.ensure_deps_for_module ( database_id uuid, module_defn_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
    mod_def modules_public.module_definitions;
    result record;
BEGIN
    SELECT * FROM modules_public.module_definitions moddefns
        WHERE
        moddefns.id = ensure_deps_for_module.module_defn_id
    INTO mod_def;

    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'NOT_FOUND';
    END IF;


    FOR result IN
    SELECT * FROM modules_private.get_all_module_deps(module_defn_id)
    LOOP

      IF (result.id != ensure_deps_for_module.module_defn_id) THEN
        IF NOT EXISTS(SELECT * FROM modules_public.modules modls
        WHERE 
          modls.database_id = ensure_deps_for_module.database_id
          AND modls.module_defn_id = result.id) THEN
          RAISE EXCEPTION 'MISSING_REQUIRED_MODULE: %', result.name;
      END IF;
      END IF;

    END LOOP;

END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION modules_private.generate_module_call_exp ( module_id uuid, database_id uuid, module_defn_id uuid ) RETURNS text AS $EOFCODE$
DECLARE
    mod_def modules_public.module_definitions;
    mod_field modules_public.module_field;
    mod_input modules_public.module_input;
    tresult text;
    cur_name text;
    cur_type text;

    sql text;
    fn_schema text;
    fn_name text;
    values text[];

BEGIN
    SELECT * FROM modules_public.module_definitions mds
        WHERE
        mds.id = generate_module_call_exp.module_defn_id AND
        mds.context = 'sql'
    INTO mod_def;

    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'NOT_FOUND';
    END IF;

    fn_schema = mod_def.exec->>'schema';
    fn_name = mod_def.exec->>'function';

    IF (fn_schema IS NULL OR fn_schema IS NULL) THEN
        RAISE EXCEPTION 'EXEC_NOT_FOUND';
    END IF;

    sql = 'SELECT ';
    sql = format(sql || '%1$I.%2$I', fn_schema, fn_name);
    sql = sql || '(';

    values = ARRAY[
        format('''%s''::uuid', generate_module_call_exp.module_id),
        format('''%s''::uuid', generate_module_call_exp.database_id)
    ];

    FOR mod_field IN
    SELECT * FROM modules_public.module_field mf
      WHERE mf.module_defn_id = generate_module_call_exp.module_defn_id
    LOOP
        cur_name = mod_field.name;
        cur_type = mod_field.type;

        SELECT * FROM modules_public.module_input mi
            WHERE mi.module_id = generate_module_call_exp.module_id
            AND mi.name = cur_type INTO mod_input;

        -- IF (NOT FOUND) THEN
        --     IF (mod_field.is_required) THEN
        --         RAISE EXCEPTION 'FIELD_NOT_FOUND %', cur_name;
        --     END IF;
        -- END IF;

        -- IF (generate_module_call_exp.data->cur_name IS NOT NULL) THEN
        --     values = array_cat(values, ARRAY[format('''%s''::%s', generate_module_call_exp.data->>cur_name, cur_type)]);
        -- ELSIF (mod_field.is_required) THEN
        --     RAISE EXCEPTION 'FIELD_NOT_FOUND %', cur_name;
        -- ELSE
        --     values = array_cat(values, ARRAY['NULL']);
        -- END IF;
    END LOOP;

    sql = sql || array_to_string(values, ',');
    sql = sql || ');';

    return sql;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.exec_module ( module_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  mod modules_public.modules;  
  sql text;
BEGIN
    SELECT * FROM modules_public.modules m
      WHERE m.id = exec_module.module_id
    INTO mod;

    IF (NOT FOUND) THEN
      RAISE EXCEPTION 'NOT_FOUND';
    END IF;

    IF (mod.executed) THEN
      RAISE EXCEPTION 'ALREADY_EXECUTED';
    END IF;

    IF (mod.context = 'sql') THEN
        SELECT modules_private.generate_module_call_exp
            (mod.id, mod.database_id, mod.module_defn_id)
        INTO sql;

        EXECUTE sql;
  
        UPDATE modules_public.modules m
        SET executed = TRUE
        WHERE m.id = exec_module.module_id;

    ELSE
        -- TODO insert a job here
    END IF;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_private.get_all_module_deps ( id uuid ) RETURNS SETOF modules_public.module_definitions AS $EOFCODE$
WITH RECURSIVE hierarchy AS (
  SELECT 
    *
  FROM modules_public.module_definitions v_base
  WHERE v_base.id = get_all_module_deps.id
  UNION
  SELECT 
    v_obj.*
  FROM
    modules_public.module_definitions AS v_obj 
  JOIN hierarchy h ON (v_obj.id = ANY(h.mods))
) SELECT * 
FROM hierarchy;
$EOFCODE$ LANGUAGE sql STABLE;

CREATE FUNCTION modules_private.write_module_output ( module_id uuid, name text, value text ) RETURNS void AS $EOFCODE$
  INSERT INTO modules_public.module_output
    (module_id, name, value)
  VALUES (write_module_output.module_id, write_module_output.name, write_module_output.value);
$EOFCODE$ LANGUAGE sql VOLATILE;

CREATE FUNCTION modules_public.install_module ( database_id uuid, module_defn_id uuid, context text, data json DEFAULT '{}'::json ) RETURNS modules_public.modules AS $EOFCODE$
DECLARE
  modl modules_public.modules;
  mdfn modules_public.module_definitions;
  key text;
  -- TODO make module install seq
  seqval text = to_char(nextval('db_deps.seq'), 'fm0000000000');
BEGIN

  INSERT INTO modules_public.modules
    (database_id, module_defn_id, context)
  VALUES (
    install_module.database_id,
    install_module.module_defn_id,
    install_module.context)
  RETURNING * INTO modl;

  SELECT * FROM modules_public.module_definitions md
    WHERE md.id = install_module.module_defn_id
  INTO mdfn;

  FOR key IN SELECT json_object_keys(data)
  LOOP
    INSERT INTO modules_public.module_input (module_id, name, value)
    VALUES (modl.id, key, data->>key);
  END LOOP;

  INSERT INTO db_migrate.sql_actions (name, database_id, deploy, payload)
    VALUES (
      mdfn.name,
      install_module.database_id,
      concat('modules/', inflection_db.get_field_name(mdfn.name), '/mod', seqval, '/install'),
      data
    );

  PERFORM modules_private.exec_module(modl.id);

  INSERT INTO db_migrate.sql_actions (name, database_id, deploy, payload)
    VALUES (
      mdfn.name,
      install_module.database_id,
      concat('modules/', inflection_db.get_field_name(mdfn.name), '/mod', seqval, '/complete'),
      data
    );

  RETURN modl;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION modules_public.install_module_by_name ( database_id uuid, module_defn text, context text, data json DEFAULT '{}'::json ) RETURNS modules_public.modules AS $EOFCODE$
  SELECT
    *
  FROM
    modules_public.install_module (database_id, (
        SELECT
          id FROM modules_public.module_definitions md
        WHERE
          md.name = install_module_by_name.module_defn
          AND md.context = install_module_by_name.context), context, data);
$EOFCODE$ LANGUAGE sql VOLATILE;

CREATE FUNCTION modules_private.tg_before_insert_set_order (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  NEW.field_order = 
    (SELECT count(1) FROM modules_public.module_field mf
        WHERE mf.module_defn_id = NEW.module_defn_id);
 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_insert_set_order 
 BEFORE INSERT ON modules_public.module_field 
 FOR EACH ROW
 EXECUTE PROCEDURE modules_private. tg_before_insert_set_order (  );

CREATE FUNCTION modules_private.tg_before_insert_module (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    mod_def modules_public.module_definitions;
BEGIN
    SELECT * FROM modules_public.module_definitions mds
        WHERE
        mds.id = NEW.module_defn_id AND
        mds.context = NEW.context
    INTO mod_def;

    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'NOT_FOUND';
    END IF;

    PERFORM modules_private.ensure_deps_for_module(
        NEW.database_id,
        NEW.module_defn_id
    );

    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_insert_module 
 BEFORE INSERT ON modules_public.modules 
 FOR EACH ROW
 EXECUTE PROCEDURE modules_private. tg_before_insert_module (  );