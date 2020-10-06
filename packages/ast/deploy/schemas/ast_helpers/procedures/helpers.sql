-- Deploy schemas/ast_helpers/procedures/helpers to pg

-- requires: schemas/ast_helpers/schema
-- requires: schemas/ast/procedures/types 

BEGIN;


CREATE FUNCTION ast_helpers.coalesce (field text, value text default '')
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = ast.func_call('coalesce', to_jsonb(ARRAY[ ast.string(''), ast.a_const('') ]));
BEGIN
	result = jsonb_set(result, '{FuncCall, args, 0, String, str}', to_jsonb(field));
	result = jsonb_set(result, '{FuncCall, args, 1, A_Const, String, str}', to_jsonb(value));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.coalesce (field jsonb, value text default '')
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = ast.func_call('coalesce', to_jsonb(ARRAY[ ast.string(''), ast.a_const('') ]));
BEGIN
	result = jsonb_set(result, '{FuncCall, args, 0}', field);
	result = jsonb_set(result, '{FuncCall, args, 1, A_Const, String, str}', to_jsonb(value));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.tsvectorw (input jsonb, weight text='A')
    RETURNS jsonb
    AS $$
BEGIN
	RETURN ast.func_call('setweight', to_jsonb(ARRAY[input, ast.a_const(weight)]));
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.tsvector (input jsonb)
    RETURNS jsonb
    AS $$
BEGIN
	RETURN ast.func_call('to_tsvector', to_jsonb(ARRAY[input]));
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
      name,
      ast.type_name( to_jsonb(ARRAY[ast.string(type)]), false ),
      105
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
      name,
      ast.type_name( to_jsonb(ARRAY[ast.string(type)]), false ),
      105,
      ast.string(default_value)
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
      name,
      ast.type_name( to_jsonb(ARRAY[ast.string(type)]), false ),
      105,
      default_value
    );
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.tsvector (lang text, input jsonb)
    RETURNS jsonb
    AS $$
BEGIN
	RETURN ast.func_call('to_tsvector', to_jsonb(ARRAY[ast.a_const(lang), input]));
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.a_expr_distinct_tg_field (field text)
    RETURNS jsonb
    AS $$
BEGIN
	RETURN ast.a_expr(3, 
        ast.column_ref(
          to_jsonb(ARRAY[ ast.string('old'),ast.string(field) ])
        ),
        '=',
        ast.column_ref(
          to_jsonb(ARRAY[ ast.string('new'),ast.string(field) ])
        ) 
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
          ast_helpers.coalesce(ast.func_call('array_to_string', to_jsonb(ARRAY[
          -- type cast null to text[] array
        ast.type_cast(ast.string(r->>'field'), ast.type_name( to_jsonb(ARRAY[ast.string('text')]), true ))
          --
        , ast.a_const(' ')])))
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
        result = ast.a_expr( 0, results[i], '||', result );
      END IF;
    END LOOP;

	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast_helpers.create_trigger_with_fields (
  trigger_name text,
  schema_name text,
  table_name text,
  trigger_fn_schema text,
  trigger_fn_name text,
  fields text[],
  timing int default 2,
  events int default 4 | 16
)
    RETURNS jsonb
    AS $$
DECLARE
  results jsonb[];
  result jsonb;
  whenClause jsonb;
  r jsonb;
	i int;
  field text;
BEGIN

  FOR i IN SELECT * FROM generate_subscripts(fields, 1) g(i)
    LOOP
      field = fields[i];
      IF (i = 1) THEN
        whenClause = ast_helpers.a_expr_distinct_tg_field(field);
      ELSE
        whenClause = ast.bool_expr( 1, to_jsonb(ARRAY[ast_helpers.a_expr_distinct_tg_field(field), whenClause]) );
      END IF;
    END LOOP;

  result = ast.create_trigger_stmt(trigger_name,
    ast.range_var(schema_name, table_name, true, 'p'),
    to_jsonb(ARRAY[ ast.string(trigger_fn_schema),ast.string(trigger_fn_name) ]),
    true,
    timing,
    events,
    whenClause
  );


	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;


CREATE FUNCTION ast_helpers.create_function (
  schema text,
  name text,
  type text,
  parameters jsonb,
  body text,
  vol text,
  lan text,
  sec int
)
    RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
BEGIN

  select * FROM ast.create_function_stmt(
    -- name
    to_jsonb(ARRAY[ ast.string(schema),ast.string(name) ]),
    -- params
    parameters,
    -- return type
    ast.type_name( to_jsonb(ARRAY[ast.string(type)]), false ),
    -- options 
    to_jsonb(ARRAY[
      ast.def_elem(
        'as',
        to_jsonb(ARRAY[ast.string(body)])
      ),
      ast.def_elem(
        'volatility',
        ast.string(vol)
      ),
      ast.def_elem(
        'language',
        ast.string(lan)
      ),
      ast.def_elem(
        'security',
        ast.integer(sec)
      )
    ]::jsonb[])
  ) INTO ast;

  RETURN ast;

END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;


CREATE FUNCTION ast_helpers.create_policy (
  name text,
  vschema text,
  vtable text,
  vrole text,
  qual jsonb,
  cmd text,
  permissive boolean

)
    RETURNS jsonb
    AS $$
DECLARE
  ast jsonb;
BEGIN
  select * FROM ast.create_policy_stmt(
    name,
    ast.range_var(vschema, vtable, true, 'p'),
    to_jsonb(ARRAY[
        ast.role_spec(vrole, 0)
    ]),
    qual,
    cmd,
    permissive
  ) INTO ast;
  RETURN ast;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;


COMMIT;