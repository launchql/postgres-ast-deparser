-- Deploy schemas/ast_helpers/procedures/helpers to pg

-- requires: schemas/ast_helpers/schema
-- requires: schemas/ast/procedures/types 
-- requires: schemas/ast_helpers/procedures/smart_comments 


BEGIN;

CREATE FUNCTION ast_helpers.eq (
  v_lexpr jsonb,
  v_rexpr jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 'AEXPR_OP',
      v_name := to_jsonb(ARRAY[
          ast.string('=')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := v_rexpr
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.neq (
  v_lexpr jsonb,
  v_rexpr jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 'AEXPR_OP',
      v_name := to_jsonb(ARRAY[
          ast.string('<>')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := v_rexpr
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.gt (
  v_lexpr jsonb,
  v_rexpr jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 'AEXPR_OP',
      v_name := to_jsonb(ARRAY[
          ast.string('>')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := v_rexpr
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.lt (
  v_lexpr jsonb,
  v_rexpr jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 'AEXPR_OP',
      v_name := to_jsonb(ARRAY[
          ast.string('<')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := v_rexpr
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.gte (
  v_lexpr jsonb,
  v_rexpr jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 'AEXPR_OP',
      v_name := to_jsonb(ARRAY[
          ast.string('>=')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := v_rexpr
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.lte (
  v_lexpr jsonb,
  v_rexpr jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 'AEXPR_OP',
      v_name := to_jsonb(ARRAY[
          ast.string('<=')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := v_rexpr
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.any (
  v_lexpr jsonb,
  v_rexpr jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 'AEXPR_OP_ANY',
      v_name := to_jsonb(ARRAY[
          ast.string('=')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := v_rexpr
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.and (
  variadic nodes jsonb[]
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.bool_expr(
      v_boolop := 'AND_EXPR',
      v_args := to_jsonb($1)
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.or (
  variadic nodes jsonb[]
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.bool_expr(
      v_boolop := 'OR_EXPR',
      v_args := to_jsonb($1)
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.is_true (
  v_arg jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.boolean_test(
    v_booltesttype := 'IS_TRUE',
    v_arg := v_arg
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.is_false (
  v_arg jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.boolean_test(
    v_booltesttype := 'IS_FALSE',
    v_arg := v_arg
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.matches (
  v_lexpr jsonb,
  v_regexp text
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 'AEXPR_OP',
      v_name := to_jsonb(ARRAY[
          ast.string('~*')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := ast.a_const(
          v_val := ast.string(v_regexp)
      )
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.array_of_strings (
  variadic strs text[]
)
    RETURNS jsonb
    AS $$
DECLARE
  nodes jsonb[];
  i int;
BEGIN
  FOR i IN
  SELECT * FROM generate_series(1, cardinality(strs))
  LOOP 
    nodes = array_append(nodes, ast.string(strs[i]));
  END LOOP;

  RETURN to_jsonb(nodes);
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.range_var (
  v_schemaname text,
  v_relname text,
  v_alias jsonb default null
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.range_var(
      v_schemaname := v_schemaname,
      v_relname := v_relname,
      v_inh := true,
      v_relpersistence := 'p',
      v_alias := v_alias
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.col (
  name text
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.column_ref(
    v_fields := to_jsonb(ARRAY[
      ast.string(name)
    ])
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;


CREATE FUNCTION ast_helpers.col (
  variadic text[]
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
  flds jsonb[];
  i int;
BEGIN
  ast_expr = ast.column_ref(
    v_fields := ast_helpers.array_of_strings( variadic strs := $1 )
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

-- Helps so you NEVER use arguments when using RLS fns...
CREATE FUNCTION ast_helpers.rls_fn (
  v_rls_schema text,
  v_fn_name text
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.func_call(
      v_funcname := to_jsonb(ARRAY[
          ast.string(v_rls_schema),
          ast.string(v_fn_name)
      ])
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.coalesce (field text, value text default '')
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = ast.coalesce_expr(
      v_args := to_jsonb(ARRAY[ ast.string(''), ast.a_const(ast.string('')) ])
    );
BEGIN
	result = jsonb_set(result, '{CoalesceExpr, args, 0, String, str}', to_jsonb(field));
	result = jsonb_set(result, '{CoalesceExpr, args, 1, A_Const, String, str}', to_jsonb(value));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.coalesce (field jsonb, value text default '')
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = ast.coalesce_expr(
      v_args := to_jsonb(ARRAY[ ast.string(''), ast.a_const(ast.string('')) ])
    );
BEGIN
	result = jsonb_set(result, '{CoalesceExpr, args, 0}', field);
	result = jsonb_set(result, '{CoalesceExpr, args, 1, A_Const, String, str}', to_jsonb(value));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.tsvectorw (input jsonb, weight text='A')
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = ast.func_call(
      v_funcname := to_jsonb(ARRAY[ast.string('setweight')]),
      v_args := to_jsonb(ARRAY[input, ast.a_const(ast.string(weight))])
    );
BEGIN
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.tsvector (input jsonb)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = ast.func_call(
      v_funcname := to_jsonb(ARRAY[ast.string('to_tsvector')]),
      v_args := to_jsonb(ARRAY[input])
    );
BEGIN
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.simple_param (
  name text,
  type text
)
    RETURNS jsonb
    AS $$
BEGIN
	RETURN ast.function_parameter(
      v_name := name,
      v_argType := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string(type)])
      ),
      v_mode := 'FUNC_PARAM_IN'
    );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.simple_param (
  name text,
  type text,
  default_value text
)
    RETURNS jsonb
    AS $$
BEGIN
	RETURN ast.function_parameter(
      v_name := name,
      v_argType := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string(type)])
      ),
      v_mode := 'FUNC_PARAM_IN',
      v_defexpr := ast.string(default_value)
    );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.simple_param (
  name text,
  type text,
  default_value jsonb
)
    RETURNS jsonb
    AS $$
BEGIN
	RETURN ast.function_parameter(
      v_name := name,
      v_argType := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string(type)])
      ),
      v_mode := 'FUNC_PARAM_IN',
      v_defexpr := default_value
    );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.tsvector (lang text, input jsonb)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = ast.func_call(
      v_funcname := to_jsonb(ARRAY[ast.string('to_tsvector')]),
      v_args := to_jsonb(ARRAY[ast.a_const(ast.string(lang)), input])
    );
BEGIN
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.distinct (
  v_lexpr jsonb,
  v_rexpr jsonb
)
    RETURNS jsonb
    AS $$
BEGIN
	RETURN ast.a_expr(v_kind := 'AEXPR_DISTINCT', 
        v_lexpr := v_lexpr,
        v_name := to_jsonb(ARRAY[ast.string('=')]),
        v_rexpr := v_rexpr
    );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.a_expr_distinct_tg_field (field text)
    RETURNS jsonb
    AS $$
BEGIN
	RETURN ast_helpers.distinct(
    v_lexpr := ast_helpers.col('old', field),
    v_rexpr := ast_helpers.col('new', field)
  );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.tsvector_index (fields jsonb)
    RETURNS jsonb
    AS $$
DECLARE
  results jsonb[];
  result jsonb;
  r jsonb;
	i int;
BEGIN
  FOR r IN (select jsonb_array_elements(fields))
    LOOP
      -- TODO maybe we get pg_catalog on some machines from get_current_ts_config and don't need to add it?
      IF ( (r->'lang') IS NULL) THEN
        r = jsonb_set(r, '{lang}', to_jsonb(get_current_ts_config()) );
        -- r = jsonb_set(r, '{lang}', to_jsonb('pg_catalog' || '.' || get_current_ts_config()) );
      END IF;

     -- TODO handle simple/english
      IF ( r->'array' = to_jsonb(true)) THEN
        -- handle array
        results = array_append(results, ast_helpers.tsvectorw( ast_helpers.tsvector(r->>'lang',
          -- start the string
          ast_helpers.coalesce(ast.func_call(
            v_funcname := to_jsonb(ARRAY[ast.string('array_to_string')]),
            v_args := to_jsonb(ARRAY[
              -- type cast null to text[] array
              ast.type_cast(
                v_arg := ast.string(r->>'field'),
                v_typeName := ast.type_name( 
                    v_names := to_jsonb(ARRAY[ast.string(r->>'type')]),
                    v_arrayBounds := to_jsonb(ARRAY[ast.integer(-1)])
                )
              ),
              ast.a_const(ast.string(' '))]
            )
          ))
        -- end array to string function call here
      ) , r->>'weight') );
      ELSE
        IF ( (r->'lang') IS NOT NULL) THEN
          results = array_append(results, ast_helpers.tsvectorw( ast_helpers.tsvector(r->>'lang', ast_helpers.coalesce(r->>'field')) , r->>'weight') );
        ELSE
          -- get_current_ts_config() returns 'english', we'd need to add pg_catalog on there...
          results = array_append(results, ast_helpers.tsvectorw( ast_helpers.tsvector(ast_helpers.coalesce(r->>'field')) , r->>'weight') );
        END IF;
      END IF;
    END LOOP;

  -- create the expressions
  FOR i IN SELECT * FROM generate_subscripts(results, 1) g(i)
    LOOP
      IF (i = 1) THEN
        result = results[i];
      ELSE
        result = ast.a_expr(
          v_kind := 'AEXPR_OP',
          v_lexpr := results[i], 
          v_name := to_jsonb(ARRAY[ast.string('||')]),
          v_rexpr := result );
      END IF;
    END LOOP;

	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.create_trigger (
  v_trigger_name text,
  
  v_schema_name text,
  v_table_name text,

  v_trigger_fn_schema text,
  v_trigger_fn_name text,

  v_whenClause jsonb DEFAULT NULL,
  v_params text[] default ARRAY[]::text[],
  v_timing int default 2,
  v_events int default 4 | 16
)
    RETURNS jsonb
    AS $$
DECLARE
  result jsonb;
BEGIN
  result = ast.create_trig_stmt(
    v_trigname := v_trigger_name,
    v_relation := ast_helpers.range_var(
      v_schemaname := v_schema_name,
      v_relname := v_table_name
    ),
    v_funcname := ast_helpers.array_of_strings(v_trigger_fn_schema, v_trigger_fn_name),
    v_args := ast_helpers.array_of_strings( variadic strs := v_params ),
    v_row := true,
    v_timing := v_timing,
    v_events := v_events,
    v_whenClause := v_whenClause
  );
	RETURN ast.raw_stmt(
    v_stmt := result,
    v_stmt_len := 1
  );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.create_trigger_distinct_fields (
  v_trigger_name text,
  
  v_schema_name text,
  v_table_name text,

  v_trigger_fn_schema text,
  v_trigger_fn_name text,

  v_fields text[] default ARRAY[]::text[],
  v_params text[] default ARRAY[]::text[],
  v_timing int default 2,
  v_events int default 4 | 16
)
    RETURNS jsonb
    AS $$
DECLARE
  whenClause jsonb;
	i int;
  nodes jsonb[];
BEGIN

  FOR i IN SELECT * FROM generate_subscripts(v_fields, 1) g(i)
  LOOP
    -- OLD.field <> NEW.field
    nodes = array_append(nodes, ast_helpers.a_expr_distinct_tg_field(v_fields[i]));
  END LOOP;
 
  IF (cardinality(nodes) > 1) THEN
    whenClause = ast_helpers.or( variadic nodes := nodes );
  ELSEIF (cardinality(nodes) = 1) THEN
    whenClause = nodes[1];
  END IF;

  RETURN ast_helpers.create_trigger(
    v_trigger_name := v_trigger_name,
    
    v_schema_name := v_schema_name,
    v_table_name := v_table_name,

    v_trigger_fn_schema := v_trigger_fn_schema,
    v_trigger_fn_name := v_trigger_fn_name,

    v_whenClause := whenClause,
    v_params := v_params,
    v_timing := v_timing,
    v_events := v_events
  );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.drop_trigger (
  v_trigger_name text,

  v_schema_name text,
  v_table_name text,

  v_cascade boolean default false
)
    RETURNS jsonb
    AS $$
  select ast.raw_stmt(
    v_stmt := ast.drop_stmt(
      v_objects := to_jsonb(ARRAY[ARRAY[
        ast.string(v_schema_name),
        ast.string(v_table_name),
        ast.string(v_trigger_name)
      ]]),
      v_removeType := 'OBJECT_TRIGGER',
      v_behavior:= (CASE when v_cascade IS TRUE then 'DROP_CASCADE' else 'DROP_RESTRICT' END)
    ),
    v_stmt_len := 1
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.create_function (
  v_schema_name text,
  v_function_name text,
  v_type text,
  v_parameters jsonb,
  v_body text,
  v_language text,
  v_volatility text default null,
  v_security int default null
)
    RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
  options jsonb[];
BEGIN

  options = array_append(options, ast.def_elem(
    v_defname := 'as',
    v_arg := to_jsonb(ARRAY[ast.string(v_body)])
  ));
  
  options = array_append(options, ast.def_elem(
    v_defname := 'language',
    v_arg := ast.string(v_language)
  ));

  IF (v_volatility IS NOT NULL) THEN 
    options = array_append(options, ast.def_elem(
      v_defname := 'volatility',
      v_arg := ast.string(v_volatility)
    ));
  END IF;

  IF (v_security IS NOT NULL) THEN 
    options = array_append(options, ast.def_elem(
      v_defname := 'security',
      v_arg := ast.integer(v_security)
    ));
  END IF;

  ast = ast.create_function_stmt(
    v_funcname := ast_helpers.array_of_strings(v_schema_name, v_function_name),
    v_parameters := v_parameters,
    v_returnType := ast.type_name( 
        v_names := ast_helpers.array_of_strings(v_type)
    ),
    v_options := to_jsonb(options)
  );

  RETURN ast.raw_stmt(
    v_stmt := ast,
    v_stmt_len := 1
  );

END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.drop_function (
  v_schema_name text default null,
  v_function_name text default null
)
RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
BEGIN
  ast = ast.raw_stmt(
    v_stmt := ast.drop_stmt(
      v_objects := to_jsonb(ARRAY[ARRAY[
        ast.string(v_schema_name),
        ast.string(v_function_name)
      ]]),
      v_removeType := 'OBJECT_FUNCTION'
    ),
    v_stmt_len := 1
  );
  RETURN ast;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.create_policy (
  v_policy_name text default null,
  v_schema_name text default null,
  v_table_name text default null,
  v_roles text[] default null,
  v_qual jsonb default null,
  v_cmd_name text default null,
  v_with_check jsonb default null,
  v_permissive boolean default null

)
RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
  roles jsonb[];
  i int;
BEGIN

  IF (v_permissive IS NULL) THEN 
    -- Policies default to permissive
    v_permissive = TRUE;
  END IF;

  -- if there are no roles then use PUBLIC
  IF (v_roles IS NULL OR cardinality(v_roles) = 0) THEN 
      roles = array_append(roles, ast.role_spec(
        v_roletype := 'ROLESPEC_PUBLIC'
      ));
  ELSE
    FOR i IN 
    SELECT * FROM generate_series(1, cardinality(v_roles))
    LOOP
      roles = array_append(roles, ast.role_spec(
        v_roletype := 'ROLESPEC_CSTRING',
        v_rolename := v_roles[i]
      ));
    END LOOP;
  END IF;

  select * FROM ast.create_policy_stmt(
    v_policy_name := v_policy_name,
    v_table := ast_helpers.range_var(
      v_schemaname := v_schema_name,
      v_relname := v_table_name
    ),
    v_roles := to_jsonb(roles),
    v_qual := v_qual,
    v_cmd_name := v_cmd_name,
    v_with_check := v_with_check,
    v_permissive := v_permissive
  ) INTO ast;

  RETURN ast.raw_stmt(
    v_stmt := ast,
    v_stmt_len := 1
  );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_policy (
  v_policy_name text default null,
  v_schema_name text default null,
  v_table_name text default null,
  v_roles text[] default null,
  v_qual jsonb default null,
  v_with_check jsonb default null
)
RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
  roles jsonb[];
  i int;
BEGIN

  -- if there are no roles then use PUBLIC
  IF (v_roles IS NOT NULL OR cardinality(v_roles) > 0) THEN 
    FOR i IN 
    SELECT * FROM generate_series(1, cardinality(v_roles))
    LOOP
      roles = array_append(roles, ast.role_spec(
        v_roletype := 'ROLESPEC_CSTRING',
        v_rolename := v_roles[i]
      ));
    END LOOP;
  END IF;

  select * FROM ast.alter_policy_stmt(
    v_policy_name := v_policy_name,
    v_table := ast_helpers.range_var(
      v_schemaname := v_schema_name,
      v_relname := v_table_name
    ),
    v_roles := to_jsonb(roles),
    v_qual := v_qual,
    v_with_check := v_with_check
  ) INTO ast;

  RETURN ast.raw_stmt(
    v_stmt := ast,
    v_stmt_len := 1
  );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.drop_policy (
  v_policy_name text default null,
  v_schema_name text default null,
  v_table_name text default null
)
RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
BEGIN
  ast = ast.raw_stmt(
    v_stmt := ast.drop_stmt(
      v_objects := to_jsonb(ARRAY[ARRAY[
        ast.string(v_schema_name),
        ast.string(v_table_name),
        ast.string(v_policy_name)
      ]]),
      v_removeType := 'OBJECT_POLICY'
    ),
    v_stmt_len := 1
  );
  RETURN ast;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.create_table (
  v_schema_name text,
  v_table_name text
)
    RETURNS jsonb
    AS $$
  select ast.raw_stmt(
    v_stmt := ast.create_stmt(
      v_relation := ast.range_var(
        v_schemaname:= v_schema_name,
        v_relname:= v_table_name,
        v_inh := TRUE,
        v_relpersistence := 'p'
      ),
      v_oncommit := 'ONCOMMIT_NOOP'
    ),
    v_stmt_len := 1
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.drop_table (
  v_schema_name text,
  v_table_name text,
  v_cascade boolean default false
)
    RETURNS jsonb
    AS $$
  select ast.raw_stmt(
    v_stmt := ast.drop_stmt(
      v_objects := to_jsonb(ARRAY[ARRAY[
        ast.string(v_schema_name),
        ast.string(v_table_name)
      ]]),
      v_removeType := 'OBJECT_TABLE',
      v_behavior:= (CASE when v_cascade IS TRUE then 'DROP_CASCADE' else 'DROP_RESTRICT' END)
    ),
    v_stmt_len := 1
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.create_index (
  v_index_name text,
  v_schema_name text,
  v_table_name text,
  v_fields text[],
  v_include_fields text[] default ARRAY[]::text[],
  v_accessMethod text default null,
  v_unique boolean default null
)
    RETURNS jsonb
    AS $$
DECLARE
  parameters jsonb[] = ARRAY[]::jsonb[];
  includingParameters jsonb[] = ARRAY[]::jsonb[];

  item text;
  i int;

  ast jsonb;
BEGIN
  FOR i IN
    SELECT * FROM generate_series(1, cardinality(v_fields)) g (i)
  LOOP
    parameters = array_append(parameters, ast.index_elem(
      v_name := v_fields[i],
      v_ordering := 'SORTBY_DEFAULT',
      v_nulls_ordering := 'SORTBY_NULLS_DEFAULT'
    ));
  END LOOP;

  FOR i IN
    SELECT * FROM generate_series(1, cardinality(v_include_fields)) g (i)
  LOOP
    includingParameters = array_append(includingParameters, ast.index_elem(
      v_name := v_include_fields[i],
      v_ordering := 'SORTBY_DEFAULT',
      v_nulls_ordering := 'SORTBY_NULLS_DEFAULT'
    ));
  END LOOP;

  ast = ast.raw_stmt(
    v_stmt := ast.index_stmt(
      v_idxname := v_index_name,
      v_relation := ast_helpers.range_var(
        v_schemaname := v_schema_name,
        v_relname := v_table_name
      ),
      v_accessMethod := v_accessMethod,
      v_indexParams := to_jsonb(parameters),
      v_indexIncludingParams := to_jsonb(includingParameters),
      v_unique := v_unique
    ),
    v_stmt_len:= 1
  );

  RETURN ast;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.drop_index (
  v_schema_name text,
  v_index_name text
)
    RETURNS jsonb
AS $$
  select ast.raw_stmt(
    v_stmt := ast.drop_stmt(
      v_objects:= to_jsonb(ARRAY[
        to_jsonb(ARRAY[
          ast.string(v_schema_name),
          ast.string(v_index_name)
        ])
      ]),
      v_removeType:= 'OBJECT_INDEX',
      v_behavior:= 'DROP_RESTRICT'
    ),
    v_stmt_len := 1
  );
$$
LANGUAGE 'sql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.table_grant (
  v_schema_name text,
  v_table_name text,
  v_priv_name text,
  v_is_grant boolean,
  v_role_name text,
  v_cols text[] default null
)
    RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
  cols jsonb[];
  i int;
BEGIN
  FOR i IN 
  SELECT * FROM generate_series(1, cardinality(v_cols))
  LOOP 
    cols = array_append(cols, ast.string(v_cols[i]));
  END LOOP;

  SELECT ast.raw_stmt(
    v_stmt := ast.grant_stmt(
      v_is_grant := v_is_grant,
      v_targtype := 'ACL_TARGET_OBJECT',
      v_objtype := 'OBJECT_TABLE',
      v_objects := to_jsonb(ARRAY[
        ast_helpers.range_var(
          v_schemaname := v_schema_name,
          v_relname := v_table_name
        )
      ]),
      v_privileges := to_jsonb(ARRAY[
        ast.access_priv(
          v_priv_name := v_priv_name,
          v_cols := to_jsonb(cols)
        )
      ]),
      v_grantees := to_jsonb(ARRAY[
        ast.role_spec(
          v_roletype := 'ROLESPEC_CSTRING',
          v_rolename:= v_role_name
        )
      ])
    ),
    v_stmt_len:= 1
  ) INTO ast;

  RETURN ast;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

-- THIS ONLY WORKS WITH pg_catalog types!
-- OTHERWISE deparser WILL ADD pg_catalog!
CREATE FUNCTION ast_helpers.alter_table_add_column (
  v_schema_name text,
  v_table_name text,
  v_column_name text,
  v_column_type text
)
    RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
BEGIN
  ast = ast.type_name(
    v_names := to_jsonb(ARRAY[
      ast.string('pg_catalog'),
      ast.string(v_column_type)
    ])
  );

  RETURN ast_helpers.alter_table_add_column(
    v_schema_name := v_schema_name,
    v_table_name := v_table_name,
    v_column_name := v_column_name,
    v_column_type := ast
  );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

-- for control over more complex types, use this
CREATE FUNCTION ast_helpers.alter_table_add_column (
  v_schema_name text,
  v_table_name text,
  v_column_name text,
  v_column_type jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
BEGIN
  RETURN ast.raw_stmt(
    v_stmt := ast.alter_table_stmt(
      v_relation := ast_helpers.range_var(
        v_schemaname := v_schema_name,
        v_relname := v_table_name
      ),
      v_cmds := to_jsonb(ARRAY[
        ast.alter_table_cmd(
          v_subtype := 'AT_AddColumn',
          v_def := ast.column_def(
            v_colname := v_column_name,
            v_typeName := v_column_type,
            v_is_local := TRUE
          ),
          v_behavior := 'DROP_RESTRICT' 
        )
      ]),
      v_relkind := 'OBJECT_TABLE'
    ),
    v_stmt_len:= 1
  );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_drop_column (
  v_schema_name text,
  v_table_name text,
  v_column_name text
)
    RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
BEGIN
  RETURN ast.raw_stmt(
    v_stmt := ast.alter_table_stmt(
      v_relation := ast_helpers.range_var(
        v_schemaname := v_schema_name,
        v_relname := v_table_name
      ),
      v_cmds := to_jsonb(ARRAY[
        ast.alter_table_cmd(
          v_subtype := 'AT_DropColumn',
          v_name := v_column_name,
          v_behavior := 'DROP_RESTRICT' 
        )
      ]),
      v_relkind := 'OBJECT_TABLE'
    ),
    v_stmt_len:= 1
  );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_rename_column (
  v_schema_name text,
  v_table_name text,
  v_old_column_name text,
  v_new_column_name text
)
    RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
BEGIN
  RETURN ast.raw_stmt(
    v_stmt := ast.rename_stmt(
      v_renameType := 'OBJECT_COLUMN',
      v_relationType := 'OBJECT_TABLE',
      v_relation := ast_helpers.range_var(
        v_schemaname := v_schema_name,
        v_relname := v_table_name
      ),
      v_subname := v_old_column_name,
      v_newname := v_new_column_name
    ),
    v_stmt_len:= 1
  );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_set_column_data_type (
  v_schema_name text,
  v_table_name text,
  v_column_name text,
  v_old_column_type text,
  v_new_column_type text
)
    RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
BEGIN
  RETURN ast.raw_stmt(
    v_stmt := ast.alter_table_stmt(
      v_relation := ast_helpers.range_var(
        v_schemaname := v_schema_name,
        v_relname := v_table_name
      ),
      v_cmds := to_jsonb(ARRAY[
        ast.alter_table_cmd(
          v_subtype := 'AT_AlterColumnType',
          v_name := v_column_name,
          v_def := ast.column_def(
            v_typeName := ast.type_name(
              v_names := to_jsonb(ARRAY[
                ast.string(v_new_column_type)
              ])
            ),
            v_raw_default := ast.type_cast(
              v_arg := ast.column_ref(
                v_fields := to_jsonb(ARRAY[
                  ast.string(v_column_name)
                ])
              ),
              v_typeName := ast.type_name(
                v_names := to_jsonb(ARRAY[
                  ast.string(v_new_column_type)
                ])
              )
            )
          ),
          v_behavior := 'DROP_RESTRICT'
        )
      ]),
      v_relkind := 'OBJECT_TABLE'
    ),
    v_stmt_len:= 1
  );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_add_check_constraint (
  v_schema_name text,
  v_table_name text,
  v_constraint_name text,
  v_constraint_expr jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
BEGIN
  RETURN ast.raw_stmt(
        v_stmt := ast.alter_table_stmt(
          v_relation := ast_helpers.range_var(
            v_schemaname := v_schema_name,
            v_relname := v_table_name
          ),
          v_cmds := to_jsonb(ARRAY[
            ast.alter_table_cmd(
              v_subtype := 'AT_AddConstraint',
              v_def := ast.constraint(
                v_contype := 'CONSTR_CHECK',
                v_conname := v_constraint_name,
                v_raw_expr := v_constraint_expr,
                v_initially_valid := true
              ),
              v_behavior := 'DROP_RESTRICT'
            )
          ]),
          v_relkind := 'OBJECT_TABLE'
        ),
        v_stmt_len:= 1
      );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_drop_constraint (
  v_schema_name text,
  v_table_name text,
  v_constraint_name text
)
    RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
BEGIN
  RETURN ast.raw_stmt(
        v_stmt := ast.alter_table_stmt(
          v_relation := ast_helpers.range_var(
            v_schemaname := v_schema_name,
            v_relname := v_table_name
          ),
          v_cmds := to_jsonb(ARRAY[
            ast.alter_table_cmd(
              v_subtype := 'AT_DropConstraint',
              v_name := v_constraint_name,
              v_behavior := 'DROP_RESTRICT'
            )
          ]),
          v_relkind := 'OBJECT_TABLE'
        ),
        v_stmt_len:= 1
      );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;


CREATE FUNCTION ast_helpers.alter_table_modify_check_constraint (
  v_schema_name text,
  v_table_name text,
  v_constraint_name text,
  v_constraint_expr jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
BEGIN
  RETURN ast.raw_stmt(
        v_stmt := ast.alter_table_stmt(
          v_relation := ast_helpers.range_var(
            v_schemaname := v_schema_name,
            v_relname := v_table_name
          ),
          v_cmds := to_jsonb(ARRAY[
            -- DROP IT FIRST
            ast.alter_table_cmd(
              v_subtype := 'AT_DropConstraint',
              v_name := v_constraint_name,
              v_behavior := 'DROP_RESTRICT',
              v_missing_ok := TRUE
            ),
            -- ADD IT BACK
            ast.alter_table_cmd(
              v_subtype := 'AT_AddConstraint',
              v_def := ast.constraint(
                v_contype := 'CONSTR_CHECK',
                v_conname := v_constraint_name,
                v_raw_expr := v_constraint_expr,
                v_initially_valid := true
              ),
              v_behavior := 'DROP_RESTRICT' 
            )
          ]),
          v_relkind := 'OBJECT_TABLE'
        ),
        v_stmt_len:= 1
      );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;


CREATE FUNCTION ast_helpers.set_comment_on_function (
  v_function_name text,
  v_comment text default null, 
  v_param_types text[] default ARRAY[]::text[],
  v_schema_name text default null
)
    RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
  types jsonb[];
  names jsonb[];
  i int;
BEGIN
  FOR i IN
  SELECT * FROM generate_series(1, cardinality(v_param_types))
  LOOP 
    types = array_append(types, 
      ast.type_name(
        v_names := to_jsonb(ARRAY[ 
            ast.string(strs[i])
        ])
      )
    );
  END LOOP;

  IF (v_schema_name IS NOT NULL) THEN 
    names = array_append(names, ast.string(v_schema_name));
  END IF;

  names = array_append(names, ast.string(v_function_name));

  RETURN ast.raw_stmt(
        v_stmt := ast.comment_stmt(
        v_objtype := 'OBJECT_FUNCTION',
        v_object := ast.object_with_args(
                v_objname := to_jsonb(names),
                v_objargs := to_jsonb(types)
            ),
            v_comment := v_comment
        ),
        v_stmt_len:= 1
      );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.set_comment_on_function (
  v_function_name text,
  v_tags jsonb default null, 
  v_description text default null, 
  v_param_types text[] default ARRAY[]::text[],
  v_schema_name text default null
)
    RETURNS jsonb
    AS $$
DECLARE
  v_comment text;
BEGIN

  v_comment = ast_helpers.smart_comments(
    v_tags,
    v_description
  );

  RETURN ast_helpers.set_comment_on_function(
    v_function_name := v_function_name,
    v_comment := v_comment,
    v_param_types := v_param_types,
    v_schema_name := v_schema_name
  );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.set_comment (
  v_objtype text,
  v_comment text default null, 
  variadic v_name text[] default null
)
    RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
  types jsonb[];
  names jsonb[];
  i int;
BEGIN

  FOR i IN
  SELECT * FROM generate_series(1, cardinality(v_name))
  LOOP 
    names = array_append(names, 
       ast.string(v_name[i])
    );
  END LOOP;

  RETURN ast.raw_stmt(
        v_stmt := ast.comment_stmt(
          v_objtype := v_objtype,
          v_object := to_jsonb(names),
          v_comment := v_comment
        ),
        v_stmt_len:= 1
      );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.set_comment (
  v_objtype text,
  v_tags jsonb default null, 
  v_description text default null, 
  variadic v_name text[] default null
)
    RETURNS jsonb
    AS $$
DECLARE
  v_comment text;
BEGIN

  v_comment = ast_helpers.smart_comments(
    v_tags,
    v_description
  );

  RETURN ast_helpers.set_comment(
    v_objtype := v_objtype,
    v_comment := v_comment,
    variadic v_name := v_name
  );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.bool (
  v_true boolean
)
    RETURNS jsonb
    AS $$
BEGIN

  RETURN ast.type_cast(
    v_arg := ast.a_const( v_val := ast.string( (CASE WHEN v_true THEN 't' ELSE 'f' END) ) ),
    v_typeName := ast.type_name(
      v_names := ast_helpers.array_of_strings('pg_catalog', 'bool'),
      v_typemod := -1
    )
  ); 

END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

COMMIT;
