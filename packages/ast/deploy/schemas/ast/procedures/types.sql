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
  relpersistence text,
  alias jsonb default null
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
	result = ast.jsonb_set(result, '{RangeVar, alias}', alias);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.res_target (
  name text,
  val jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"ResTarget":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{ResTarget, val}', val);
	result = ast.jsonb_set(result, '{ResTarget, name}', to_jsonb(name));
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.explain_stmt (
  query jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"ExplainStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{ExplainStmt, query}', query);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.sort_by (
  sortby_dir int,
  sortby_nulls int,
  useOp jsonb,
  node jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"SortBy":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{SortBy, sortby_dir}', to_jsonb(sortby_dir));
	result = ast.jsonb_set(result, '{SortBy, sortby_nulls}', to_jsonb(sortby_nulls));
	result = ast.jsonb_set(result, '{SortBy, useOp}', useOp);
	result = ast.jsonb_set(result, '{SortBy, node}', node);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.drop_stmt (
  removeType int,
  objects jsonb,
  missing_ok boolean,
  behavior int
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"DropStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{DropStmt, objects}', objects);
	result = ast.jsonb_set(result, '{DropStmt, removeType}', to_jsonb(removeType));
	result = ast.jsonb_set(result, '{DropStmt, behavior}', to_jsonb(behavior));
	result = ast.jsonb_set(result, '{DropStmt, missing_ok}', to_jsonb(missing_ok));
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.row_expr (
  row_format int,
  args jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"RowExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{RowExpr, row_format}', to_jsonb(row_format));
	result = ast.jsonb_set(result, '{RowExpr, args}', args);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.delete_stmt (
  relation jsonb,
  whereClause jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"DeleteStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{DeleteStmt, relation}', relation);
	result = ast.jsonb_set(result, '{DeleteStmt, whereClause}', whereClause);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.grant_stmt (
  objtype int,
  targtype int,
  is_grant boolean,
  grant_option boolean,
  privileges jsonb, 
  objects jsonb, 
  grantees jsonb,
  behavior int
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"GrantStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{GrantStmt, objtype}', to_jsonb(objtype));
	result = ast.jsonb_set(result, '{GrantStmt, targtype}', to_jsonb(targtype));
	result = ast.jsonb_set(result, '{GrantStmt, is_grant}', to_jsonb(is_grant));
	result = ast.jsonb_set(result, '{GrantStmt, grant_option}', to_jsonb(grant_option));
	result = ast.jsonb_set(result, '{GrantStmt, privileges}', privileges);
	result = ast.jsonb_set(result, '{GrantStmt, objects}', objects);
	result = ast.jsonb_set(result, '{GrantStmt, grantees}', grantees);
	result = ast.jsonb_set(result, '{GrantStmt, behavior}', to_jsonb(behavior));
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.select_stmt (
  op int,
  relation jsonb,
  valuesList jsonb default null,
  targetList jsonb default null,
  larg jsonb default null,
  rarg jsonb default null,
  vall boolean default null,
  distinctClause jsonb default null,
  intoClause jsonb default null,
  fromClause jsonb default null,
  groupClause jsonb default null,
  whereClause jsonb default null,
  sortClause jsonb default null,
  limitCount jsonb default null,
  limitOffset jsonb default null,
  lockingClause jsonb default null,
  windowClause jsonb default null
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"SelectStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{SelectStmt, op}', to_jsonb(op)); 
  result = ast.jsonb_set(result, '{SelectStmt, relation}', relation); 
  result = ast.jsonb_set(result, '{SelectStmt, valuesList}', valuesList); 
  result = ast.jsonb_set(result, '{SelectStmt, targetList}', targetList); 
  result = ast.jsonb_set(result, '{SelectStmt, larg}', larg); 
  result = ast.jsonb_set(result, '{SelectStmt, rarg}', rarg); 
  result = ast.jsonb_set(result, '{SelectStmt, all}', to_jsonb(vall)); 
  result = ast.jsonb_set(result, '{SelectStmt, distinctClause}', distinctClause); 
  result = ast.jsonb_set(result, '{SelectStmt, intoClause}', intoClause); 
  result = ast.jsonb_set(result, '{SelectStmt, fromClause}', fromClause); 
  result = ast.jsonb_set(result, '{SelectStmt, groupClause}', groupClause); 
  result = ast.jsonb_set(result, '{SelectStmt, whereClause}', whereClause); 
  result = ast.jsonb_set(result, '{SelectStmt, sortClause}', sortClause); 
  result = ast.jsonb_set(result, '{SelectStmt, limitCount}', limitCount); 
  result = ast.jsonb_set(result, '{SelectStmt, limitOffset}', limitOffset); 
  result = ast.jsonb_set(result, '{SelectStmt, lockingClause}', lockingClause); 
  result = ast.jsonb_set(result, '{SelectStmt, windowClause}', windowClause); 
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.insert_stmt (
  relation jsonb,
  cols jsonb default null,
  selectStmt jsonb default null,
  onConflictClause jsonb default null,
  returningList jsonb default null
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"InsertStmt":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{InsertStmt, relation}', relation);
	  result = ast.jsonb_set(result, '{InsertStmt, cols}', cols);
	  result = ast.jsonb_set(result, '{InsertStmt, selectStmt}', selectStmt);
	  result = ast.jsonb_set(result, '{InsertStmt, onConflictClause}', onConflictClause);
	  result = ast.jsonb_set(result, '{InsertStmt, returningList}', returningList);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.update_stmt (
  relation jsonb,
  targetList jsonb,
  fromClause jsonb,
  whereClause jsonb,
  returningList jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"UpdateStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{UpdateStmt, relation}', relation);
	result = ast.jsonb_set(result, '{UpdateStmt, targetList}', targetList);
	result = ast.jsonb_set(result, '{UpdateStmt, fromClause}', fromClause);
	result = ast.jsonb_set(result, '{UpdateStmt, whereClause}', whereClause);
	result = ast.jsonb_set(result, '{UpdateStmt, returningList}', returningList);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.join_expr (
  larg jsonb,
  jointype int,
  rarg jsonb default null,
  isNatural boolean default null,
  quals jsonb default null,
  usingClause jsonb default null,
  alias jsonb default null
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"JoinExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{JoinExpr, larg}', larg);
	result = ast.jsonb_set(result, '{JoinExpr, rarg}', rarg);
	result = ast.jsonb_set(result, '{JoinExpr, isNatural}', to_jsonb(isNatural));
	result = ast.jsonb_set(result, '{JoinExpr, jointype}', to_jsonb(jointype));
	result = ast.jsonb_set(result, '{JoinExpr, quals}', quals);
	result = ast.jsonb_set(result, '{JoinExpr, usingClause}', usingClause);
	result = ast.jsonb_set(result, '{JoinExpr, alias}', alias);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.locking_clause (
  strength int,
  lockedRels jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"LockingClause":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{LockingClause, strength}', to_jsonb(strength));
	result = ast.jsonb_set(result, '{LockingClause, lockedRels}', lockedRels);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.named_arg_expr (
  name text,
  arg jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"NamedArgExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{NamedArgExpr, name}', to_jsonb(name));
	result = ast.jsonb_set(result, '{NamedArgExpr, arg}', arg);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.min_max_expr (
  op int,
  args jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"MinMaxExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{MinMaxExpr, op}', to_jsonb(op));
	result = ast.jsonb_set(result, '{MinMaxExpr, args}', args);
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.into_clause (
  rel jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"IntoClause":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{IntoClause, rel}', rel);
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

CREATE FUNCTION ast.constraint (
  contype int,
  keys jsonb,
  raw_expr jsonb default null,
  fk_del_action text default 'a',
  fk_upd_action text default 'a', 
  fk_matchtype text default null,
  is_no_inherit boolean default null, 
  skip_validation boolean default null, 
  vdeferrable boolean default null,

  -- exclusion constraint
  exclusions jsonb default null,
  access_method boolean default null,

  -- reference constraint
  pk_attrs jsonb default null,
  fk_attrs jsonb default null,
  conname text default null, -- shared (also on other constraints)
  pktable jsonb default null


)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"Constraint":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{Constraint, contype}', to_jsonb(contype)); 
  result = ast.jsonb_set(result, '{Constraint, keys}', keys); 
  result = ast.jsonb_set(result, '{Constraint, raw_expr}', raw_expr); 
  result = ast.jsonb_set(result, '{Constraint, fk_del_action}', to_jsonb(fk_del_action)); 
  result = ast.jsonb_set(result, '{Constraint, fk_upd_action}', to_jsonb(fk_upd_action)); 
  result = ast.jsonb_set(result, '{Constraint, fk_matchtype}', to_jsonb(fk_matchtype)); 
  result = ast.jsonb_set(result, '{Constraint, is_no_inherit}', to_jsonb(is_no_inherit)); 
  result = ast.jsonb_set(result, '{Constraint, skip_validation}', to_jsonb(skip_validation)); 
  result = ast.jsonb_set(result, '{Constraint, vdeferrable}', to_jsonb(vdeferrable)); 
  
  result = ast.jsonb_set(result, '{Constraint, exclusions}', exclusions); 
  result = ast.jsonb_set(result, '{Constraint, access_method}', to_jsonb(access_method)); 

  result = ast.jsonb_set(result, '{Constraint, pk_attrs}', pk_attrs); 
  result = ast.jsonb_set(result, '{Constraint, fk_attrs}', fk_attrs); 
  result = ast.jsonb_set(result, '{Constraint, pktable}', pktable); 

  result = ast.jsonb_set(result, '{Constraint, conname}', to_jsonb(conname)); 

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

CREATE FUNCTION ast.access_priv (
  priv_name text,
  cols jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"AccessPriv":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{AccessPriv, cols}', cols);
	result = ast.jsonb_set(result, '{AccessPriv, priv_name}', to_jsonb(priv_name));
  return result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.variable_set_stmt (
  kind int,
  is_local boolean,
  name text,
  args jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"VariableSetStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{VariableSetStmt, args}', args);
	result = ast.jsonb_set(result, '{VariableSetStmt, kind}', to_jsonb(kind));
	result = ast.jsonb_set(result, '{VariableSetStmt, is_local}', to_jsonb(is_local));
	result = ast.jsonb_set(result, '{VariableSetStmt, name}', to_jsonb(name));
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
	result = ast.jsonb_set(result, '{ColumnRef, fields}', fields);
  RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.common_table_expr (
  ctename text,
  ctequery jsonb,
  aliascolnames jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"CommonTableExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CommonTableExpr, ctename}', to_jsonb(ctename));
	result = ast.jsonb_set(result, '{CommonTableExpr, ctequery}', ctequery);
	result = ast.jsonb_set(result, '{CommonTableExpr, aliascolnames}', aliascolnames);
  RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.comment_stmt (
  objtype int,
  object jsonb,
  comment text,
  objargs jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"CommentStmt":{"fields":""}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CommentStmt, objtype}', to_jsonb(objtype));
	result = ast.jsonb_set(result, '{CommentStmt, object}', object);
	result = ast.jsonb_set(result, '{CommentStmt, comment}', to_jsonb(comment));
	result = ast.jsonb_set(result, '{CommentStmt, objargs}', objargs);
  RETURN result;
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

CREATE FUNCTION ast.grouping_func (
  args jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"GroupingFunc":{"args":[]}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{GroupingFunc, args}', args);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.grouping_set (
  kind int,
  content jsonb default null
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"GroupingSet":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{GroupingSet, kind}', to_jsonb(kind));
	  result = ast.jsonb_set(result, '{GroupingSet, content}', content);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.index_stmt (
  relation jsonb,
  indexParams jsonb default null,
  whereClause jsonb default null,
  uniq boolean default null,
  idxname text default null,
  concur boolean default null
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"IndexStmt":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{IndexStmt, relation}', relation);
	  result = ast.jsonb_set(result, '{IndexStmt, indexParams}', indexParams);
	  result = ast.jsonb_set(result, '{IndexStmt, whereClause}', whereClause);
	  result = ast.jsonb_set(result, '{IndexStmt, idxname}', to_jsonb(idxname));
	  result = ast.jsonb_set(result, '{IndexStmt, unique}', to_jsonb(uniq));
	  result = ast.jsonb_set(result, '{IndexStmt, concurrent}', to_jsonb(concur));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.index_elem (
  name text,
  expr jsonb default null
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"IndexElem":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{IndexElem, name}', to_jsonb(name));
	  result = ast.jsonb_set(result, '{IndexElem, expr}', expr);
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

CREATE FUNCTION ast.func_call (
  funcname jsonb,
  args jsonb default '[]'::jsonb,
  func_variadic boolean default null,
  agg_distinct boolean default null,
  agg_within_group boolean default null,
  agg_star boolean default null,
  agg_filter jsonb default null,
  agg_order jsonb default null,
  vover jsonb default null
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"FuncCall":{"funcname":[],"args":[]}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{FuncCall, funcname}', funcname);
	  result = ast.jsonb_set(result, '{FuncCall, args}', args);
	  result = ast.jsonb_set(result, '{FuncCall, over}', vover);
	  result = ast.jsonb_set(result, '{FuncCall, func_variadic}', to_jsonb(func_variadic));
	  result = ast.jsonb_set(result, '{FuncCall, agg_distinct}', to_jsonb(agg_distinct));
	  result = ast.jsonb_set(result, '{FuncCall, agg_order}', agg_order);
	  result = ast.jsonb_set(result, '{FuncCall, agg_filter}', agg_filter);
	  result = ast.jsonb_set(result, '{FuncCall, agg_within_group}', to_jsonb(agg_within_group));
	  result = ast.jsonb_set(result, '{FuncCall, agg_star}', to_jsonb(agg_star));
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

CREATE FUNCTION ast.null_test (
  nulltesttype int
)
RETURNS jsonb AS $$
DECLARE
    result jsonb = '{"NullTest":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{NullTest, nulltesttype}', to_jsonb(nulltesttype));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.range_function (
  vlateral boolean,
  functions jsonb,
  is_rowsfrom boolean,
  ordinality boolean,
  alias jsonb,
  coldeflist jsonb
)
RETURNS jsonb AS $$
DECLARE
    result jsonb = '{"RangeFunction":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{RangeFunction, lateral}', to_jsonb(vlateral));
	  result = ast.jsonb_set(result, '{RangeFunction, is_rowsfrom}', to_jsonb(is_rowsfrom));
	  result = ast.jsonb_set(result, '{RangeFunction, ordinality}', to_jsonb(ordinality));
	  result = ast.jsonb_set(result, '{RangeFunction, coldeflist}', coldeflist);
	  result = ast.jsonb_set(result, '{RangeFunction, functions}', functions);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.range_subselect (
  vlateral boolean,
  subquery jsonb,
  alias jsonb
)
RETURNS jsonb AS $$
DECLARE
    result jsonb = '{"RangeFunction":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{RangeFunction, lateral}', to_jsonb(vlateral));
	  result = ast.jsonb_set(result, '{RangeFunction, subquery}', subquery);
	  result = ast.jsonb_set(result, '{RangeFunction, alias}', alias);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.param_ref (
  num int
)
RETURNS jsonb AS $$
DECLARE
    result jsonb = '{"ParamRef":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{ParamRef, number}', to_jsonb(num));
	RETURN result;
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

CREATE FUNCTION ast.do_stmt (
  stmt text
)
    RETURNS jsonb
    AS $$
DECLARE
  -- seemed like this was the only pattern seen so far... so simplified it
  result jsonb = '{"DoStmt":{"args":[{"DefElem":{"arg":{"String":{"str":""}}}}]}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{DoStmt, args, 0, DefElem, arg, String, str}', to_jsonb(stmt));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.float (
  flt float
)
    RETURNS jsonb
    AS $$
DECLARE
  result jsonb = '{"Float":{"str":""}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{Float, str}', to_jsonb(flt));
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
  args jsonb,
  isrow bool,
  timing int,
  events int,
  whenClause jsonb,
  columns jsonb default null,
  transitionRels jsonb default null,
  isconstraint bool default null,
  vdeferrable boolean default null,
  initdeferred boolean default null
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"CreateTrigStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CreateTrigStmt, trigname}', to_jsonb(trigname));
	result = ast.jsonb_set(result, '{CreateTrigStmt, row}', to_jsonb(isrow));
	result = ast.jsonb_set(result, '{CreateTrigStmt, timing}', to_jsonb(timing));
	result = ast.jsonb_set(result, '{CreateTrigStmt, deferrable}', to_jsonb(vdeferrable));
	result = ast.jsonb_set(result, '{CreateTrigStmt, initdeferred}', to_jsonb(initdeferred));
	result = ast.jsonb_set(result, '{CreateTrigStmt, events}', to_jsonb(events));
	result = ast.jsonb_set(result, '{CreateTrigStmt, funcname}', funcname);
	result = ast.jsonb_set(result, '{CreateTrigStmt, args}', args);
	result = ast.jsonb_set(result, '{CreateTrigStmt, relation}', relation);
	result = ast.jsonb_set(result, '{CreateTrigStmt, whenClause}', whenClause);
	result = ast.jsonb_set(result, '{CreateTrigStmt, columns}', columns);
	result = ast.jsonb_set(result, '{CreateTrigStmt, transitionRels}', transitionRels);
	result = ast.jsonb_set(result, '{CreateTrigStmt, isconstraint}', to_jsonb(isconstraint));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.function_parameter (
  name text,
  argType jsonb,
  mode int,
  defexpr jsonb default null
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"FunctionParameter":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{FunctionParameter, name}', to_jsonb(name));
	result = ast.jsonb_set(result, '{FunctionParameter, argType}', argType);
	result = ast.jsonb_set(result, '{FunctionParameter, defexpr}', defexpr);
	result = ast.jsonb_set(result, '{FunctionParameter, mode}', to_jsonb(mode));

	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.create_function_stmt (
  funcname jsonb,
  parameters jsonb,
  returnType jsonb,
  options jsonb,
  repl boolean default null
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
	result = ast.jsonb_set(result, '{CreateFunctionStmt, replace}', to_jsonb(repl));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.create_domain_stmt (
  domainname jsonb,
  typeName jsonb,
  constraints jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"CreateDomainStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CreateDomainStmt, domainname}', domainname);
	result = ast.jsonb_set(result, '{CreateDomainStmt, typeName}', typeName);
	result = ast.jsonb_set(result, '{CreateDomainStmt, constraints}', constraints);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.role_spec (
  roletype int,
  rolename text default null
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

CREATE FUNCTION ast.view_stmt (
  view jsonb,
  query jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"ViewStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{ViewStmt, view}', view);
	result = ast.jsonb_set(result, '{ViewStmt, query}', query);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.create_table_as_stmt (
  vinto jsonb,
  query jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"CreateTableAsStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CreateTableAsStmt, into}', vinto);
	result = ast.jsonb_set(result, '{CreateTableAsStmt, query}', query);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.create_stmt (
  relation jsonb,
  tableElts jsonb,
  options jsonb,
  inhRelations jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"CreateStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CreateStmt, relation}', relation);
	result = ast.jsonb_set(result, '{CreateStmt, tableElts}', tableElts);
	result = ast.jsonb_set(result, '{CreateStmt, inhRelations}', inhRelations);
	result = ast.jsonb_set(result, '{CreateStmt, options}', options);
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

CREATE FUNCTION ast.create_seq_stmt (
  seq jsonb,
  options jsonb
)
    RETURNS jsonb
    AS $$
DECLARE
    result jsonb = '{"CreateSeqStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CreateSeqStmt, sequence}', seq);
	result = ast.jsonb_set(result, '{CreateSeqStmt, options}', options);
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
  with_check jsonb,
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
	result = ast.jsonb_set(result, '{CreatePolicyStmt, with_check}', with_check);
	result = ast.jsonb_set(result, '{CreatePolicyStmt, cmd_name}', to_jsonb(cmd_name));
	result = ast.jsonb_set(result, '{CreatePolicyStmt, permissive}', to_jsonb(permissive));
	RETURN result;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

COMMIT;
