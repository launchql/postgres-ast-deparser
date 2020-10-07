-- Deploy schemas/ast/procedures/types to pg

-- requires: schemas/ast/schema

BEGIN;

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


CREATE FUNCTION ast.raw_stmt (
    v_stmt jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RawStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RawStmt, stmt}', v_stmt);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_schema_stmt (
    v_schemaname text DEFAULT NULL,
    v_if_not_exists boolean DEFAULT NULL,
    v_schemaElts jsonb DEFAULT NULL,
    v_authrole jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateSchemaStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateSchemaStmt, schemaname}', to_jsonb(v_schemaname));
    result = ast.jsonb_set(result, '{CreateSchemaStmt, if_not_exists}', to_jsonb(v_if_not_exists));
    result = ast.jsonb_set(result, '{CreateSchemaStmt, schemaElts}', v_schemaElts);
    result = ast.jsonb_set(result, '{CreateSchemaStmt, authrole}', v_authrole);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_stmt (
    v_relation jsonb DEFAULT NULL,
    v_tableElts jsonb DEFAULT NULL,
    v_oncommit int DEFAULT NULL,
    v_inhRelations jsonb DEFAULT NULL,
    v_options jsonb DEFAULT NULL,
    v_ofTypename jsonb DEFAULT NULL,
    v_if_not_exists boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{CreateStmt, tableElts}', v_tableElts);
    result = ast.jsonb_set(result, '{CreateStmt, oncommit}', to_jsonb(v_oncommit));
    result = ast.jsonb_set(result, '{CreateStmt, inhRelations}', v_inhRelations);
    result = ast.jsonb_set(result, '{CreateStmt, options}', v_options);
    result = ast.jsonb_set(result, '{CreateStmt, ofTypename}', v_ofTypename);
    result = ast.jsonb_set(result, '{CreateStmt, if_not_exists}', to_jsonb(v_if_not_exists));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_var (
    v_schemaname text DEFAULT NULL,
    v_relname text DEFAULT NULL,
    v_inh boolean DEFAULT NULL,
    v_relpersistence text DEFAULT NULL,
    v_alias jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RangeVar":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RangeVar, schemaname}', to_jsonb(v_schemaname));
    result = ast.jsonb_set(result, '{RangeVar, relname}', to_jsonb(v_relname));
    result = ast.jsonb_set(result, '{RangeVar, inh}', to_jsonb(v_inh));
    result = ast.jsonb_set(result, '{RangeVar, relpersistence}', to_jsonb(v_relpersistence));
    result = ast.jsonb_set(result, '{RangeVar, alias}', v_alias);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.column_def (
    v_colname text DEFAULT NULL,
    v_typeName jsonb DEFAULT NULL,
    v_is_local boolean DEFAULT NULL,
    v_constraints jsonb DEFAULT NULL,
    v_raw_default jsonb DEFAULT NULL,
    v_collClause jsonb DEFAULT NULL,
    v_fdwoptions jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ColumnDef":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ColumnDef, colname}', to_jsonb(v_colname));
    result = ast.jsonb_set(result, '{ColumnDef, typeName}', v_typeName);
    result = ast.jsonb_set(result, '{ColumnDef, is_local}', to_jsonb(v_is_local));
    result = ast.jsonb_set(result, '{ColumnDef, constraints}', v_constraints);
    result = ast.jsonb_set(result, '{ColumnDef, raw_default}', v_raw_default);
    result = ast.jsonb_set(result, '{ColumnDef, collClause}', v_collClause);
    result = ast.jsonb_set(result, '{ColumnDef, fdwoptions}', v_fdwoptions);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.type_name (
    v_names jsonb DEFAULT NULL,
    v_typemod int DEFAULT NULL,
    v_typmods jsonb DEFAULT NULL,
    v_setof boolean DEFAULT NULL,
    v_arrayBounds jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"TypeName":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{TypeName, names}', v_names);
    result = ast.jsonb_set(result, '{TypeName, typemod}', to_jsonb(v_typemod));
    result = ast.jsonb_set(result, '{TypeName, typmods}', v_typmods);
    result = ast.jsonb_set(result, '{TypeName, setof}', to_jsonb(v_setof));
    result = ast.jsonb_set(result, '{TypeName, arrayBounds}', v_arrayBounds);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.string (
    v_str text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"String":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{String, str}', to_jsonb(v_str));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.constraint (
    v_contype int DEFAULT NULL,
    v_raw_expr jsonb DEFAULT NULL,
    v_conname text DEFAULT NULL,
    v_pktable jsonb DEFAULT NULL,
    v_fk_attrs jsonb DEFAULT NULL,
    v_pk_attrs jsonb DEFAULT NULL,
    v_fk_matchtype text DEFAULT NULL,
    v_fk_upd_action text DEFAULT NULL,
    v_fk_del_action text DEFAULT NULL,
    v_initially_valid boolean DEFAULT NULL,
    v_keys jsonb DEFAULT NULL,
    v_is_no_inherit boolean DEFAULT NULL,
    v_skip_validation boolean DEFAULT NULL,
    v_exclusions jsonb DEFAULT NULL,
    v_access_method text DEFAULT NULL,
    v_deferrable boolean DEFAULT NULL,
    v_indexname text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"Constraint":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{Constraint, contype}', to_jsonb(v_contype));
    result = ast.jsonb_set(result, '{Constraint, raw_expr}', v_raw_expr);
    result = ast.jsonb_set(result, '{Constraint, conname}', to_jsonb(v_conname));
    result = ast.jsonb_set(result, '{Constraint, pktable}', v_pktable);
    result = ast.jsonb_set(result, '{Constraint, fk_attrs}', v_fk_attrs);
    result = ast.jsonb_set(result, '{Constraint, pk_attrs}', v_pk_attrs);
    result = ast.jsonb_set(result, '{Constraint, fk_matchtype}', to_jsonb(v_fk_matchtype));
    result = ast.jsonb_set(result, '{Constraint, fk_upd_action}', to_jsonb(v_fk_upd_action));
    result = ast.jsonb_set(result, '{Constraint, fk_del_action}', to_jsonb(v_fk_del_action));
    result = ast.jsonb_set(result, '{Constraint, initially_valid}', to_jsonb(v_initially_valid));
    result = ast.jsonb_set(result, '{Constraint, keys}', v_keys);
    result = ast.jsonb_set(result, '{Constraint, is_no_inherit}', to_jsonb(v_is_no_inherit));
    result = ast.jsonb_set(result, '{Constraint, skip_validation}', to_jsonb(v_skip_validation));
    result = ast.jsonb_set(result, '{Constraint, exclusions}', v_exclusions);
    result = ast.jsonb_set(result, '{Constraint, access_method}', to_jsonb(v_access_method));
    result = ast.jsonb_set(result, '{Constraint, deferrable}', to_jsonb(v_deferrable));
    result = ast.jsonb_set(result, '{Constraint, indexname}', to_jsonb(v_indexname));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_const (
    v_val jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Const":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{A_Const, val}', v_val);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.integer (
    v_ival int DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"Integer":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{Integer, ival}', to_jsonb(v_ival));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_table_stmt (
    v_relation jsonb DEFAULT NULL,
    v_cmds jsonb DEFAULT NULL,
    v_relkind int DEFAULT NULL,
    v_missing_ok boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterTableStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterTableStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{AlterTableStmt, cmds}', v_cmds);
    result = ast.jsonb_set(result, '{AlterTableStmt, relkind}', to_jsonb(v_relkind));
    result = ast.jsonb_set(result, '{AlterTableStmt, missing_ok}', to_jsonb(v_missing_ok));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_table_cmd (
    v_subtype int DEFAULT NULL,
    v_behavior int DEFAULT NULL,
    v_name text DEFAULT NULL,
    v_def jsonb DEFAULT NULL,
    v_missing_ok boolean DEFAULT NULL,
    v_newowner jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterTableCmd":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterTableCmd, subtype}', to_jsonb(v_subtype));
    result = ast.jsonb_set(result, '{AlterTableCmd, behavior}', to_jsonb(v_behavior));
    result = ast.jsonb_set(result, '{AlterTableCmd, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{AlterTableCmd, def}', v_def);
    result = ast.jsonb_set(result, '{AlterTableCmd, missing_ok}', to_jsonb(v_missing_ok));
    result = ast.jsonb_set(result, '{AlterTableCmd, newowner}', v_newowner);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.sql_value_function (
    v_op int DEFAULT NULL,
    v_typmod int DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"SQLValueFunction":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{SQLValueFunction, op}', to_jsonb(v_op));
    result = ast.jsonb_set(result, '{SQLValueFunction, typmod}', to_jsonb(v_typmod));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.rename_stmt (
    v_renameType int DEFAULT NULL,
    v_relationType int DEFAULT NULL,
    v_relation jsonb DEFAULT NULL,
    v_subname text DEFAULT NULL,
    v_newname text DEFAULT NULL,
    v_behavior int DEFAULT NULL,
    v_object jsonb DEFAULT NULL,
    v_missing_ok boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RenameStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RenameStmt, renameType}', to_jsonb(v_renameType));
    result = ast.jsonb_set(result, '{RenameStmt, relationType}', to_jsonb(v_relationType));
    result = ast.jsonb_set(result, '{RenameStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{RenameStmt, subname}', to_jsonb(v_subname));
    result = ast.jsonb_set(result, '{RenameStmt, newname}', to_jsonb(v_newname));
    result = ast.jsonb_set(result, '{RenameStmt, behavior}', to_jsonb(v_behavior));
    result = ast.jsonb_set(result, '{RenameStmt, object}', v_object);
    result = ast.jsonb_set(result, '{RenameStmt, missing_ok}', to_jsonb(v_missing_ok));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_expr (
    v_kind int DEFAULT NULL,
    v_name jsonb DEFAULT NULL,
    v_lexpr jsonb DEFAULT NULL,
    v_rexpr jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Expr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{A_Expr, kind}', to_jsonb(v_kind));
    result = ast.jsonb_set(result, '{A_Expr, name}', v_name);
    result = ast.jsonb_set(result, '{A_Expr, lexpr}', v_lexpr);
    result = ast.jsonb_set(result, '{A_Expr, rexpr}', v_rexpr);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.type_cast (
    v_arg jsonb DEFAULT NULL,
    v_typeName jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"TypeCast":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{TypeCast, arg}', v_arg);
    result = ast.jsonb_set(result, '{TypeCast, typeName}', v_typeName);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.column_ref (
    v_fields jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ColumnRef":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ColumnRef, fields}', v_fields);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.func_call (
    v_funcname jsonb DEFAULT NULL,
    v_args jsonb DEFAULT NULL,
    v_agg_star boolean DEFAULT NULL,
    v_func_variadic boolean DEFAULT NULL,
    v_agg_order jsonb DEFAULT NULL,
    v_agg_distinct boolean DEFAULT NULL,
    v_agg_filter jsonb DEFAULT NULL,
    v_agg_within_group boolean DEFAULT NULL,
    v_over jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"FuncCall":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{FuncCall, funcname}', v_funcname);
    result = ast.jsonb_set(result, '{FuncCall, args}', v_args);
    result = ast.jsonb_set(result, '{FuncCall, agg_star}', to_jsonb(v_agg_star));
    result = ast.jsonb_set(result, '{FuncCall, func_variadic}', to_jsonb(v_func_variadic));
    result = ast.jsonb_set(result, '{FuncCall, agg_order}', v_agg_order);
    result = ast.jsonb_set(result, '{FuncCall, agg_distinct}', to_jsonb(v_agg_distinct));
    result = ast.jsonb_set(result, '{FuncCall, agg_filter}', v_agg_filter);
    result = ast.jsonb_set(result, '{FuncCall, agg_within_group}', to_jsonb(v_agg_within_group));
    result = ast.jsonb_set(result, '{FuncCall, over}', v_over);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_default_privileges_stmt (
    v_options jsonb DEFAULT NULL,
    v_action jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterDefaultPrivilegesStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterDefaultPrivilegesStmt, options}', v_options);
    result = ast.jsonb_set(result, '{AlterDefaultPrivilegesStmt, action}', v_action);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.def_elem (
    v_defname text DEFAULT NULL,
    v_arg jsonb DEFAULT NULL,
    v_defaction int DEFAULT NULL,
    v_defnamespace text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DefElem":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DefElem, defname}', to_jsonb(v_defname));
    result = ast.jsonb_set(result, '{DefElem, arg}', v_arg);
    result = ast.jsonb_set(result, '{DefElem, defaction}', to_jsonb(v_defaction));
    result = ast.jsonb_set(result, '{DefElem, defnamespace}', to_jsonb(v_defnamespace));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grant_stmt (
    v_is_grant boolean DEFAULT NULL,
    v_targtype int DEFAULT NULL,
    v_objtype int DEFAULT NULL,
    v_privileges jsonb DEFAULT NULL,
    v_grantees jsonb DEFAULT NULL,
    v_behavior int DEFAULT NULL,
    v_objects jsonb DEFAULT NULL,
    v_grant_option boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"GrantStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{GrantStmt, is_grant}', to_jsonb(v_is_grant));
    result = ast.jsonb_set(result, '{GrantStmt, targtype}', to_jsonb(v_targtype));
    result = ast.jsonb_set(result, '{GrantStmt, objtype}', to_jsonb(v_objtype));
    result = ast.jsonb_set(result, '{GrantStmt, privileges}', v_privileges);
    result = ast.jsonb_set(result, '{GrantStmt, grantees}', v_grantees);
    result = ast.jsonb_set(result, '{GrantStmt, behavior}', to_jsonb(v_behavior));
    result = ast.jsonb_set(result, '{GrantStmt, objects}', v_objects);
    result = ast.jsonb_set(result, '{GrantStmt, grant_option}', to_jsonb(v_grant_option));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.access_priv (
    v_priv_name text DEFAULT NULL,
    v_cols jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AccessPriv":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AccessPriv, priv_name}', to_jsonb(v_priv_name));
    result = ast.jsonb_set(result, '{AccessPriv, cols}', v_cols);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.role_spec (
    v_roletype int DEFAULT NULL,
    v_rolename text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RoleSpec":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RoleSpec, roletype}', to_jsonb(v_roletype));
    result = ast.jsonb_set(result, '{RoleSpec, rolename}', to_jsonb(v_rolename));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.comment_stmt (
    v_objtype int DEFAULT NULL,
    v_object jsonb DEFAULT NULL,
    v_comment text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CommentStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CommentStmt, objtype}', to_jsonb(v_objtype));
    result = ast.jsonb_set(result, '{CommentStmt, object}', v_object);
    result = ast.jsonb_set(result, '{CommentStmt, comment}', to_jsonb(v_comment));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.object_with_args (
    v_objname jsonb DEFAULT NULL,
    v_objargs jsonb DEFAULT NULL,
    v_args_unspecified boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ObjectWithArgs":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ObjectWithArgs, objname}', v_objname);
    result = ast.jsonb_set(result, '{ObjectWithArgs, objargs}', v_objargs);
    result = ast.jsonb_set(result, '{ObjectWithArgs, args_unspecified}', to_jsonb(v_args_unspecified));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.select_stmt (
    v_targetList jsonb DEFAULT NULL,
    v_fromClause jsonb DEFAULT NULL,
    v_groupClause jsonb DEFAULT NULL,
    v_havingClause jsonb DEFAULT NULL,
    v_op int DEFAULT NULL,
    v_sortClause jsonb DEFAULT NULL,
    v_whereClause jsonb DEFAULT NULL,
    v_distinctClause jsonb DEFAULT NULL,
    v_limitCount jsonb DEFAULT NULL,
    v_valuesLists jsonb DEFAULT NULL,
    v_intoClause jsonb DEFAULT NULL,
    v_all boolean DEFAULT NULL,
    v_larg jsonb DEFAULT NULL,
    v_rarg jsonb DEFAULT NULL,
    v_limitOffset jsonb DEFAULT NULL,
    v_withClause jsonb DEFAULT NULL,
    v_lockingClause jsonb DEFAULT NULL,
    v_windowClause jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"SelectStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{SelectStmt, targetList}', v_targetList);
    result = ast.jsonb_set(result, '{SelectStmt, fromClause}', v_fromClause);
    result = ast.jsonb_set(result, '{SelectStmt, groupClause}', v_groupClause);
    result = ast.jsonb_set(result, '{SelectStmt, havingClause}', v_havingClause);
    result = ast.jsonb_set(result, '{SelectStmt, op}', to_jsonb(v_op));
    result = ast.jsonb_set(result, '{SelectStmt, sortClause}', v_sortClause);
    result = ast.jsonb_set(result, '{SelectStmt, whereClause}', v_whereClause);
    result = ast.jsonb_set(result, '{SelectStmt, distinctClause}', v_distinctClause);
    result = ast.jsonb_set(result, '{SelectStmt, limitCount}', v_limitCount);
    result = ast.jsonb_set(result, '{SelectStmt, valuesLists}', v_valuesLists);
    result = ast.jsonb_set(result, '{SelectStmt, intoClause}', v_intoClause);
    result = ast.jsonb_set(result, '{SelectStmt, all}', to_jsonb(v_all));
    result = ast.jsonb_set(result, '{SelectStmt, larg}', v_larg);
    result = ast.jsonb_set(result, '{SelectStmt, rarg}', v_rarg);
    result = ast.jsonb_set(result, '{SelectStmt, limitOffset}', v_limitOffset);
    result = ast.jsonb_set(result, '{SelectStmt, withClause}', v_withClause);
    result = ast.jsonb_set(result, '{SelectStmt, lockingClause}', v_lockingClause);
    result = ast.jsonb_set(result, '{SelectStmt, windowClause}', v_windowClause);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.res_target (
    v_val jsonb DEFAULT NULL,
    v_name text DEFAULT NULL,
    v_indirection jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ResTarget":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ResTarget, val}', v_val);
    result = ast.jsonb_set(result, '{ResTarget, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{ResTarget, indirection}', v_indirection);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alias (
    v_aliasname text DEFAULT NULL,
    v_colnames jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"Alias":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{Alias, aliasname}', to_jsonb(v_aliasname));
    result = ast.jsonb_set(result, '{Alias, colnames}', v_colnames);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.join_expr (
    v_jointype int DEFAULT NULL,
    v_larg jsonb DEFAULT NULL,
    v_rarg jsonb DEFAULT NULL,
    v_quals jsonb DEFAULT NULL,
    v_usingClause jsonb DEFAULT NULL,
    v_isNatural boolean DEFAULT NULL,
    v_alias jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"JoinExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{JoinExpr, jointype}', to_jsonb(v_jointype));
    result = ast.jsonb_set(result, '{JoinExpr, larg}', v_larg);
    result = ast.jsonb_set(result, '{JoinExpr, rarg}', v_rarg);
    result = ast.jsonb_set(result, '{JoinExpr, quals}', v_quals);
    result = ast.jsonb_set(result, '{JoinExpr, usingClause}', v_usingClause);
    result = ast.jsonb_set(result, '{JoinExpr, isNatural}', to_jsonb(v_isNatural));
    result = ast.jsonb_set(result, '{JoinExpr, alias}', v_alias);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.bool_expr (
    v_boolop int DEFAULT NULL,
    v_args jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"BoolExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{BoolExpr, boolop}', to_jsonb(v_boolop));
    result = ast.jsonb_set(result, '{BoolExpr, args}', v_args);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_star (
    
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Star":{}}'::jsonb;
BEGIN
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.sort_by (
    v_node jsonb DEFAULT NULL,
    v_sortby_dir int DEFAULT NULL,
    v_sortby_nulls int DEFAULT NULL,
    v_useOp jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"SortBy":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{SortBy, node}', v_node);
    result = ast.jsonb_set(result, '{SortBy, sortby_dir}', to_jsonb(v_sortby_dir));
    result = ast.jsonb_set(result, '{SortBy, sortby_nulls}', to_jsonb(v_sortby_nulls));
    result = ast.jsonb_set(result, '{SortBy, useOp}', v_useOp);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.named_arg_expr (
    v_arg jsonb DEFAULT NULL,
    v_name text DEFAULT NULL,
    v_argnumber int DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"NamedArgExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{NamedArgExpr, arg}', v_arg);
    result = ast.jsonb_set(result, '{NamedArgExpr, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{NamedArgExpr, argnumber}', to_jsonb(v_argnumber));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_array_expr (
    v_elements jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_ArrayExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{A_ArrayExpr, elements}', v_elements);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.float (
    v_str text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"Float":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{Float, str}', to_jsonb(v_str));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_function (
    v_is_rowsfrom boolean DEFAULT NULL,
    v_functions jsonb DEFAULT NULL,
    v_coldeflist jsonb DEFAULT NULL,
    v_alias jsonb DEFAULT NULL,
    v_lateral boolean DEFAULT NULL,
    v_ordinality boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RangeFunction":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RangeFunction, is_rowsfrom}', to_jsonb(v_is_rowsfrom));
    result = ast.jsonb_set(result, '{RangeFunction, functions}', v_functions);
    result = ast.jsonb_set(result, '{RangeFunction, coldeflist}', v_coldeflist);
    result = ast.jsonb_set(result, '{RangeFunction, alias}', v_alias);
    result = ast.jsonb_set(result, '{RangeFunction, lateral}', to_jsonb(v_lateral));
    result = ast.jsonb_set(result, '{RangeFunction, ordinality}', to_jsonb(v_ordinality));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.sub_link (
    v_subLinkType int DEFAULT NULL,
    v_subselect jsonb DEFAULT NULL,
    v_testexpr jsonb DEFAULT NULL,
    v_operName jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"SubLink":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{SubLink, subLinkType}', to_jsonb(v_subLinkType));
    result = ast.jsonb_set(result, '{SubLink, subselect}', v_subselect);
    result = ast.jsonb_set(result, '{SubLink, testexpr}', v_testexpr);
    result = ast.jsonb_set(result, '{SubLink, operName}', v_operName);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.null (
    
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"Null":{}}'::jsonb;
BEGIN
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.variable_set_stmt (
    v_kind int DEFAULT NULL,
    v_name text DEFAULT NULL,
    v_args jsonb DEFAULT NULL,
    v_is_local boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"VariableSetStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{VariableSetStmt, kind}', to_jsonb(v_kind));
    result = ast.jsonb_set(result, '{VariableSetStmt, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{VariableSetStmt, args}', v_args);
    result = ast.jsonb_set(result, '{VariableSetStmt, is_local}', to_jsonb(v_is_local));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.variable_show_stmt (
    v_name text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"VariableShowStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{VariableShowStmt, name}', to_jsonb(v_name));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.do_stmt (
    v_args jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DoStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DoStmt, args}', v_args);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_domain_stmt (
    v_domainname jsonb DEFAULT NULL,
    v_typeName jsonb DEFAULT NULL,
    v_constraints jsonb DEFAULT NULL,
    v_collClause jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateDomainStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateDomainStmt, domainname}', v_domainname);
    result = ast.jsonb_set(result, '{CreateDomainStmt, typeName}', v_typeName);
    result = ast.jsonb_set(result, '{CreateDomainStmt, constraints}', v_constraints);
    result = ast.jsonb_set(result, '{CreateDomainStmt, collClause}', v_collClause);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_enum_stmt (
    v_typeName jsonb DEFAULT NULL,
    v_vals jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateEnumStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateEnumStmt, typeName}', v_typeName);
    result = ast.jsonb_set(result, '{CreateEnumStmt, vals}', v_vals);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_extension_stmt (
    v_extname text DEFAULT NULL,
    v_options jsonb DEFAULT NULL,
    v_if_not_exists boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateExtensionStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateExtensionStmt, extname}', to_jsonb(v_extname));
    result = ast.jsonb_set(result, '{CreateExtensionStmt, options}', v_options);
    result = ast.jsonb_set(result, '{CreateExtensionStmt, if_not_exists}', to_jsonb(v_if_not_exists));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_function_stmt (
    v_replace boolean DEFAULT NULL,
    v_funcname jsonb DEFAULT NULL,
    v_parameters jsonb DEFAULT NULL,
    v_returnType jsonb DEFAULT NULL,
    v_options jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateFunctionStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateFunctionStmt, replace}', to_jsonb(v_replace));
    result = ast.jsonb_set(result, '{CreateFunctionStmt, funcname}', v_funcname);
    result = ast.jsonb_set(result, '{CreateFunctionStmt, parameters}', v_parameters);
    result = ast.jsonb_set(result, '{CreateFunctionStmt, returnType}', v_returnType);
    result = ast.jsonb_set(result, '{CreateFunctionStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.function_parameter (
    v_name text DEFAULT NULL,
    v_argType jsonb DEFAULT NULL,
    v_mode int DEFAULT NULL,
    v_defexpr jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"FunctionParameter":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{FunctionParameter, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{FunctionParameter, argType}', v_argType);
    result = ast.jsonb_set(result, '{FunctionParameter, mode}', to_jsonb(v_mode));
    result = ast.jsonb_set(result, '{FunctionParameter, defexpr}', v_defexpr);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.transaction_stmt (
    v_kind int DEFAULT NULL,
    v_options jsonb DEFAULT NULL,
    v_gid text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"TransactionStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{TransactionStmt, kind}', to_jsonb(v_kind));
    result = ast.jsonb_set(result, '{TransactionStmt, options}', v_options);
    result = ast.jsonb_set(result, '{TransactionStmt, gid}', to_jsonb(v_gid));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.index_stmt (
    v_idxname text DEFAULT NULL,
    v_relation jsonb DEFAULT NULL,
    v_accessMethod text DEFAULT NULL,
    v_indexParams jsonb DEFAULT NULL,
    v_concurrent boolean DEFAULT NULL,
    v_unique boolean DEFAULT NULL,
    v_whereClause jsonb DEFAULT NULL,
    v_options jsonb DEFAULT NULL,
    v_if_not_exists boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"IndexStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{IndexStmt, idxname}', to_jsonb(v_idxname));
    result = ast.jsonb_set(result, '{IndexStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{IndexStmt, accessMethod}', to_jsonb(v_accessMethod));
    result = ast.jsonb_set(result, '{IndexStmt, indexParams}', v_indexParams);
    result = ast.jsonb_set(result, '{IndexStmt, concurrent}', to_jsonb(v_concurrent));
    result = ast.jsonb_set(result, '{IndexStmt, unique}', to_jsonb(v_unique));
    result = ast.jsonb_set(result, '{IndexStmt, whereClause}', v_whereClause);
    result = ast.jsonb_set(result, '{IndexStmt, options}', v_options);
    result = ast.jsonb_set(result, '{IndexStmt, if_not_exists}', to_jsonb(v_if_not_exists));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.index_elem (
    v_name text DEFAULT NULL,
    v_ordering int DEFAULT NULL,
    v_nulls_ordering int DEFAULT NULL,
    v_expr jsonb DEFAULT NULL,
    v_opclass jsonb DEFAULT NULL,
    v_collation jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"IndexElem":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{IndexElem, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{IndexElem, ordering}', to_jsonb(v_ordering));
    result = ast.jsonb_set(result, '{IndexElem, nulls_ordering}', to_jsonb(v_nulls_ordering));
    result = ast.jsonb_set(result, '{IndexElem, expr}', v_expr);
    result = ast.jsonb_set(result, '{IndexElem, opclass}', v_opclass);
    result = ast.jsonb_set(result, '{IndexElem, collation}', v_collation);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.null_test (
    v_arg jsonb DEFAULT NULL,
    v_nulltesttype int DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"NullTest":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{NullTest, arg}', v_arg);
    result = ast.jsonb_set(result, '{NullTest, nulltesttype}', to_jsonb(v_nulltesttype));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.param_ref (
    v_number int DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ParamRef":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ParamRef, number}', to_jsonb(v_number));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_policy_stmt (
    v_policy_name text DEFAULT NULL,
    v_table jsonb DEFAULT NULL,
    v_cmd_name text DEFAULT NULL,
    v_permissive boolean DEFAULT NULL,
    v_roles jsonb DEFAULT NULL,
    v_qual jsonb DEFAULT NULL,
    v_with_check jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreatePolicyStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreatePolicyStmt, policy_name}', to_jsonb(v_policy_name));
    result = ast.jsonb_set(result, '{CreatePolicyStmt, table}', v_table);
    result = ast.jsonb_set(result, '{CreatePolicyStmt, cmd_name}', to_jsonb(v_cmd_name));
    result = ast.jsonb_set(result, '{CreatePolicyStmt, permissive}', to_jsonb(v_permissive));
    result = ast.jsonb_set(result, '{CreatePolicyStmt, roles}', v_roles);
    result = ast.jsonb_set(result, '{CreatePolicyStmt, qual}', v_qual);
    result = ast.jsonb_set(result, '{CreatePolicyStmt, with_check}', v_with_check);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_subselect (
    v_subquery jsonb DEFAULT NULL,
    v_alias jsonb DEFAULT NULL,
    v_lateral boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RangeSubselect":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RangeSubselect, subquery}', v_subquery);
    result = ast.jsonb_set(result, '{RangeSubselect, alias}', v_alias);
    result = ast.jsonb_set(result, '{RangeSubselect, lateral}', to_jsonb(v_lateral));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_indirection (
    v_arg jsonb DEFAULT NULL,
    v_indirection jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Indirection":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{A_Indirection, arg}', v_arg);
    result = ast.jsonb_set(result, '{A_Indirection, indirection}', v_indirection);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.row_expr (
    v_args jsonb DEFAULT NULL,
    v_row_format int DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RowExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RowExpr, args}', v_args);
    result = ast.jsonb_set(result, '{RowExpr, row_format}', to_jsonb(v_row_format));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_role_stmt (
    v_stmt_type int DEFAULT NULL,
    v_role text DEFAULT NULL,
    v_options jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateRoleStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateRoleStmt, stmt_type}', to_jsonb(v_stmt_type));
    result = ast.jsonb_set(result, '{CreateRoleStmt, role}', to_jsonb(v_role));
    result = ast.jsonb_set(result, '{CreateRoleStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grant_role_stmt (
    v_granted_roles jsonb DEFAULT NULL,
    v_grantee_roles jsonb DEFAULT NULL,
    v_is_grant boolean DEFAULT NULL,
    v_behavior int DEFAULT NULL,
    v_admin_opt boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"GrantRoleStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{GrantRoleStmt, granted_roles}', v_granted_roles);
    result = ast.jsonb_set(result, '{GrantRoleStmt, grantee_roles}', v_grantee_roles);
    result = ast.jsonb_set(result, '{GrantRoleStmt, is_grant}', to_jsonb(v_is_grant));
    result = ast.jsonb_set(result, '{GrantRoleStmt, behavior}', to_jsonb(v_behavior));
    result = ast.jsonb_set(result, '{GrantRoleStmt, admin_opt}', to_jsonb(v_admin_opt));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.rule_stmt (
    v_relation jsonb DEFAULT NULL,
    v_rulename text DEFAULT NULL,
    v_event int DEFAULT NULL,
    v_instead boolean DEFAULT NULL,
    v_actions jsonb DEFAULT NULL,
    v_whereClause jsonb DEFAULT NULL,
    v_replace boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RuleStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RuleStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{RuleStmt, rulename}', to_jsonb(v_rulename));
    result = ast.jsonb_set(result, '{RuleStmt, event}', to_jsonb(v_event));
    result = ast.jsonb_set(result, '{RuleStmt, instead}', to_jsonb(v_instead));
    result = ast.jsonb_set(result, '{RuleStmt, actions}', v_actions);
    result = ast.jsonb_set(result, '{RuleStmt, whereClause}', v_whereClause);
    result = ast.jsonb_set(result, '{RuleStmt, replace}', to_jsonb(v_replace));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.update_stmt (
    v_relation jsonb DEFAULT NULL,
    v_targetList jsonb DEFAULT NULL,
    v_whereClause jsonb DEFAULT NULL,
    v_returningList jsonb DEFAULT NULL,
    v_fromClause jsonb DEFAULT NULL,
    v_withClause jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"UpdateStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{UpdateStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{UpdateStmt, targetList}', v_targetList);
    result = ast.jsonb_set(result, '{UpdateStmt, whereClause}', v_whereClause);
    result = ast.jsonb_set(result, '{UpdateStmt, returningList}', v_returningList);
    result = ast.jsonb_set(result, '{UpdateStmt, fromClause}', v_fromClause);
    result = ast.jsonb_set(result, '{UpdateStmt, withClause}', v_withClause);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.delete_stmt (
    v_relation jsonb DEFAULT NULL,
    v_whereClause jsonb DEFAULT NULL,
    v_usingClause jsonb DEFAULT NULL,
    v_returningList jsonb DEFAULT NULL,
    v_withClause jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DeleteStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DeleteStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{DeleteStmt, whereClause}', v_whereClause);
    result = ast.jsonb_set(result, '{DeleteStmt, usingClause}', v_usingClause);
    result = ast.jsonb_set(result, '{DeleteStmt, returningList}', v_returningList);
    result = ast.jsonb_set(result, '{DeleteStmt, withClause}', v_withClause);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.insert_stmt (
    v_relation jsonb DEFAULT NULL,
    v_selectStmt jsonb DEFAULT NULL,
    v_override int DEFAULT NULL,
    v_cols jsonb DEFAULT NULL,
    v_onConflictClause jsonb DEFAULT NULL,
    v_returningList jsonb DEFAULT NULL,
    v_withClause jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"InsertStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{InsertStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{InsertStmt, selectStmt}', v_selectStmt);
    result = ast.jsonb_set(result, '{InsertStmt, override}', to_jsonb(v_override));
    result = ast.jsonb_set(result, '{InsertStmt, cols}', v_cols);
    result = ast.jsonb_set(result, '{InsertStmt, onConflictClause}', v_onConflictClause);
    result = ast.jsonb_set(result, '{InsertStmt, returningList}', v_returningList);
    result = ast.jsonb_set(result, '{InsertStmt, withClause}', v_withClause);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_seq_stmt (
    v_sequence jsonb DEFAULT NULL,
    v_options jsonb DEFAULT NULL,
    v_if_not_exists boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateSeqStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateSeqStmt, sequence}', v_sequence);
    result = ast.jsonb_set(result, '{CreateSeqStmt, options}', v_options);
    result = ast.jsonb_set(result, '{CreateSeqStmt, if_not_exists}', to_jsonb(v_if_not_exists));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.on_conflict_clause (
    v_action int DEFAULT NULL,
    v_infer jsonb DEFAULT NULL,
    v_targetList jsonb DEFAULT NULL,
    v_whereClause jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"OnConflictClause":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{OnConflictClause, action}', to_jsonb(v_action));
    result = ast.jsonb_set(result, '{OnConflictClause, infer}', v_infer);
    result = ast.jsonb_set(result, '{OnConflictClause, targetList}', v_targetList);
    result = ast.jsonb_set(result, '{OnConflictClause, whereClause}', v_whereClause);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.infer_clause (
    v_indexElems jsonb DEFAULT NULL,
    v_conname text DEFAULT NULL,
    v_whereClause jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"InferClause":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{InferClause, indexElems}', v_indexElems);
    result = ast.jsonb_set(result, '{InferClause, conname}', to_jsonb(v_conname));
    result = ast.jsonb_set(result, '{InferClause, whereClause}', v_whereClause);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.multi_assign_ref (
    v_source jsonb DEFAULT NULL,
    v_colno int DEFAULT NULL,
    v_ncolumns int DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"MultiAssignRef":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{MultiAssignRef, source}', v_source);
    result = ast.jsonb_set(result, '{MultiAssignRef, colno}', to_jsonb(v_colno));
    result = ast.jsonb_set(result, '{MultiAssignRef, ncolumns}', to_jsonb(v_ncolumns));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.set_to_default (
    
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"SetToDefault":{}}'::jsonb;
BEGIN
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.min_max_expr (
    v_op int DEFAULT NULL,
    v_args jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"MinMaxExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{MinMaxExpr, op}', to_jsonb(v_op));
    result = ast.jsonb_set(result, '{MinMaxExpr, args}', v_args);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.drop_stmt (
    v_objects jsonb DEFAULT NULL,
    v_removeType int DEFAULT NULL,
    v_behavior int DEFAULT NULL,
    v_missing_ok boolean DEFAULT NULL,
    v_concurrent boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DropStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DropStmt, objects}', v_objects);
    result = ast.jsonb_set(result, '{DropStmt, removeType}', to_jsonb(v_removeType));
    result = ast.jsonb_set(result, '{DropStmt, behavior}', to_jsonb(v_behavior));
    result = ast.jsonb_set(result, '{DropStmt, missing_ok}', to_jsonb(v_missing_ok));
    result = ast.jsonb_set(result, '{DropStmt, concurrent}', to_jsonb(v_concurrent));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_trig_stmt (
    v_trigname text DEFAULT NULL,
    v_relation jsonb DEFAULT NULL,
    v_funcname jsonb DEFAULT NULL,
    v_row boolean DEFAULT NULL,
    v_timing int DEFAULT NULL,
    v_events int DEFAULT NULL,
    v_args jsonb DEFAULT NULL,
    v_columns jsonb DEFAULT NULL,
    v_whenClause jsonb DEFAULT NULL,
    v_transitionRels jsonb DEFAULT NULL,
    v_isconstraint boolean DEFAULT NULL,
    v_deferrable boolean DEFAULT NULL,
    v_initdeferred boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateTrigStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateTrigStmt, trigname}', to_jsonb(v_trigname));
    result = ast.jsonb_set(result, '{CreateTrigStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{CreateTrigStmt, funcname}', v_funcname);
    result = ast.jsonb_set(result, '{CreateTrigStmt, row}', to_jsonb(v_row));
    result = ast.jsonb_set(result, '{CreateTrigStmt, timing}', to_jsonb(v_timing));
    result = ast.jsonb_set(result, '{CreateTrigStmt, events}', to_jsonb(v_events));
    result = ast.jsonb_set(result, '{CreateTrigStmt, args}', v_args);
    result = ast.jsonb_set(result, '{CreateTrigStmt, columns}', v_columns);
    result = ast.jsonb_set(result, '{CreateTrigStmt, whenClause}', v_whenClause);
    result = ast.jsonb_set(result, '{CreateTrigStmt, transitionRels}', v_transitionRels);
    result = ast.jsonb_set(result, '{CreateTrigStmt, isconstraint}', to_jsonb(v_isconstraint));
    result = ast.jsonb_set(result, '{CreateTrigStmt, deferrable}', to_jsonb(v_deferrable));
    result = ast.jsonb_set(result, '{CreateTrigStmt, initdeferred}', to_jsonb(v_initdeferred));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.trigger_transition (
    v_name text DEFAULT NULL,
    v_isNew boolean DEFAULT NULL,
    v_isTable boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"TriggerTransition":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{TriggerTransition, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{TriggerTransition, isNew}', to_jsonb(v_isNew));
    result = ast.jsonb_set(result, '{TriggerTransition, isTable}', to_jsonb(v_isTable));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.composite_type_stmt (
    v_typevar jsonb DEFAULT NULL,
    v_coldeflist jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CompositeTypeStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CompositeTypeStmt, typevar}', v_typevar);
    result = ast.jsonb_set(result, '{CompositeTypeStmt, coldeflist}', v_coldeflist);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.explain_stmt (
    v_query jsonb DEFAULT NULL,
    v_options jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ExplainStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ExplainStmt, query}', v_query);
    result = ast.jsonb_set(result, '{ExplainStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.view_stmt (
    v_view jsonb DEFAULT NULL,
    v_query jsonb DEFAULT NULL,
    v_withCheckOption int DEFAULT NULL,
    v_replace boolean DEFAULT NULL,
    v_aliases jsonb DEFAULT NULL,
    v_options jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ViewStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ViewStmt, view}', v_view);
    result = ast.jsonb_set(result, '{ViewStmt, query}', v_query);
    result = ast.jsonb_set(result, '{ViewStmt, withCheckOption}', to_jsonb(v_withCheckOption));
    result = ast.jsonb_set(result, '{ViewStmt, replace}', to_jsonb(v_replace));
    result = ast.jsonb_set(result, '{ViewStmt, aliases}', v_aliases);
    result = ast.jsonb_set(result, '{ViewStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.collate_clause (
    v_arg jsonb DEFAULT NULL,
    v_collname jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CollateClause":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CollateClause, arg}', v_arg);
    result = ast.jsonb_set(result, '{CollateClause, collname}', v_collname);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.define_stmt (
    v_kind int DEFAULT NULL,
    v_defnames jsonb DEFAULT NULL,
    v_args jsonb DEFAULT NULL,
    v_definition jsonb DEFAULT NULL,
    v_oldstyle boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DefineStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DefineStmt, kind}', to_jsonb(v_kind));
    result = ast.jsonb_set(result, '{DefineStmt, defnames}', v_defnames);
    result = ast.jsonb_set(result, '{DefineStmt, args}', v_args);
    result = ast.jsonb_set(result, '{DefineStmt, definition}', v_definition);
    result = ast.jsonb_set(result, '{DefineStmt, oldstyle}', to_jsonb(v_oldstyle));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.drop_role_stmt (
    v_roles jsonb DEFAULT NULL,
    v_missing_ok boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DropRoleStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DropRoleStmt, roles}', v_roles);
    result = ast.jsonb_set(result, '{DropRoleStmt, missing_ok}', to_jsonb(v_missing_ok));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_owner_stmt (
    v_objectType int DEFAULT NULL,
    v_object jsonb DEFAULT NULL,
    v_newowner jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterOwnerStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterOwnerStmt, objectType}', to_jsonb(v_objectType));
    result = ast.jsonb_set(result, '{AlterOwnerStmt, object}', v_object);
    result = ast.jsonb_set(result, '{AlterOwnerStmt, newowner}', v_newowner);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_object_schema_stmt (
    v_objectType int DEFAULT NULL,
    v_object jsonb DEFAULT NULL,
    v_newschema text DEFAULT NULL,
    v_relation jsonb DEFAULT NULL,
    v_missing_ok boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterObjectSchemaStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, objectType}', to_jsonb(v_objectType));
    result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, object}', v_object);
    result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, newschema}', to_jsonb(v_newschema));
    result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, missing_ok}', to_jsonb(v_missing_ok));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_conversion_stmt (
    v_conversion_name jsonb DEFAULT NULL,
    v_for_encoding_name text DEFAULT NULL,
    v_to_encoding_name text DEFAULT NULL,
    v_func_name jsonb DEFAULT NULL,
    v_def boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateConversionStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateConversionStmt, conversion_name}', v_conversion_name);
    result = ast.jsonb_set(result, '{CreateConversionStmt, for_encoding_name}', to_jsonb(v_for_encoding_name));
    result = ast.jsonb_set(result, '{CreateConversionStmt, to_encoding_name}', to_jsonb(v_to_encoding_name));
    result = ast.jsonb_set(result, '{CreateConversionStmt, func_name}', v_func_name);
    result = ast.jsonb_set(result, '{CreateConversionStmt, def}', to_jsonb(v_def));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_fdw_stmt (
    v_fdwname text DEFAULT NULL,
    v_func_options jsonb DEFAULT NULL,
    v_options jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateFdwStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateFdwStmt, fdwname}', to_jsonb(v_fdwname));
    result = ast.jsonb_set(result, '{CreateFdwStmt, func_options}', v_func_options);
    result = ast.jsonb_set(result, '{CreateFdwStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_foreign_server_stmt (
    v_servername text DEFAULT NULL,
    v_fdwname text DEFAULT NULL,
    v_options jsonb DEFAULT NULL,
    v_servertype text DEFAULT NULL,
    v_version text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateForeignServerStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateForeignServerStmt, servername}', to_jsonb(v_servername));
    result = ast.jsonb_set(result, '{CreateForeignServerStmt, fdwname}', to_jsonb(v_fdwname));
    result = ast.jsonb_set(result, '{CreateForeignServerStmt, options}', v_options);
    result = ast.jsonb_set(result, '{CreateForeignServerStmt, servertype}', to_jsonb(v_servertype));
    result = ast.jsonb_set(result, '{CreateForeignServerStmt, version}', to_jsonb(v_version));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_p_lang_stmt (
    v_plname text DEFAULT NULL,
    v_plhandler jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreatePLangStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreatePLangStmt, plname}', to_jsonb(v_plname));
    result = ast.jsonb_set(result, '{CreatePLangStmt, plhandler}', v_plhandler);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_op_family_stmt (
    v_opfamilyname jsonb DEFAULT NULL,
    v_amname text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateOpFamilyStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateOpFamilyStmt, opfamilyname}', v_opfamilyname);
    result = ast.jsonb_set(result, '{CreateOpFamilyStmt, amname}', to_jsonb(v_amname));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_op_class_stmt (
    v_opclassname jsonb DEFAULT NULL,
    v_amname text DEFAULT NULL,
    v_datatype jsonb DEFAULT NULL,
    v_items jsonb DEFAULT NULL,
    v_isDefault boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateOpClassStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateOpClassStmt, opclassname}', v_opclassname);
    result = ast.jsonb_set(result, '{CreateOpClassStmt, amname}', to_jsonb(v_amname));
    result = ast.jsonb_set(result, '{CreateOpClassStmt, datatype}', v_datatype);
    result = ast.jsonb_set(result, '{CreateOpClassStmt, items}', v_items);
    result = ast.jsonb_set(result, '{CreateOpClassStmt, isDefault}', to_jsonb(v_isDefault));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_op_class_item (
    v_itemtype int DEFAULT NULL,
    v_storedtype jsonb DEFAULT NULL,
    v_name jsonb DEFAULT NULL,
    v_number int DEFAULT NULL,
    v_class_args jsonb DEFAULT NULL,
    v_order_family jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateOpClassItem":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateOpClassItem, itemtype}', to_jsonb(v_itemtype));
    result = ast.jsonb_set(result, '{CreateOpClassItem, storedtype}', v_storedtype);
    result = ast.jsonb_set(result, '{CreateOpClassItem, name}', v_name);
    result = ast.jsonb_set(result, '{CreateOpClassItem, number}', to_jsonb(v_number));
    result = ast.jsonb_set(result, '{CreateOpClassItem, class_args}', v_class_args);
    result = ast.jsonb_set(result, '{CreateOpClassItem, order_family}', v_order_family);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_op_family_stmt (
    v_opfamilyname jsonb DEFAULT NULL,
    v_amname text DEFAULT NULL,
    v_items jsonb DEFAULT NULL,
    v_isDrop boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterOpFamilyStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterOpFamilyStmt, opfamilyname}', v_opfamilyname);
    result = ast.jsonb_set(result, '{AlterOpFamilyStmt, amname}', to_jsonb(v_amname));
    result = ast.jsonb_set(result, '{AlterOpFamilyStmt, items}', v_items);
    result = ast.jsonb_set(result, '{AlterOpFamilyStmt, isDrop}', to_jsonb(v_isDrop));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_operator_stmt (
    v_opername jsonb DEFAULT NULL,
    v_options jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterOperatorStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterOperatorStmt, opername}', v_opername);
    result = ast.jsonb_set(result, '{AlterOperatorStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.vacuum_stmt (
    v_options int DEFAULT NULL,
    v_relation jsonb DEFAULT NULL,
    v_va_cols jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"VacuumStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{VacuumStmt, options}', to_jsonb(v_options));
    result = ast.jsonb_set(result, '{VacuumStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{VacuumStmt, va_cols}', v_va_cols);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_table_as_stmt (
    v_query jsonb DEFAULT NULL,
    v_into jsonb DEFAULT NULL,
    v_relkind int DEFAULT NULL,
    v_if_not_exists boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateTableAsStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateTableAsStmt, query}', v_query);
    result = ast.jsonb_set(result, '{CreateTableAsStmt, into}', v_into);
    result = ast.jsonb_set(result, '{CreateTableAsStmt, relkind}', to_jsonb(v_relkind));
    result = ast.jsonb_set(result, '{CreateTableAsStmt, if_not_exists}', to_jsonb(v_if_not_exists));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.into_clause (
    v_rel jsonb DEFAULT NULL,
    v_onCommit int DEFAULT NULL,
    v_colNames jsonb DEFAULT NULL,
    v_skipData boolean DEFAULT NULL,
    v_options jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"IntoClause":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{IntoClause, rel}', v_rel);
    result = ast.jsonb_set(result, '{IntoClause, onCommit}', to_jsonb(v_onCommit));
    result = ast.jsonb_set(result, '{IntoClause, colNames}', v_colNames);
    result = ast.jsonb_set(result, '{IntoClause, skipData}', to_jsonb(v_skipData));
    result = ast.jsonb_set(result, '{IntoClause, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.case_expr (
    v_args jsonb DEFAULT NULL,
    v_defresult jsonb DEFAULT NULL,
    v_arg jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CaseExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CaseExpr, args}', v_args);
    result = ast.jsonb_set(result, '{CaseExpr, defresult}', v_defresult);
    result = ast.jsonb_set(result, '{CaseExpr, arg}', v_arg);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.case_when (
    v_expr jsonb DEFAULT NULL,
    v_result jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CaseWhen":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CaseWhen, expr}', v_expr);
    result = ast.jsonb_set(result, '{CaseWhen, result}', v_result);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.boolean_test (
    v_arg jsonb DEFAULT NULL,
    v_booltesttype int DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"BooleanTest":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{BooleanTest, arg}', v_arg);
    result = ast.jsonb_set(result, '{BooleanTest, booltesttype}', to_jsonb(v_booltesttype));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_function_stmt (
    v_func jsonb DEFAULT NULL,
    v_actions jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterFunctionStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterFunctionStmt, func}', v_func);
    result = ast.jsonb_set(result, '{AlterFunctionStmt, actions}', v_actions);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.truncate_stmt (
    v_relations jsonb DEFAULT NULL,
    v_behavior int DEFAULT NULL,
    v_restart_seqs boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"TruncateStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{TruncateStmt, relations}', v_relations);
    result = ast.jsonb_set(result, '{TruncateStmt, behavior}', to_jsonb(v_behavior));
    result = ast.jsonb_set(result, '{TruncateStmt, restart_seqs}', to_jsonb(v_restart_seqs));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_indices (
    v_is_slice boolean DEFAULT NULL,
    v_lidx jsonb DEFAULT NULL,
    v_uidx jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Indices":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{A_Indices, is_slice}', to_jsonb(v_is_slice));
    result = ast.jsonb_set(result, '{A_Indices, lidx}', v_lidx);
    result = ast.jsonb_set(result, '{A_Indices, uidx}', v_uidx);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.notify_stmt (
    v_conditionname text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"NotifyStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{NotifyStmt, conditionname}', to_jsonb(v_conditionname));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.listen_stmt (
    v_conditionname text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ListenStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ListenStmt, conditionname}', to_jsonb(v_conditionname));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.unlisten_stmt (
    v_conditionname text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"UnlistenStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{UnlistenStmt, conditionname}', to_jsonb(v_conditionname));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.bit_string (
    v_str text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"BitString":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{BitString, str}', to_jsonb(v_str));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.coalesce_expr (
    v_args jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CoalesceExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CoalesceExpr, args}', v_args);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.cluster_stmt (
    v_relation jsonb DEFAULT NULL,
    v_indexname text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ClusterStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ClusterStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{ClusterStmt, indexname}', to_jsonb(v_indexname));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.table_like_clause (
    v_relation jsonb DEFAULT NULL,
    v_options int DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"TableLikeClause":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{TableLikeClause, relation}', v_relation);
    result = ast.jsonb_set(result, '{TableLikeClause, options}', to_jsonb(v_options));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.with_clause (
    v_ctes jsonb DEFAULT NULL,
    v_recursive boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"WithClause":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{WithClause, ctes}', v_ctes);
    result = ast.jsonb_set(result, '{WithClause, recursive}', to_jsonb(v_recursive));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.common_table_expr (
    v_ctename text DEFAULT NULL,
    v_aliascolnames jsonb DEFAULT NULL,
    v_ctequery jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CommonTableExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CommonTableExpr, ctename}', to_jsonb(v_ctename));
    result = ast.jsonb_set(result, '{CommonTableExpr, aliascolnames}', v_aliascolnames);
    result = ast.jsonb_set(result, '{CommonTableExpr, ctequery}', v_ctequery);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_range_stmt (
    v_typeName jsonb DEFAULT NULL,
    v_params jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateRangeStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateRangeStmt, typeName}', v_typeName);
    result = ast.jsonb_set(result, '{CreateRangeStmt, params}', v_params);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.declare_cursor_stmt (
    v_portalname text DEFAULT NULL,
    v_options int DEFAULT NULL,
    v_query jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DeclareCursorStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DeclareCursorStmt, portalname}', to_jsonb(v_portalname));
    result = ast.jsonb_set(result, '{DeclareCursorStmt, options}', to_jsonb(v_options));
    result = ast.jsonb_set(result, '{DeclareCursorStmt, query}', v_query);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.fetch_stmt (
    v_direction int DEFAULT NULL,
    v_howMany int DEFAULT NULL,
    v_portalname text DEFAULT NULL,
    v_ismove boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"FetchStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{FetchStmt, direction}', to_jsonb(v_direction));
    result = ast.jsonb_set(result, '{FetchStmt, howMany}', to_jsonb(v_howMany));
    result = ast.jsonb_set(result, '{FetchStmt, portalname}', to_jsonb(v_portalname));
    result = ast.jsonb_set(result, '{FetchStmt, ismove}', to_jsonb(v_ismove));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.locking_clause (
    v_strength int DEFAULT NULL,
    v_waitPolicy int DEFAULT NULL,
    v_lockedRels jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"LockingClause":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{LockingClause, strength}', to_jsonb(v_strength));
    result = ast.jsonb_set(result, '{LockingClause, waitPolicy}', to_jsonb(v_waitPolicy));
    result = ast.jsonb_set(result, '{LockingClause, lockedRels}', v_lockedRels);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_am_stmt (
    v_amname text DEFAULT NULL,
    v_handler_name jsonb DEFAULT NULL,
    v_amtype text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateAmStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateAmStmt, amname}', to_jsonb(v_amname));
    result = ast.jsonb_set(result, '{CreateAmStmt, handler_name}', v_handler_name);
    result = ast.jsonb_set(result, '{CreateAmStmt, amtype}', to_jsonb(v_amtype));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_cast_stmt (
    v_sourcetype jsonb DEFAULT NULL,
    v_targettype jsonb DEFAULT NULL,
    v_context int DEFAULT NULL,
    v_inout boolean DEFAULT NULL,
    v_func jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateCastStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateCastStmt, sourcetype}', v_sourcetype);
    result = ast.jsonb_set(result, '{CreateCastStmt, targettype}', v_targettype);
    result = ast.jsonb_set(result, '{CreateCastStmt, context}', to_jsonb(v_context));
    result = ast.jsonb_set(result, '{CreateCastStmt, inout}', to_jsonb(v_inout));
    result = ast.jsonb_set(result, '{CreateCastStmt, func}', v_func);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.reindex_stmt (
    v_kind int DEFAULT NULL,
    v_relation jsonb DEFAULT NULL,
    v_options int DEFAULT NULL,
    v_name text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ReindexStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ReindexStmt, kind}', to_jsonb(v_kind));
    result = ast.jsonb_set(result, '{ReindexStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{ReindexStmt, options}', to_jsonb(v_options));
    result = ast.jsonb_set(result, '{ReindexStmt, name}', to_jsonb(v_name));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.drop_owned_stmt (
    v_roles jsonb DEFAULT NULL,
    v_behavior int DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DropOwnedStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DropOwnedStmt, roles}', v_roles);
    result = ast.jsonb_set(result, '{DropOwnedStmt, behavior}', to_jsonb(v_behavior));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.reassign_owned_stmt (
    v_roles jsonb DEFAULT NULL,
    v_newrole jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ReassignOwnedStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ReassignOwnedStmt, roles}', v_roles);
    result = ast.jsonb_set(result, '{ReassignOwnedStmt, newrole}', v_newrole);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_seq_stmt (
    v_sequence jsonb DEFAULT NULL,
    v_options jsonb DEFAULT NULL,
    v_missing_ok boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterSeqStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterSeqStmt, sequence}', v_sequence);
    result = ast.jsonb_set(result, '{AlterSeqStmt, options}', v_options);
    result = ast.jsonb_set(result, '{AlterSeqStmt, missing_ok}', to_jsonb(v_missing_ok));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_domain_stmt (
    v_subtype text DEFAULT NULL,
    v_typeName jsonb DEFAULT NULL,
    v_behavior int DEFAULT NULL,
    v_def jsonb DEFAULT NULL,
    v_name text DEFAULT NULL,
    v_missing_ok boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterDomainStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterDomainStmt, subtype}', to_jsonb(v_subtype));
    result = ast.jsonb_set(result, '{AlterDomainStmt, typeName}', v_typeName);
    result = ast.jsonb_set(result, '{AlterDomainStmt, behavior}', to_jsonb(v_behavior));
    result = ast.jsonb_set(result, '{AlterDomainStmt, def}', v_def);
    result = ast.jsonb_set(result, '{AlterDomainStmt, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{AlterDomainStmt, missing_ok}', to_jsonb(v_missing_ok));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.prepare_stmt (
    v_name text DEFAULT NULL,
    v_query jsonb DEFAULT NULL,
    v_argtypes jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"PrepareStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{PrepareStmt, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{PrepareStmt, query}', v_query);
    result = ast.jsonb_set(result, '{PrepareStmt, argtypes}', v_argtypes);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.execute_stmt (
    v_name text DEFAULT NULL,
    v_params jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ExecuteStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ExecuteStmt, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{ExecuteStmt, params}', v_params);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_enum_stmt (
    v_typeName jsonb DEFAULT NULL,
    v_newVal text DEFAULT NULL,
    v_newValIsAfter boolean DEFAULT NULL,
    v_newValNeighbor text DEFAULT NULL,
    v_skipIfNewValExists boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterEnumStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterEnumStmt, typeName}', v_typeName);
    result = ast.jsonb_set(result, '{AlterEnumStmt, newVal}', to_jsonb(v_newVal));
    result = ast.jsonb_set(result, '{AlterEnumStmt, newValIsAfter}', to_jsonb(v_newValIsAfter));
    result = ast.jsonb_set(result, '{AlterEnumStmt, newValNeighbor}', to_jsonb(v_newValNeighbor));
    result = ast.jsonb_set(result, '{AlterEnumStmt, skipIfNewValExists}', to_jsonb(v_skipIfNewValExists));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_event_trig_stmt (
    v_trigname text DEFAULT NULL,
    v_eventname text DEFAULT NULL,
    v_funcname jsonb DEFAULT NULL,
    v_whenclause jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateEventTrigStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateEventTrigStmt, trigname}', to_jsonb(v_trigname));
    result = ast.jsonb_set(result, '{CreateEventTrigStmt, eventname}', to_jsonb(v_eventname));
    result = ast.jsonb_set(result, '{CreateEventTrigStmt, funcname}', v_funcname);
    result = ast.jsonb_set(result, '{CreateEventTrigStmt, whenclause}', v_whenclause);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_event_trig_stmt (
    v_trigname text DEFAULT NULL,
    v_tgenabled text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterEventTrigStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterEventTrigStmt, trigname}', to_jsonb(v_trigname));
    result = ast.jsonb_set(result, '{AlterEventTrigStmt, tgenabled}', to_jsonb(v_tgenabled));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_user_mapping_stmt (
    v_user jsonb DEFAULT NULL,
    v_servername text DEFAULT NULL,
    v_options jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateUserMappingStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateUserMappingStmt, user}', v_user);
    result = ast.jsonb_set(result, '{CreateUserMappingStmt, servername}', to_jsonb(v_servername));
    result = ast.jsonb_set(result, '{CreateUserMappingStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_role_stmt (
    v_role jsonb DEFAULT NULL,
    v_options jsonb DEFAULT NULL,
    v_action int DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterRoleStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterRoleStmt, role}', v_role);
    result = ast.jsonb_set(result, '{AlterRoleStmt, options}', v_options);
    result = ast.jsonb_set(result, '{AlterRoleStmt, action}', to_jsonb(v_action));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_policy_stmt (
    v_policy_name text DEFAULT NULL,
    v_table jsonb DEFAULT NULL,
    v_qual jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterPolicyStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterPolicyStmt, policy_name}', to_jsonb(v_policy_name));
    result = ast.jsonb_set(result, '{AlterPolicyStmt, table}', v_table);
    result = ast.jsonb_set(result, '{AlterPolicyStmt, qual}', v_qual);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_fdw_stmt (
    v_fdwname text DEFAULT NULL,
    v_func_options jsonb DEFAULT NULL,
    v_options jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterFdwStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterFdwStmt, fdwname}', to_jsonb(v_fdwname));
    result = ast.jsonb_set(result, '{AlterFdwStmt, func_options}', v_func_options);
    result = ast.jsonb_set(result, '{AlterFdwStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_foreign_server_stmt (
    v_servername text DEFAULT NULL,
    v_version text DEFAULT NULL,
    v_options jsonb DEFAULT NULL,
    v_has_version boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterForeignServerStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterForeignServerStmt, servername}', to_jsonb(v_servername));
    result = ast.jsonb_set(result, '{AlterForeignServerStmt, version}', to_jsonb(v_version));
    result = ast.jsonb_set(result, '{AlterForeignServerStmt, options}', v_options);
    result = ast.jsonb_set(result, '{AlterForeignServerStmt, has_version}', to_jsonb(v_has_version));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_user_mapping_stmt (
    v_user jsonb DEFAULT NULL,
    v_servername text DEFAULT NULL,
    v_options jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterUserMappingStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterUserMappingStmt, user}', v_user);
    result = ast.jsonb_set(result, '{AlterUserMappingStmt, servername}', to_jsonb(v_servername));
    result = ast.jsonb_set(result, '{AlterUserMappingStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.drop_user_mapping_stmt (
    v_user jsonb DEFAULT NULL,
    v_servername text DEFAULT NULL,
    v_missing_ok boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DropUserMappingStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DropUserMappingStmt, user}', v_user);
    result = ast.jsonb_set(result, '{DropUserMappingStmt, servername}', to_jsonb(v_servername));
    result = ast.jsonb_set(result, '{DropUserMappingStmt, missing_ok}', to_jsonb(v_missing_ok));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_foreign_table_stmt (
    v_base jsonb DEFAULT NULL,
    v_servername text DEFAULT NULL,
    v_options jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateForeignTableStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateForeignTableStmt, base}', v_base);
    result = ast.jsonb_set(result, '{CreateForeignTableStmt, servername}', to_jsonb(v_servername));
    result = ast.jsonb_set(result, '{CreateForeignTableStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.import_foreign_schema_stmt (
    v_server_name text DEFAULT NULL,
    v_remote_schema text DEFAULT NULL,
    v_local_schema text DEFAULT NULL,
    v_list_type int DEFAULT NULL,
    v_table_list jsonb DEFAULT NULL,
    v_options jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ImportForeignSchemaStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ImportForeignSchemaStmt, server_name}', to_jsonb(v_server_name));
    result = ast.jsonb_set(result, '{ImportForeignSchemaStmt, remote_schema}', to_jsonb(v_remote_schema));
    result = ast.jsonb_set(result, '{ImportForeignSchemaStmt, local_schema}', to_jsonb(v_local_schema));
    result = ast.jsonb_set(result, '{ImportForeignSchemaStmt, list_type}', to_jsonb(v_list_type));
    result = ast.jsonb_set(result, '{ImportForeignSchemaStmt, table_list}', v_table_list);
    result = ast.jsonb_set(result, '{ImportForeignSchemaStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.constraints_set_stmt (
    v_deferred boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ConstraintsSetStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ConstraintsSetStmt, deferred}', to_jsonb(v_deferred));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grouping_func (
    v_args jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"GroupingFunc":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{GroupingFunc, args}', v_args);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grouping_set (
    v_kind int DEFAULT NULL,
    v_content jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"GroupingSet":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{GroupingSet, kind}', to_jsonb(v_kind));
    result = ast.jsonb_set(result, '{GroupingSet, content}', v_content);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.window_def (
    v_orderClause jsonb DEFAULT NULL,
    v_frameOptions int DEFAULT NULL,
    v_partitionClause jsonb DEFAULT NULL,
    v_name text DEFAULT NULL,
    v_startOffset jsonb DEFAULT NULL,
    v_endOffset jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"WindowDef":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{WindowDef, orderClause}', v_orderClause);
    result = ast.jsonb_set(result, '{WindowDef, frameOptions}', to_jsonb(v_frameOptions));
    result = ast.jsonb_set(result, '{WindowDef, partitionClause}', v_partitionClause);
    result = ast.jsonb_set(result, '{WindowDef, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{WindowDef, startOffset}', v_startOffset);
    result = ast.jsonb_set(result, '{WindowDef, endOffset}', v_endOffset);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.discard_stmt (
    v_target int DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DiscardStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DiscardStmt, target}', to_jsonb(v_target));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.lock_stmt (
    v_relations jsonb DEFAULT NULL,
    v_mode int DEFAULT NULL,
    v_nowait boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"LockStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{LockStmt, relations}', v_relations);
    result = ast.jsonb_set(result, '{LockStmt, mode}', to_jsonb(v_mode));
    result = ast.jsonb_set(result, '{LockStmt, nowait}', to_jsonb(v_nowait));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_role_set_stmt (
    v_role jsonb DEFAULT NULL,
    v_setstmt jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterRoleSetStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterRoleSetStmt, role}', v_role);
    result = ast.jsonb_set(result, '{AlterRoleSetStmt, setstmt}', v_setstmt);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.refresh_mat_view_stmt (
    v_relation jsonb DEFAULT NULL,
    v_concurrent boolean DEFAULT NULL,
    v_skipData boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RefreshMatViewStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RefreshMatViewStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{RefreshMatViewStmt, concurrent}', to_jsonb(v_concurrent));
    result = ast.jsonb_set(result, '{RefreshMatViewStmt, skipData}', to_jsonb(v_skipData));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_transform_stmt (
    v_type_name jsonb DEFAULT NULL,
    v_lang text DEFAULT NULL,
    v_fromsql jsonb DEFAULT NULL,
    v_tosql jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateTransformStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateTransformStmt, type_name}', v_type_name);
    result = ast.jsonb_set(result, '{CreateTransformStmt, lang}', to_jsonb(v_lang));
    result = ast.jsonb_set(result, '{CreateTransformStmt, fromsql}', v_fromsql);
    result = ast.jsonb_set(result, '{CreateTransformStmt, tosql}', v_tosql);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.close_portal_stmt (
    v_portalname text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ClosePortalStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ClosePortalStmt, portalname}', to_jsonb(v_portalname));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.current_of_expr (
    v_cursor_name text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CurrentOfExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CurrentOfExpr, cursor_name}', to_jsonb(v_cursor_name));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.deallocate_stmt (
    v_name text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DeallocateStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DeallocateStmt, name}', to_jsonb(v_name));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.replica_identity_stmt (
    v_identity_type text DEFAULT NULL,
    v_name text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ReplicaIdentityStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ReplicaIdentityStmt, identity_type}', to_jsonb(v_identity_type));
    result = ast.jsonb_set(result, '{ReplicaIdentityStmt, name}', to_jsonb(v_name));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_table_sample (
    v_relation jsonb DEFAULT NULL,
    v_method jsonb DEFAULT NULL,
    v_args jsonb DEFAULT NULL,
    v_repeatable jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RangeTableSample":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RangeTableSample, relation}', v_relation);
    result = ast.jsonb_set(result, '{RangeTableSample, method}', v_method);
    result = ast.jsonb_set(result, '{RangeTableSample, args}', v_args);
    result = ast.jsonb_set(result, '{RangeTableSample, repeatable}', v_repeatable);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.sec_label_stmt (
    v_objtype int DEFAULT NULL,
    v_object jsonb DEFAULT NULL,
    v_label text DEFAULT NULL,
    v_provider text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"SecLabelStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{SecLabelStmt, objtype}', to_jsonb(v_objtype));
    result = ast.jsonb_set(result, '{SecLabelStmt, object}', v_object);
    result = ast.jsonb_set(result, '{SecLabelStmt, label}', to_jsonb(v_label));
    result = ast.jsonb_set(result, '{SecLabelStmt, provider}', to_jsonb(v_provider));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.copy_stmt (
    v_query jsonb DEFAULT NULL,
    v_filename text DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CopyStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CopyStmt, query}', v_query);
    result = ast.jsonb_set(result, '{CopyStmt, filename}', to_jsonb(v_filename));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_ts_configuration_stmt (
    v_kind int DEFAULT NULL,
    v_cfgname jsonb DEFAULT NULL,
    v_tokentype jsonb DEFAULT NULL,
    v_dicts jsonb DEFAULT NULL,
    v_override boolean DEFAULT NULL,
    v_replace boolean DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterTSConfigurationStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, kind}', to_jsonb(v_kind));
    result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, cfgname}', v_cfgname);
    result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, tokentype}', v_tokentype);
    result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, dicts}', v_dicts);
    result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, override}', to_jsonb(v_override));
    result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, replace}', to_jsonb(v_replace));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.xml_expr (
    v_op int DEFAULT NULL,
    v_args jsonb DEFAULT NULL,
    v_name text DEFAULT NULL,
    v_xmloption int DEFAULT NULL,
    v_named_args jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"XmlExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{XmlExpr, op}', to_jsonb(v_op));
    result = ast.jsonb_set(result, '{XmlExpr, args}', v_args);
    result = ast.jsonb_set(result, '{XmlExpr, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{XmlExpr, xmloption}', to_jsonb(v_xmloption));
    result = ast.jsonb_set(result, '{XmlExpr, named_args}', v_named_args);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.xml_serialize (
    v_xmloption int DEFAULT NULL,
    v_expr jsonb DEFAULT NULL,
    v_typeName jsonb DEFAULT NULL
) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"XmlSerialize":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{XmlSerialize, xmloption}', to_jsonb(v_xmloption));
    result = ast.jsonb_set(result, '{XmlSerialize, expr}', v_expr);
    result = ast.jsonb_set(result, '{XmlSerialize, typeName}', v_typeName);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

COMMIT;
