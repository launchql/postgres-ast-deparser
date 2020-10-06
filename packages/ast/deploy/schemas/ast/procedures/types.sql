-- Deploy schemas/ast/procedures/types to pg

-- requires: schemas/ast/schema

BEGIN;

-- NOTE: we purposesly dont set null values...
CREATE FUNCTION ast.jsonb_set (
    result jsonb,
    path text[],
    new_value jsonb
  )
    RETURNS jsonb
    AS $$
BEGIN
  IF (new_value IS NOT NULL) THEN
  	RETURN jsonb_set(result, path, new_value);
  END IF;
  RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.a_const (str text default '')
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"A_Const":{"val":{"String":{"str":""}}}}'::jsonb;
BEGIN
	RETURN ast.jsonb_set(result, '{A_Const, val, String, str}', to_jsonb(str));
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
	RETURN ast.jsonb_set(result, '{A_Const, val}', val);
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.a_indices (
  uidx jsonb,
  lidx jsonb default null
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"A_Indices":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{A_Indices, uidx}', uidx);
	result = ast.jsonb_set(result, '{A_Indices, lidx}', lidx);
  RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.bit_string (
  str text
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"BitString":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{BitString, str}', to_jsonb(str));
  RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.a_star ()
    RETURNS jsonb
    AS $$
BEGIN
  RETURN '{"A_Star":{}}'::jsonb;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.a_indirection (
  arg jsonb,
  indirection jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"A_Indirection":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{A_Indirection, arg}', arg);
	result = ast.jsonb_set(result, '{A_Indirection, indirection}', indirection);
  RETURN result;
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
	result = ast.jsonb_set(result, '{RangeVar, schemaname}', to_jsonb(schemaname));
	result = ast.jsonb_set(result, '{RangeVar, relname}', to_jsonb(relname));
	result = ast.jsonb_set(result, '{RangeVar, inh}', to_jsonb(inh));
	result = ast.jsonb_set(result, '{RangeVar, relpersistence}', to_jsonb(relpersistence));
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.raw_stmt (
  stmt jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"RawStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{RawStmt, stmt}', stmt);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.rule_stmt (
  rulename text,
  event int,
  relation jsonb,
  whereClause jsonb,
  actions jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"RuleStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{RuleStmt, rulename}', to_jsonb(rulename));
	result = ast.jsonb_set(result, '{RuleStmt, event}', to_jsonb(event));
	result = ast.jsonb_set(result, '{RuleStmt, relation}', relation);
	result = ast.jsonb_set(result, '{RuleStmt, whereClause}', whereClause);
	result = ast.jsonb_set(result, '{RuleStmt, actions}', actions);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.a_array_expr (
  elements jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"A_ArrayExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{A_ArrayExpr, elements}', elements);
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
	result = ast.jsonb_set(result, '{BoolExpr, boolop}', to_jsonb(boolop));
	result = ast.jsonb_set(result, '{BoolExpr, args}', args);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.case_expr (
  arg jsonb,
  args jsonb,
  defresult jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"CaseExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CaseExpr, arg}', arg);
	result = ast.jsonb_set(result, '{CaseExpr, args}', args);
	result = ast.jsonb_set(result, '{CaseExpr, defresult}', defresult);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.composite_type_stmt (
  typevar jsonb,
  coldeflist jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"CompositeTypeStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CompositeTypeStmt, typevar}', typevar);
	result = ast.jsonb_set(result, '{CompositeTypeStmt, coldeflist}', coldeflist);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.rename_stmt (
  renameType int,
  relationType int,
  relation jsonb,
  subname text,
  newname text
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"RenameStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{RenameStmt, renameType}', to_jsonb(renameType));
	result = ast.jsonb_set(result, '{RenameStmt, relationType}', to_jsonb(relationType));
	result = ast.jsonb_set(result, '{RenameStmt, relation}', relation);
	result = ast.jsonb_set(result, '{RenameStmt, subname}', to_jsonb(subname));
	result = ast.jsonb_set(result, '{RenameStmt, newname}', to_jsonb(newname));
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.coalesce_expr (
  args jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"CoalesceExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CoalesceExpr, args}', args);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.collate_clause (
  arg jsonb,
  collname jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"CollateClause":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CollateClause, arg}', arg);
	result = ast.jsonb_set(result, '{CollateClause, collname}', collname);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.boolean_test (
  booltesttype int,
  arg jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"BooleanTest":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{BooleanTest, booltesttype}', to_jsonb(booltesttype));
	result = ast.jsonb_set(result, '{BooleanTest, arg}', arg);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.column_ref (
  fields jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"ColumnRef":{"fields":""}}'::jsonb;
BEGIN
	RETURN ast.jsonb_set(result, '{ColumnRef, fields}', fields);
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.column_def (
  colname text,
  typeName jsonb,
  constraints jsonb,
  collClause jsonb,
  raw_default jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"ColumnDef":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{ColumnDef, colname}', to_jsonb(colname));
	result = ast.jsonb_set(result, '{ColumnDef, typeName}', typeName);
	result = ast.jsonb_set(result, '{ColumnDef, raw_default}', raw_default);
	result = ast.jsonb_set(result, '{ColumnDef, constraints}', constraints);
	result = ast.jsonb_set(result, '{ColumnDef, collClause}', collClause);
  RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.sql_value_function (
  op int
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"SQLValueFunction":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{SQLValueFunction, op}', to_jsonb(op));
  RETURN result;
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
	  result = ast.jsonb_set(result, '{FuncCall, funcname, 0, String, str}', to_jsonb(name));
	  result = ast.jsonb_set(result, '{FuncCall, args}', args);
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
	  result = ast.jsonb_set(result, '{FuncCall, funcname}', name);
	  result = ast.jsonb_set(result, '{FuncCall, args}', args);
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

CREATE FUNCTION ast.alias (
  aliasname text,
  colnames jsonb default null
)
RETURNS jsonb AS $$
DECLARE
    result jsonb = '{"Alias":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{Alias, aliasname}', to_jsonb(aliasname));
	  result = ast.jsonb_set(result, '{Alias, colnames}', colnames);
	RETURN result;
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
	result = ast.jsonb_set(result, '{TypeName, names}', names);
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
	result = ast.jsonb_set(result, '{TypeCast, arg}', arg);
	result = ast.jsonb_set(result, '{TypeCast, typeName}', typename);
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
	result = ast.jsonb_set(result, '{String, str}', to_jsonb(str));
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
	result = ast.jsonb_set(result, '{Integer, ival}', to_jsonb(ival));
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
	result = ast.jsonb_set(result, '{DefElem, defname}', to_jsonb(defname));
	result = ast.jsonb_set(result, '{DefElem, arg}', arg);
	result = ast.jsonb_set(result, '{DefElem, defaction}', to_jsonb(defaction));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.a_expr (
  kind int,
  lexpr jsonb,
  op text,
  rexpr jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"A_Expr":{"kind":0,"lexpr":{},"name":[],"rexpr":{}}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{A_Expr, kind}', to_jsonb(kind));
	result = ast.jsonb_set(result, '{A_Expr, lexpr}', lexpr);
	result = ast.jsonb_set(result, '{A_Expr, name, 0}', ast.string(op));
	result = ast.jsonb_set(result, '{A_Expr, rexpr}', rexpr);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.a_expr (
  kind int,
  lexpr jsonb,
  name jsonb,
  rexpr jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"A_Expr":{"kind":0,"lexpr":{},"name":[],"rexpr":{}}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{A_Expr, kind}', to_jsonb(kind));
	result = ast.jsonb_set(result, '{A_Expr, lexpr}', lexpr);
	result = ast.jsonb_set(result, '{A_Expr, name}', name);
	result = ast.jsonb_set(result, '{A_Expr, rexpr}', rexpr);
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
	result = ast.jsonb_set(result, '{CreateTrigStmt, trigname}', to_jsonb(trigname));
	result = ast.jsonb_set(result, '{CreateTrigStmt, row}', to_jsonb(isrow));
	result = ast.jsonb_set(result, '{CreateTrigStmt, timing}', to_jsonb(timing));
	result = ast.jsonb_set(result, '{CreateTrigStmt, events}', to_jsonb(events));
	result = ast.jsonb_set(result, '{CreateTrigStmt, funcname}', funcname);
	result = ast.jsonb_set(result, '{CreateTrigStmt, relation}', relation);
	result = ast.jsonb_set(result, '{CreateTrigStmt, whenClause}', whenClause);
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
	result = ast.jsonb_set(result, '{FunctionParameter, name}', to_jsonb(name));
	result = ast.jsonb_set(result, '{FunctionParameter, argType}', argType);
	result = ast.jsonb_set(result, '{FunctionParameter, mode}', to_jsonb(mode));

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
	result = ast.jsonb_set(result, '{FunctionParameter, name}', to_jsonb(name));
	result = ast.jsonb_set(result, '{FunctionParameter, argType}', argType);
	result = ast.jsonb_set(result, '{FunctionParameter, mode}', to_jsonb(mode));
	result = ast.jsonb_set(result, '{FunctionParameter, defexpr}', defexpr);

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
	result = ast.jsonb_set(result, '{CreateFunctionStmt, funcname}', funcname);
	result = ast.jsonb_set(result, '{CreateFunctionStmt, parameters}', parameters);
	result = ast.jsonb_set(result, '{CreateFunctionStmt, returnType}', returnType);
	result = ast.jsonb_set(result, '{CreateFunctionStmt, options}', options);
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
	result = ast.jsonb_set(result, '{RoleSpec, roletype}', to_jsonb(roletype));
	result = ast.jsonb_set(result, '{RoleSpec, rolename}', to_jsonb(rolename));
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
	result = ast.jsonb_set(result, '{CreatePolicyStmt, policy_name}', to_jsonb(policy_name));
	result = ast.jsonb_set(result, '{CreatePolicyStmt, table}', tbl);
	result = ast.jsonb_set(result, '{CreatePolicyStmt, roles}', roles);
	result = ast.jsonb_set(result, '{CreatePolicyStmt, qual}', qual);
	result = ast.jsonb_set(result, '{CreatePolicyStmt, cmd_name}', to_jsonb(cmd_name));
	result = ast.jsonb_set(result, '{CreatePolicyStmt, permissive}', to_jsonb(permissive));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

COMMIT;
