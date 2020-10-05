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

COMMIT;
