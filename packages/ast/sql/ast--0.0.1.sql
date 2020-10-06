\echo Use "CREATE EXTENSION ast" to load this file. \quit
CREATE SCHEMA ast_helpers;

CREATE SCHEMA ast;

CREATE FUNCTION ast.jsonb_set ( result jsonb, path text[], new_value jsonb ) RETURNS jsonb AS $EOFCODE$
BEGIN
  IF (new_value IS NOT NULL) THEN
  	RETURN jsonb_set(result, path, new_value);
  END IF;
  RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_const ( str text DEFAULT '' ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Const":{"val":{"String":{"str":""}}}}'::jsonb;
BEGIN
	RETURN ast.jsonb_set(result, '{A_Const, val, String, str}', to_jsonb(str));
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_const ( val jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Const":{"val":""}}'::jsonb;
BEGIN
	RETURN ast.jsonb_set(result, '{A_Const, val}', val);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_indices ( uidx jsonb, lidx jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Indices":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{A_Indices, uidx}', uidx);
	result = ast.jsonb_set(result, '{A_Indices, lidx}', lidx);
  RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.bit_string ( str text ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"BitString":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{BitString, str}', to_jsonb(str));
  RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_star (  ) RETURNS jsonb AS $EOFCODE$
BEGIN
  RETURN '{"A_Star":{}}'::jsonb;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_indirection ( arg jsonb, indirection jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Indirection":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{A_Indirection, arg}', arg);
	result = ast.jsonb_set(result, '{A_Indirection, indirection}', indirection);
  RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_var ( schemaname text, relname text, inh bool, relpersistence text, alias jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.res_target ( name text, val jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ResTarget":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{ResTarget, val}', val);
	result = ast.jsonb_set(result, '{ResTarget, name}', to_jsonb(name));
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.explain_stmt ( query jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ExplainStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{ExplainStmt, query}', query);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.sort_by ( sortby_dir int, sortby_nulls int, useop jsonb, node jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"SortBy":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{SortBy, sortby_dir}', to_jsonb(sortby_dir));
	result = ast.jsonb_set(result, '{SortBy, sortby_nulls}', to_jsonb(sortby_nulls));
	result = ast.jsonb_set(result, '{SortBy, useOp}', useOp);
	result = ast.jsonb_set(result, '{SortBy, node}', node);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.drop_stmt ( removetype int, objects jsonb, missing_ok boolean, behavior int ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DropStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{DropStmt, objects}', objects);
	result = ast.jsonb_set(result, '{DropStmt, removeType}', to_jsonb(removeType));
	result = ast.jsonb_set(result, '{DropStmt, behavior}', to_jsonb(behavior));
	result = ast.jsonb_set(result, '{DropStmt, missing_ok}', to_jsonb(missing_ok));
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.row_expr ( row_format int, args jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RowExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{RowExpr, row_format}', to_jsonb(row_format));
	result = ast.jsonb_set(result, '{RowExpr, args}', args);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.delete_stmt ( relation jsonb, whereclause jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DeleteStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{DeleteStmt, relation}', relation);
	result = ast.jsonb_set(result, '{DeleteStmt, whereClause}', whereClause);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.transaction_stmt ( kind int, options jsonb DEFAULT NULL, gid text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"TransactionStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{TransactionStmt, kind}', to_jsonb(kind));
	result = ast.jsonb_set(result, '{TransactionStmt, options}', options);
	result = ast.jsonb_set(result, '{TransactionStmt, gid}', to_jsonb(gid));
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grant_role_stmt ( is_grant boolean, granted_roles jsonb, grantee_roles jsonb, admin_opt boolean ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"GrantRoleStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{GrantRoleStmt, is_grant}', to_jsonb(is_grant));
	result = ast.jsonb_set(result, '{GrantRoleStmt, granted_roles}', granted_roles);
	result = ast.jsonb_set(result, '{GrantRoleStmt, grantee_roles}', grantee_roles);
	result = ast.jsonb_set(result, '{GrantRoleStmt, admin_opt}', to_jsonb(admin_opt));
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grant_stmt ( objtype int, targtype int, is_grant boolean, grant_option boolean, privileges jsonb, objects jsonb, grantees jsonb, behavior int ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.select_stmt ( op int, relation jsonb, valueslist jsonb DEFAULT NULL, targetlist jsonb DEFAULT NULL, larg jsonb DEFAULT NULL, rarg jsonb DEFAULT NULL, vall boolean DEFAULT NULL, distinctclause jsonb DEFAULT NULL, intoclause jsonb DEFAULT NULL, fromclause jsonb DEFAULT NULL, groupclause jsonb DEFAULT NULL, whereclause jsonb DEFAULT NULL, sortclause jsonb DEFAULT NULL, limitcount jsonb DEFAULT NULL, limitoffset jsonb DEFAULT NULL, lockingclause jsonb DEFAULT NULL, windowclause jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.insert_stmt ( relation jsonb, cols jsonb DEFAULT NULL, selectstmt jsonb DEFAULT NULL, onconflictclause jsonb DEFAULT NULL, returninglist jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.update_stmt ( relation jsonb, targetlist jsonb, fromclause jsonb, whereclause jsonb, returninglist jsonb ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.join_expr ( larg jsonb, jointype int, rarg jsonb DEFAULT NULL, isnatural boolean DEFAULT NULL, quals jsonb DEFAULT NULL, usingclause jsonb DEFAULT NULL, alias jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.locking_clause ( strength int, lockedrels jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"LockingClause":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{LockingClause, strength}', to_jsonb(strength));
	result = ast.jsonb_set(result, '{LockingClause, lockedRels}', lockedRels);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.named_arg_expr ( name text, arg jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"NamedArgExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{NamedArgExpr, name}', to_jsonb(name));
	result = ast.jsonb_set(result, '{NamedArgExpr, arg}', arg);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.min_max_expr ( op int, args jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"MinMaxExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{MinMaxExpr, op}', to_jsonb(op));
	result = ast.jsonb_set(result, '{MinMaxExpr, args}', args);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.into_clause ( rel jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"IntoClause":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{IntoClause, rel}', rel);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.raw_stmt ( stmt jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RawStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{RawStmt, stmt}', stmt);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.rule_stmt ( rulename text, event int, relation jsonb, whereclause jsonb, actions jsonb ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_array_expr ( elements jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_ArrayExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{A_ArrayExpr, elements}', elements);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.bool_expr ( boolop int, args jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"BoolExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{BoolExpr, boolop}', to_jsonb(boolop));
	result = ast.jsonb_set(result, '{BoolExpr, args}', args);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.case_expr ( arg jsonb, args jsonb, defresult jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CaseExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CaseExpr, arg}', arg);
	result = ast.jsonb_set(result, '{CaseExpr, args}', args);
	result = ast.jsonb_set(result, '{CaseExpr, defresult}', defresult);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.case_when ( expr jsonb, res jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CaseWhen":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CaseWhen, result}', res);
	result = ast.jsonb_set(result, '{CaseWhen, expr}', expr);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.with_clause ( recur boolean, ctes jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"WithClause":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{WithClause, recursive}', to_jsonb(recur));
	result = ast.jsonb_set(result, '{WithClause, ctes}', ctes);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.composite_type_stmt ( typevar jsonb, coldeflist jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CompositeTypeStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CompositeTypeStmt, typevar}', typevar);
	result = ast.jsonb_set(result, '{CompositeTypeStmt, coldeflist}', coldeflist);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.sub_link ( sublinktype jsonb, subselect jsonb, testexpr jsonb, opername jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"SubLink":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{SubLink, subLinkType}', subLinkType);
	result = ast.jsonb_set(result, '{SubLink, subselect}', subselect);
	result = ast.jsonb_set(result, '{SubLink, testexpr}', testexpr);
	result = ast.jsonb_set(result, '{SubLink, operName}', operName);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.rename_stmt ( renametype int, relationtype int, relation jsonb, subname text, newname text ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.coalesce_expr ( args jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CoalesceExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CoalesceExpr, args}', args);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.constraint ( contype int, keys jsonb, raw_expr jsonb DEFAULT NULL, fk_del_action text DEFAULT 'a', fk_upd_action text DEFAULT 'a', fk_matchtype text DEFAULT NULL, is_no_inherit boolean DEFAULT NULL, skip_validation boolean DEFAULT NULL, vdeferrable boolean DEFAULT NULL, exclusions jsonb DEFAULT NULL, access_method boolean DEFAULT NULL, pk_attrs jsonb DEFAULT NULL, fk_attrs jsonb DEFAULT NULL, conname text DEFAULT NULL, pktable jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.collate_clause ( arg jsonb, collname jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CollateClause":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CollateClause, arg}', arg);
	result = ast.jsonb_set(result, '{CollateClause, collname}', collname);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.access_priv ( priv_name text, cols jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AccessPriv":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{AccessPriv, cols}', cols);
	result = ast.jsonb_set(result, '{AccessPriv, priv_name}', to_jsonb(priv_name));
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.variable_set_stmt ( kind int, is_local boolean, name text, args jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"VariableSetStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{VariableSetStmt, args}', args);
	result = ast.jsonb_set(result, '{VariableSetStmt, kind}', to_jsonb(kind));
	result = ast.jsonb_set(result, '{VariableSetStmt, is_local}', to_jsonb(is_local));
	result = ast.jsonb_set(result, '{VariableSetStmt, name}', to_jsonb(name));
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.boolean_test ( booltesttype int, arg jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"BooleanTest":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{BooleanTest, booltesttype}', to_jsonb(booltesttype));
	result = ast.jsonb_set(result, '{BooleanTest, arg}', arg);
  return result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.column_ref ( fields jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ColumnRef":{"fields":""}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{ColumnRef, fields}', fields);
  RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.common_table_expr ( ctename text, ctequery jsonb, aliascolnames jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CommonTableExpr":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CommonTableExpr, ctename}', to_jsonb(ctename));
	result = ast.jsonb_set(result, '{CommonTableExpr, ctequery}', ctequery);
	result = ast.jsonb_set(result, '{CommonTableExpr, aliascolnames}', aliascolnames);
  RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.comment_stmt ( objtype int, object jsonb, comment text, objargs jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CommentStmt":{"fields":""}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CommentStmt, objtype}', to_jsonb(objtype));
	result = ast.jsonb_set(result, '{CommentStmt, object}', object);
	result = ast.jsonb_set(result, '{CommentStmt, comment}', to_jsonb(comment));
	result = ast.jsonb_set(result, '{CommentStmt, objargs}', objargs);
  RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.column_def ( colname text, typename jsonb, constraints jsonb, collclause jsonb, raw_default jsonb ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.sql_value_function ( op int ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"SQLValueFunction":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{SQLValueFunction, op}', to_jsonb(op));
  RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grouping_func ( args jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"GroupingFunc":{"args":[]}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{GroupingFunc, args}', args);
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grouping_set ( kind int, content jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"GroupingSet":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{GroupingSet, kind}', to_jsonb(kind));
	  result = ast.jsonb_set(result, '{GroupingSet, content}', content);
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.index_stmt ( relation jsonb, indexparams jsonb DEFAULT NULL, whereclause jsonb DEFAULT NULL, uniq boolean DEFAULT NULL, idxname text DEFAULT NULL, concur boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.index_elem ( name text, expr jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"IndexElem":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{IndexElem, name}', to_jsonb(name));
	  result = ast.jsonb_set(result, '{IndexElem, expr}', expr);
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.func_call ( name text, args jsonb DEFAULT '[]'::jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"FuncCall":{"funcname":[{"String":{"str":""}}],"args":[]}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{FuncCall, funcname, 0, String, str}', to_jsonb(name));
	  result = ast.jsonb_set(result, '{FuncCall, args}', args);
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.func_call ( funcname jsonb, args jsonb DEFAULT '[]'::jsonb, func_variadic boolean DEFAULT NULL, agg_distinct boolean DEFAULT NULL, agg_within_group boolean DEFAULT NULL, agg_star boolean DEFAULT NULL, agg_filter jsonb DEFAULT NULL, agg_order jsonb DEFAULT NULL, vover jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.null (  ) RETURNS jsonb AS $EOFCODE$
BEGIN
  RETURN '{"Null":{}}'::jsonb;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.null_test ( nulltesttype int ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"NullTest":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{NullTest, nulltesttype}', to_jsonb(nulltesttype));
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_function ( vlateral boolean, functions jsonb, is_rowsfrom boolean, ordinality boolean, alias jsonb, coldeflist jsonb ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_subselect ( vlateral boolean, subquery jsonb, alias jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RangeFunction":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{RangeFunction, lateral}', to_jsonb(vlateral));
	  result = ast.jsonb_set(result, '{RangeFunction, subquery}', subquery);
	  result = ast.jsonb_set(result, '{RangeFunction, alias}', alias);
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.param_ref ( num int ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ParamRef":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{ParamRef, number}', to_jsonb(num));
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alias ( aliasname text, colnames jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"Alias":{}}'::jsonb;
BEGIN
	  result = ast.jsonb_set(result, '{Alias, aliasname}', to_jsonb(aliasname));
	  result = ast.jsonb_set(result, '{Alias, colnames}', colnames);
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.type_name ( names jsonb, isarray boolean DEFAULT (FALSE) ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.type_name ( names jsonb, vsetof boolean, typemods jsonb, arraybounds jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  result jsonb = '{"TypeName":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{TypeName, names}', names);
	result = ast.jsonb_set(result, '{TypeName, setof}', to_jsonb(vsetof));
	result = ast.jsonb_set(result, '{TypeName, typemods}', typemods);
	result = ast.jsonb_set(result, '{TypeName, arrayBounds}', arrayBounds);
  RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.type_cast ( arg jsonb, typename jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  result jsonb = '{"TypeCast":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{TypeCast, arg}', arg);
	result = ast.jsonb_set(result, '{TypeCast, typeName}', typename);
  RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.string ( str text ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"String":{"str":""}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{String, str}', to_jsonb(str));
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.integer ( ival int ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"Integer":{"ival":""}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{Integer, ival}', to_jsonb(ival));
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.def_elem ( defname text, arg jsonb, defaction int DEFAULT 0 ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DefElem":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{DefElem, defname}', to_jsonb(defname));
	result = ast.jsonb_set(result, '{DefElem, arg}', arg);
	result = ast.jsonb_set(result, '{DefElem, defaction}', to_jsonb(defaction));
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.do_stmt ( stmt text ) RETURNS jsonb AS $EOFCODE$
DECLARE
  -- seemed like this was the only pattern seen so far... so simplified it
  result jsonb = '{"DoStmt":{"args":[{"DefElem":{"arg":{"String":{"str":""}}}}]}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{DoStmt, args, 0, DefElem, arg, String, str}', to_jsonb(stmt));
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.float ( flt pg_catalog.float8 ) RETURNS jsonb AS $EOFCODE$
DECLARE
  result jsonb = '{"Float":{"str":""}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{Float, str}', to_jsonb(flt));
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_expr ( kind int, lexpr jsonb, op text, rexpr jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Expr":{"kind":0,"lexpr":{},"name":[],"rexpr":{}}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{A_Expr, kind}', to_jsonb(kind));
	result = ast.jsonb_set(result, '{A_Expr, lexpr}', lexpr);
	result = ast.jsonb_set(result, '{A_Expr, name, 0}', ast.string(op));
	result = ast.jsonb_set(result, '{A_Expr, rexpr}', rexpr);
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_expr ( kind int, lexpr jsonb, name jsonb, rexpr jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Expr":{"kind":0,"lexpr":{},"name":[],"rexpr":{}}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{A_Expr, kind}', to_jsonb(kind));
	result = ast.jsonb_set(result, '{A_Expr, lexpr}', lexpr);
	result = ast.jsonb_set(result, '{A_Expr, name}', name);
	result = ast.jsonb_set(result, '{A_Expr, rexpr}', rexpr);
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_trigger_stmt ( trigname text, relation jsonb, funcname jsonb, args jsonb, isrow bool, timing int, events int, whenclause jsonb, columns jsonb DEFAULT NULL, transitionrels jsonb DEFAULT NULL, isconstraint bool DEFAULT NULL, vdeferrable boolean DEFAULT NULL, initdeferred boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.function_parameter ( name text, argtype jsonb, mode int, defexpr jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"FunctionParameter":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{FunctionParameter, name}', to_jsonb(name));
	result = ast.jsonb_set(result, '{FunctionParameter, argType}', argType);
	result = ast.jsonb_set(result, '{FunctionParameter, defexpr}', defexpr);
	result = ast.jsonb_set(result, '{FunctionParameter, mode}', to_jsonb(mode));

	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_function_stmt ( funcname jsonb, parameters jsonb, returntype jsonb, options jsonb, repl boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_domain_stmt ( domainname jsonb, typename jsonb, constraints jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateDomainStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CreateDomainStmt, domainname}', domainname);
	result = ast.jsonb_set(result, '{CreateDomainStmt, typeName}', typeName);
	result = ast.jsonb_set(result, '{CreateDomainStmt, constraints}', constraints);
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.role_spec ( roletype int, rolename text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RoleSpec":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{RoleSpec, roletype}', to_jsonb(roletype));
	result = ast.jsonb_set(result, '{RoleSpec, rolename}', to_jsonb(rolename));
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.view_stmt ( view jsonb, query jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ViewStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{ViewStmt, view}', view);
	result = ast.jsonb_set(result, '{ViewStmt, query}', query);
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_table_as_stmt ( vinto jsonb, query jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateTableAsStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CreateTableAsStmt, into}', vinto);
	result = ast.jsonb_set(result, '{CreateTableAsStmt, query}', query);
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_stmt ( relation jsonb, tableelts jsonb, options jsonb, inhrelations jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CreateStmt, relation}', relation);
	result = ast.jsonb_set(result, '{CreateStmt, tableElts}', tableElts);
	result = ast.jsonb_set(result, '{CreateStmt, inhRelations}', inhRelations);
	result = ast.jsonb_set(result, '{CreateStmt, options}', options);
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_seq_stmt ( seq jsonb, options jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateSeqStmt":{}}'::jsonb;
BEGIN
	result = ast.jsonb_set(result, '{CreateSeqStmt, sequence}', seq);
	result = ast.jsonb_set(result, '{CreateSeqStmt, options}', options);
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_policy_stmt ( policy_name text, tbl jsonb, roles jsonb, qual jsonb, cmd_name text, with_check jsonb, permissive boolean ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.coalesce ( field text, value text DEFAULT '' ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = ast.func_call('coalesce', to_jsonb(ARRAY[ ast.string(''), ast.a_const('') ]));
BEGIN
	result = jsonb_set(result, '{FuncCall, args, 0, String, str}', to_jsonb(field));
	result = jsonb_set(result, '{FuncCall, args, 1, A_Const, String, str}', to_jsonb(value));
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.coalesce ( field jsonb, value text DEFAULT '' ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = ast.func_call('coalesce', to_jsonb(ARRAY[ ast.string(''), ast.a_const('') ]));
BEGIN
	result = jsonb_set(result, '{FuncCall, args, 0}', field);
	result = jsonb_set(result, '{FuncCall, args, 1, A_Const, String, str}', to_jsonb(value));
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.tsvectorw ( input jsonb, weight text DEFAULT 'A' ) RETURNS jsonb AS $EOFCODE$
BEGIN
	RETURN ast.func_call('setweight', to_jsonb(ARRAY[input, ast.a_const(weight)]));
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.tsvector ( input jsonb ) RETURNS jsonb AS $EOFCODE$
BEGIN
	RETURN ast.func_call('to_tsvector', to_jsonb(ARRAY[input]));
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.simple_param ( name text, type text ) RETURNS jsonb AS $EOFCODE$
BEGIN
	RETURN ast.function_parameter(
      name,
      ast.type_name( to_jsonb(ARRAY[ast.string(type)]), false ),
      105
    );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.simple_param ( name text, type text, default_value text ) RETURNS jsonb AS $EOFCODE$
BEGIN
	RETURN ast.function_parameter(
      name,
      ast.type_name( to_jsonb(ARRAY[ast.string(type)]), false ),
      105,
      ast.string(default_value)
    );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.simple_param ( name text, type text, default_value jsonb ) RETURNS jsonb AS $EOFCODE$
BEGIN
	RETURN ast.function_parameter(
      name,
      ast.type_name( to_jsonb(ARRAY[ast.string(type)]), false ),
      105,
      default_value
    );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.tsvector ( lang text, input jsonb ) RETURNS jsonb AS $EOFCODE$
BEGIN
	RETURN ast.func_call('to_tsvector', to_jsonb(ARRAY[ast.a_const(lang), input]));
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.a_expr_distinct_tg_field ( field text ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.tsvector_index ( fields jsonb ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.create_trigger_with_fields ( trigger_name text, schema_name text, table_name text, trigger_fn_schema text, trigger_fn_name text, fields text[], timing int DEFAULT 2, events int DEFAULT ((4) | (16)) ) RETURNS jsonb AS $EOFCODE$
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
    NULL,
    true,
    timing,
    events,
    whenClause
  );


	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.create_function ( schema text, name text, type text, parameters jsonb, body text, vol text, lan text, sec int ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.create_policy ( name text, vschema text, vtable text, vrole text, qual jsonb, cmd text, with_check jsonb, permissive boolean ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast jsonb;
BEGIN
  select * FROM ast.create_policy_stmt(
    name,
    ast.range_var(vschema, vtable, true, 'p'),
    to_jsonb(ARRAY[
        ast.role_spec(0, vrole)
    ]),
    qual,
    cmd,
    with_check,
    permissive
  ) INTO ast;
  RETURN ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE SCHEMA ast_utils;

CREATE FUNCTION ast_utils.interval ( n int ) RETURNS text[] AS $EOFCODE$
	select (CASE 
WHEN ( n = 2 ) THEN ARRAY[ 'month' ]
WHEN ( n = 4 ) THEN ARRAY[ 'year' ]
WHEN ( n = 6 ) THEN ARRAY[ 'year', 'month' ]
WHEN ( n = 8 ) THEN ARRAY[ 'day' ]
WHEN ( n = 1024 ) THEN ARRAY[ 'hour' ]
WHEN ( n = 1032 ) THEN ARRAY[ 'day', 'hour' ]
WHEN ( n = 2048 ) THEN ARRAY[ 'minute' ]
WHEN ( n = 3072 ) THEN ARRAY[ 'hour', 'minute' ]
WHEN ( n = 3080 ) THEN ARRAY[ 'day', 'minute' ]
WHEN ( n = 4096 ) THEN ARRAY[ 'second' ]
WHEN ( n = 6144 ) THEN ARRAY[ 'minute', 'second' ]
WHEN ( n = 7168 ) THEN ARRAY[ 'hour', 'second' ]
WHEN ( n = 7176 ) THEN ARRAY[ 'day', 'second' ]
WHEN ( n = 32767 ) THEN ARRAY[]::text[]
END);
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_utils.reserved ( str text ) RETURNS boolean AS $EOFCODE$
	select exists( select 1 from pg_get_keywords() where catcode = 'R' AND word=str  );
$EOFCODE$ LANGUAGE sql SECURITY DEFINER;

CREATE FUNCTION ast_utils.objtypes (  ) RETURNS text[] AS $EOFCODE$
	select ARRAY[ 'ACCESS METHOD', 'AGGREGATE', NULL, NULL, NULL, 'CAST', 'COLUMN', 'COLLATION', 'CONVERSION', 'DATABASE', NULL, NULL, 'DOMAIN', 'CONSTRAINT', NULL, 'EXTENSION', 'FOREIGN DATA WRAPPER', 'SERVER', 'FOREIGN TABLE', 'FUNCTION', 'INDEX', 'LANGUAGE', 'LARGE OBJECT', 'MATERIALIZED VIEW', 'OPERATOR CLASS', 'OPERATOR', 'OPERATOR FAMILY', 'POLICY', NULL, NULL, 'ROLE', 'RULE', 'SCHEMA', 'SEQUENCE', NULL, 'STATISTICS', 'CONSTRAINT', 'TABLE', 'TABLESPACE', 'TRANSFORM', 'TRIGGER', 'TEXT SEARCH CONFIGURATION', 'TEXT SEARCH DICTIONARY', 'TEXT SEARCH PARSER', 'TEXT SEARCH TEMPLATE', 'TYPE', NULL, 'VIEW' ]::text[];
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_utils.constrainttype_idxs ( typ text ) RETURNS int AS $EOFCODE$
  select (CASE
WHEN (typ = 'CONSTR_NULL') THEN 0
WHEN (typ = 'CONSTR_NOTNULL') THEN 1
WHEN (typ = 'CONSTR_DEFAULT') THEN 2
WHEN (typ = 'CONSTR_IDENTITY') THEN 3
WHEN (typ = 'CONSTR_CHECK') THEN 4
WHEN (typ = 'CONSTR_PRIMARY') THEN 5
WHEN (typ = 'CONSTR_UNIQUE') THEN 6
WHEN (typ = 'CONSTR_EXCLUSION') THEN 7
WHEN (typ = 'CONSTR_FOREIGN') THEN 8
WHEN (typ = 'CONSTR_ATTR_DEFERRABLE') THEN 9
WHEN (typ = 'CONSTR_ATTR_NOT_DEFERRABLE') THEN 10
WHEN (typ = 'CONSTR_ATTR_DEFERRED') THEN 11
WHEN (typ = 'CONSTR_ATTR_IMMEDIATE') THEN 12
END);
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_utils.constrainttypes ( contype int ) RETURNS text AS $EOFCODE$
  select (CASE
WHEN (contype =  0 ) THEN 'NULL'
WHEN (contype =  1 ) THEN 'NOT NULL'
WHEN (contype =  2 ) THEN 'DEFAULT'
WHEN (contype =  4 ) THEN 'CHECK'
WHEN (contype =  5 ) THEN 'PRIMARY KEY'
WHEN (contype =  6 ) THEN 'UNIQUE'
WHEN (contype =  7 ) THEN 'EXCLUDE'
WHEN (contype =  8 ) THEN 'REFERENCES'
END);
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_utils.objtypes_idxs ( typ text ) RETURNS int AS $EOFCODE$
	select (CASE
WHEN (typ = 'OBJECT_ACCESS_METHOD') THEN 0
WHEN (typ = 'OBJECT_AGGREGATE') THEN 1
WHEN (typ = 'OBJECT_AMOP') THEN 2
WHEN (typ = 'OBJECT_AMPROC') THEN 3
WHEN (typ = 'OBJECT_ATTRIBUTE') THEN 4
WHEN (typ = 'OBJECT_CAST') THEN 5
WHEN (typ = 'OBJECT_COLUMN') THEN 6
WHEN (typ = 'OBJECT_COLLATION') THEN 7
WHEN (typ = 'OBJECT_CONVERSION') THEN 8
WHEN (typ = 'OBJECT_DATABASE') THEN 9
WHEN (typ = 'OBJECT_DEFAULT') THEN 10
WHEN (typ = 'OBJECT_DEFACL') THEN 11
WHEN (typ = 'OBJECT_DOMAIN') THEN 12
WHEN (typ = 'OBJECT_DOMCONSTRAINT') THEN 13
WHEN (typ = 'OBJECT_EVENT_TRIGGER') THEN 14
WHEN (typ = 'OBJECT_EXTENSION') THEN 15
WHEN (typ = 'OBJECT_FDW') THEN 16
WHEN (typ = 'OBJECT_FOREIGN_SERVER') THEN 17
WHEN (typ = 'OBJECT_FOREIGN_TABLE') THEN 18
WHEN (typ = 'OBJECT_FUNCTION') THEN 19
WHEN (typ = 'OBJECT_INDEX') THEN 20
WHEN (typ = 'OBJECT_LANGUAGE') THEN 21
WHEN (typ = 'OBJECT_LARGEOBJECT') THEN 22
WHEN (typ = 'OBJECT_MATVIEW') THEN 23
WHEN (typ = 'OBJECT_OPCLASS') THEN 24
WHEN (typ = 'OBJECT_OPERATOR') THEN 25
WHEN (typ = 'OBJECT_OPFAMILY') THEN 26
WHEN (typ = 'OBJECT_POLICY') THEN 27
WHEN (typ = 'OBJECT_PUBLICATION') THEN 28
WHEN (typ = 'OBJECT_PUBLICATION_REL') THEN 29
WHEN (typ = 'OBJECT_ROLE') THEN 30
WHEN (typ = 'OBJECT_RULE') THEN 31
WHEN (typ = 'OBJECT_SCHEMA') THEN 32
WHEN (typ = 'OBJECT_SEQUENCE') THEN 33
WHEN (typ = 'OBJECT_SUBSCRIPTION') THEN 34
WHEN (typ = 'OBJECT_STATISTIC_EXT') THEN 35
WHEN (typ = 'OBJECT_TABCONSTRAINT') THEN 36
WHEN (typ = 'OBJECT_TABLE') THEN 37
WHEN (typ = 'OBJECT_TABLESPACE') THEN 38
WHEN (typ = 'OBJECT_TRANSFORM') THEN 39
WHEN (typ = 'OBJECT_TRIGGER') THEN 40
WHEN (typ = 'OBJECT_TSCONFIGURATION') THEN 41
WHEN (typ = 'OBJECT_TSDICTIONARY') THEN 42
WHEN (typ = 'OBJECT_TSPARSER') THEN 43
WHEN (typ = 'OBJECT_TSTEMPLATE') THEN 44
WHEN (typ = 'OBJECT_TYPE') THEN 45
WHEN (typ = 'OBJECT_USER_MAPPING') THEN 46
WHEN (typ = 'OBJECT_VIEW') THEN 47
END);
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_utils.getgrantobject ( node jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  objtype int;
  targtype int;
BEGIN 

  objtype = (node->'objtype')::int;
  IF (node->'targtype') IS NOT NULL THEN
    targtype = (node->'targtype')::int;
  END IF;

  IF (objtype = 0) THEN
    RETURN 'COLUMN';
  ELSIF (objtype = 1) THEN
    IF (targtype = 1) THEN 
      RETURN 'ALL TABLES IN SCHEMA';
    ELSIF (targtype = 2) THEN 
      RETURN 'TABLES';
    END IF;
    -- TODO could be a view
    RETURN 'TABLE';
  ELSIF (objtype = 2) THEN
    RETURN 'SEQUENCE';
  ELSIF (objtype = 3) THEN
    RETURN 'DATABASE';
  ELSIF (objtype = 4) THEN
    RETURN 'DOMAIN';
  ELSIF (objtype = 5) THEN
    RETURN 'FOREIGN DATA WRAPPER';
  ELSIF (objtype = 6) THEN
    RETURN 'FOREIGN SERVER';
  ELSIF (objtype = 7) THEN
    IF (targtype = 1) THEN 
      RETURN 'ALL FUNCTIONS IN SCHEMA';
    ELSIF (targtype = 2) THEN 
      RETURN 'FUNCTIONS';
    END IF;
    RETURN 'FUNCTION';
  ELSIF (objtype = 8) THEN
    RETURN 'LANGUAGE';
  ELSIF (objtype = 9) THEN
    RETURN 'LARGE OBJECT';
  ELSIF (objtype = 10) THEN
    RETURN 'SCHEMA';
  ELSIF (objtype = 11) THEN
    RETURN 'TABLESPACE';
  ELSIF (objtype = 12) THEN
    RETURN 'TYPE';
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION %', 'GrantObjectType';

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE SCHEMA deparser;

CREATE FUNCTION deparser.parens ( str text ) RETURNS text AS $EOFCODE$
	select '(' || str || ')';
$EOFCODE$ LANGUAGE sql;

CREATE FUNCTION deparser.compact ( vvalues text[], usetrim boolean DEFAULT (FALSE) ) RETURNS text[] AS $EOFCODE$
DECLARE
  value text;
  filtered text[];
BEGIN
  FOREACH value IN array vvalues
    LOOP
        IF (usetrim IS TRUE) THEN 
          IF (value IS NOT NULL AND character_length (trim(value)) > 0) THEN 
            filtered = array_append(filtered, value);
          END IF;
        ELSE
          IF (value IS NOT NULL AND character_length (value) > 0) THEN 
            filtered = array_append(filtered, value);
          END IF;
        END IF;
    END LOOP;
  RETURN filtered;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.deparse_interval ( node jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  typ text[];
  typmods text[];
  intervals text[];
  out text[];
  invl text;
BEGIN
  typ = array_append(typ, 'interval');

  IF (node->'arrayBounds' IS NOT NULL) THEN 
    typ = array_append(typ, '[]');
  END IF;

  IF (node->'typmods' IS NOT NULL) THEN 
    typmods = deparser.expressions_array(node->'typmods');
    intervals = ast_utils.interval(typmods[1]::int);

    IF (
      node->'typmods'->0 IS NOT NULL AND
      node->'typmods'->0->'A_Const' IS NOT NULL AND
      node->'typmods'->0->'A_Const'->'val'->'Integer'->'ival' IS NOT NULL AND
      (node->'typmods'->0->'A_Const'->'val'->'Integer'->'ival')::int = 32767 AND
      node->'typmods'->1 IS NOT NULL AND
      node->'typmods'->1->'A_Const' IS NOT NULL 
    ) THEN 
      intervals = ARRAY[
        deparser.parens(node->'typmods'->1->'A_Const'->'val'->'Integer'->>'ival')
      ]::text[];
      typ = array_append(typ, array_to_string(intervals, ' to '));
    ELSE 
      FOREACH invl IN ARRAY intervals 
      LOOP
        out = array_append(out, (
          CASE 
            WHEN (invl = 'second' AND cardinality(typmods) = 2) THEN 'second(' || typemods[2] || ')'
            ELSE invl
          END
        ));
      END LOOP;
      typ = array_append(typ, array_to_string(out, ' to '));
    END IF;
  END IF;

  RETURN array_to_string(typ, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.get_pgtype ( typ text, typemods text ) RETURNS text AS $EOFCODE$
SELECT (CASE
WHEN (typ = 'bpchar') THEN
        (CASE
            WHEN (typemods IS NOT NULL) THEN 'char'
            ELSE 'pg_catalog.bpchar'
        END)
WHEN (typ = 'varchar') THEN 'varchar'
WHEN (typ = 'numeric') THEN 'numeric'
WHEN (typ = 'bool') THEN 'boolean'
WHEN (typ = 'int2') THEN 'smallint'
WHEN (typ = 'int4') THEN 'int'
WHEN (typ = 'int8') THEN 'bigint'
WHEN (typ = 'real') THEN 'real'
WHEN (typ = 'float4') THEN 'real'
WHEN (typ = 'float8') THEN 'pg_catalog.float8'
WHEN (typ = 'text') THEN 'text'
WHEN (typ = 'date') THEN 'pg_catalog.date'
WHEN (typ = 'time') THEN 'time'
WHEN (typ = 'timetz') THEN 'pg_catalog.timetz'
WHEN (typ = 'timestamp') THEN 'timestamp'
WHEN (typ = 'timestamptz') THEN 'pg_catalog.timestamptz'
WHEN (typ = 'interval') THEN 'interval'
WHEN (typ = 'bit') THEN 'bit'
ELSE typ
END);
$EOFCODE$ LANGUAGE sql;

CREATE FUNCTION deparser.parse_type ( names jsonb, typemods text ) RETURNS text AS $EOFCODE$
DECLARE
  parsed text[];
  catalog text;
  typ text;
BEGIN
  parsed = deparser.expressions_array(names);
  catalog = parsed[1];
  typ = parsed[2];

  IF (names->0->'String'->>'str' = 'char' ) THEN 
    	names = jsonb_set(names, '{0, String, str}', '"char"');
  END IF;

  IF (catalog != 'pg_catalog') THEN 
    IF (typemods IS NOT NULL AND character_length(typemods) > 0) THEN 
      RETURN deparser.quoted_name(names, 'type') || deparser.parens(typemods);
    ELSE
      RETURN deparser.quoted_name(names, 'type');
    END IF;
  END IF;

  typ = deparser.get_pgtype(typ, typemods);
  IF (typemods IS NOT NULL AND character_length(typemods) > 0) THEN 
    RETURN typ || deparser.parens(typemods);
  ELSE
    RETURN typ;
  END IF;

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.type_name ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[] = ARRAY[]::text[];
  typemods text;
  lastname jsonb;
  typ text[];
BEGIN
    IF (node->'TypeName') IS NULL THEN  
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'TypeName';
    END IF;

    node = node->'TypeName';

    IF (node->'names') IS NULL THEN  
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'TypeName';
    END IF;

    lastname = node->'names'->>-1;

    IF (deparser.expression(lastname) = 'interval') THEN 
      RETURN deparser.deparse_interval(node);
    END IF;

    IF (node->'setof') IS NOT NULL THEN
      output = array_append(output, 'SETOF');
    END IF;

    IF (node->'typmods') IS NOT NULL THEN
      typemods = deparser.list(node->'typmods');
    END IF;

    typ = array_append(typ, deparser.parse_type(
      node->'names',
      typemods
      -- context
    ));

    IF (node->'arrayBounds') IS NOT NULL THEN
      typ = array_append(typ, '[]');
    END IF;

    output = array_append(output, array_to_string(typ, ''));

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.type_cast ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  type text;
  arg text;
BEGIN
    IF (node->'TypeCast') IS NULL THEN  
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'TypeCast';
    END IF;

    node = node->'TypeCast';

    IF (node->'typeName') IS NULL THEN  
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'TypeCast';
    END IF;

    type = deparser.expression(node->'typeName', context);
    arg = deparser.expression(node->'arg', context);
    IF (type = 'boolean') THEN
      IF (arg = 'f') THEN
        RETURN '(FALSE)';
      ELSEIF (arg = 't') THEN
        RETURN '(TRUE)';
      END IF;
    END IF;

    RETURN format('%s::%s', arg, type);    
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.returning_list ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  rets text[];
  item jsonb;
  name text;
BEGIN
  IF (node->'returningList' IS NOT NULL) THEN 
    output = array_append(output, 'RETURNING');
    FOR item IN
    SELECT * FROM jsonb_array_elements(node->'returningList')
    LOOP 

      IF (item->'ResTarget'->'name' IS NOT NULL) THEN 
        name = ' AS ' || quote_ident(item->'ResTarget'->>'name');
      ELSE 
        name = '';
      END IF;

      rets = array_append(rets, 
        deparser.expression(item->'ResTarget'->'val')
      ) || name;

    END LOOP;

    output = array_append(output, array_to_string(deparser.compact(rets, true), ', '));

  END IF;

  RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.range_var ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
    
BEGIN
    IF (node->'RangeVar') IS NULL THEN  
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RangeVar';
    END IF;

    node = node->'RangeVar';

    -- TODO why have both inhOpt AND inh?
    -- seems like it's worth researching

    IF ((node->'inhOpt')::int = 0) THEN
      output = array_append(output, 'ONLY');
    END IF;

    IF ((node->'inh')::bool = FALSE) THEN
      output = array_append(output, 'ONLY');
    END IF;

    IF ((node->'relpersistence')::text = 'u') THEN
      output = array_append(output, 'UNLOGGED');
    END IF;

    IF ((node->'relpersistence')::text = 't') THEN
      output = array_append(output, 'TEMPORARY TABLE');
    END IF;

    IF (node->'schemaname') IS NOT NULL THEN
      output = array_append(output, quote_ident(node->>'schemaname') || '.' || quote_ident(node->>'relname'));
    ELSE
      output = array_append(output, quote_ident(node->>'relname'));
    END IF;

    IF (node->'alias') IS NOT NULL THEN
      output = array_append(output, deparser.expression(node->'alias', context));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_between ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  right_expr text;
  right_expr2 text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr'->0, context);
  right_expr2 = deparser.expression(expr->'rexpr'->1, context);

  IF ((expr->>'kind')::int = 11) THEN
    RETURN format('%s BETWEEN %s AND %s', left_expr, right_expr, right_expr2);
  ELSE 
    RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_BETWEEN)', 'A_Expr';
  END IF;

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_not_between ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  right_expr text;
  right_expr2 text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr'->0, context);
  right_expr2 = deparser.expression(expr->'rexpr'->1, context);

  IF ((expr->>'kind')::int = 12) THEN
    RETURN format('%s NOT BETWEEN %s AND %s', left_expr, right_expr, right_expr2);
  ELSE
    RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_NOT_BETWEEN)', 'A_Expr';
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_similar ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
  right_expr2 text;
BEGIN
  IF (expr->'name') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_SIMILAR)', 'A_Expr';
  END IF;

  left_expr = deparser.expression(expr->'lexpr', context);
  operator = deparser.expression(expr->'name'->0, context);

  IF ((expr->>'kind')::int = 10) THEN
    -- AEXPR_SIMILAR
    IF (operator = '!~') THEN
      IF (expr->'rexpr'->'FuncCall'->'args'->1->'Null') IS NOT NULL THEN
        SELECT deparser.expression(expr->'rexpr'->'FuncCall'->'args'->0, context) INTO right_expr;
        RETURN format('%s NOT SIMILAR TO %s', left_expr, right_expr);
      ELSE 
        SELECT deparser.expression(expr->'rexpr'->'FuncCall'->'args'->0, context) INTO right_expr;
        SELECT deparser.expression(expr->'rexpr'->'FuncCall'->'args'->1, context) INTO right_expr2;
        RETURN format('%s NOT SIMILAR TO %s ESCAPE %s', left_expr, right_expr, right_expr2);
      END IF;
    ELSE
      IF (expr->'rexpr'->'FuncCall'->'args'->1->'Null') IS NOT NULL THEN
        SELECT deparser.expression(expr->'rexpr'->'FuncCall'->'args'->0, context) INTO right_expr;
        RETURN format('%s SIMILAR TO %s', left_expr, right_expr);
      ELSE 
        SELECT deparser.expression(expr->'rexpr'->'FuncCall'->'args'->0, context) INTO right_expr;
        SELECT deparser.expression(expr->'rexpr'->'FuncCall'->'args'->1, context) INTO right_expr2;
        RETURN format('%s SIMILAR TO %s ESCAPE %s', left_expr, right_expr, right_expr2);
      END IF;
    END IF;
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_SIMILAR)', 'A_Expr';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_ilike ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  IF (expr->'name') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_ILIKE)', 'A_Expr';
  END IF;

  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);
  operator = deparser.expression(expr->'name'->0);

  IF ((expr->>'kind')::int = 9) THEN
    -- AEXPR_ILIKE
    IF (operator = '!~~*') THEN
      RETURN format('%s %s ( %s )', left_expr, 'NOT ILIKE', right_expr);
    ELSE
      RETURN format('%s %s ( %s )', left_expr, 'ILIKE', right_expr);
    END IF;
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_ILIKE)', 'A_Expr';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_like ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);

  IF ((expr->>'kind')::int = 8) THEN
    -- AEXPR_LIKE
    IF (operator = '!~~') THEN
      RETURN format('%s %s ( %s )', left_expr, 'NOT LIKE', right_expr);
    ELSE
      RETURN format('%s %s ( %s )', left_expr, 'LIKE', right_expr);
    END IF;
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_LIKE)', 'A_Expr';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_of ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  IF (expr->'name') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_OF)', 'A_Expr';
  END IF;

  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.list(expr->'rexpr', ', ', context);
  operator = deparser.expression(expr->'name'->0, context);

  IF ((expr->>'kind')::int = 5) THEN
    -- AEXPR_OF
    IF (operator = '=') THEN
      RETURN format('%s %s ( %s )', left_expr, 'IS OF', right_expr);
    ELSE
      RETURN format('%s %s ( %s )', left_expr, 'IS NOT OF', right_expr);
    END IF;
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_OF)', 'A_Expr';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_in ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  IF (expr->'name') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_IN)', 'A_Expr';
  END IF;

  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.list(expr->'rexpr', ', ', context);
  operator = deparser.expression(expr->'name'->0, context);
  
  IF ((expr->>'kind')::int = 6) THEN
    -- AEXPR_IN
    IF (operator = '=') THEN
      RETURN format('%s %s ( %s )', left_expr, 'IN', right_expr);
    ELSE
      RETURN format('%s %s ( %s )', left_expr, 'NOT IN', right_expr);
    END IF;
  ELSEIF ((expr->>'kind')::int = 7) THEN
    -- AEXPR_IN
    IF (operator = '<>') THEN
      RETURN format('%s %s ( %s )', left_expr, 'NOT IN', right_expr);
    ELSE
      RETURN format('%s %s ( %s )', left_expr, 'IN', right_expr);
    END IF;
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_IN)', 'A_Expr';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_nullif ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  right_expr text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);

  IF ((expr->>'kind')::int = 4) THEN
    -- AEXPR_NULLIF
    RETURN format('NULLIF(%s, %s)', left_expr, right_expr);
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_NULLIF)', 'A_Expr';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_op ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  operator text;
  schemaname text;
  right_expr text;
  output text[];
BEGIN
  IF (expr->'name') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_OP)', 'A_Expr';
  END IF;

  IF (expr->'lexpr' IS NOT NULL) THEN
    left_expr = deparser.expression(expr->'lexpr', context);
    output = array_append(output, left_expr);
  END IF;

  IF ((expr->>'kind')::int != 0) THEN
    -- AEXPR_OP
    RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_OP)', 'A_Expr';
  END IF;

  IF (jsonb_array_length(expr->'name') > 1) THEN 
    schemaname = deparser.expression(expr->'name'->0);
    operator = deparser.expression(expr->'name'->1);
    output = array_append(output, 
      'OPERATOR' ||
      '(' ||
      quote_ident(schemaname) ||
      '.' ||
      operator ||
      ')'
    );
  ELSE
    operator = deparser.expression(expr->'name'->0);
    output = array_append(output, operator);
  END IF;

  IF (expr->'rexpr' IS NOT NULL) THEN
    right_expr = deparser.expression(expr->'rexpr', context);
    output = array_append(output, right_expr);
  END IF;

  IF (cardinality(output) = 2) THEN 
    RETURN deparser.parens(array_to_string(output, ''));
  END IF;

  RETURN deparser.parens(array_to_string(output, ' '));

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_op_any ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  IF (expr->'name') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_OP_ANY)', 'A_Expr';
  END IF;

  IF ((expr->>'kind')::int != 1) THEN
    -- AEXPR_OP_ANY
    RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_OP_ANY)', 'A_Expr';
  END IF;

  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);
  operator = deparser.expression(expr->'name'->0);

  RETURN format('%s %s ANY( %s )', left_expr, operator, right_expr);

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_op_all ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  IF (expr->'name') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
  END IF;

  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);
  operator = deparser.expression(expr->'name'->0);

  IF ((expr->>'kind')::int != 2) THEN
    -- AEXPR_OP_ALL
    RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_OP_ALL)', 'A_Expr';
  END IF;

  RETURN format('%s %s ALL( %s )', left_expr, operator, right_expr);

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_distinct ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);

  IF ((expr->>'kind')::int = 3) THEN
    -- AEXPR_DISTINCT
    RETURN format('%s IS DISTINCT FROM %s', left_expr, right_expr);
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_DISTINCT)', 'A_Expr';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  kind int;
BEGIN

  IF (expr->>'A_Expr') IS NULL THEN  
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
  END IF;

  expr = expr->'A_Expr';

  IF (expr->'lexpr') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
  END IF;
  IF (expr->'rexpr') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
  END IF;
  IF (expr->'kind') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
  END IF;

  kind = (expr->>'kind')::int;

  IF (kind = 0) THEN
    -- AEXPR_OP
    RETURN deparser.a_expr_op(expr, context);
  ELSEIF (kind = 1) THEN
    -- AEXPR_OP_ANY
    RETURN deparser.a_expr_op_any(expr, context);
  ELSEIF (kind = 2) THEN
    -- AEXPR_OP_ALL
    RETURN deparser.a_expr_op_all(expr, context);
  ELSEIF (kind = 3) THEN
    -- AEXPR_DISTINCT
    RETURN deparser.a_expr_distinct(expr, context);
  ELSEIF (kind = 4) THEN
    -- AEXPR_NULLIF
    RETURN deparser.a_expr_nullif(expr, context);
  ELSEIF (kind = 5) THEN
    -- AEXPR_OF
    RETURN deparser.a_expr_of(expr, context);
  ELSEIF (kind = 6) THEN
    -- AEXPR_IN
    RETURN deparser.a_expr_in(expr, context);
  ELSEIF (kind = 7) THEN
    -- AEXPR_IN
    RETURN deparser.a_expr_in(expr, context);
  ELSEIF (kind = 8) THEN
    -- AEXPR_LIKE
    RETURN deparser.a_expr_like(expr, context);
  ELSEIF (kind = 9) THEN
    -- AEXPR_ILIKE
    RETURN deparser.a_expr_ilike(expr, context);
  ELSEIF (kind = 10) THEN
    -- AEXPR_SIMILAR
    RETURN deparser.a_expr_similar(expr, context);
  ELSEIF (kind = 11) THEN
    -- AEXPR_BETWEEN
    RETURN deparser.a_expr_between(expr, context);
  ELSEIF (kind = 12) THEN
    -- AEXPR_NOT_BETWEEN
    RETURN deparser.a_expr_not_between(expr, context);
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.bool_expr ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  txt text[];
BEGIN

  IF (node->>'BoolExpr') IS NULL THEN  
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'BoolExpr';
  END IF;

  node = node->'BoolExpr';

  IF (node->'boolop') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'BoolExpr';
  END IF;
  IF (node->'args') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'BoolExpr';
  END IF;
 
  IF ((node->>'boolop')::int = 2) THEN
    RETURN format('NOT IN (%s)', deparser.expression(node->'args'->0, context));
  END IF;

  txt = deparser.expressions_array(node->'args', context);

  IF ((node->>'boolop')::int = 0) THEN
    RETURN format('(%s)', array_to_string(txt, ' AND '));
  ELSEIF ((node->>'boolop')::int = 1) THEN
    RETURN format('(%s)', array_to_string(txt, ' OR '));
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION %', 'BoolExpr';

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.column_ref ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  txt text;
BEGIN

  IF (node->'ColumnRef') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'ColumnRef';
  END IF;

  IF (node->'ColumnRef'->>'fields') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'ColumnRef';
  END IF;

  IF (context IS NULL) THEN 
    context = 'column';
  END IF;

  RETURN deparser.list(node->'ColumnRef'->'fields', '.', context);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.explain_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
BEGIN

  IF (node->'ExplainStmt') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'ExplainStmt';
  END IF;

  IF (node->'ExplainStmt'->'query') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'ExplainStmt';
  END IF;

  RETURN 'EXPLAIN' || ' ' || deparser.expression(node->'ExplainStmt'->'query');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.collate_clause ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN

  IF (node->'CollateClause') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'CollateClause';
  END IF;

  node = node->'CollateClause';

  IF (node->'arg' IS NOT NULL) THEN 
    output = array_append(output, deparser.expression(node->'arg'));
  END IF;

  output = array_append(output, 'COLLATE');

  IF (node->'collname' IS NOT NULL) THEN 
    output = array_append(output, deparser.list_quotes(node->'collname'));
  END IF;

  RETURN array_to_string(output, ' ');

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_array_expr ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
BEGIN

  IF (node->'A_ArrayExpr') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_ArrayExpr';
  END IF;

  IF (node->'A_ArrayExpr'->'elements') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_ArrayExpr';
  END IF;

  node = node->'A_ArrayExpr';

  RETURN format('ARRAY[%s]', deparser.list(node->'elements'));
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.column_def ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN

  IF (node->'ColumnDef') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'ColumnDef';
  END IF;

  IF (node->'ColumnDef'->'colname') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (colname)', 'ColumnDef';
  END IF;

  IF (node->'ColumnDef'->'typeName') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (typeName)', 'ColumnDef';
  END IF;

  node = node->'ColumnDef';

  output = array_append(output, quote_ident(node->>'colname'));
  output = array_append(output, deparser.expression(node->'typeName', context));

  IF (node->'raw_default') IS NOT NULL THEN
    output = array_append(output, 'USING');
    output = array_append(output, deparser.expression(node->'raw_default', context));
  END IF;

  IF (node->'constraints') IS NOT NULL THEN
    output = array_append(output, deparser.list(node->'constraints', ' ', context));
  END IF;

  IF (node->'collClause') IS NOT NULL THEN
    output = array_append(output, 'COLLATE');
    output = array_append(output, quote_ident(node->'collClause'->'CollateClause'->'collname'->0->'String'->>'str'));
  END IF;

  RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.sql_value_function ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  op int;
BEGIN

  IF (node->'SQLValueFunction') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'SQLValueFunction';
  END IF;

  IF (node->'SQLValueFunction'->'op') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (op)', 'SQLValueFunction';
  END IF;

  node = node->'SQLValueFunction';
  op = (node->'op')::int;

  IF (op = 0) THEN
    RETURN 'CURRENT_DATE';
  ELSIF (op = 3) THEN
    RETURN 'CURRENT_TIMESTAMP';
  ELSIF (op = 10) THEN 
    RETURN 'CURRENT_USER';
  ELSIF (op = 12) THEN
    RETURN 'SESSION_USER';
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION %', 'SQLValueFunction';

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.common_table_expr ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN

  IF (node->'CommonTableExpr') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'CommonTableExpr';
  END IF;

  IF (node->'CommonTableExpr'->'ctename') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (ctename)', 'CommonTableExpr';
  END IF;

  IF (node->'CommonTableExpr'->'ctequery') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (ctequery)', 'CommonTableExpr';
  END IF;

  node = node->'CommonTableExpr';

  -- TODO needs quote?
  output = array_append(output, node->>'ctename');
  -- output = array_append(output, quote_ident(node->>'ctename'));

  IF (node->'aliascolnames' IS NOT NULL) THEN 
    output = array_append(output, 
      deparser.parens(
        deparser.list_quotes(node->'aliascolnames')
      )
    );
  END IF;

  output = array_append(output, 
      format('AS (%s)', deparser.expression(node->'ctequery'))
  );

  RETURN array_to_string(output, ' ');

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.escape ( txt text ) RETURNS text AS $EOFCODE$
BEGIN
  -- TODO isn't there a native function for this?
  txt = REPLACE(txt, '''', '''''' );
  return format('''%s''', txt);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.bit_string ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  prefix text;
  rest text;
BEGIN

  IF (node->'BitString') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'BitString';
  END IF;

  node = node->'BitString';

  IF (node->'str') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'BitString';
  END IF;

  prefix = LEFT(node->>'str', 1);
  rest = SUBSTR(node->>'str', 2 );
  RETURN format('%s''%s''', prefix, rest);

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_const ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  txt text;
BEGIN

  IF (node->'A_Const') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Const';
  END IF;

  node = node->'A_Const';

  IF (node->'val') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Const';
  END IF;

  txt = deparser.expression(node->'val', context);

  IF (node->'val'->'String') IS NOT NULL THEN
    RETURN deparser.escape(txt);
  END IF;

  RETURN txt;

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.boolean_test ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  booltesttype int;
BEGIN

  IF (node->'BooleanTest') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'BooleanTest';
  END IF;

  node = node->'BooleanTest';

  IF (node->'arg') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'BooleanTest';
  END IF;

  IF (node->'booltesttype') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'BooleanTest';
  END IF;

  booltesttype = (node->'booltesttype')::int;

  output = array_append(output, deparser.expression(node->'arg'));

  output = array_append(output, (CASE
      WHEN booltesttype = 0 THEN 'IS TRUE'
      WHEN booltesttype = 1 THEN 'IS NOT TRUE'
      WHEN booltesttype = 2 THEN 'IS FALSE'
      WHEN booltesttype = 3 THEN 'IS NOT FALSE'
      WHEN booltesttype = 4 THEN 'IS UNKNOWN'
      WHEN booltesttype = 5 THEN 'IS NOT UNKNOWN'
  END));

  RETURN array_to_string(output, ' ');

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.create_trigger_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  txt text;
  output text[];
  events text[];
  item jsonb;
  vdeferrable bool;
  initdeferred bool;
  args text[];
  str text;
BEGIN

  IF (node->'CreateTrigStmt') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateTrigStmt';
  END IF;

  node = node->'CreateTrigStmt';

  output = array_append(output, 'CREATE');
  if ((node->'isconstraint')::jsonb = to_jsonb(TRUE)) THEN 
    output = array_append(output, 'CONSTRAINT');
  END IF;
  output = array_append(output, 'TRIGGER');
  output = array_append(output, quote_ident(node->>'trigname'));
  output = array_append(output, chr(10));

  -- int16 timing;  BEFORE, AFTER, or INSTEAD

  IF (node->'timing' = to_jsonb(64)) THEN
    output = array_append(output, 'INSTEAD OF');
  ELSIF  (node->'timing' = to_jsonb(2)) THEN
    output = array_append(output, 'BEFORE');
  ELSE 
    output = array_append(output, 'AFTER');
  END IF;

  -- int16 events;  "OR" of INSERT/UPDATE/DELETE/TRUNCATE
  --  4 = 0b000100 (insert)
  --  8 = 0b001000 (delete)
  -- 16 = 0b010000 (update)
  -- 32 = 0b100000 (TRUNCATE)

  IF (((node->'events')::int & 4) = 4) THEN
    events = array_append(events, 'INSERT');
  END IF;

  IF (((node->'events')::int & 8) = 8) THEN
    events = array_append(events, 'DELETE');
  END IF;

  IF (((node->'events')::int & 16) = 16) THEN
    events = array_append(events, 'UPDATE');
  END IF;

  IF (((node->'events')::int & 32) = 32) THEN
    events = array_append(events, 'TRUNCATE');
  END IF;

  output = array_append(output, array_to_string(events, ' OR '));

  -- columns
  IF (node->'columns') IS NOT NULL THEN
    output = array_append(output, 'OF');
    output = array_append(output, deparser.list(node->'columns', ', ', context));
  END IF;

  -- on
  output = array_append(output, 'ON');
  output = array_append(output, deparser.expression(node->'relation', context));
  output = array_append(output, chr(10));

  -- transitionRels
  IF (node->'transitionRels' IS NOT NULL) THEN 
    output = array_append(output, 'REFERENCING');
    FOR item IN SELECT * FROM jsonb_array_elements(node->'transitionRels')
    LOOP 
      IF (
        item->'TriggerTransition' IS NOT NULL AND
        item->'TriggerTransition'->'isNew' IS NOT NULL AND
        (item->'TriggerTransition'->'isNew')::bool IS TRUE AND
        item->'TriggerTransition'->'isTable' IS NOT NULL AND
        (item->'TriggerTransition'->'isTable')::bool IS TRUE
      ) THEN 
        output = array_append(output, format(
          'NEW TABLE AS %s',
          item->'TriggerTransition'->>'name'
        ));
      ELSIF (
        item->'TriggerTransition' IS NOT NULL AND
        (item->'TriggerTransition'->'isNew' IS NOT NULL OR
          (item->'TriggerTransition'->'isNew')::bool IS FALSE
        ) AND
        item->'TriggerTransition'->'isTable' IS NOT NULL AND
        (item->'TriggerTransition'->'isTable')::bool IS TRUE
      ) THEN 
        output = array_append(output, format(
          'OLD TABLE AS %s',
          item->'TriggerTransition'->>'name'
        ));
      END IF;
    END LOOP;
  END IF;

  -- deferrable
  vdeferrable = (
      node->'deferrable' IS NOT NULL AND
      (node->'deferrable')::bool IS TRUE
  );
  -- initdeferred
  initdeferred = (
      node->'initdeferred' IS NOT NULL AND
      (node->'initdeferred')::bool IS TRUE
  );
  IF (vdeferrable IS TRUE OR initdeferred IS TRUE) THEN
    IF (vdeferrable IS TRUE) THEN 
      output = array_append(output, 'DEFERRABLE');
    END IF;
    IF (initdeferred IS TRUE) THEN 
      output = array_append(output, 'INITIALLY DEFERRED');
    END IF;
  END IF;

  -- row
  IF (node->'row' IS NOT NULL AND (node->'row')::bool = TRUE) THEN
    output = array_append(output, 'FOR EACH ROW');
  ELSE
    output = array_append(output, 'FOR EACH STATEMENT');
  END IF;
  output = array_append(output, chr(10));

  -- when
  IF (node->'whenClause') IS NOT NULL THEN
      output = array_append(output, 'WHEN');
      output = array_append(output, deparser.parens(
        deparser.expression(node->'whenClause', 'trigger')
      ));
      output = array_append(output, chr(10));
  END IF;

  -- exec
  output = array_append(output, 'EXECUTE PROCEDURE');
  output = array_append(output, deparser.quoted_name(node->'funcname'));

  -- args
  output = array_append(output, '(');
  IF (node->'args' IS NOT NULL AND jsonb_array_length(node->'args') > 0) THEN
    FOR item IN SELECT * FROM jsonb_array_elements(node->'args')
    LOOP 
      IF (item->'String' IS NOT NULL) THEN
        str = '''' || deparser.expression(item) || '''';
      ELSE
        str = deparser.expression(item);
      END IF;
      IF (character_length(str) > 0) THEN 
        args = array_append(args, str);
      END IF;
    END LOOP;
    output = array_append(output, array_to_string(args, ', '));
  END IF;
  output = array_append(output, ')');

  RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.string ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  txt text = expr->'String'->>'str';
BEGIN
  IF (context = 'trigger') THEN
    IF (upper(txt) = 'NEW') THEN
      RETURN 'NEW';
    ELSIF (upper(txt) = 'OLD') THEN
      RETURN 'OLD';
    ELSE 
      RETURN quote_ident(txt);
    END IF;
  ELSIF (context = 'column') THEN
    RETURN quote_ident(txt);
  ELSIF (context = 'update') THEN
    IF (upper(txt) = 'EXCLUDED') THEN 
      RETURN 'EXCLUDED';
    END IF;
  ELSIF (context = 'enum') THEN
    RETURN '''' || txt || '''';
  ELSIF (context = 'identifiers') THEN
    RETURN quote_ident(txt);
  END IF;
  RETURN txt;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.float ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
BEGIN
  IF (LEFT(node->'Float'->>'str', 1) = '-') THEN 
    RETURN deparser.parens(node->'Float'->>'str');
  END IF;
  RETURN node->'Float'->>'str';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.list ( node jsonb, delimiter text DEFAULT ', ', context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  txt text;
BEGIN
  RETURN array_to_string(deparser.expressions_array(node, context), delimiter);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.list_quotes ( node jsonb, delimiter text DEFAULT ', ', context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  txt text;
  unquoted text[];
  str text;
  quoted text[];
BEGIN
  unquoted = deparser.expressions_array(node, context);
  FOREACH str in ARRAY unquoted
  LOOP
    quoted = array_append(quoted, quote_ident(str));
  END LOOP;
  RETURN array_to_string(quoted, delimiter);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.create_policy_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'CreatePolicyStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreatePolicyStmt';
    END IF;

    IF (node->'CreatePolicyStmt'->'policy_name') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreatePolicyStmt';
    END IF;
    IF (node->'CreatePolicyStmt'->'roles') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreatePolicyStmt';
    END IF;

    node = node->'CreatePolicyStmt';

    output = array_append(output, 'CREATE');
    output = array_append(output, 'POLICY');
    output = array_append(output, quote_ident(node->>'policy_name'));

    IF (node->'table') IS NOT NULL THEN
      output = array_append(output, 'ON');
      output = array_append(output, deparser.expression(node->'table'));
    END IF;
    IF (node->'cmd_name') IS NOT NULL THEN
      output = array_append(output, 'FOR');
      output = array_append(output, upper(node->>'cmd_name'));
    END IF;

    output = array_append(output, 'TO');
    output = array_append(output, deparser.list(node->'roles'));

    IF (node->'with_check') IS NOT NULL THEN
      output = array_append(output, 'WITH CHECK');
      output = array_append(output, '(');
      output = array_append(output, deparser.expression(node->'with_check'));
      output = array_append(output, ')');
    ELSE 
      output = array_append(output, 'USING');
      output = array_append(output, '(');
      output = array_append(output, deparser.expression(node->'qual'));
      output = array_append(output, ')');
    END IF;

    RETURN array_to_string(output, ' ');

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.role_spec ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  roletype int;
BEGIN
    IF (node->'RoleSpec') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RoleSpec';
    END IF;

    IF (node->'RoleSpec'->'roletype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RoleSpec';
    END IF;

    node = node->'RoleSpec';
    roletype = (node->'roletype')::int;

    IF (roletype = 0) THEN
      output = array_append(output, quote_ident(node->>'rolename'));
    ELSIF (roletype = 1) THEN 
      output = array_append(output, 'CURRENT_USER');
    ELSIF (roletype = 2) THEN 
      output = array_append(output, 'SESSION_USER');
    ELSIF (roletype = 3) THEN 
      output = array_append(output, 'PUBLIC');
    ELSE
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RoleSpec';
    END IF;

    RETURN array_to_string(output, ' ');

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.insert_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'InsertStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'InsertStmt';
    END IF;

    IF (node->'InsertStmt'->'relation') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'InsertStmt';
    END IF;

    node = node->'InsertStmt';

    output = array_append(output, 'INSERT INTO');
    output = array_append(output, deparser.expression(node->'relation'));

    IF (node->'cols' IS NOT NULL AND jsonb_array_length(node->'cols') > 0) THEN 
      output = array_append(output, deparser.parens(deparser.list(node->'cols')));
    END IF;

    IF (node->'selectStmt') IS NOT NULL THEN
      output = array_append(output, deparser.expression(node->'selectStmt'));
    ELSE
      output = array_append(output, 'DEFAULT VALUES');
    END IF;

    IF (node->'onConflictClause') IS NOT NULL THEN
      output = array_append(output, deparser.expression(node->'onConflictClause'));
    END IF;

    IF (node->'returningList' IS NOT NULL) THEN 
      output = array_append(output, deparser.returning_list(node));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.create_schema_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'CreateSchemaStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateSchemaStmt';
    END IF;

    IF (node->'CreateSchemaStmt'->'schemaname') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateSchemaStmt';
    END IF;

    node = node->'CreateSchemaStmt';

    output = array_append(output, 'CREATE');
    IF (node->'replace' IS NOT NULL AND (node->'replace')::bool IS TRUE) THEN 
      output = array_append(output, 'OR REPLACE');
    END IF;
    output = array_append(output, 'SCHEMA');

    IF (node->'if_not_exists' IS NOT NULL AND (node->'if_not_exists')::bool IS TRUE) THEN 
      output = array_append(output, 'IF NOT EXISTS');
    END IF;

    output = array_append(output, quote_ident(node->>'schemaname'));

    RETURN array_to_string(output, ' ');

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.exclusion_constraint ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  exclusion jsonb;
  a text[];
  b text[];
  i int;
BEGIN
    
    IF (node->'exclusions' IS NOT NULL AND node->'access_method' IS NOT NULL) THEN 
      output = array_append(output, 'USING');
      output = array_append(output, node->>'access_method');
      output = array_append(output, '(');
      FOR exclusion IN SELECT * FROM jsonb_array_elements(node->'exclusions')
      LOOP
        IF (exclusion->0 IS NOT NULL) THEN
          -- a
          IF (exclusion->0->'IndexElem' IS NOT NULL) THEN
            IF (exclusion->0->'IndexElem'->'name' IS NOT NULL) THEN
                a = array_append(a, exclusion->0->'IndexElem'->>'name');
            ELSIF (exclusion->0->'IndexElem'->'expr' IS NOT NULL) THEN
                a = array_append(a, deparser.expression(exclusion->0->'IndexElem'->'expr'));
            ELSE 
                a = array_append(a, NULL);
            END IF;
          END IF;
          -- b
          b = array_append(b, deparser.expression(exclusion->1->0));
        END IF;
      END LOOP;
      -- after loop

      FOR i IN
      SELECT * FROM generate_series(1, a) g (i)
      LOOP
        output = array_append(output, format('%s WITH %s', a[i], b[i]));
        IF ( cardinality(a) = i ) THEN 
          output = array_append(output, ',');
        END IF;
      END LOOP;
      output = array_append(output, ')');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.reference_constraint ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  has_pk_attrs boolean default false;
  has_fk_attrs boolean default false;
BEGIN

    has_fk_attrs = (node->'fk_attrs' IS NOT NULL AND jsonb_array_length(node->'fk_attrs') > 0);
    has_pk_attrs = (node->'pk_attrs' IS NOT NULL AND jsonb_array_length(node->'pk_attrs') > 0);

    IF (has_pk_attrs AND has_fk_attrs) THEN
      IF (node->'conname' IS NOT NULL) THEN
        output = array_append(output, 'CONSTRAINT');
        -- TODO needs quote?
        output = array_append(output, node->>'conname');
      END IF;
      output = array_append(output, 'FOREIGN KEY');
      output = array_append(output, deparser.parens(deparser.list_quotes(node->'fk_attrs')));
      output = array_append(output, 'REFERENCES');
      output = array_append(output, deparser.expression(node->'pktable'));
      output = array_append(output, deparser.parens(deparser.list_quotes(node->'pk_attrs')));
    ELSIF (has_pk_attrs) THEN 
      output = array_append(output, deparser.constraint_stmt(node));
      output = array_append(output, deparser.expression(node->'pktable'));
      output = array_append(output, deparser.parens(deparser.list_quotes(node->'pk_attrs')));
    ELSIF (has_fk_attrs) THEN 
      IF (node->'conname' IS NOT NULL) THEN
        output = array_append(output, 'CONSTRAINT');
        -- TODO needs quote?
        output = array_append(output, node->>'conname');
      END IF;
      output = array_append(output, 'FOREIGN KEY');
      output = array_append(output, deparser.parens(deparser.list_quotes(node->'fk_attrs')));
      output = array_append(output, 'REFERENCES');
      output = array_append(output, deparser.expression(node->'pktable'));
    ELSE 
      output = array_append(output, deparser.constraint_stmt(node));
      output = array_append(output, deparser.expression(node->'pktable'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.constraint_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  contype int;
  constrainttype text;
BEGIN
  contype = (node->'contype')::int;
  constrainttype = ast_utils.constrainttypes(contype);
  IF (node->'conname' IS NOT NULL) THEN
    output = array_append(output, 'CONSTRAINT');
    output = array_append(output, quote_ident(node->>'conname'));
    IF (node->'pktable' IS NULL) THEN 
      output = array_append(output, constrainttype);
    END IF;
  ELSE 
    output = array_append(output, constrainttype);
  END IF;

  RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.create_seq_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'CreateSeqStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateSeqStmt';
    END IF;

    IF (node->'CreateSeqStmt'->'sequence') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateSeqStmt';
    END IF;

    node = node->'CreateSeqStmt';

    output = array_append(output, 'CREATE SEQUENCE');
    output = array_append(output, deparser.expression(node->'sequence'));

    IF (node->'options' IS NOT NULL AND jsonb_array_length(node->'options') > 0) THEN 
      output = array_append(output, deparser.list(node->'options', ' ', 'sequence'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.do_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'DoStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'DoStmt';
    END IF;

    IF (node->'DoStmt'->'args') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'DoStmt';
    END IF;
    
    node = node->'DoStmt';

    IF (
      node->'args'->0 IS NULL OR
      node->'args'->0->'DefElem' IS NULL OR
      node->'args'->0->'DefElem'->'arg'->'String'->'str' IS NULL
    ) THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'DoStmt';
    END IF;

    output = array_append(output, E'DO $CODEZ$\n');
    output = array_append(output, node->'args'->0->'DefElem'->'arg'->'String'->>'str');
    output = array_append(output, E'$CODEZ$');

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.create_table_as_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'CreateTableAsStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateTableAsStmt';
    END IF;

    IF (node->'CreateTableAsStmt'->'into') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateTableAsStmt';
    END IF;

    IF (node->'CreateTableAsStmt'->'query') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateTableAsStmt';
    END IF;
    
    node = node->'CreateTableAsStmt';

    output = array_append(output, 'CREATE MATERIALIZED VIEW');
    output = array_append(output, deparser.expression(node->'into'));
    output = array_append(output, 'AS');
    output = array_append(output, deparser.expression(node->'query'));

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.constraint ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  contype int;
BEGIN

    IF (node->'Constraint') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'Constraint';
    END IF;

    IF (node->'Constraint'->'contype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'Constraint';
    END IF;

    node = node->'Constraint';
    contype = (node->'contype')::int;

    IF (contype = ast_utils.constrainttype_idxs('CONSTR_FOREIGN')) THEN 
      output = array_append(output, deparser.reference_constraint(node));
    ELSE
      output = array_append(output, deparser.constraint_stmt(node));
    END IF;

    IF (node->'keys' IS NOT NULL AND jsonb_array_length(node->'keys') > 0) THEN 
      output = array_append(output, deparser.parens(deparser.list_quotes(node->'keys')));
    END IF;

    IF (node->'raw_expr' IS NOT NULL) THEN 
      output = array_append(output, deparser.parens(deparser.expression(node->'raw_expr')));
    END IF;

    IF (node->'fk_del_action' IS NOT NULL) THEN 
      output = array_append(output, (CASE
          WHEN node->>'fk_del_action' = 'r' THEN 'ON DELETE RESTRICT'
          WHEN node->>'fk_del_action' = 'c' THEN 'ON DELETE CASCADE'
          WHEN node->>'fk_del_action' = 'n' THEN 'ON DELETE SET NULL'
          WHEN node->>'fk_del_action' = 'd' THEN 'ON DELETE SET DEFAULT'
          WHEN node->>'fk_del_action' = 'a' THEN '' -- 'ON DELETE NO ACTION'
      END));
    END IF;

    IF (node->'fk_upd_action' IS NOT NULL) THEN 
      output = array_append(output, (CASE
          WHEN node->>'fk_upd_action' = 'r' THEN 'ON UPDATE RESTRICT'
          WHEN node->>'fk_upd_action' = 'c' THEN 'ON UPDATE CASCADE'
          WHEN node->>'fk_upd_action' = 'n' THEN 'ON UPDATE SET NULL'
          WHEN node->>'fk_upd_action' = 'd' THEN 'ON UPDATE SET DEFAULT'
          WHEN node->>'fk_upd_action' = 'a' THEN '' -- 'ON UPDATE NO ACTION'
      END));
    END IF;

    IF (node->'fk_matchtype' IS NOT NULL AND node->>'fk_matchtype' = 'f') THEN 
      output = array_append(output, 'MATCH FULL');
    END IF;

    IF (node->'is_no_inherit' IS NOT NULL AND (node->>'is_no_inherit')::bool IS TRUE ) THEN 
      output = array_append(output, 'NO INHERIT');
    END IF;

    IF (node->'skip_validation' IS NOT NULL AND (node->>'skip_validation')::bool IS TRUE ) THEN 
      output = array_append(output, 'NOT VALID');
    END IF;

    IF (contype = ast_utils.constrainttype_idxs('CONSTR_EXCLUSION')) THEN 
      output = array_append(output, deparser.exclusion_constraint(node));
    END IF;

    IF (node->'deferrable' IS NOT NULL AND (node->>'deferrable')::bool IS TRUE ) THEN 
      output = array_append(output, 'DEFERRABLE');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.def_elem ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  defname text;
BEGIN
    IF (node->'DefElem') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'DefElem';
    END IF;

    IF (node->'DefElem'->'defname') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'DefElem';
    END IF;

    node = node->'DefElem';
    defname = node->>'defname';

    IF (defname = 'transaction_isolation') THEN 
      RETURN format(
        'ISOLATION LEVEL %s',
         upper(deparser.expression(node->'arg'->'A_Const'->'val'))
      );
    ELSIF (defname = 'transaction_read_only') THEN
      IF ( (node->'arg'->'A_Const'->'val'->'Integer'->'ival')::int = 0 ) THEN 
        RETURN 'READ WRITE';
      ELSE
        RETURN 'READ ONLY';
      END IF;
    ELSIF (defname = 'transaction_deferrable') THEN
      IF ( (node->'arg'->'A_Const'->'val'->'Integer'->'ival')::int = 0 ) THEN 
        RETURN 'NOT DEFERRABLE';
      ELSE
        RETURN 'DEFERRABLE';
      END IF;
    ELSIF (defname = 'set') THEN
      RETURN deparser.expression(node->'arg');
    END IF;

    IF (node->'defnamespace' IS NOT NULL) THEN 
      -- TODO needs quotes?
      defname = node->>'defnamespace' || '.' || node->>'defname';
    END IF;

    IF (context = 'sequence') THEN
      IF (defname = 'cycle') THEN 
        IF (trim(deparser.expression(node->'arg')) = '1') THEN
          RETURN 'CYCLE';
        ELSE 
          RETURN 'NO CYCLE';
        END IF;
      ELSIF (defname = 'minvalue') THEN 
        IF (node->'arg' IS NULL) THEN
          RETURN 'NO MINVALUE';
        ELSE 
          RETURN defname || ' ' || deparser.expression(node->'arg', 'simple');
        END IF;
      ELSIF (defname = 'maxvalue') THEN 
        IF (node->'arg' IS NULL) THEN
          RETURN 'NO MAXVALUE';
        ELSE 
          RETURN defname || ' ' || deparser.expression(node->'arg', 'simple');
        END IF;
      ELSIF (node->'arg' IS NOT NULL) THEN
        RETURN defname || ' ' || deparser.expression(node->'arg', 'simple');
      END IF;
    ELSE
        RETURN defname || '=' || deparser.expression(node->'arg');
    END IF;

    RETURN defname;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.comment_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  objtype int;
  objtypes text[];
BEGIN
    IF (node->'CommentStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CommentStmt';
    END IF;

    IF (node->'CommentStmt'->'objtype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CommentStmt';
    END IF;

    node = node->'CommentStmt';
    objtypes = ast_utils.objtypes();
    objtype = (node->'objtype')::int;
    output = array_append(output, 'COMMENT');
    output = array_append(output, 'ON');
    output = array_append(output, objtypes[objtype + 1]);

    IF (objtype = ast_utils.objtypes_idxs('OBJECT_CAST')) THEN
      output = array_append(output, '(');
      output = array_append(output, deparser.expression(node->'object'->0));
      output = array_append(output, 'AS');
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, ')');
    ELSIF (objtype = ast_utils.objtypes_idxs('OBJECT_DOMCONSTRAINT')) THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'ON');
      output = array_append(output, 'DOMAIN');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = ast_utils.objtypes_idxs('OBJECT_OPCLASS')) THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'USING');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = ast_utils.objtypes_idxs('OBJECT_OPFAMILY')) THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'USING');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = ast_utils.objtypes_idxs('OBJECT_OPERATOR')) THEN
      -- TODO lookup noquotes context in pgsql-parser
      output = array_append(output, deparser.expression(node->'object', 'noquotes'));
    ELSIF (objtype = ast_utils.objtypes_idxs('OBJECT_POLICY')) THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'ON');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = ast_utils.objtypes_idxs('OBJECT_ROLE')) THEN
      output = array_append(output, deparser.expression(node->'object'));
    ELSIF (objtype = ast_utils.objtypes_idxs('OBJECT_RULE')) THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'ON');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = ast_utils.objtypes_idxs('OBJECT_TABCONSTRAINT')) THEN
      IF (jsonb_array_length(node->'object') = 3) THEN 
        output = array_append(output, deparser.expression(node->'object'->2));
        output = array_append(output, 'ON');
        -- TODO needs quotes instead?
          -- output = array_append(output, deparser.quoted_name(
          --  to_jsonb(ARRAY[
          --    node->'object'->0,
          --    node->'object'->1
          --  ])
          -- ));
        output = array_append(output, deparser.expression(node->'object'->0));
        output = array_append(output, '.');
        output = array_append(output, deparser.expression(node->'object'->1));
      ELSE 
        output = array_append(output, deparser.expression(node->'object'->1));
        output = array_append(output, 'ON');
        output = array_append(output, deparser.expression(node->'object'->0));
      END IF;
    ELSIF (objtype = ast_utils.objtypes_idxs('OBJECT_TRANSFORM')) THEN
      output = array_append(output, 'FOR');
      output = array_append(output, deparser.expression(node->'object'->0));
      output = array_append(output, 'LANGUAGE');
      output = array_append(output, deparser.expression(node->'object'->1));
    ELSIF (objtype = ast_utils.objtypes_idxs('OBJECT_TRIGGER')) THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'ON');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = ast_utils.objtypes_idxs('OBJECT_LARGEOBJECT')) THEN
      output = array_append(output, deparser.expression(node->'object'));
    ELSE 
      IF (jsonb_typeof(node->'object') = 'array') THEN 
        output = array_append(output, deparser.list_quotes(node->'object', '.'));
      ELSE
        output = array_append(output, deparser.expression(node->'object'));
      END IF;

      IF (node->'objargs' IS NOT NULL AND jsonb_array_length(node->'objargs') > 0) THEN 
        output = array_append(output, deparser.parens(deparser.list(node->'objargs')));
      END IF;
    END IF;

    output = array_append(output, 'IS');
    IF (node->'comment' IS NOT NULL) THEN 
      output = array_append(output, 'E' || '''' || (node->>'comment') || '''');
    ELSE
      output = array_append(output, 'NULL');
    END IF;
  
    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_default_privileges_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  item jsonb;
  def jsonb;
BEGIN
    IF (node->'AlterDefaultPrivilegesStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterDefaultPrivilegesStmt';
    END IF;

    node = node->'AlterDefaultPrivilegesStmt';

    output = array_append(output, 'ALTER DEFAULT PRIVILEGES');

    IF (node->'options' IS NOT NULL AND jsonb_array_length(node->'options') > 0) THEN 
      FOR item IN SELECT * FROM jsonb_array_elements(node->'options')
      LOOP 
        IF (item->'DefElem' IS NOT NULL) THEN
          def = item;
        END IF;
      END LOOP;
      IF ( def IS NOT NULL) THEN
        IF ( def->'DefElem'->>'defname' = 'schemas') THEN
          output = array_append(output, 'IN SCHEMA');
          output = array_append(output, deparser.expression(def->'DefElem'->'arg'->0));
        ELSIF ( def->'DefElem'->>'defname' = 'schemas') THEN
          output = array_append(output, 'FOR ROLE');
          output = array_append(output, deparser.expression(def->'DefElem'->'arg'->0));
        END IF;
        output = array_append(output, E'\n');
      END IF;
    END IF;

    output = array_append(output, deparser.expression(def->'action'));

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.case_expr ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'CaseExpr') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CaseExpr';
    END IF;

    node = node->'CaseExpr';
    output = array_append(output, 'CASE');

    IF (node->'arg') IS NOT NULL THEN 
      output = array_append(output, deparser.expression(node->'arg'));
    END IF;

    IF (node->'args' IS NOT NULL AND jsonb_array_length(node->'args') > 0) THEN 
      output = array_append(output, deparser.list(node->'args', ' '));
    END IF;

    IF (node->'defresult') IS NOT NULL THEN 
      output = array_append(output, 'ELSE');
      output = array_append(output, deparser.expression(node->'defresult'));
    END IF;

    output = array_append(output, 'END');
    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.case_when ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'CaseWhen') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CaseWhen';
    END IF;

    IF (node->'CaseWhen'->'expr') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CaseWhen';
    END IF;

    IF (node->'CaseWhen'->'result') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CaseWhen';
    END IF;

    node = node->'CaseWhen';
    output = array_append(output, 'WHEN');

    output = array_append(output, deparser.expression(node->'expr'));
    output = array_append(output, 'THEN');
    output = array_append(output, deparser.expression(node->'result'));

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.with_clause ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'WithClause') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'WithClause';
    END IF;

    IF (node->'WithClause'->'ctes') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'WithClause';
    END IF;

    node = node->'WithClause';
    output = array_append(output, 'WITH');
    IF (node->'recursive' IS NOT NULL AND (node->'recursive')::bool IS TRUE) THEN 
      output = array_append(output, 'RECURSIVE');
    END IF;
    output = array_append(output, deparser.list(node->'ctes'));

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.variable_set_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  kind int;
  local text = '';
  multi text = '';
BEGIN
    IF (node->'VariableSetStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'VariableSetStmt';
    END IF;

    IF (node->'VariableSetStmt'->'kind') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'VariableSetStmt';
    END IF;

    node = node->'VariableSetStmt';

    -- NOTE uses ENUM
    kind = (node->'kind')::int;
    IF (kind = 0) THEN 
      IF (node->'is_local' IS NOT NULL AND (node->'is_local')::bool IS TRUE) THEN 
        local = 'LOCAL ';
      END IF;
      output = array_append(output, format('SET %s%s = %s', local, node->>'name', deparser.list(node->'args', ', ', 'simple')));
    ELSIF (kind = 1) THEN
      output = array_append(output, format('SET %s TO DEFAULT', node->>'name'));
    ELSIF (kind = 2) THEN
      output = array_append(output, format('SET %s FROM CURRENT', node->>'name'));
    ELSIF (kind = 3) THEN
      IF (node->>'name' = 'TRANSACTION') THEN
        multi = 'TRANSACTION';
      ELSIF (node->>'name' = 'SESSION CHARACTERISTICS') THEN
        multi = 'SESSION CHARACTERISTICS AS TRANSACTION';
      END IF;
      output = array_append(output, format('SET %s %s', multi, deparser.list(node->'args', ', ', 'simple')));
    ELSIF (kind = 4) THEN
      output = array_append(output, format('RESET %s', node->>'name'));
    ELSIF (kind = 5) THEN
      output = array_append(output, 'RESET ALL');
    ELSE
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'VariableSetStmt';
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alias ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'Alias') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'Alias';
    END IF;

    IF (node->'Alias'->'aliasname') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'Alias';
    END IF;

    node = node->'Alias';

    output = array_append(output, 'AS');
    output = array_append(output, quote_ident(node->>'aliasname'));
    IF (node->'colnames' IS NOT NULL AND jsonb_array_length(node->'colnames') > 0) THEN 
      output = array_append(output, 
        deparser.parens(deparser.list_quotes(node->'colnames'))
      );
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.range_subselect ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'RangeSubselect') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RangeSubselect';
    END IF;

    IF (node->'RangeSubselect'->'subquery') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RangeSubselect';
    END IF;

    node = node->'RangeSubselect';

    IF (node->'lateral' IS NOT NULL) THEN 
      output = array_append(output, 'LATERAL');
    END IF;

    output = array_append(output, deparser.parens(deparser.expression(node->'subquery')));

    IF (node->'alias' IS NOT NULL) THEN 
      output = array_append(output, deparser.expression(node->'alias'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.delete_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'DeleteStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'DeleteStmt';
    END IF;

    IF (node->'DeleteStmt'->'relation') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'DeleteStmt';
    END IF;

    node = node->'DeleteStmt';

    output = array_append(output, 'DELETE');
    output = array_append(output, 'FROM');
    output = array_append(output, deparser.expression(node->'relation'));

    IF (node->'whereClause' IS NOT NULL) THEN 
      output = array_append(output, 'WHERE');
      output = array_append(output, deparser.expression(node->'whereClause'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.quoted_name ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  item text;
BEGIN
    -- NOTE: assumes array of names passed in 

    IF (context = 'type') THEN 


      FOREACH item IN array deparser.expressions_array(node)
      LOOP
        -- strip off the [] if it exists at the end, and set is_array prop
        IF (ARRAY_LENGTH(REGEXP_MATCHES(trim(item), '(.*)\s*(\[\s*?\])$', 'i'), 1) > 0) THEN
          item = REGEXP_REPLACE(trim(item), '(.*)\s*(\[\s*?\])$', '\1', 'i');
          output = array_append(output, quote_ident(item) || '[]');
        ELSE
          output = array_append(output, quote_ident(item));
        END IF;

      END LOOP;

    ELSE
      FOREACH item IN array deparser.expressions_array(node)
      LOOP
        output = array_append(output, quote_ident(item));
      END LOOP;
    END IF;
    RETURN array_to_string(output, '.');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.create_domain_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'CreateDomainStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateDomainStmt';
    END IF;

    IF (node->'CreateDomainStmt'->'domainname') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateDomainStmt';
    END IF;

    IF (node->'CreateDomainStmt'->'typeName') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateDomainStmt';
    END IF;

    node = node->'CreateDomainStmt';

    output = array_append(output, 'CREATE');
    output = array_append(output, 'DOMAIN');

    output = array_append(output, deparser.quoted_name(node->'domainname'));
    output = array_append(output, 'AS');
    output = array_append(output, deparser.expression(node->'typeName'));

    IF (node->'constraints' IS NOT NULL) THEN 
      output = array_append(output, deparser.list(node->'constraints'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.grant_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  objtype int;
BEGIN
    IF (node->'GrantStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'GrantStmt';
    END IF;

    IF (node->'GrantStmt'->'objtype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'GrantStmt';
    END IF;

    node = node->'GrantStmt';
    objtype = (node->'objtype')::int;

    IF (objtype != 0) THEN 
      IF (node->'is_grant' IS NOT NULL AND (node->'is_grant')::bool IS TRUE) THEN 
        output = array_append(output, 'REVOKE');
        IF (node->'grant_option' IS NOT NULL AND (node->'grant_option')::bool IS TRUE) THEN 
          output = array_append(output, 'GRANT OPTION');
          output = array_append(output, 'FOR');
        END IF;
        IF (node->'privileges' IS NOT NULL AND jsonb_array_length(node->'privileges') > 0) THEN 
          output = array_append(output, deparser.list(node->'privileges'));
        ELSE
          output = array_append(output, 'ALL');
        END IF;
        output = array_append(output, 'ON');
        output = array_append(output, ast_utils.getgrantobject(node));
        output = array_append(output, deparser.list(node->'objects'));
        output = array_append(output, 'FROM');
        output = array_append(output, deparser.list(node->'grantees'));
      ELSE
        output = array_append(output, 'GRANT');
        IF (node->'privileges' IS NOT NULL AND jsonb_array_length(node->'privileges') > 0) THEN 
          output = array_append(output, deparser.list(node->'privileges'));
        ELSE
          output = array_append(output, 'ALL');
        END IF;
        output = array_append(output, 'ON');
        output = array_append(output, ast_utils.getgrantobject(node));
        output = array_append(output, deparser.list(node->'objects'));
        output = array_append(output, 'TO');
        output = array_append(output, deparser.list(node->'grantees'));
        IF (node->'grant_option' IS NOT NULL AND (node->'grant_option')::bool IS TRUE) THEN 
          output = array_append(output, 'WITH GRANT OPTION');
        END IF;
      END IF;
      
      IF (node->'behavior' IS NOT NULL AND (node->'behavior')::int = 1) THEN
        output = array_append(output, 'CASCADE');
      END IF;

    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.composite_type_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'CompositeTypeStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CompositeTypeStmt';
    END IF;

    IF (node->'CompositeTypeStmt'->'typevar') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CompositeTypeStmt';
    END IF;

    IF (node->'CompositeTypeStmt'->'coldeflist') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CompositeTypeStmt';
    END IF;

    node = node->'CompositeTypeStmt';

    output = array_append(output, 'CREATE');
    output = array_append(output, 'TYPE');
    output = array_append(output, deparser.expression(node->'typevar'));
    output = array_append(output, 'AS');
    output = array_append(output, deparser.parens(
      deparser.list(node->'coldeflist', E',')
    ));

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.index_elem ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
BEGIN
    IF (node->'IndexElem') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'IndexElem';
    END IF;

    node = node->'IndexElem';

    IF (node->'name' IS NOT NULL) THEN
      RETURN node->>'name';
    END IF;

    IF (node->'expr' IS NOT NULL) THEN
      RETURN deparser.expression(node->'expr');
    END IF;

    RAISE EXCEPTION 'BAD_EXPRESSION %', 'IndexElem';

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.create_enum_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'CreateEnumStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateEnumStmt';
    END IF;

    IF (node->'CreateEnumStmt'->'typeName') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateEnumStmt';
    END IF;

    node = node->'CreateEnumStmt';

    output = array_append(output, 'CREATE');
    output = array_append(output, 'TYPE');

    -- TODO needs quote?
    output = array_append(output, deparser.list(node->'typeName', '.'));
    output = array_append(output, 'AS ENUM');
    output = array_append(output, E'(\n');
    output = array_append(output, deparser.list(node->'vals', E',\n', 'enum'));
    output = array_append(output, E'\n)');

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_table_cmd ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  subtype int;
BEGIN
    IF (node->'AlterTableCmd') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterTableCmd';
    END IF;

    IF (node->'AlterTableCmd'->'subtype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterTableCmd';
    END IF;

    node = node->'AlterTableCmd';
    subtype = (node->'subtype')::int;

    IF (subtype = 0) THEN 
      output = array_append(output, 'ADD COLUMN');
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = 3) THEN
      output = array_append(output, 'ALTER COLUMN');
      output = array_append(output, quote_ident(node->>'name'));
      IF (node->'def' IS NOT NULL) THEN
        output = array_append(output, 'SET DEFAULT');
        output = array_append(output, deparser.expression(node->'def'));
      ELSE
        output = array_append(output, 'DROP DEFAULT');
      END IF;
    ELSIF (subtype = 4) THEN
      output = array_append(output, 'ALTER COLUMN');
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'DROP NOT NULL');
    ELSIF (subtype = 5) THEN
      output = array_append(output, 'ALTER COLUMN');
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'SET NOT NULL');
    ELSIF (subtype = 6) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'SET STATISTICS');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = 7) THEN
      output = array_append(output, 'ALTER COLUMN');
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'SET');
      output = array_append(output, deparser.parens(deparser.list(node->'def')));
    ELSIF (subtype = 9) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'SET STORAGE');
      IF (node->'def' IS NOT NULL) THEN
        output = array_append(output, deparser.expression(node->'def'));
      ELSE
        output = array_append(output, 'PLAIN');
      END IF;
    ELSIF (subtype = 10) THEN
      output = array_append(output, 'DROP');
      IF (node->'missing_ok' IS NOT NULL AND (node->'missing_ok')::bool IS TRUE) THEN
        output = array_append(output, 'IF EXISTS');
      END IF;
      output = array_append(output, quote_ident(node->>'name'));
    ELSIF (subtype = 14) THEN
      output = array_append(output, 'ADD');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = 18) THEN
      output = array_append(output, 'VALIDATE CONSTRAINT');
      output = array_append(output, quote_ident(node->>'name'));
    ELSIF (subtype = 22) THEN
      output = array_append(output, 'DROP CONSTRAINT');
      IF (node->'missing_ok' IS NOT NULL AND (node->'missing_ok')::bool IS TRUE) THEN
        output = array_append(output, 'IF EXISTS');
      END IF;
      output = array_append(output, quote_ident(node->>'name'));
    ELSIF (subtype = 25) THEN
      output = array_append(output, 'ALTER COLUMN');
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'TYPE');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = 28) THEN
      output = array_append(output, 'CLUSTER ON');
      output = array_append(output, quote_ident(node->>'name'));
    ELSIF (subtype = 29) THEN
      output = array_append(output, 'SET WITHOUT CLUSTER');
    ELSIF (subtype = 32) THEN
      output = array_append(output, 'SET WITH OIDS');
    ELSIF (subtype = 34) THEN
      output = array_append(output, 'SET WITHOUT OIDS');
    ELSIF (subtype = 36) THEN
      output = array_append(output, 'SET');
      output = array_append(output, deparser.parens(deparser.list(node->'def')));
    ELSIF (subtype = 37) THEN
      output = array_append(output, 'RESET');
      output = array_append(output, deparser.parens(deparser.list(node->'def')));
    ELSIF (subtype = 51) THEN
      output = array_append(output, 'INHERIT');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = 52) THEN
      output = array_append(output, 'NO INHERIT');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = 56) THEN
      output = array_append(output, 'ENABLE ROW LEVEL SECURITY');
    ELSIF (subtype = 57) THEN
      output = array_append(output, 'DISABLE ROW LEVEL SECURITY');
    ELSIF (subtype = 58) THEN
      output = array_append(output, 'FORCE ROW SECURITY');
    ELSIF (subtype = 59) THEN
      output = array_append(output, 'NO FORCE ROW SECURITY');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_table_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  relkind int;
BEGIN
    IF (node->'AlterTableStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterTableStmt';
    END IF;

    IF (node->'AlterTableStmt'->'relkind') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterTableStmt';
    END IF;

    IF (node->'AlterTableStmt'->'relation') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterTableStmt';
    END IF;

    node = node->'AlterTableStmt';
    relkind = (node->'relkind')::int;
    output = array_append(output, 'ALTER');

    IF (relkind = 32) THEN 
      output = array_append(output, 'TABLE');
    ELSIF (relkind = 42) THEN 
      output = array_append(output, 'VIEW');
    ELSIF (relkind = 40) THEN 
      output = array_append(output, 'TYPE');
    ELSE
      output = array_append(output, 'TABLE');
      IF (
        node->'relation'->'RangeVar' IS NOT NULL AND
        node->'relation'->'RangeVar'->'inh' IS NOT NULL AND
        (node->'relation'->'RangeVar'->'inh')::bool IS FALSE
      ) THEN 
        output = array_append(output, 'ONLY');
      END IF;
    END IF;

    IF (node->'missing_ok' IS NOT NULL AND (node->'missing_ok')::bool IS TRUE) THEN 
      output = array_append(output, 'IF EXISTS');
    END IF;

    output = array_append(output, deparser.expression(node->'relation'));
    output = array_append(output, deparser.list(node->'cmds'));

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.range_function ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  funcs text[];
  func jsonb;
BEGIN
    IF (node->'RangeFunction') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RangeFunction';
    END IF;

    node = node->'RangeFunction';

    IF (node->'lateral' IS NOT NULL) THEN 
      output = array_append(output, 'LATERAL');
    END IF;

    IF (node->'functions' IS NOT NULL AND jsonb_array_length(node->'functions') > 0) THEN 
      FOR func in SELECT * FROM jsonb_array_elements(node->'functions')
      LOOP 
        funcs = array_append(funcs, deparser.expression(func->0));
        IF (func->1 IS NOT NULL AND jsonb_array_length(func->1) > 0) THEN 
          funcs = array_append(funcs, format(
            'AS (%s)',
            deparser.list(func->1)
          ));
        END IF;
      END LOOP;

      IF (node->'is_rowsfrom' IS NOT NULL AND (node->'is_rowsfrom')::bool IS TRUE) THEN 
        output = array_append(output, format('ROWS FROM (%s)', array_to_string(funcs, ', ')));
      ELSE
        output = array_append(output, array_to_string(funcs, ', '));
      END IF;
    END IF;

    IF (node->'ordinality' IS NOT NULL AND (node->'ordinality')::bool IS TRUE) THEN
      output = array_append(output, 'WITH ORDINALITY');
    END IF;

    IF (node->'alias' IS NOT NULL) THEN
      output = array_append(output, deparser.expression(node->'alias'));
    END IF;

    IF (node->'coldeflist' IS NOT NULL AND jsonb_array_length(node->'coldeflist') > 0) THEN
      IF (node->'alias' IS NOT NULL) THEN
        output = array_append(output, format('(%s)', deparser.list(node->'coldeflist')));
      ELSE 
        output = array_append(output, format('AS (%s)', deparser.list(node->'coldeflist')));
      END IF;
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.index_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'IndexStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'IndexStmt';
    END IF;

    IF (node->'IndexStmt'->'relation') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'IndexStmt';
    END IF;

    node = node->'IndexStmt';

    output = array_append(output, 'CREATE');
    IF (node->'unique' IS NOT NULL) THEN 
      output = array_append(output, 'UNIQUE');
    END IF;
    
    output = array_append(output, 'INDEX');
    
    IF (node->'concurrent' IS NOT NULL) THEN 
      output = array_append(output, 'CONCURRENTLY');
    END IF;
    
    IF (node->'idxname' IS NOT NULL) THEN 
      -- TODO needs quote?
      output = array_append(output, node->>'idxname');
    END IF;

    output = array_append(output, 'ON');
    output = array_append(output, deparser.expression(node->'relation'));

    IF (node->'indexParams' IS NOT NULL AND jsonb_array_length(node->'indexParams') > 0) THEN 
      output = array_append(output, deparser.parens(deparser.list(node->'indexParams')));
    END IF; 

    IF (node->'whereClause' IS NOT NULL) THEN 
      output = array_append(output, deparser.expression(node->'whereClause'));
    END IF; 

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.update_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  targets text[];
  rets text[];
  name text;
  item jsonb;
BEGIN
    IF (node->'UpdateStmt') IS NOT NULL THEN
      -- we re-use this function for onConflictClause, so we only 
      -- check this for UpdateStmt, and then assume it's good for the other calls
      IF (node->'UpdateStmt'->'relation') IS NULL THEN
        RAISE EXCEPTION 'BAD_EXPRESSION % (relation)', 'UpdateStmt';
      END IF;

      node = node->'UpdateStmt';
    END IF;
  
    output = array_append(output, 'UPDATE');
    IF (node->'relation' IS NOT NULL) THEN 
      output = array_append(output, deparser.expression(node->'relation'));
    END IF;
    output = array_append(output, 'SET');

    IF (node->'targetList' IS NOT NULL AND jsonb_array_length(node->'targetList') > 0) THEN 
      IF (
        node->'targetList'->0->'ResTarget' IS NOT NULL AND 
        node->'targetList'->0->'ResTarget'->'val' IS NOT NULL AND 
        node->'targetList'->0->'ResTarget'->'val'->'MultiAssignRef' IS NOT NULL 
      ) THEN 

        FOR item IN
        SELECT * FROM jsonb_array_elements(node->'targetList')
        LOOP 
          targets = array_append(targets, item->'ResTarget'->>'name');
        END LOOP;
        output = array_append(output, deparser.parens(array_to_string(targets, ', ')));
        output = array_append(output, '=');
        output = array_append(output, deparser.expression(node->'targetList'->0->'ResTarget'->'val'));
      ELSE
        output = array_append(output, deparser.list(node->'targetList', ', ', 'update'));
      END IF;
    END IF;

    IF (node->'fromClause' IS NOT NULL) THEN 
      output = array_append(output, 'FROM');
      output = array_append(output, deparser.list(node->'fromClause', ' '));
    END IF;

    IF (node->'whereClause' IS NOT NULL) THEN 
      output = array_append(output, 'WHERE');
      output = array_append(output, deparser.expression(node->'whereClause'));
    END IF;

    IF (node->'returningList' IS NOT NULL) THEN 
      output = array_append(output, deparser.returning_list(node));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.param_ref ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
BEGIN
    IF (node->'ParamRef') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'ParamRef';
    END IF;

    node = node->'ParamRef';

    IF (node->'number' IS NOT NULL AND (node->'number')::int > 0) THEN 
      RETURN '$' || (node->>'number');
    END IF;

    RETURN '?';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.set_to_default ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
BEGIN
    IF (node->'SetToDefault') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'SetToDefault';
    END IF;

    RETURN 'DEFAULT';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.multi_assign_ref ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
BEGIN
    IF (node->'MultiAssignRef') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'MultiAssignRef';
    END IF;

    RETURN deparser.expression(node->'source');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.join_expr ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  jointype int;
  jointxt text;
  wrapped text;
  is_natural bool = false;
BEGIN
    IF (node->'JoinExpr') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'JoinExpr';
    END IF;

    IF (node->'JoinExpr'->'larg') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'JoinExpr';
    END IF;

    IF (node->'JoinExpr'->'jointype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'JoinExpr';
    END IF;

    node = node->'JoinExpr';

    IF (node->'isNatural' IS NOT NULL AND (node->'isNatural')::bool IS TRUE) THEN 
      output = array_append(output, 'NATURAL');
      is_natural = TRUE;
    END IF;

    jointype = (node->'jointype')::int;
    IF (jointype = 0) THEN 
      IF (node->'quals' IS NOT NULL) THEN 
        jointxt = 'INNER JOIN';
      ELSIF (
        NOT is_natural AND
        node->'quals' IS NULL AND
        node->'usingClause' IS NULL
      ) THEN
        jointxt = 'CROSS JOIN';
      ELSE
        jointxt = 'JOIN';
      END IF;
    ELSIF (jointype = 1) THEN
        jointxt = 'LEFT OUTER JOIN';
    ELSIF (jointype = 2) THEN
        jointxt = 'FULL OUTER JOIN';
    ELSIF (jointype = 3) THEN
        jointxt = 'RIGHT OUTER JOIN';
    ELSE
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'JoinExpr';
    END IF;
    output = array_append(output, jointxt);

    IF (node->'rarg' IS NOT NULL) THEN 
      IF (node->'rarg'->'JoinExpr' IS NOT NULL AND node->'rarg'->'JoinExpr'->'alias' IS NULL) THEN 
        output = array_append(output, deparser.parens(deparser.expression(node->'rarg')));
      ELSE
        output = array_append(output, deparser.expression(node->'rarg'));
      END IF;
    END IF;

    IF (node->'quals' IS NOT NULL) THEN 
      output = array_append(output, 'ON');
      output = array_append(output, deparser.expression(node->'quals'));
    END IF;

    IF (node->'usingClause' IS NOT NULL) THEN 
      output = array_append(output, 'USING');
      -- TODO check this... maybe not correct.
      output = array_append(output, deparser.list_quotes(node->'usingClause'));
    END IF;

    IF (node->'rarg' IS NOT NULL OR node->'alias' IS NOT NULL) THEN 
      wrapped = deparser.parens(array_to_string(output, ' '));
    ELSE 
      wrapped = array_to_string(output, ' ');
    END IF;

    IF (node->'alias' IS NOT NULL) THEN 
      wrapped = wrapped || ' ' || deparser.expression(node->'alias');
    END IF;

    RETURN wrapped;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_indirection ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  subnode jsonb;
BEGIN
    IF (node->'A_Indirection') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Indirection';
    END IF;

    node = node->'A_Indirection';

    IF (node->'indirection' IS NOT NULL AND jsonb_array_length(node->'indirection') > 0) THEN 
      FOR subnode IN SELECT * FROM jsonb_array_elements(node->'indirection')
      LOOP 
        IF (subnode->'A_Star' IS NOT NULL) THEN
          output = array_append(output, '.' || deparser.expression(subnode));
        ELSIF (subnode->'String' IS NOT NULL) THEN
          output = array_append(output, '.' || quote_ident(deparser.expression(subnode)));
        ELSE
          output = array_append(output, deparser.expression(subnode));
        END IF;
      END LOOP;
    END IF;

    -- NOT A SPACE HERE ON PURPOSE
    RETURN array_to_string(output, '');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.sub_link ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  subLinkType int;
BEGIN
    IF (node->'SubLink') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'SubLink';
    END IF;

    node = node->'SubLink';
    subLinkType = (node->'subLinkType')::int;
    IF (subLinkType = 0) THEN
      output = array_append(output, format(
        'EXISTS (%s)', 
        deparser.expression(node->'subselect')
      ));
    ELSIF (subLinkType = 1) THEN
      output = array_append(output, format(
        '%s %s ALL (%s)',
        deparser.expression(node->'testexpr'),
        deparser.expression(node->'operName'->0),
        deparser.expression(node->'subselect')
      ));
    ELSIF (subLinkType = 2) THEN
      IF (node->'operName' IS NOT NULL) THEN 
        output = array_append(output, format(
          '%s %s ANY (%s)',
          deparser.expression(node->'testexpr'),
          deparser.expression(node->'operName'->0),
          deparser.expression(node->'subselect')
        ));      
      ELSE 
        output = array_append(output, format(
          '%s IN (%s)',
          deparser.expression(node->'testexpr'),
          deparser.expression(node->'subselect')
        ));
      END IF;
    ELSIF (subLinkType = 3) THEN
      output = array_append(output, format(
        '%s %s (%s)',
        deparser.expression(node->'testexpr'),
        deparser.expression(node->'operName'->0),
        deparser.expression(node->'subselect')
      ));
    ELSIF (subLinkType = 4) THEN
      output = array_append(output, format(
        '(%s)',
        deparser.expression(node->'subselect')
      ));
    ELSIF (subLinkType = 5) THEN
       RAISE EXCEPTION 'BAD_EXPRESSION %', 'unknown kind SubLink';
    ELSIF (subLinkType = 6) THEN
      output = array_append(output, format(
        'ARRAY (%s)',
        deparser.expression(node->'subselect')
      ));
    ELSE
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'SubLink';
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_star ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
BEGIN
    IF (node->'A_Star') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Star';
    END IF;
    RETURN '*';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.integer ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  ival int;
BEGIN
    IF (node->'Integer') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'Integer';
    END IF;

    IF (node->'Integer'->'ival') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'Integer';
    END IF;

    node = node->'Integer';
    ival = (node->'ival')::int;

    IF (ival < 0 AND context != 'simple') THEN
      RETURN deparser.parens(node->>'ival');
    END IF;
    
    RETURN node->>'ival';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.access_priv ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'AccessPriv') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AccessPriv';
    END IF;

    node = node->'AccessPriv';

    IF (node->'priv_name') IS NOT NULL THEN
      output = array_append(output, upper(node->>'priv_name'));
    ELSE
      output = array_append(output, 'ALL');
    END IF;

    IF (node->'cols') IS NOT NULL THEN
      output = array_append(output, '(');
      output = array_append(output, deparser.list(node->'cols', context));
      output = array_append(output, ')');
    END IF;

    RETURN array_to_string(output, ' ');

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.grouping_func ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
BEGIN
    IF (node->'GroupingFunc') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'GroupingFunc';
    END IF;
    IF (node->'GroupingFunc'->'args') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'GroupingFunc';
    END IF;

    node = node->'GroupingFunc';

    RETURN format('GROUPING(%s)', deparser.list(node->'args'));
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.grouping_set ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  kind int;
BEGIN
    IF (node->'GroupingSet') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'GroupingSet';
    END IF;
    IF (node->'GroupingSet'->'kind') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'GroupingSet';
    END IF;

    node = node->'GroupingSet';
    kind = (node->'kind')::int;

    IF (kind = 0) THEN 
      RETURN '()';
    ELSIF (kind = 2) THEN 
      RETURN format('ROLLUP (%s)', deparser.list(node->'content'));
    ELSIF (kind = 3) THEN 
      RETURN format('CUBE (%s)', deparser.list(node->'content'));
    ELSIF (kind = 4) THEN 
      RETURN format('GROUPING SETS (%s)', deparser.list(node->'content'));
    END IF;

    RAISE EXCEPTION 'BAD_EXPRESSION %', 'GroupingSet';

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.func_call ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  fn_name text;
  fn_args text = '';
  args text[];
  ordr text[];
  calr text[];
  output text[];
  arg jsonb;
  agg_within_group boolean;
BEGIN
    IF (node->'FuncCall') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'FuncCall';
    END IF;

    IF (node->'FuncCall'->'funcname') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'FuncCall';
    END IF;

    node = node->'FuncCall';

    fn_name = deparser.quoted_name(node->'funcname');
    IF (node->'args' IS NOT NULL AND jsonb_array_length(node->'args') > 0) THEN
        -- fn_args = deparser.list(node->'args', ', ', context);
        FOR arg in SELECT * FROM jsonb_array_elements(node->'args')
        LOOP 
          args = array_append(args, deparser.expression(arg));
        END LOOP;
    END IF;

    IF (node->'agg_star' IS NOT NULL AND (node->'agg_star')::bool IS TRUE) THEN 
      args = array_append(args, '*');
    END IF;

    IF (node->'agg_order' IS NOT NULL) THEN 
      ordr = array_append(ordr, 'ORDER BY');
      ordr = array_append(ordr, deparser.list(node->'agg_order', ', ', context));
    END IF;

    calr = array_append(calr, fn_name);
    calr = array_append(calr, '(');

    IF (node->'agg_distinct' IS NOT NULL AND (node->'agg_distinct')::bool IS TRUE) THEN 
      calr = array_append(calr, 'DISTINCT');
      calr = array_append(calr, ' ');
    END IF;

    IF (node->'func_variadic' IS NOT NULL AND (node->'func_variadic')::bool IS TRUE) THEN 
      args[cardinality(args)] = 'VARIADIC ' || args[cardinality(args)];
    END IF;

    calr = array_append(calr, array_to_string(args, ', '));

    agg_within_group = (node->'agg_within_group' IS NOT NULL AND (node->'agg_within_group')::bool IS TRUE);

    IF (cardinality(ordr) > 0 AND agg_within_group IS FALSE) THEN 
      calr = array_append(calr, ' ');
      calr = array_append(calr, array_to_string(ordr, ' '));
      calr = array_append(calr, ' ');
    END IF;

    calr = array_append(calr, ')');
    output = array_append(output, array_to_string(deparser.compact(calr), ''));

    IF (cardinality(ordr) > 0 AND agg_within_group IS TRUE) THEN 
      output = array_append(output, 'WITHIN GROUP');
      output = array_append(output, deparser.parens(array_to_string(ordr, ' ')));
    END IF;

    IF (node->'agg_filter' IS NOT NULL) THEN 
      output = array_append(output, format('FILTER (WHERE %s)', deparser.expression(node->'agg_filter')));
    END IF;

    IF (node->'over' IS NOT NULL) THEN 
      output = array_append(output, format('OVER %s', deparser.expression(node->'over')));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.rule_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  event int;
BEGIN
    IF (node->'RuleStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RuleStmt';
    END IF;

    IF (node->'RuleStmt'->'event') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RuleStmt';
    END IF;

    IF (node->'RuleStmt'->'relation') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RuleStmt';
    END IF;

    node = node->'RuleStmt';

    output = array_append(output, 'CREATE');
    output = array_append(output, 'RULE');
    IF (node->>'rulename' = '_RETURN') THEN
      -- special rules
      output = array_append(output, '"_RETURN"');
    ELSE
      output = array_append(output, quote_ident(node->>'rulename'));
    END IF;
    output = array_append(output, 'AS');
    output = array_append(output, 'ON');

    -- events
    event = (node->'event')::int;
    IF (event = 1) THEN
      output = array_append(output, 'SELECT');
    ELSIF (event = 2) THEN 
      output = array_append(output, 'UPDATE');
    ELSIF (event = 3) THEN 
      output = array_append(output, 'INSERT');
    ELSIF (event = 4) THEN 
      output = array_append(output, 'DELETE');
    ELSE
      RAISE EXCEPTION 'event type not yet implemented for RuleStmt';
    END IF;

    -- relation

    output = array_append(output, 'TO');
    output = array_append(output, deparser.expression(node->'relation', context));

    IF (node->'instead') IS NOT NULL THEN 
      output = array_append(output, 'DO');
      output = array_append(output, 'INSTEAD');
    END IF;

    IF (node->'whereClause') IS NOT NULL THEN 
      output = array_append(output, 'WHERE');
      output = array_append(output, deparser.expression(node->'whereClause', context));
      output = array_append(output, 'DO');
    END IF;

    IF (
      node->'actions' IS NOT NULL AND
      jsonb_array_length(node->'actions') > 0
    ) THEN 
      output = array_append(output, deparser.expression(node->'actions'->0, context));
    ELSE
      output = array_append(output, 'NOTHING');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.create_role_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  event int;
BEGIN
    IF (node->'CreateRoleStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateRoleStmt';
    END IF;

    -- IF (node->'CreateRoleStmt'->'event') IS NULL THEN
    --   RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateRoleStmt';
    -- END IF;

    -- IF (node->'CreateRoleStmt'->'relation') IS NULL THEN
    --   RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateRoleStmt';
    -- END IF;

    node = node->'CreateRoleStmt';

    output = array_append(output, 'CREATE');

    RAISE EXCEPTION 'TODO %', 'CreateRoleStmt';

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.create_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  relpersistence text;
BEGIN
    IF (node->'CreateStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateStmt';
    END IF;

    IF (node->'CreateStmt'->'relation') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateStmt';
    END IF;

    node = node->'CreateStmt';

    IF (
        node->'relation' IS NOT NULL AND
        node->'relation'->'RangeVar' IS NOT NULL AND
        node->'relation'->'RangeVar'->'relpersistence' IS NOT NULL) THEN
      relpersistence = node->'relation'->'RangeVar'->>'relpersistence';
    END IF;

    IF (relpersistence = 't') THEN 
      output = array_append(output, 'CREATE');
    ELSE
      output = array_append(output, 'CREATE TABLE');
    END IF;

    output = array_append(output, deparser.expression(node->'relation', context));
    output = array_append(output, E'(\n');
    -- TODO add tabs (see pgsql-parser)
    output = array_append(output, deparser.list(node->'tableElts', E',\n', context));
    output = array_append(output, E'\n)');

    IF (relpersistence = 'p' AND node->'inhRelations' IS NOT NULL) THEN 
      output = array_append(output, 'INHERITS');
      output = array_append(output, deparser.parens(deparser.list(node->'inhRelations')));
    END IF;

    IF (node->'options') IS NOT NULL THEN
      -- TODO with/without OIDs
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.transaction_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  kind int;
BEGIN
    IF (node->'TransactionStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'TransactionStmt';
    END IF;

    IF (node->'TransactionStmt'->'kind') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'TransactionStmt';
    END IF;

    node = node->'TransactionStmt';
    kind = (node->'kind')::int;

    IF (kind = 0) THEN
      -- TODO implement other options
      output = array_append(output, 'BEGIN');
    ELSIF (kind = 1) THEN
      -- TODO implement other options
      output = array_append(output, 'START TRANSACTION');
    ELSIF (kind = 2) THEN
      output = array_append(output, 'COMMIT');
    ELSIF (kind = 3) THEN
      output = array_append(output, 'ROLLBACK');
    ELSIF (kind = 4) THEN
      output = array_append(output, 'SAVEPOINT');
      output = array_append(output, deparser.expression(node->'options'->0->'DefElem'->'arg'));
    ELSIF (kind = 5) THEN
      output = array_append(output, 'RELEASE SAVEPOINT');
      output = array_append(output, deparser.expression(node->'options'->0->'DefElem'->'arg'));
    ELSIF (kind = 6) THEN
      output = array_append(output, 'ROLLBACK TO');
      output = array_append(output, deparser.expression(node->'options'->0->'DefElem'->'arg'));
    ELSIF (kind = 7) THEN
      output = array_append(output, 'PREPARE TRANSACTION');
      output = array_append(output, '''' || node->>'gid' || '''');
    ELSIF (kind = 8) THEN
      output = array_append(output, 'COMMIT PREPARED');
      output = array_append(output, '''' || node->>'gid' || '''');
    ELSIF (kind = 9) THEN
      output = array_append(output, 'ROLLBACK PREPARED');
      output = array_append(output, '''' || node->>'gid' || '''');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.view_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  event int;
BEGIN
    IF (node->'ViewStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'ViewStmt';
    END IF;

    IF (node->'ViewStmt'->'view') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'ViewStmt';
    END IF;

    IF (node->'ViewStmt'->'query') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'ViewStmt';
    END IF;

    node = node->'ViewStmt';
    output = array_append(output, 'CREATE VIEW');
    output = array_append(output, deparser.expression(node->'view', context));
    output = array_append(output, 'AS');
    output = array_append(output, deparser.expression(node->'query', context));
    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.sort_by ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  dir int;
  nulls int;
BEGIN
    IF (node->'SortBy') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'SortBy';
    END IF;

    IF (node->'SortBy'->'sortby_dir') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'SortBy';
    END IF;

    node = node->'SortBy';

    IF (node->'node' IS NOT NULL) THEN 
      output = array_append(output, deparser.expression(node->'node'));
    END IF;


    -- NOTE uses ENUMS
    dir = (node->'sortby_dir')::int;
    IF (dir = 0) THEN 
      -- noop
    ELSIF (dir = 1) THEN
      output = array_append(output, 'ASC');
    ELSIF (dir = 2) THEN
      output = array_append(output, 'DESC');
    ELSIF (dir = 3) THEN
      output = array_append(output, 'USING');
      output = array_append(output, deparser.list(node->'useOp'));
    ELSE 
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'SortBy (enum)';
    END IF;

    IF (node->'sortby_nulls' IS NOT NULL) THEN
      nulls = (node->'sortby_nulls')::int;
      IF (nulls = 0) THEN 
        -- noop
      ELSIF (nulls = 1) THEN
        output = array_append(output, 'NULLS FIRST');
      ELSIF (nulls = 2) THEN
        output = array_append(output, 'NULLS LAST');
      END IF;
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.res_target ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  event int;
BEGIN
    IF (node->'ResTarget') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'ResTarget';
    END IF;

    node = node->'ResTarget';

    -- NOTE seems like compact is required here, sometimes the name is NOT used!
    IF (context = 'select') THEN       
      output = array_append(output, array_to_string(deparser.compact(ARRAY[
        deparser.expression(node->'val', 'select'),
        quote_ident(node->>'name')
      ]), ' AS '));
    ELSIF (context = 'update') THEN 
      output = array_append(output, array_to_string(deparser.compact(ARRAY[
        quote_ident(node->>'name'),
        deparser.expression(node->'val', 'update')
      ]), ' = '));
    ELSE
      output = array_append(output, quote_ident(node->>'name'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.object_with_args ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  rets text[];
  item jsonb;
BEGIN
    IF (node->'ObjectWithArgs') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'ObjectWithArgs';
    END IF;

    node = node->'ObjectWithArgs';

    IF (context = 'noquotes') THEN 
      output = array_append(output, deparser.list(node->'objname'));
    ELSE
      -- TODO why no '.' for the case above?
      output = array_append(output, deparser.list_quotes(node->'objname', '.'));
    END IF;

    IF (node->'objargs' IS NOT NULL AND jsonb_array_length(node->'objargs') > 0) THEN 
      output = array_append(output, '(');
      FOR item in SELECT * FROM jsonb_array_elements(node->'objargs')
      LOOP 
        IF (item IS NULL) THEN
          rets = array_append(rets, 'NONE');
        ELSE
          rets = array_append(rets, deparser.expression(item));
        END IF;
      END LOOP;
      output = array_append(output, array_to_string(rets, ', '));
      output = array_append(output, ')');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_domain_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  subtype text;
BEGIN
    IF (node->'AlterDomainStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterDomainStmt';
    END IF;

    node = node->'AlterDomainStmt';

    output = array_append(output, 'ALTER DOMAIN');
 
    subtype = node->>'subtype';
    output = array_append(output, deparser.quoted_name(node->'typeName'));

    IF (node->'behavior' IS NOT NULL AND (node->'behavior')::int = 0) THEN 
      output = array_append(output, 'CASCADE');
    END IF;

    -- IF (subtype = 'O') THEN 
    --   output = array_append(output, '');
    -- END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_enum_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'AlterEnumStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterEnumStmt';
    END IF;

    node = node->'AlterEnumStmt';

    output = array_append(output, 'ALTER TYPE');
    output = array_append(output, deparser.quoted_name(node->'typeName'));
    output = array_append(output, 'ADD VALUE');
    output = array_append(output, '''' || (node->>'newVal') || '''');
    IF (node->'newValNeighbor' IS NOT NULL) THEN 
      IF (node->'newValIsAfter' IS NOT NULL AND (node->'newValIsAfter')::bool IS TRUE) THEN 
        output = array_append(output, 'AFTER');
      ELSE
        output = array_append(output, 'BEFORE');
      END IF;
      output = array_append(output, '''' || (node->>'newValNeighbor') || '''');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.execute_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  fn_args text;
  fn_name text;
BEGIN
    IF (node->'ExecuteStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'ExecuteStmt';
    END IF;

    node = node->'ExecuteStmt';

    IF (jsonb_typeof(node->'name') = 'array') THEN 
      fn_name = deparser.quoted_name(node->'name');
    ELSE 
      fn_name = quote_ident(node->>'name');
    END IF;

    IF (node->'params') IS NOT NULL THEN
        fn_args = deparser.list(node->'params', ', ', context);
    END IF;

    RETURN array_to_string(ARRAY[fn_name, format( '(%s)', fn_args )], ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.row_expr ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  row_format int;
BEGIN
    IF (node->'RowExpr') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RowExpr';
    END IF;

    node = node->'RowExpr';
    row_format = (node->'row_format')::int;
    IF (row_format = 2) THEN 
      RETURN deparser.parens(deparser.list(node->'args'));
    END IF;

    RETURN format('ROW(%s)', deparser.list(node->'args'));
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_indices ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
BEGIN
    IF (node->'A_Indices') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Indices';
    END IF;

    node = node->'A_Indices';
    IF (node->'lidx' IS NOT NULL) THEN 
      RETURN format(
        '[%s:%s]',
        deparser.expression(node->'lidx'),
        deparser.expression(node->'uidx')
      );
    END IF;
    
    RETURN format('[%s]', deparser.expression(node->'uidx'));
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.into_clause ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
BEGIN
    IF (node->'IntoClause') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'IntoClause';
    END IF;
    node = node->'IntoClause';
    RETURN deparser.expression(node->'rel');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.rename_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  objtype int;
BEGIN
    IF (node->'RenameStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RenameStmt';
    END IF;

    node = node->'RenameStmt';
    objtype = (node->'renameType')::int;
    IF (objtype = ast_utils.objtypes_idxs('OBJECT_COLUMN')) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, 'TABLE');
      output = array_append(output, deparser.expression(node->'relation'));
      output = array_append(output, 'RENAME');
      output = array_append(output, 'COLUMN');
      output = array_append(output, node->>'subname');
      output = array_append(output, 'TO');
      output = array_append(output, node->>'newname');
    ELSE
      RAISE EXCEPTION 'BAD_EXPRESSION % type(%)', 'RenameStmt', node->>'renameType';
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.vacuum_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  objtype int;
BEGIN
    IF (node->'VacuumStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'VacuumStmt';
    END IF;

    node = node->'VacuumStmt';


    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.select_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  sets text[];
  values text[];
  pvalues text[];
  value text;
  op int;
  valueSet jsonb;
  valueArr text[];
BEGIN
    IF (node->'SelectStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'SelectStmt';
    END IF;

    IF (node->'SelectStmt'->'op') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'SelectStmt';
    END IF;

    node = node->'SelectStmt';

    IF (node->'withClause') IS NOT NULL THEN 
      output = array_append(output, deparser.expression(node->'withClause'), context);
    END IF;

    op = (node->'op')::int;

    IF (op = 0) THEN 
       IF (node->'valuesLists') IS NULL THEN 
        output = array_append(output, 'SELECT');
       END IF;
    ELSE 
        output = array_append(output, '(');
        output = array_append(output, deparser.expression(node->'larg', context));
        output = array_append(output, ')');
        
        -- sets
        sets = ARRAY['NONE', 'UNION', 'INTERSECT', 'EXCEPT']::text[];
        output = array_append(output, sets[op+1]);
        
        -- all
        IF (node->'all') IS NOT NULL THEN
          output = array_append(output, 'ALL');
        END IF;        

        -- rarg
        output = array_append(output, '(');
        output = array_append(output, deparser.expression(node->'rarg', context));
        output = array_append(output, ')');
    END IF;

    -- distinct
    IF (node->'distinctClause') IS NOT NULL THEN 
      IF (node->'distinctClause'->0) IS NOT NULL THEN 
        output = array_append(output, 'DISTINCT ON');
        output = array_append(output, '(');
        output = array_append(output, deparser.list(node->'distinctClause', E',\n', context));
        output = array_append(output, ')');
      ELSE
        output = array_append(output, 'DISTINCT');
      END IF;
    END IF;

    -- target
    IF (node->'targetList') IS NOT NULL THEN 
      output = array_append(output, deparser.list(node->'targetList', E',\n', 'select'));
    END IF;

    -- into
    IF (node->'intoClause') IS NOT NULL THEN 
      output = array_append(output, deparser.expression(node->'intoClause', context));
    END IF;

    -- from
    IF (node->'fromClause') IS NOT NULL THEN 
      output = array_append(output, deparser.list(node->'fromClause', E',\n', 'from'));
    END IF;

    -- where
    IF (node->'whereClause') IS NOT NULL THEN 
      output = array_append(output, 'WHERE');
      output = array_append(output, deparser.expression(node->'whereClause', context));
    END IF;

    -- values
    IF (node->'valuesLists' IS NOT NULL AND jsonb_array_length(node->'valuesLists') > 0) THEN 
      output = array_append(output, 'VALUES');
      FOR valueSet IN
      SELECT * FROM jsonb_array_elements(node->'valuesLists')
      LOOP
        valueArr = array_append(valueArr, deparser.parens( deparser.list(valueSet) ));
      END LOOP;
      output = array_append(output, array_to_string(valueArr, ', '));
    END IF;

    -- groups
    IF (node->'groupClause') IS NOT NULL THEN 
      output = array_append(output, 'GROUP BY');
      output = array_append(output, deparser.list(node->'groupClause', E',\n', 'group'));
    END IF;

    -- having
    IF (node->'havingClause') IS NOT NULL THEN 
      output = array_append(output, 'HAVING');
      output = array_append(output, deparser.expression(node->'havingClause', context));
    END IF;

    -- window
    IF (node->'windowClause') IS NOT NULL THEN 
      RAISE EXCEPTION 'implement windowClause';
    END IF;

    -- sort
    IF (node->'sortClause') IS NOT NULL THEN 
      output = array_append(output, 'ORDER BY');
      output = array_append(output, deparser.list(node->'sortClause', E',\n', 'sort'));
    END IF;

    -- limit
    IF (node->'limitCount') IS NOT NULL THEN 
      output = array_append(output, 'LIMIT');
      output = array_append(output, deparser.expression(node->'limitCount', context));
    END IF;

    -- offset
    IF (node->'limitOffset') IS NOT NULL THEN 
      output = array_append(output, 'OFFSET');
      output = array_append(output, deparser.expression(node->'limitOffset', context));
    END IF;

    -- locking
    IF (node->'lockingClause') IS NOT NULL THEN 
      output = array_append(output, 'OFFSET');
      output = array_append(output, deparser.list(node->'lockingClause', ' ', context));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.grant_role_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  event int;
BEGIN
    IF (node->'GrantRoleStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'GrantRoleStmt';
    END IF;

    IF (node->'GrantRoleStmt'->'granted_roles') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'GrantRoleStmt';
    END IF;

    node = node->'GrantRoleStmt';

    IF (node->'is_grant' IS NULL OR (node->'is_grant')::bool = FALSE) THEN
      output = array_append(output, 'REVOKE');
      output = array_append(output, deparser.list(node->'granted_roles'));
      output = array_append(output, 'FROM');
      output = array_append(output, deparser.list(node->'grantee_roles'));
    ELSE
      output = array_append(output, 'GRANT');
      output = array_append(output, deparser.list(node->'granted_roles'));
      output = array_append(output, 'TO');
      output = array_append(output, deparser.list(node->'grantee_roles'));
    END IF;

    IF (node->'admin_opt' IS NOT NULL AND (node->'admin_opt')::bool = TRUE) THEN 
      output = array_append(output, 'WITH ADMIN OPTION');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.locking_clause ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  strength int;
BEGIN
    IF (node->'LockingClause') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'LockingClause';
    END IF;

    IF (node->'LockingClause'->'strength') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'LockingClause';
    END IF;

    node = node->'LockingClause';
    strength = (node->'strength')::int;
    IF (strength = 0) THEN 
      output = array_append(output, 'NONE');
    ELSIF (strength = 1) THEN
      output = array_append(output, 'FOR KEY SHARE');
    ELSIF (strength = 2) THEN
      output = array_append(output, 'FOR SHARE');
    ELSIF (strength = 3) THEN
      output = array_append(output, 'FOR NO KEY UPDATE');
    ELSIF (strength = 4) THEN
      output = array_append(output, 'FOR UPDATE');
    END IF;

    IF (node->'lockedRels' IS NOT NULL) THEN 
      output = array_append(output, 'OF');
      output = array_append(output, deparser.list(node->'lockedRels'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.coalesce_expr ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
BEGIN
    IF (node->'CoalesceExpr') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CoalesceExpr';
    END IF;

    IF (node->'CoalesceExpr'->'args') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CoalesceExpr';
    END IF;

    node = node->'CoalesceExpr';

    RETURN format('COALESCE(%s)', deparser.list(node->'args'));
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.min_max_expr ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  op int;
  output text[];
BEGIN
    IF (node->'MinMaxExpr') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'MinMaxExpr';
    END IF;

    IF (node->'MinMaxExpr'->'op') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'MinMaxExpr';
    END IF;

    node = node->'MinMaxExpr';
    op = (node->'op')::int;
    IF (op = 0) THEN 
      output = array_append(output, 'GREATEST');
    ELSE 
      output = array_append(output, 'LEAST');
    END IF;

    output = array_append(output, deparser.parens(deparser.list(node->'args')));

    RETURN array_to_string(output, '');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.null_test ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  nulltesttype int;
  output text[];
BEGIN
    IF (node->'NullTest') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'NullTest';
    END IF;

    IF (node->'NullTest'->'nulltesttype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'NullTest';
    END IF;

    node = node->'NullTest';
    nulltesttype = (node->'nulltesttype')::int;
    IF (nulltesttype = 0) THEN 
      output = array_append(output, 'IS NULL');
    ELSE 
      output = array_append(output, 'IS NOT NULL');
    END IF;

    RETURN array_to_string(output, '');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.named_arg_expr ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'NamedArgExpr') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'NamedArgExpr';
    END IF;

    IF (node->'NamedArgExpr'->'name') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'NamedArgExpr';
    END IF;

    IF (node->'NamedArgExpr'->'arg') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'NamedArgExpr';
    END IF;

    node = node->'NamedArgExpr';

    output = array_append(output, node->>'name');
    output = array_append(output, ':=');
    output = array_append(output, deparser.expression(node->'arg'));

    RETURN array_to_string(output, '');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.drop_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  objtypes text[];
  objtype int;
  obj jsonb;
  quoted text[];
BEGIN
    IF (node->'DropStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'DropStmt';
    END IF;

    IF (node->'DropStmt'->'objects') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'DropStmt';
    END IF;

    IF (node->'DropStmt'->'removeType') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'DropStmt';
    END IF;

    node = node->'DropStmt';

    output = array_append(output, 'DROP');
    objtypes = ast_utils.objtypes();
    objtype = (node->'removeType')::int;
    output = array_append(output, objtypes[objtype + 1]);
    
    IF (node->'missing_ok' IS NOT NULL AND (node->'missing_ok')::bool IS TRUE) THEN 
      output = array_append(output, 'IF EXISTS');
    END IF;

    
    FOR obj IN SELECT * FROM jsonb_array_elements(node->'objects')
    LOOP
      IF (jsonb_typeof(obj) = 'array') THEN
        -- quoted = array_append(quoted, deparser.quoted_name(obj));
        quoted = array_append(quoted, deparser.list(obj, '.'));
      ELSE
        -- TODO if you quote this, then you end up with:
        -- DROP FUNCTION "sillysrf (int)"
        -- quoted = array_append(quoted, quote_ident(deparser.expression(obj)));
        quoted = array_append(quoted, deparser.expression(obj));
      END IF;
    END LOOP;

    output = array_append(output, array_to_string(quoted, ', '));

    -- behavior
    IF (node->'behavior' IS NOT NULL AND (node->'behavior')::int = 1) THEN 
      output = array_append(output, 'CASCADE');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.infer_clause ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  action int;
BEGIN
    IF (node->'InferClause') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'InferClause';
    END IF;

    node = node->'InferClause';

    IF (node->'indexElems' IS NOT NULL) THEN
      output = array_append(output, deparser.parens(deparser.list(node->'indexElems')));
    ELSIF (node->'conname' IS NOT NULL) THEN 
      output = array_append(output, 'ON CONSTRAINT');
      output = array_append(output, node->>'conname');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.on_conflict_clause ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  action int;
BEGIN
    IF (node->'OnConflictClause') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'OnConflictClause';
    END IF;

    IF (node->'OnConflictClause'->'infer') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'OnConflictClause';
    END IF;

    node = node->'OnConflictClause';

    output = array_append(output, 'ON CONFLICT');
    output = array_append(output, deparser.expression(node->'infer'));

    action = (node->'action')::int;
    IF (action = 1) THEN 
      output = array_append(output, 'DO NOTHING');
    ELSIF (action = 2) THEN 
      output = array_append(output, 'DO');
      output = array_append(output, deparser.update_stmt(node));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.create_function_stmt ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  param jsonb;
  option jsonb;
  params jsonb[];
  rets jsonb[];
  defname text;
BEGIN
    IF (node->'CreateFunctionStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateFunctionStmt';
    END IF;

    node = node->'CreateFunctionStmt';

    output = array_append(output, 'CREATE');
    IF (node->'replace' IS NOT NULL AND (node->'replace')::bool IS TRUE) THEN
      output = array_append(output, 'OR REPLACE');
    END IF;
    output = array_append(output, 'FUNCTION');
    output = array_append(output, deparser.list(node->'funcname', '.', 'identifiers'));

    -- params
    output = array_append(output, '(');
    IF (node->'parameters' IS NOT NULL) THEN

      FOR param IN
      SELECT * FROM jsonb_array_elements(node->'parameters')
      LOOP
        IF ((param->'FunctionParameter'->'mode')::int = ANY(ARRAY[118, 111, 98, 105]::int[])) THEN
          params = array_append(params, param);
        END IF;
        IF ((param->'FunctionParameter'->'mode')::int = 116) THEN
          rets = array_append(params, param);
        END IF;
      END LOOP;

      output = array_append(output, deparser.list(to_jsonb(params)));

    END IF;
    output = array_append(output, ')');

    -- RETURNS

    IF (cardinality(rets) > 0) THEN
      output = array_append(output, 'RETURNS');
      output = array_append(output, 'TABLE');
      output = array_append(output, '(');
      output = array_append(output, deparser.list(to_jsonb(rets)));
      output = array_append(output, ')');      
    ELSE
      output = array_append(output, 'RETURNS');
      output = array_append(output, deparser.expression(node->'returnType'));
    END IF;

    -- TODO IMMUTABLE type? where is that option?

    -- options
    IF (node->'options') IS NOT NULL THEN

      FOR option IN
      SELECT * FROM jsonb_array_elements(node->'options')
      LOOP
        IF (option->'DefElem' IS NOT NULL AND option->'DefElem'->'defname' IS NOT NULL) THEN 
            defname = option->'DefElem'->>'defname';

            IF (defname = 'as') THEN
              output = array_append(output, 'AS $LQLCODEZ$');
              output = array_append(output, chr(10));
              output = array_append(output, deparser.expression(option->'DefElem'->'arg'->0) );
              output = array_append(output, chr(10));
              output = array_append(output, '$LQLCODEZ$' );
            ELSIF (defname = 'language') THEN 
              output = array_append(output, 'LANGUAGE' );
              output = array_append(output, deparser.expression(option->'DefElem'->'arg') );
            ELSIF (defname = 'security') THEN 
              output = array_append(output, 'SECURITY' );
              IF ((option->'DefElem'->'arg'->'Integer'->'ival')::int > 0) THEN
                output = array_append(output, 'DEFINER' );
              ELSE
                output = array_append(output, 'INVOKER' );
              END IF;
            ELSIF (defname = 'leakproof') THEN 
              IF ((option->'DefElem'->'arg'->'Integer'->'ival')::int > 0) THEN
                output = array_append(output, 'LEAKPROOF' );
              END IF;
            ELSIF (defname = 'window') THEN 
              IF ((option->'DefElem'->'arg'->'Integer'->'ival')::int > 0) THEN
                output = array_append(output, 'WINDOW' );
              END IF;
            ELSIF (defname = 'strict') THEN 
              IF ((option->'DefElem'->'arg'->'Integer'->'ival')::int > 0) THEN
                output = array_append(output, 'STRICT' );
              ELSE
                output = array_append(output, 'CALLED ON NULL INPUT' );
              END IF;
            -- ELSIF (defname = 'set') THEN 
            ELSIF (defname = 'volatility') THEN 
              output = array_append(output, upper(deparser.expression(option->'DefElem'->'arg')) );
            END IF;

        END IF;
      END LOOP;

    END IF;

  RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.function_parameter ( node jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'FunctionParameter') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'FunctionParameter';
    END IF;

    node = node->'FunctionParameter';

    IF ((node->'mode')::int = 118) THEN
      output = array_append(output, 'VARIADIC');
    END IF;

    IF ((node->'mode')::int = 111) THEN
      output = array_append(output, 'OUT');
    END IF;

    IF ((node->'mode')::int = 98) THEN
      output = array_append(output, 'INOUT');
    END IF;

    output = array_append(output, quote_ident(node->>'name'));
    output = array_append(output, deparser.expression(node->'argType'));

    IF (node->'defexpr') IS NOT NULL THEN
      output = array_append(output, 'DEFAULT');
      output = array_append(output, deparser.expression(node->'defexpr'));
    END IF;

  RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.expression ( expr jsonb, context text DEFAULT NULL ) RETURNS text AS $EOFCODE$
BEGIN

  IF (expr->>'A_Const') IS NOT NULL THEN
    RETURN deparser.a_const(expr, context);
  ELSEIF (expr->>'A_ArrayExpr') IS NOT NULL THEN
    RETURN deparser.a_array_expr(expr, context);
  ELSEIF (expr->>'A_Expr') IS NOT NULL THEN
    RETURN deparser.a_expr(expr, context);
  ELSEIF (expr->>'A_Indices') IS NOT NULL THEN
    RETURN deparser.a_indices(expr, context);
  ELSEIF (expr->>'A_Indirection') IS NOT NULL THEN
    RETURN deparser.a_indirection(expr, context);
  ELSEIF (expr->>'A_Star') IS NOT NULL THEN
    RETURN deparser.a_star(expr, context);
  ELSEIF (expr->>'AccessPriv') IS NOT NULL THEN
    RETURN deparser.access_priv(expr, context);
  ELSEIF (expr->>'Alias') IS NOT NULL THEN
    RETURN deparser.alias(expr, context);
  ELSEIF (expr->>'AlterDefaultPrivilegesStmt') IS NOT NULL THEN
    RETURN deparser.alter_default_privileges_stmt(expr, context);
  ELSEIF (expr->>'AlterDomainStmt') IS NOT NULL THEN
    RETURN deparser.alter_domain_stmt(expr, context);
  ELSEIF (expr->>'AlterEnumStmt') IS NOT NULL THEN
    RETURN deparser.alter_enum_stmt(expr, context);
  ELSEIF (expr->>'AlterTableCmd') IS NOT NULL THEN
    RETURN deparser.alter_table_cmd(expr, context);
  ELSEIF (expr->>'AlterTableStmt') IS NOT NULL THEN
    RETURN deparser.alter_table_stmt(expr, context);
  ELSEIF (expr->>'BitString') IS NOT NULL THEN
    RETURN deparser.bit_string(expr, context);
  ELSEIF (expr->>'BoolExpr') IS NOT NULL THEN
    RETURN deparser.bool_expr(expr, context);
  ELSEIF (expr->>'BooleanTest') IS NOT NULL THEN
    RETURN deparser.boolean_test(expr, context);
  ELSEIF (expr->>'CaseExpr') IS NOT NULL THEN
    RETURN deparser.case_expr(expr, context);
  ELSEIF (expr->>'CaseWhen') IS NOT NULL THEN
    RETURN deparser.case_when(expr, context);
  ELSEIF (expr->>'CoalesceExpr') IS NOT NULL THEN
    RETURN deparser.coalesce_expr(expr, context);
  ELSEIF (expr->>'ColumnDef') IS NOT NULL THEN
    RETURN deparser.column_def(expr, context);
  ELSEIF (expr->>'ColumnRef') IS NOT NULL THEN
    RETURN deparser.column_ref(expr, context);
  ELSEIF (expr->>'CollateClause') IS NOT NULL THEN
    RETURN deparser.collate_clause(expr, context);
  ELSEIF (expr->>'CommentStmt') IS NOT NULL THEN
    RETURN deparser.comment_stmt(expr, context);
  ELSEIF (expr->>'CommonTableExpr') IS NOT NULL THEN
    RETURN deparser.common_table_expr(expr, context);
  ELSEIF (expr->>'CompositeTypeStmt') IS NOT NULL THEN
    RETURN deparser.composite_type_stmt(expr, context);
  ELSEIF (expr->>'Constraint') IS NOT NULL THEN
    RETURN deparser.constraint(expr, context);
  ELSEIF (expr->>'CreateDomainStmt') IS NOT NULL THEN
    RETURN deparser.create_domain_stmt(expr, context);
  ELSEIF (expr->>'CreateEnumStmt') IS NOT NULL THEN
    RETURN deparser.create_enum_stmt(expr, context);
  ELSEIF (expr->>'CreateFunctionStmt') IS NOT NULL THEN
    RETURN deparser.create_function_stmt(expr, context);
  ELSEIF (expr->>'CreatePolicyStmt') IS NOT NULL THEN
    RETURN deparser.create_policy_stmt(expr, context);
  ELSEIF (expr->>'CreateRoleStmt') IS NOT NULL THEN
    RETURN deparser.create_role_stmt(expr, context);
  ELSEIF (expr->>'CreateSchemaStmt') IS NOT NULL THEN
    RETURN deparser.create_schema_stmt(expr, context);
  ELSEIF (expr->>'CreateSeqStmt') IS NOT NULL THEN
    RETURN deparser.create_seq_stmt(expr, context);
  ELSEIF (expr->>'CreateStmt') IS NOT NULL THEN
    RETURN deparser.create_stmt(expr, context);
  ELSEIF (expr->>'CreateTrigStmt') IS NOT NULL THEN
    RETURN deparser.create_trigger_stmt(expr, context);
  ELSEIF (expr->>'CreateTableAsStmt') IS NOT NULL THEN
    RETURN deparser.create_table_as_stmt(expr, context);
  ELSEIF (expr->>'DefElem') IS NOT NULL THEN
    RETURN deparser.def_elem(expr, context);
  ELSEIF (expr->>'DeleteStmt') IS NOT NULL THEN
    RETURN deparser.delete_stmt(expr, context);
  ELSEIF (expr->>'DropStmt') IS NOT NULL THEN
    RETURN deparser.drop_stmt(expr, context);
  ELSEIF (expr->>'DoStmt') IS NOT NULL THEN
    RETURN deparser.do_stmt(expr, context);
  ELSEIF (expr->>'ExplainStmt') IS NOT NULL THEN
    RETURN deparser.explain_stmt(expr, context);
  ELSEIF (expr->>'ExecuteStmt') IS NOT NULL THEN
    RETURN deparser.execute_stmt(expr, context);
  ELSEIF (expr->>'Float') IS NOT NULL THEN
    RETURN deparser.float(expr, context);
  ELSEIF (expr->>'FuncCall') IS NOT NULL THEN
    RETURN deparser.func_call(expr, context);
  ELSEIF (expr->>'FunctionParameter') IS NOT NULL THEN
    RETURN deparser.function_parameter(expr, context);
  ELSEIF (expr->>'GrantRoleStmt') IS NOT NULL THEN
    RETURN deparser.grant_role_stmt(expr, context);
  ELSEIF (expr->>'GrantStmt') IS NOT NULL THEN
    RETURN deparser.grant_stmt(expr, context);
  ELSEIF (expr->>'GroupingFunc') IS NOT NULL THEN
    RETURN deparser.grouping_func(expr, context);
  ELSEIF (expr->>'GroupingSet') IS NOT NULL THEN
    RETURN deparser.grouping_set(expr, context);
  ELSEIF (expr->>'IndexElem') IS NOT NULL THEN
    RETURN deparser.index_elem(expr, context);
  ELSEIF (expr->>'IndexStmt') IS NOT NULL THEN
    RETURN deparser.index_stmt(expr, context);
  ELSEIF (expr->>'InferClause') IS NOT NULL THEN
    RETURN deparser.infer_clause(expr, context);
  ELSEIF (expr->>'InsertStmt') IS NOT NULL THEN
    RETURN deparser.insert_stmt(expr, context);
  ELSEIF (expr->>'Integer') IS NOT NULL THEN
    RETURN deparser.integer(expr, context);
  ELSEIF (expr->>'IntoClause') IS NOT NULL THEN
    RETURN deparser.into_clause(expr, context);
  ELSEIF (expr->>'JoinExpr') IS NOT NULL THEN
    RETURN deparser.join_expr(expr, context);
  ELSEIF (expr->>'LockingClause') IS NOT NULL THEN
    RETURN deparser.locking_clause(expr, context);
  ELSEIF (expr->>'MinMaxExpr') IS NOT NULL THEN
    RETURN deparser.min_max_expr(expr, context);
  ELSEIF (expr->>'MultiAssignRef') IS NOT NULL THEN
    RETURN deparser.multi_assign_ref(expr, context);
  ELSEIF (expr->>'NamedArgExpr') IS NOT NULL THEN
    RETURN deparser.named_arg_expr(expr, context);
  ELSEIF (expr->>'Null') IS NOT NULL THEN
    RETURN 'NULL';
  ELSEIF (expr->>'NullTest') IS NOT NULL THEN
    RETURN deparser.null_test(expr, context);
  ELSEIF (expr->>'OnConflictClause') IS NOT NULL THEN
    RETURN deparser.on_conflict_clause(expr, context);
  ELSEIF (expr->>'ObjectWithArgs') IS NOT NULL THEN
    RETURN deparser.object_with_args(expr, context);
  ELSEIF (expr->>'ParamRef') IS NOT NULL THEN
    RETURN deparser.param_ref(expr, context);
  ELSEIF (expr->>'RangeFunction') IS NOT NULL THEN
    RETURN deparser.range_function(expr, context);
  ELSEIF (expr->>'RangeSubselect') IS NOT NULL THEN
    RETURN deparser.range_subselect(expr, context);
  ELSEIF (expr->>'RangeVar') IS NOT NULL THEN
    RETURN deparser.range_var(expr, context);
  ELSEIF (expr->>'RawStmt') IS NOT NULL THEN
    RETURN deparser.expression(expr->'RawStmt'->'stmt');
  ELSEIF (expr->>'RenameStmt') IS NOT NULL THEN
    RETURN deparser.rename_stmt(expr, context);
  ELSEIF (expr->>'ResTarget') IS NOT NULL THEN
    RETURN deparser.res_target(expr, context);
  ELSEIF (expr->>'RoleSpec') IS NOT NULL THEN
    RETURN deparser.role_spec(expr, context);
  ELSEIF (expr->>'RowExpr') IS NOT NULL THEN
    RETURN deparser.row_expr(expr, context);
  ELSEIF (expr->>'RuleStmt') IS NOT NULL THEN
    RETURN deparser.rule_stmt(expr, context);
  ELSEIF (expr->>'SetToDefault') IS NOT NULL THEN
    RETURN deparser.set_to_default(expr, context);
  ELSEIF (expr->>'SelectStmt') IS NOT NULL THEN
    RETURN deparser.select_stmt(expr, context);
  ELSEIF (expr->>'SortBy') IS NOT NULL THEN
    RETURN deparser.sort_by(expr, context);
  ELSEIF (expr->>'SQLValueFunction') IS NOT NULL THEN
    RETURN deparser.sql_value_function(expr, context);
  ELSEIF (expr->>'String') IS NOT NULL THEN
    RETURN deparser.string(expr, context);
  ELSEIF (expr->>'SubLink') IS NOT NULL THEN
    RETURN deparser.sub_link(expr, context);
  ELSEIF (expr->>'TransactionStmt') IS NOT NULL THEN
    RETURN deparser.transaction_stmt(expr, context);
  ELSEIF (expr->>'TypeCast') IS NOT NULL THEN
    RETURN deparser.type_cast(expr, context);
  ELSEIF (expr->>'TypeName') IS NOT NULL THEN
    RETURN deparser.type_name(expr, context);
  ELSEIF (expr->>'UpdateStmt') IS NOT NULL THEN
    RETURN deparser.update_stmt(expr, context);
  ELSEIF (expr->>'VacuumStmt') IS NOT NULL THEN
    RETURN deparser.vacuum_stmt(expr, context);
  ELSEIF (expr->>'VariableSetStmt') IS NOT NULL THEN
    RETURN deparser.variable_set_stmt(expr, context);
  ELSEIF (expr->>'ViewStmt') IS NOT NULL THEN
    RETURN deparser.view_stmt(expr, context);
  ELSEIF (expr->>'WithClause') IS NOT NULL THEN
    RETURN deparser.with_clause(expr, context);
  ELSE
    RAISE EXCEPTION 'UNSUPPORTED_EXPRESSION %', expr::text;
  END IF;

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.expressions_array ( node jsonb, context text DEFAULT NULL ) RETURNS text[] AS $EOFCODE$
DECLARE
  expr jsonb;
  els text[] = ARRAY[]::text[];
BEGIN

  FOR expr IN
  SELECT * FROM jsonb_array_elements(node)
  LOOP
    els = array_append(els, deparser.expression(expr, context));
  END LOOP;

  return els;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.deparse ( ast jsonb ) RETURNS text AS $EOFCODE$
BEGIN
	RETURN deparser.expression(ast);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.deparse_query ( ast jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  lines text[];
  node jsonb;
BEGIN
   FOR node IN SELECT * FROM jsonb_array_elements(ast)
   LOOP 
    lines = array_append(lines, deparser.deparse(node) || ';' || E'\n');
   END LOOP;
   RETURN array_to_string(lines, E'\n');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;