-- Deploy schemas/ast_helpers/procedures/verify to pg

-- requires: schemas/ast_helpers/schema

BEGIN;

CREATE FUNCTION ast_helpers.verify (
  VARIADIC text[]
)
    RETURNS jsonb
    AS $$
DECLARE
  i int;
  fnname text;
  arguments jsonb[];
  ast jsonb;
BEGIN
 
  FOR i IN 
  SELECT * FROM generate_series(1, cardinality($1))
  LOOP 
    IF (i = 1) THEN
        fnname = $1[i];
    ELSE
        arguments = array_append(arguments,
                  ast.a_const(
                    v_val := ast.string(
                      $1[i]
                    )
                  )
                );
    END IF;

  END LOOP;

  select ast.raw_stmt(
    v_stmt := ast.select_stmt(
      v_targetList := to_jsonb(ARRAY[
        ast.res_target(
          v_val := ast.func_call(
            v_funcname := to_jsonb(ARRAY[
              ast.string(fnname)
            ]),
            v_args := to_jsonb(arguments)
          )
        )
      ]),
      v_op := 0
    ),
    v_stmt_len := 1
  ) INTO ast;

  RETURN ast;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_schema (
  v_schema_name text
)
    RETURNS jsonb
    AS $$
  select ast_helpers.verify(
    'verify_schema',
    v_schema_name
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_table (
  v_schema_name text,
  v_table_name text
)
    RETURNS jsonb
    AS $$
  select ast_helpers.verify(
    'verify_table',
    v_schema_name || '.' || v_table_name
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_table_grant (
  v_schema_name text,
  v_table_name text,
  v_priv_name text,
  v_role_name text
)
    RETURNS jsonb
    AS $$
  select ast_helpers.verify(
    'verify_table_grant',
    v_schema_name || '.' || v_table_name,
    v_priv_name,
    v_role_name
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_index (
  v_schema_name text,
  v_table_name text,
  v_index_name text
)
    RETURNS jsonb
    AS $$
  select ast_helpers.verify(
    'verify_index',
    v_schema_name || '.' || v_table_name,
    v_index_name
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_policy (
  v_policy_name text,
  v_schema_name text,
  v_table_name text
)
    RETURNS jsonb
    AS $$
  select ast_helpers.verify(
    'verify_policy',
    v_policy_name,
    v_schema_name || '.' || v_table_name
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_security (
  v_schema_name text,
  v_table_name text
)
    RETURNS jsonb
    AS $$
  select ast_helpers.verify(
    'verify_security',
    v_schema_name || '.' || v_table_name
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_function (
  v_schema_name text,
  v_function_name text,
  v_role_name text default null
)
    RETURNS jsonb
    AS $$
  select (CASE
   WHEN v_role_name IS NULL THEN
    ast_helpers.verify(
      'verify_function',
      v_schema_name || '.' || v_function_name
    )
   ELSE 
    ast_helpers.verify(
      'verify_function',
      v_schema_name || '.' || v_function_name,
      v_role_name
    )
  END);
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_trigger (
  v_schema_name text,
  v_trigger_name text
)
    RETURNS jsonb
    AS $$
  select ast_helpers.verify(
    'verify_trigger',
    v_schema_name || '.' || v_trigger_name
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_type (
  v_schema_name text,
  v_type_name text
)
    RETURNS jsonb
    AS $$
  select ast_helpers.verify(
    'verify_type',
    v_schema_name || '.' || v_type_name
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_domain (
  v_schema_name text,
  v_type_name text
)
    RETURNS jsonb
    AS $$
  select ast_helpers.verify(
    'verify_domain',
    v_schema_name || '.' || v_type_name
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_extension (
  v_extname text
)
    RETURNS jsonb
    AS $$
  select ast_helpers.verify(
    'verify_extension',
    v_extname
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_view (
  v_schema_name text,
  v_view_name text
)
    RETURNS jsonb
    AS $$
  select ast_helpers.verify(
    'verify_view',
    v_schema_name || '.' || v_view_name
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

COMMIT;
