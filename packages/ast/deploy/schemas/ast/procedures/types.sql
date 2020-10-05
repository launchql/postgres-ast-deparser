-- Deploy schemas/ast/procedures/types to pg

-- requires: schemas/ast/schema

BEGIN;

CREATE FUNCTION ast.a_const (str text default '')
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"A_Const":{"val":{"String":{"str":""}}}}'::jsonb;
BEGIN
	RETURN jsonb_set(result, '{A_Const, val, String, str}', to_jsonb(str));
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.a_const (val jsonb)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"A_Const":{"val":""}}'::jsonb;
BEGIN
	RETURN jsonb_set(result, '{A_Const, val}', val);
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.range_var (
  schemaname text,
  relname text,
  inh bool,
  relpersistence text
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"RangeVar":{}}'::jsonb;
BEGIN
	result = jsonb_set(result, '{RangeVar, schemaname}', to_jsonb(schemaname));
	result = jsonb_set(result, '{RangeVar, relname}', to_jsonb(relname));
	result = jsonb_set(result, '{RangeVar, inh}', to_jsonb(inh));
	result = jsonb_set(result, '{RangeVar, relpersistence}', to_jsonb(relpersistence));
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.bool_expr (
  boolop int,
  args jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"BoolExpr":{}}'::jsonb;
BEGIN
	result = jsonb_set(result, '{BoolExpr, boolop}', to_jsonb(boolop));
	result = jsonb_set(result, '{BoolExpr, args}', args);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.column_ref (fields jsonb)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"ColumnRef":{"fields":""}}'::jsonb;
BEGIN
	RETURN jsonb_set(result, '{ColumnRef, fields}', fields);
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.func_call (name text, args jsonb default '[]'::jsonb)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"FuncCall":{"funcname":[{"String":{"str":""}}],"args":[]}}'::jsonb;
BEGIN
	  result = jsonb_set(result, '{FuncCall, funcname, 0, String, str}', to_jsonb(name));
	  result = jsonb_set(result, '{FuncCall, args}', args);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.func_call (name jsonb, args jsonb default '[]'::jsonb)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"FuncCall":{"funcname":[],"args":[]}}'::jsonb;
BEGIN
	  result = jsonb_set(result, '{FuncCall, funcname}', name);
	  result = jsonb_set(result, '{FuncCall, args}', args);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;


CREATE FUNCTION ast.null ()
    RETURNS jsonb
    AS $$
BEGIN
  RETURN '{"Null":{}}'::jsonb;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.type_name (names jsonb, isarray boolean default false)
    RETURNS jsonb
    AS $$
DECLARE
  result jsonb;
BEGIN
   IF (isarray) THEN
     result = '{"TypeName":{"names":[],"typemod":-1,"arrayBounds":[{"Integer":{"ival":-1}}]}}'::jsonb;
   ELSE 
     result = '{"TypeName":{"names":[],"typemod":-1}}'::jsonb;
   END IF;
	result = jsonb_set(result, '{TypeName, names}', names);
  RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.type_cast (arg jsonb, typename jsonb)
    RETURNS jsonb
    AS $$
DECLARE
  result jsonb = '{"TypeCast":{"arg":{},"typeName":{"TypeName":{"names":[{"String":{"str":"text"}}],"typemod":-1,"arrayBounds":[{"Integer":{"ival":-1}}]}}}}'::jsonb;
BEGIN
	result = jsonb_set(result, '{TypeCast, arg}', arg);
	result = jsonb_set(result, '{TypeCast, typeName}', typename);
  RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;


CREATE FUNCTION ast.string (str text)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"String":{"str":""}}'::jsonb;
BEGIN
	result = jsonb_set(result, '{String, str}', to_jsonb(str));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.integer (ival int)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"Integer":{"ival":""}}'::jsonb;
BEGIN
	result = jsonb_set(result, '{Integer, ival}', to_jsonb(ival));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.def_elem (
  defname text,
  arg jsonb,
  defaction int default 0
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"DefElem":{}}'::jsonb;
BEGIN
	result = jsonb_set(result, '{DefElem, defname}', to_jsonb(defname));
	result = jsonb_set(result, '{DefElem, arg}', arg);
	result = jsonb_set(result, '{DefElem, defaction}', to_jsonb(defaction));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.a_expr (kind int, lexpr jsonb, op text, rexpr jsonb)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"A_Expr":{"kind":0,"lexpr":{},"name":[],"rexpr":{}}}'::jsonb;
BEGIN
	result = jsonb_set(result, '{A_Expr, kind}', to_jsonb(kind));
	result = jsonb_set(result, '{A_Expr, lexpr}', lexpr);
	result = jsonb_set(result, '{A_Expr, name, 0}', ast.string(op));
	result = jsonb_set(result, '{A_Expr, rexpr}', rexpr);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

-- SQL OBJECTS 

CREATE FUNCTION ast.create_trigger_stmt (
  trigname text,
  relation jsonb,
  funcname jsonb,
  isrow bool,
  timing int,
  events int,
  whenClause jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"CreateTrigStmt":{}}'::jsonb;
BEGIN
	result = jsonb_set(result, '{CreateTrigStmt, trigname}', to_jsonb(trigname));
	result = jsonb_set(result, '{CreateTrigStmt, row}', to_jsonb(isrow));
	result = jsonb_set(result, '{CreateTrigStmt, timing}', to_jsonb(timing));
	result = jsonb_set(result, '{CreateTrigStmt, events}', to_jsonb(events));
	result = jsonb_set(result, '{CreateTrigStmt, funcname}', funcname);
	result = jsonb_set(result, '{CreateTrigStmt, relation}', relation);
	result = jsonb_set(result, '{CreateTrigStmt, whenClause}', whenClause);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.function_parameter (
  name text,
  argType jsonb,
  mode int
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"FunctionParameter":{}}'::jsonb;
BEGIN
	result = jsonb_set(result, '{FunctionParameter, name}', to_jsonb(name));
	result = jsonb_set(result, '{FunctionParameter, argType}', argType);
	result = jsonb_set(result, '{FunctionParameter, mode}', to_jsonb(mode));

	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.function_parameter (
  name text,
  argType jsonb,
  mode int,
  defexpr jsonb -- never let this be NULL, just don't pass it in. breaks shit. just stop.
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"FunctionParameter":{}}'::jsonb;
BEGIN
	result = jsonb_set(result, '{FunctionParameter, name}', to_jsonb(name));
	result = jsonb_set(result, '{FunctionParameter, argType}', argType);
	result = jsonb_set(result, '{FunctionParameter, mode}', to_jsonb(mode));
	result = jsonb_set(result, '{FunctionParameter, defexpr}', defexpr);

	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.create_function_stmt (
  funcname jsonb,
  parameters jsonb,
  returnType jsonb,
  options jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"CreateFunctionStmt":{}}'::jsonb;
BEGIN
	result = jsonb_set(result, '{CreateFunctionStmt, funcname}', funcname);
	result = jsonb_set(result, '{CreateFunctionStmt, parameters}', parameters);
	result = jsonb_set(result, '{CreateFunctionStmt, returnType}', returnType);
	result = jsonb_set(result, '{CreateFunctionStmt, options}', options);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.role_spec (
  rolename text,
  roletype int
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"RoleSpec":{}}'::jsonb;
BEGIN
	result = jsonb_set(result, '{RoleSpec, roletype}', to_jsonb(roletype));
	result = jsonb_set(result, '{RoleSpec, rolename}', to_jsonb(rolename));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.create_policy_stmt (
  policy_name text,
  tbl jsonb,
  roles jsonb,
  qual jsonb,
  cmd_name text,
  permissive boolean
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"CreatePolicyStmt":{}}'::jsonb;
BEGIN
	result = jsonb_set(result, '{CreatePolicyStmt, policy_name}', to_jsonb(policy_name));
	result = jsonb_set(result, '{CreatePolicyStmt, table}', tbl);
	result = jsonb_set(result, '{CreatePolicyStmt, roles}', roles);
	result = jsonb_set(result, '{CreatePolicyStmt, qual}', qual);
	result = jsonb_set(result, '{CreatePolicyStmt, cmd_name}', to_jsonb(cmd_name));
	result = jsonb_set(result, '{CreatePolicyStmt, permissive}', to_jsonb(permissive));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

-- HELPER OBJECTS 

CREATE FUNCTION ast.coalesce (field text, value text default '')
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

CREATE FUNCTION ast.coalesce (field jsonb, value text default '')
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

CREATE FUNCTION ast.tsvectorw (input jsonb, weight text='A')
    RETURNS jsonb
    AS $$
BEGIN
	RETURN ast.func_call('setweight', to_jsonb(ARRAY[input, ast.a_const(weight)]));
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.tsvector (input jsonb)
    RETURNS jsonb
    AS $$
BEGIN
	RETURN ast.func_call('to_tsvector', to_jsonb(ARRAY[input]));
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.simple_param (
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

CREATE FUNCTION ast.simple_param (
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

CREATE FUNCTION ast.simple_param (
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

CREATE FUNCTION ast.tsvector (lang text, input jsonb)
    RETURNS jsonb
    AS $$
BEGIN
	RETURN ast.func_call('to_tsvector', to_jsonb(ARRAY[ast.a_const(lang), input]));
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.a_expr_distinct_tg_field (field text)
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

-- HIGHER LEVEL OBJECTS

CREATE FUNCTION ast.tsvector_index (fields jsonb)
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
        results = array_append(results, ast.tsvectorw( ast.tsvector(r->>'lang',
          -- start the string
          ast.coalesce(ast.func_call('array_to_string', to_jsonb(ARRAY[
          -- type cast null to text[] array
        ast.type_cast(ast.string(r->>'field'), ast.type_name( to_jsonb(ARRAY[ast.string('text')]), true ))
          --
        , ast.a_const(' ')])))
        -- end array to string function call here
      ) , r->>'weight') );
      ELSE
        IF ( (r->'lang') IS NOT NULL) THEN
          results = array_append(results, ast.tsvectorw( ast.tsvector(r->>'lang', ast.coalesce(r->>'field')) , r->>'weight') );
        ELSE
          -- get_current_ts_config() returns 'english', we'd need to add pg_catalog on there...
          results = array_append(results, ast.tsvectorw( ast.tsvector(ast.coalesce(r->>'field')) , r->>'weight') );
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

CREATE FUNCTION ast.create_trigger_with_fields (
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
        whenClause = ast.a_expr_distinct_tg_field(field);
      ELSE
        whenClause = ast.bool_expr( 1, to_jsonb(ARRAY[ast.a_expr_distinct_tg_field(field), whenClause]) );
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


CREATE FUNCTION ast.create_function (
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


CREATE FUNCTION ast.create_policy (
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
