\echo Use "CREATE EXTENSION ast" to load this file. \quit
CREATE SCHEMA ast_constants;

CREATE FUNCTION ast_constants.alter_table_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE val
 WHEN 'AT_AddColumn' THEN 0
 WHEN 'AT_AddColumnRecurse' THEN 1
 WHEN 'AT_AddColumnToView' THEN 2
 WHEN 'AT_ColumnDefault' THEN 3
 WHEN 'AT_DropNotNull' THEN 4
 WHEN 'AT_SetNotNull' THEN 5
 WHEN 'AT_SetStatistics' THEN 6
 WHEN 'AT_SetOptions' THEN 7
 WHEN 'AT_ResetOptions' THEN 8
 WHEN 'AT_SetStorage' THEN 9
 WHEN 'AT_DropColumn' THEN 10
 WHEN 'AT_DropColumnRecurse' THEN 11
 WHEN 'AT_AddIndex' THEN 12
 WHEN 'AT_ReAddIndex' THEN 13
 WHEN 'AT_AddConstraint' THEN 14
 WHEN 'AT_AddConstraintRecurse' THEN 15
 WHEN 'AT_ReAddConstraint' THEN 16
 WHEN 'AT_AlterConstraint' THEN 17
 WHEN 'AT_ValidateConstraint' THEN 18
 WHEN 'AT_ValidateConstraintRecurse' THEN 19
 WHEN 'AT_ProcessedConstraint' THEN 20
 WHEN 'AT_AddIndexConstraint' THEN 21
 WHEN 'AT_DropConstraint' THEN 22
 WHEN 'AT_DropConstraintRecurse' THEN 23
 WHEN 'AT_ReAddComment' THEN 24
 WHEN 'AT_AlterColumnType' THEN 25
 WHEN 'AT_AlterColumnGenericOptions' THEN 26
 WHEN 'AT_ChangeOwner' THEN 27
 WHEN 'AT_ClusterOn' THEN 28
 WHEN 'AT_DropCluster' THEN 29
 WHEN 'AT_SetLogged' THEN 30
 WHEN 'AT_SetUnLogged' THEN 31
 WHEN 'AT_AddOids' THEN 32
 WHEN 'AT_AddOidsRecurse' THEN 33
 WHEN 'AT_DropOids' THEN 34
 WHEN 'AT_SetTableSpace' THEN 35
 WHEN 'AT_SetRelOptions' THEN 36
 WHEN 'AT_ResetRelOptions' THEN 37
 WHEN 'AT_ReplaceRelOptions' THEN 38
 WHEN 'AT_EnableTrig' THEN 39
 WHEN 'AT_EnableAlwaysTrig' THEN 40
 WHEN 'AT_EnableReplicaTrig' THEN 41
 WHEN 'AT_DisableTrig' THEN 42
 WHEN 'AT_EnableTrigAll' THEN 43
 WHEN 'AT_DisableTrigAll' THEN 44
 WHEN 'AT_EnableTrigUser' THEN 45
 WHEN 'AT_DisableTrigUser' THEN 46
 WHEN 'AT_EnableRule' THEN 47
 WHEN 'AT_EnableAlwaysRule' THEN 48
 WHEN 'AT_EnableReplicaRule' THEN 49
 WHEN 'AT_DisableRule' THEN 50
 WHEN 'AT_AddInherit' THEN 51
 WHEN 'AT_DropInherit' THEN 52
 WHEN 'AT_AddOf' THEN 53
 WHEN 'AT_DropOf' THEN 54
 WHEN 'AT_ReplicaIdentity' THEN 55
 WHEN 'AT_EnableRowSecurity' THEN 56
 WHEN 'AT_DisableRowSecurity' THEN 57
 WHEN 'AT_ForceRowSecurity' THEN 58
 WHEN 'AT_NoForceRowSecurity' THEN 59
 WHEN 'AT_GenericOptions' THEN 60
 WHEN 'AT_AttachPartition' THEN 61
 WHEN 'AT_DetachPartition' THEN 62
 WHEN 'AT_AddIdentity' THEN 63
 WHEN 'AT_SetIdentity' THEN 64
 WHEN 'AT_DropIdentity' THEN 65 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.join_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE val
 WHEN 'JOIN_INNER' THEN 0
 WHEN 'JOIN_LEFT' THEN 1
 WHEN 'JOIN_FULL' THEN 2
 WHEN 'JOIN_RIGHT' THEN 3
 WHEN 'JOIN_SEMI' THEN 4
 WHEN 'JOIN_ANTI' THEN 5
 WHEN 'JOIN_UNIQUE_OUTER' THEN 6
 WHEN 'JOIN_UNIQUE_INNER' THEN 7 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.role_stmt_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE val
 WHEN 'ROLESTMT_ROLE' THEN 0
 WHEN 'ROLESTMT_USER' THEN 1
 WHEN 'ROLESTMT_GROUP' THEN 2 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.role_spec_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE val
 WHEN 'ROLESPEC_CSTRING' THEN 0
 WHEN 'ROLESPEC_CURRENT_USER' THEN 1
 WHEN 'ROLESPEC_SESSION_USER' THEN 2
 WHEN 'ROLESPEC_PUBLIC' THEN 3 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.sql_value_function_op ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE val
 WHEN 'SVFOP_CURRENT_DATE' THEN 0
 WHEN 'SVFOP_CURRENT_TIME' THEN 1
 WHEN 'SVFOP_CURRENT_TIME_N' THEN 2
 WHEN 'SVFOP_CURRENT_TIMESTAMP' THEN 3
 WHEN 'SVFOP_CURRENT_TIMESTAMP_N' THEN 4
 WHEN 'SVFOP_LOCALTIME' THEN 5
 WHEN 'SVFOP_LOCALTIME_N' THEN 6
 WHEN 'SVFOP_LOCALTIMESTAMP' THEN 7
 WHEN 'SVFOP_LOCALTIMESTAMP_N' THEN 8
 WHEN 'SVFOP_CURRENT_ROLE' THEN 9
 WHEN 'SVFOP_CURRENT_USER' THEN 10
 WHEN 'SVFOP_USER' THEN 11
 WHEN 'SVFOP_SESSION_USER' THEN 12
 WHEN 'SVFOP_CURRENT_CATALOG' THEN 13
 WHEN 'SVFOP_CURRENT_SCHEMA' THEN 14 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.bool_expr_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE val
 WHEN 'AND_EXPR' THEN 0
 WHEN 'OR_EXPR' THEN 1 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.a_expr_kind ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE val
 WHEN 'AEXPR_OP' THEN 0
 WHEN 'AEXPR_OP_ANY' THEN 1
 WHEN 'AEXPR_OP_ALL' THEN 2
 WHEN 'AEXPR_DISTINCT' THEN 3
 WHEN 'AEXPR_NOT_DISTINCT' THEN 4
 WHEN 'AEXPR_NULLIF' THEN 5
 WHEN 'AEXPR_OF' THEN 6
 WHEN 'AEXPR_IN' THEN 7
 WHEN 'AEXPR_LIKE' THEN 8
 WHEN 'AEXPR_ILIKE' THEN 9
 WHEN 'AEXPR_SIMILAR' THEN 10
 WHEN 'AEXPR_BETWEEN' THEN 11
 WHEN 'AEXPR_NOT_BETWEEN' THEN 12
 WHEN 'AEXPR_BETWEEN_SYM' THEN 13
 WHEN 'AEXPR_NOT_BETWEEN_SYM' THEN 14
 WHEN 'AEXPR_PAREN' THEN 15 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.null_test_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE val
 WHEN 'IS_NULL' THEN 0
 WHEN 'IS_NOT_NULL' THEN 1 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.lock_clause_strength ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE val
 WHEN 'LCS_NONE' THEN 0
 WHEN 'LCS_FORKEYSHARE' THEN 1
 WHEN 'LCS_FORSHARE' THEN 2
 WHEN 'LCS_FORNOKEYUPDATE' THEN 3
 WHEN 'LCS_FORUPDATE' THEN 4 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.sort_by_dir ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE val
 WHEN 'SORTBY_DEFAULT' THEN 0
 WHEN 'SORTBY_ASC' THEN 1
 WHEN 'SORTBY_DESC' THEN 2
 WHEN 'SORTBY_USING' THEN 3 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.sort_by_nulls ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE val
 WHEN 'SORTBY_NULLS_DEFAULT' THEN 0
 WHEN 'SORTBY_NULLS_FIRST' THEN 1
 WHEN 'SORTBY_NULLS_LAST' THEN 2 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.variable_set_kind ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE val
 WHEN 'VAR_SET_VALUE' THEN 0
 WHEN 'VAR_SET_DEFAULT' THEN 1
 WHEN 'VAR_SET_CURRENT' THEN 2
 WHEN 'VAR_SET_MULTI' THEN 3
 WHEN 'VAR_RESET' THEN 4
 WHEN 'VAR_RESET_ALL' THEN 5 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.object_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE val
 WHEN 'OBJECT_ACCESS_METHOD' THEN 0
 WHEN 'OBJECT_AGGREGATE' THEN 1
 WHEN 'OBJECT_AMOP' THEN 2
 WHEN 'OBJECT_AMPROC' THEN 3
 WHEN 'OBJECT_ATTRIBUTE' THEN 4
 WHEN 'OBJECT_CAST' THEN 5
 WHEN 'OBJECT_COLUMN' THEN 6
 WHEN 'OBJECT_COLLATION' THEN 7
 WHEN 'OBJECT_CONVERSION' THEN 8
 WHEN 'OBJECT_DATABASE' THEN 9
 WHEN 'OBJECT_DEFAULT' THEN 10
 WHEN 'OBJECT_DEFACL' THEN 11
 WHEN 'OBJECT_DOMAIN' THEN 12
 WHEN 'OBJECT_DOMCONSTRAINT' THEN 13
 WHEN 'OBJECT_EVENT_TRIGGER' THEN 14
 WHEN 'OBJECT_EXTENSION' THEN 15
 WHEN 'OBJECT_FDW' THEN 16
 WHEN 'OBJECT_FOREIGN_SERVER' THEN 17
 WHEN 'OBJECT_FOREIGN_TABLE' THEN 18
 WHEN 'OBJECT_FUNCTION' THEN 19
 WHEN 'OBJECT_INDEX' THEN 20
 WHEN 'OBJECT_LANGUAGE' THEN 21
 WHEN 'OBJECT_LARGEOBJECT' THEN 22
 WHEN 'OBJECT_MATVIEW' THEN 23
 WHEN 'OBJECT_OPCLASS' THEN 24
 WHEN 'OBJECT_OPERATOR' THEN 25
 WHEN 'OBJECT_OPFAMILY' THEN 26
 WHEN 'OBJECT_POLICY' THEN 27
 WHEN 'OBJECT_PUBLICATION' THEN 28
 WHEN 'OBJECT_PUBLICATION_REL' THEN 29
 WHEN 'OBJECT_ROLE' THEN 30
 WHEN 'OBJECT_RULE' THEN 31
 WHEN 'OBJECT_SCHEMA' THEN 32
 WHEN 'OBJECT_SEQUENCE' THEN 33
 WHEN 'OBJECT_SUBSCRIPTION' THEN 34
 WHEN 'OBJECT_STATISTIC_EXT' THEN 35
 WHEN 'OBJECT_TABCONSTRAINT' THEN 36
 WHEN 'OBJECT_TABLE' THEN 37
 WHEN 'OBJECT_TABLESPACE' THEN 38
 WHEN 'OBJECT_TRANSFORM' THEN 39
 WHEN 'OBJECT_TRIGGER' THEN 40
 WHEN 'OBJECT_TSCONFIGURATION' THEN 41
 WHEN 'OBJECT_TSDICTIONARY' THEN 42
 WHEN 'OBJECT_TSPARSER' THEN 43
 WHEN 'OBJECT_TSTEMPLATE' THEN 44
 WHEN 'OBJECT_TYPE' THEN 45
 WHEN 'OBJECT_USER_MAPPING' THEN 46
 WHEN 'OBJECT_VIEW' THEN 47 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.object_type ( val int ) RETURNS text AS $EOFCODE$
SELECT CASE val
 WHEN 0 THEN 'OBJECT_ACCESS_METHOD'
 WHEN 1 THEN 'OBJECT_AGGREGATE'
 WHEN 2 THEN 'OBJECT_AMOP'
 WHEN 3 THEN 'OBJECT_AMPROC'
 WHEN 4 THEN 'OBJECT_ATTRIBUTE'
 WHEN 5 THEN 'OBJECT_CAST'
 WHEN 6 THEN 'OBJECT_COLUMN'
 WHEN 7 THEN 'OBJECT_COLLATION'
 WHEN 8 THEN 'OBJECT_CONVERSION'
 WHEN 9 THEN 'OBJECT_DATABASE'
 WHEN 10 THEN 'OBJECT_DEFAULT'
 WHEN 11 THEN 'OBJECT_DEFACL'
 WHEN 12 THEN 'OBJECT_DOMAIN'
 WHEN 13 THEN 'OBJECT_DOMCONSTRAINT'
 WHEN 14 THEN 'OBJECT_EVENT_TRIGGER'
 WHEN 15 THEN 'OBJECT_EXTENSION'
 WHEN 16 THEN 'OBJECT_FDW'
 WHEN 17 THEN 'OBJECT_FOREIGN_SERVER'
 WHEN 18 THEN 'OBJECT_FOREIGN_TABLE'
 WHEN 19 THEN 'OBJECT_FUNCTION'
 WHEN 20 THEN 'OBJECT_INDEX'
 WHEN 21 THEN 'OBJECT_LANGUAGE'
 WHEN 22 THEN 'OBJECT_LARGEOBJECT'
 WHEN 23 THEN 'OBJECT_MATVIEW'
 WHEN 24 THEN 'OBJECT_OPCLASS'
 WHEN 25 THEN 'OBJECT_OPERATOR'
 WHEN 26 THEN 'OBJECT_OPFAMILY'
 WHEN 27 THEN 'OBJECT_POLICY'
 WHEN 28 THEN 'OBJECT_PUBLICATION'
 WHEN 29 THEN 'OBJECT_PUBLICATION_REL'
 WHEN 30 THEN 'OBJECT_ROLE'
 WHEN 31 THEN 'OBJECT_RULE'
 WHEN 32 THEN 'OBJECT_SCHEMA'
 WHEN 33 THEN 'OBJECT_SEQUENCE'
 WHEN 34 THEN 'OBJECT_SUBSCRIPTION'
 WHEN 35 THEN 'OBJECT_STATISTIC_EXT'
 WHEN 36 THEN 'OBJECT_TABCONSTRAINT'
 WHEN 37 THEN 'OBJECT_TABLE'
 WHEN 38 THEN 'OBJECT_TABLESPACE'
 WHEN 39 THEN 'OBJECT_TRANSFORM'
 WHEN 40 THEN 'OBJECT_TRIGGER'
 WHEN 41 THEN 'OBJECT_TSCONFIGURATION'
 WHEN 42 THEN 'OBJECT_TSDICTIONARY'
 WHEN 43 THEN 'OBJECT_TSPARSER'
 WHEN 44 THEN 'OBJECT_TSTEMPLATE'
 WHEN 45 THEN 'OBJECT_TYPE'
 WHEN 46 THEN 'OBJECT_USER_MAPPING'
 WHEN 47 THEN 'OBJECT_VIEW' END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.constr_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE val
 WHEN 'CONSTR_NULL' THEN 0
 WHEN 'CONSTR_NOTNULL' THEN 1
 WHEN 'CONSTR_DEFAULT' THEN 2
 WHEN 'CONSTR_IDENTITY' THEN 3
 WHEN 'CONSTR_CHECK' THEN 4
 WHEN 'CONSTR_PRIMARY' THEN 5
 WHEN 'CONSTR_UNIQUE' THEN 6
 WHEN 'CONSTR_EXCLUSION' THEN 7
 WHEN 'CONSTR_FOREIGN' THEN 8
 WHEN 'CONSTR_ATTR_DEFERRABLE' THEN 9
 WHEN 'CONSTR_ATTR_NOT_DEFERRABLE' THEN 10
 WHEN 'CONSTR_ATTR_DEFERRED' THEN 11
 WHEN 'CONSTR_ATTR_IMMEDIATE' THEN 12 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

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

CREATE FUNCTION ast.raw_stmt ( v_stmt jsonb DEFAULT NULL, v_stmt_len int DEFAULT NULL, v_stmt_location int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RawStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RawStmt, stmt}', v_stmt);
    result = ast.jsonb_set(result, '{RawStmt, stmt_len}', to_jsonb(v_stmt_len));
    result = ast.jsonb_set(result, '{RawStmt, stmt_location}', to_jsonb(v_stmt_location));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_schema_stmt ( v_schemaname text DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL, v_schemaelts jsonb DEFAULT NULL, v_authrole jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.create_stmt ( v_relation jsonb DEFAULT NULL, v_tableelts jsonb DEFAULT NULL, v_oncommit int DEFAULT NULL, v_inhrelations jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL, v_oftypename jsonb DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.range_var ( v_schemaname text DEFAULT NULL, v_relname text DEFAULT NULL, v_inh boolean DEFAULT NULL, v_relpersistence text DEFAULT NULL, v_alias jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.column_def ( v_colname text DEFAULT NULL, v_typename jsonb DEFAULT NULL, v_is_local boolean DEFAULT NULL, v_constraints jsonb DEFAULT NULL, v_raw_default jsonb DEFAULT NULL, v_collclause jsonb DEFAULT NULL, v_fdwoptions jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.type_name ( v_names jsonb DEFAULT NULL, v_typemod int DEFAULT NULL, v_typmods jsonb DEFAULT NULL, v_setof boolean DEFAULT NULL, v_arraybounds jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.string ( v_str text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"String":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{String, str}', to_jsonb(v_str));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.constraint ( v_contype int DEFAULT NULL, v_raw_expr jsonb DEFAULT NULL, v_conname text DEFAULT NULL, v_pktable jsonb DEFAULT NULL, v_fk_attrs jsonb DEFAULT NULL, v_pk_attrs jsonb DEFAULT NULL, v_fk_matchtype text DEFAULT NULL, v_fk_upd_action text DEFAULT NULL, v_fk_del_action text DEFAULT NULL, v_initially_valid boolean DEFAULT NULL, v_keys jsonb DEFAULT NULL, v_is_no_inherit boolean DEFAULT NULL, v_skip_validation boolean DEFAULT NULL, v_exclusions jsonb DEFAULT NULL, v_access_method text DEFAULT NULL, v_deferrable boolean DEFAULT NULL, v_indexname text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.a_const ( v_val jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Const":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{A_Const, val}', v_val);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.integer ( v_ival int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"Integer":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{Integer, ival}', to_jsonb(v_ival));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_table_stmt ( v_relation jsonb DEFAULT NULL, v_cmds jsonb DEFAULT NULL, v_relkind int DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.alter_table_cmd ( v_subtype int DEFAULT NULL, v_behavior int DEFAULT NULL, v_name text DEFAULT NULL, v_def jsonb DEFAULT NULL, v_missing_ok boolean DEFAULT NULL, v_newowner jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.sql_value_function ( v_op int DEFAULT NULL, v_typmod int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"SQLValueFunction":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{SQLValueFunction, op}', to_jsonb(v_op));
    result = ast.jsonb_set(result, '{SQLValueFunction, typmod}', to_jsonb(v_typmod));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.rename_stmt ( v_renametype int DEFAULT NULL, v_relationtype int DEFAULT NULL, v_relation jsonb DEFAULT NULL, v_subname text DEFAULT NULL, v_newname text DEFAULT NULL, v_behavior int DEFAULT NULL, v_object jsonb DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.a_expr ( v_kind int DEFAULT NULL, v_name jsonb DEFAULT NULL, v_lexpr jsonb DEFAULT NULL, v_rexpr jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.type_cast ( v_arg jsonb DEFAULT NULL, v_typename jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"TypeCast":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{TypeCast, arg}', v_arg);
    result = ast.jsonb_set(result, '{TypeCast, typeName}', v_typeName);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.column_ref ( v_fields jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ColumnRef":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ColumnRef, fields}', v_fields);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.func_call ( v_funcname jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL, v_agg_star boolean DEFAULT NULL, v_func_variadic boolean DEFAULT NULL, v_agg_order jsonb DEFAULT NULL, v_agg_distinct boolean DEFAULT NULL, v_agg_filter jsonb DEFAULT NULL, v_agg_within_group boolean DEFAULT NULL, v_over jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.alter_default_privileges_stmt ( v_options jsonb DEFAULT NULL, v_action jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterDefaultPrivilegesStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterDefaultPrivilegesStmt, options}', v_options);
    result = ast.jsonb_set(result, '{AlterDefaultPrivilegesStmt, action}', v_action);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.def_elem ( v_defname text DEFAULT NULL, v_arg jsonb DEFAULT NULL, v_defaction int DEFAULT NULL, v_defnamespace text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.grant_stmt ( v_is_grant boolean DEFAULT NULL, v_targtype int DEFAULT NULL, v_objtype int DEFAULT NULL, v_privileges jsonb DEFAULT NULL, v_grantees jsonb DEFAULT NULL, v_behavior int DEFAULT NULL, v_objects jsonb DEFAULT NULL, v_grant_option boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.access_priv ( v_priv_name text DEFAULT NULL, v_cols jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AccessPriv":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AccessPriv, priv_name}', to_jsonb(v_priv_name));
    result = ast.jsonb_set(result, '{AccessPriv, cols}', v_cols);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.role_spec ( v_roletype int DEFAULT NULL, v_rolename text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RoleSpec":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RoleSpec, roletype}', to_jsonb(v_roletype));
    result = ast.jsonb_set(result, '{RoleSpec, rolename}', to_jsonb(v_rolename));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.comment_stmt ( v_objtype int DEFAULT NULL, v_object jsonb DEFAULT NULL, v_comment text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CommentStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CommentStmt, objtype}', to_jsonb(v_objtype));
    result = ast.jsonb_set(result, '{CommentStmt, object}', v_object);
    result = ast.jsonb_set(result, '{CommentStmt, comment}', to_jsonb(v_comment));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.object_with_args ( v_objname jsonb DEFAULT NULL, v_objargs jsonb DEFAULT NULL, v_args_unspecified boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ObjectWithArgs":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ObjectWithArgs, objname}', v_objname);
    result = ast.jsonb_set(result, '{ObjectWithArgs, objargs}', v_objargs);
    result = ast.jsonb_set(result, '{ObjectWithArgs, args_unspecified}', to_jsonb(v_args_unspecified));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.select_stmt ( v_targetlist jsonb DEFAULT NULL, v_fromclause jsonb DEFAULT NULL, v_groupclause jsonb DEFAULT NULL, v_havingclause jsonb DEFAULT NULL, v_op int DEFAULT NULL, v_sortclause jsonb DEFAULT NULL, v_whereclause jsonb DEFAULT NULL, v_distinctclause jsonb DEFAULT NULL, v_limitcount jsonb DEFAULT NULL, v_valueslists jsonb DEFAULT NULL, v_intoclause jsonb DEFAULT NULL, v_all boolean DEFAULT NULL, v_larg jsonb DEFAULT NULL, v_rarg jsonb DEFAULT NULL, v_limitoffset jsonb DEFAULT NULL, v_withclause jsonb DEFAULT NULL, v_lockingclause jsonb DEFAULT NULL, v_windowclause jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.res_target ( v_val jsonb DEFAULT NULL, v_name text DEFAULT NULL, v_indirection jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ResTarget":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ResTarget, val}', v_val);
    result = ast.jsonb_set(result, '{ResTarget, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{ResTarget, indirection}', v_indirection);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alias ( v_aliasname text DEFAULT NULL, v_colnames jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"Alias":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{Alias, aliasname}', to_jsonb(v_aliasname));
    result = ast.jsonb_set(result, '{Alias, colnames}', v_colnames);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.join_expr ( v_jointype int DEFAULT NULL, v_larg jsonb DEFAULT NULL, v_rarg jsonb DEFAULT NULL, v_quals jsonb DEFAULT NULL, v_usingclause jsonb DEFAULT NULL, v_isnatural boolean DEFAULT NULL, v_alias jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.bool_expr ( v_boolop int DEFAULT NULL, v_args jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"BoolExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{BoolExpr, boolop}', to_jsonb(v_boolop));
    result = ast.jsonb_set(result, '{BoolExpr, args}', v_args);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_star (  ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Star":{}}'::jsonb;
BEGIN
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.sort_by ( v_node jsonb DEFAULT NULL, v_sortby_dir int DEFAULT NULL, v_sortby_nulls int DEFAULT NULL, v_useop jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.named_arg_expr ( v_arg jsonb DEFAULT NULL, v_name text DEFAULT NULL, v_argnumber int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"NamedArgExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{NamedArgExpr, arg}', v_arg);
    result = ast.jsonb_set(result, '{NamedArgExpr, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{NamedArgExpr, argnumber}', to_jsonb(v_argnumber));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_array_expr ( v_elements jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_ArrayExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{A_ArrayExpr, elements}', v_elements);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.float ( v_str text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"Float":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{Float, str}', to_jsonb(v_str));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_function ( v_is_rowsfrom boolean DEFAULT NULL, v_functions jsonb DEFAULT NULL, v_coldeflist jsonb DEFAULT NULL, v_alias jsonb DEFAULT NULL, v_lateral boolean DEFAULT NULL, v_ordinality boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.sub_link ( v_sublinktype int DEFAULT NULL, v_subselect jsonb DEFAULT NULL, v_testexpr jsonb DEFAULT NULL, v_opername jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.null (  ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"Null":{}}'::jsonb;
BEGIN
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.variable_set_stmt ( v_kind int DEFAULT NULL, v_name text DEFAULT NULL, v_args jsonb DEFAULT NULL, v_is_local boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.variable_show_stmt ( v_name text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"VariableShowStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{VariableShowStmt, name}', to_jsonb(v_name));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.do_stmt ( v_args jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DoStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DoStmt, args}', v_args);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_domain_stmt ( v_domainname jsonb DEFAULT NULL, v_typename jsonb DEFAULT NULL, v_constraints jsonb DEFAULT NULL, v_collclause jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.create_enum_stmt ( v_typename jsonb DEFAULT NULL, v_vals jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateEnumStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateEnumStmt, typeName}', v_typeName);
    result = ast.jsonb_set(result, '{CreateEnumStmt, vals}', v_vals);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_extension_stmt ( v_extname text DEFAULT NULL, v_options jsonb DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateExtensionStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateExtensionStmt, extname}', to_jsonb(v_extname));
    result = ast.jsonb_set(result, '{CreateExtensionStmt, options}', v_options);
    result = ast.jsonb_set(result, '{CreateExtensionStmt, if_not_exists}', to_jsonb(v_if_not_exists));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_function_stmt ( v_replace boolean DEFAULT NULL, v_funcname jsonb DEFAULT NULL, v_parameters jsonb DEFAULT NULL, v_returntype jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.function_parameter ( v_name text DEFAULT NULL, v_argtype jsonb DEFAULT NULL, v_mode int DEFAULT NULL, v_defexpr jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.transaction_stmt ( v_kind int DEFAULT NULL, v_options jsonb DEFAULT NULL, v_gid text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"TransactionStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{TransactionStmt, kind}', to_jsonb(v_kind));
    result = ast.jsonb_set(result, '{TransactionStmt, options}', v_options);
    result = ast.jsonb_set(result, '{TransactionStmt, gid}', to_jsonb(v_gid));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.index_stmt ( v_idxname text DEFAULT NULL, v_relation jsonb DEFAULT NULL, v_accessmethod text DEFAULT NULL, v_indexparams jsonb DEFAULT NULL, v_concurrent boolean DEFAULT NULL, v_unique boolean DEFAULT NULL, v_whereclause jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.index_elem ( v_name text DEFAULT NULL, v_ordering int DEFAULT NULL, v_nulls_ordering int DEFAULT NULL, v_expr jsonb DEFAULT NULL, v_opclass jsonb DEFAULT NULL, v_collation jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.null_test ( v_arg jsonb DEFAULT NULL, v_nulltesttype int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"NullTest":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{NullTest, arg}', v_arg);
    result = ast.jsonb_set(result, '{NullTest, nulltesttype}', to_jsonb(v_nulltesttype));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.param_ref ( v_number int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ParamRef":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ParamRef, number}', to_jsonb(v_number));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_policy_stmt ( v_policy_name text DEFAULT NULL, v_table jsonb DEFAULT NULL, v_cmd_name text DEFAULT NULL, v_permissive boolean DEFAULT NULL, v_roles jsonb DEFAULT NULL, v_qual jsonb DEFAULT NULL, v_with_check jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.range_subselect ( v_subquery jsonb DEFAULT NULL, v_alias jsonb DEFAULT NULL, v_lateral boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RangeSubselect":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RangeSubselect, subquery}', v_subquery);
    result = ast.jsonb_set(result, '{RangeSubselect, alias}', v_alias);
    result = ast.jsonb_set(result, '{RangeSubselect, lateral}', to_jsonb(v_lateral));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_indirection ( v_arg jsonb DEFAULT NULL, v_indirection jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Indirection":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{A_Indirection, arg}', v_arg);
    result = ast.jsonb_set(result, '{A_Indirection, indirection}', v_indirection);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.row_expr ( v_args jsonb DEFAULT NULL, v_row_format int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RowExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RowExpr, args}', v_args);
    result = ast.jsonb_set(result, '{RowExpr, row_format}', to_jsonb(v_row_format));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_role_stmt ( v_stmt_type int DEFAULT NULL, v_role text DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateRoleStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateRoleStmt, stmt_type}', to_jsonb(v_stmt_type));
    result = ast.jsonb_set(result, '{CreateRoleStmt, role}', to_jsonb(v_role));
    result = ast.jsonb_set(result, '{CreateRoleStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grant_role_stmt ( v_granted_roles jsonb DEFAULT NULL, v_grantee_roles jsonb DEFAULT NULL, v_is_grant boolean DEFAULT NULL, v_behavior int DEFAULT NULL, v_admin_opt boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.rule_stmt ( v_relation jsonb DEFAULT NULL, v_rulename text DEFAULT NULL, v_event int DEFAULT NULL, v_instead boolean DEFAULT NULL, v_actions jsonb DEFAULT NULL, v_whereclause jsonb DEFAULT NULL, v_replace boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.update_stmt ( v_relation jsonb DEFAULT NULL, v_targetlist jsonb DEFAULT NULL, v_whereclause jsonb DEFAULT NULL, v_returninglist jsonb DEFAULT NULL, v_fromclause jsonb DEFAULT NULL, v_withclause jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.delete_stmt ( v_relation jsonb DEFAULT NULL, v_whereclause jsonb DEFAULT NULL, v_usingclause jsonb DEFAULT NULL, v_returninglist jsonb DEFAULT NULL, v_withclause jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.insert_stmt ( v_relation jsonb DEFAULT NULL, v_selectstmt jsonb DEFAULT NULL, v_override int DEFAULT NULL, v_cols jsonb DEFAULT NULL, v_onconflictclause jsonb DEFAULT NULL, v_returninglist jsonb DEFAULT NULL, v_withclause jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.create_seq_stmt ( v_sequence jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateSeqStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateSeqStmt, sequence}', v_sequence);
    result = ast.jsonb_set(result, '{CreateSeqStmt, options}', v_options);
    result = ast.jsonb_set(result, '{CreateSeqStmt, if_not_exists}', to_jsonb(v_if_not_exists));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.on_conflict_clause ( v_action int DEFAULT NULL, v_infer jsonb DEFAULT NULL, v_targetlist jsonb DEFAULT NULL, v_whereclause jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.infer_clause ( v_indexelems jsonb DEFAULT NULL, v_conname text DEFAULT NULL, v_whereclause jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"InferClause":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{InferClause, indexElems}', v_indexElems);
    result = ast.jsonb_set(result, '{InferClause, conname}', to_jsonb(v_conname));
    result = ast.jsonb_set(result, '{InferClause, whereClause}', v_whereClause);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.multi_assign_ref ( v_source jsonb DEFAULT NULL, v_colno int DEFAULT NULL, v_ncolumns int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"MultiAssignRef":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{MultiAssignRef, source}', v_source);
    result = ast.jsonb_set(result, '{MultiAssignRef, colno}', to_jsonb(v_colno));
    result = ast.jsonb_set(result, '{MultiAssignRef, ncolumns}', to_jsonb(v_ncolumns));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.set_to_default (  ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"SetToDefault":{}}'::jsonb;
BEGIN
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.min_max_expr ( v_op int DEFAULT NULL, v_args jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"MinMaxExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{MinMaxExpr, op}', to_jsonb(v_op));
    result = ast.jsonb_set(result, '{MinMaxExpr, args}', v_args);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.drop_stmt ( v_objects jsonb DEFAULT NULL, v_removetype int DEFAULT NULL, v_behavior int DEFAULT NULL, v_missing_ok boolean DEFAULT NULL, v_concurrent boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.create_trig_stmt ( v_trigname text DEFAULT NULL, v_relation jsonb DEFAULT NULL, v_funcname jsonb DEFAULT NULL, v_row boolean DEFAULT NULL, v_timing int DEFAULT NULL, v_events int DEFAULT NULL, v_args jsonb DEFAULT NULL, v_columns jsonb DEFAULT NULL, v_whenclause jsonb DEFAULT NULL, v_transitionrels jsonb DEFAULT NULL, v_isconstraint boolean DEFAULT NULL, v_deferrable boolean DEFAULT NULL, v_initdeferred boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.trigger_transition ( v_name text DEFAULT NULL, v_isnew boolean DEFAULT NULL, v_istable boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"TriggerTransition":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{TriggerTransition, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{TriggerTransition, isNew}', to_jsonb(v_isNew));
    result = ast.jsonb_set(result, '{TriggerTransition, isTable}', to_jsonb(v_isTable));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.composite_type_stmt ( v_typevar jsonb DEFAULT NULL, v_coldeflist jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CompositeTypeStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CompositeTypeStmt, typevar}', v_typevar);
    result = ast.jsonb_set(result, '{CompositeTypeStmt, coldeflist}', v_coldeflist);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.explain_stmt ( v_query jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ExplainStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ExplainStmt, query}', v_query);
    result = ast.jsonb_set(result, '{ExplainStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.view_stmt ( v_view jsonb DEFAULT NULL, v_query jsonb DEFAULT NULL, v_withcheckoption int DEFAULT NULL, v_replace boolean DEFAULT NULL, v_aliases jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.collate_clause ( v_arg jsonb DEFAULT NULL, v_collname jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CollateClause":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CollateClause, arg}', v_arg);
    result = ast.jsonb_set(result, '{CollateClause, collname}', v_collname);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.define_stmt ( v_kind int DEFAULT NULL, v_defnames jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL, v_definition jsonb DEFAULT NULL, v_oldstyle boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.drop_role_stmt ( v_roles jsonb DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DropRoleStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DropRoleStmt, roles}', v_roles);
    result = ast.jsonb_set(result, '{DropRoleStmt, missing_ok}', to_jsonb(v_missing_ok));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_owner_stmt ( v_objecttype int DEFAULT NULL, v_object jsonb DEFAULT NULL, v_newowner jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterOwnerStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterOwnerStmt, objectType}', to_jsonb(v_objectType));
    result = ast.jsonb_set(result, '{AlterOwnerStmt, object}', v_object);
    result = ast.jsonb_set(result, '{AlterOwnerStmt, newowner}', v_newowner);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_object_schema_stmt ( v_objecttype int DEFAULT NULL, v_object jsonb DEFAULT NULL, v_newschema text DEFAULT NULL, v_relation jsonb DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.create_conversion_stmt ( v_conversion_name jsonb DEFAULT NULL, v_for_encoding_name text DEFAULT NULL, v_to_encoding_name text DEFAULT NULL, v_func_name jsonb DEFAULT NULL, v_def boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.create_fdw_stmt ( v_fdwname text DEFAULT NULL, v_func_options jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateFdwStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateFdwStmt, fdwname}', to_jsonb(v_fdwname));
    result = ast.jsonb_set(result, '{CreateFdwStmt, func_options}', v_func_options);
    result = ast.jsonb_set(result, '{CreateFdwStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_foreign_server_stmt ( v_servername text DEFAULT NULL, v_fdwname text DEFAULT NULL, v_options jsonb DEFAULT NULL, v_servertype text DEFAULT NULL, v_version text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.create_p_lang_stmt ( v_plname text DEFAULT NULL, v_plhandler jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreatePLangStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreatePLangStmt, plname}', to_jsonb(v_plname));
    result = ast.jsonb_set(result, '{CreatePLangStmt, plhandler}', v_plhandler);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_op_family_stmt ( v_opfamilyname jsonb DEFAULT NULL, v_amname text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateOpFamilyStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateOpFamilyStmt, opfamilyname}', v_opfamilyname);
    result = ast.jsonb_set(result, '{CreateOpFamilyStmt, amname}', to_jsonb(v_amname));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_op_class_stmt ( v_opclassname jsonb DEFAULT NULL, v_amname text DEFAULT NULL, v_datatype jsonb DEFAULT NULL, v_items jsonb DEFAULT NULL, v_isdefault boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.create_op_class_item ( v_itemtype int DEFAULT NULL, v_storedtype jsonb DEFAULT NULL, v_name jsonb DEFAULT NULL, v_number int DEFAULT NULL, v_class_args jsonb DEFAULT NULL, v_order_family jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.alter_op_family_stmt ( v_opfamilyname jsonb DEFAULT NULL, v_amname text DEFAULT NULL, v_items jsonb DEFAULT NULL, v_isdrop boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.alter_operator_stmt ( v_opername jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterOperatorStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterOperatorStmt, opername}', v_opername);
    result = ast.jsonb_set(result, '{AlterOperatorStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.vacuum_stmt ( v_options int DEFAULT NULL, v_relation jsonb DEFAULT NULL, v_va_cols jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"VacuumStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{VacuumStmt, options}', to_jsonb(v_options));
    result = ast.jsonb_set(result, '{VacuumStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{VacuumStmt, va_cols}', v_va_cols);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_table_as_stmt ( v_query jsonb DEFAULT NULL, v_into jsonb DEFAULT NULL, v_relkind int DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.into_clause ( v_rel jsonb DEFAULT NULL, v_oncommit int DEFAULT NULL, v_colnames jsonb DEFAULT NULL, v_skipdata boolean DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.case_expr ( v_args jsonb DEFAULT NULL, v_defresult jsonb DEFAULT NULL, v_arg jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CaseExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CaseExpr, args}', v_args);
    result = ast.jsonb_set(result, '{CaseExpr, defresult}', v_defresult);
    result = ast.jsonb_set(result, '{CaseExpr, arg}', v_arg);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.case_when ( v_expr jsonb DEFAULT NULL, v_result jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CaseWhen":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CaseWhen, expr}', v_expr);
    result = ast.jsonb_set(result, '{CaseWhen, result}', v_result);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.boolean_test ( v_arg jsonb DEFAULT NULL, v_booltesttype int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"BooleanTest":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{BooleanTest, arg}', v_arg);
    result = ast.jsonb_set(result, '{BooleanTest, booltesttype}', to_jsonb(v_booltesttype));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_function_stmt ( v_func jsonb DEFAULT NULL, v_actions jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterFunctionStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterFunctionStmt, func}', v_func);
    result = ast.jsonb_set(result, '{AlterFunctionStmt, actions}', v_actions);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.truncate_stmt ( v_relations jsonb DEFAULT NULL, v_behavior int DEFAULT NULL, v_restart_seqs boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"TruncateStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{TruncateStmt, relations}', v_relations);
    result = ast.jsonb_set(result, '{TruncateStmt, behavior}', to_jsonb(v_behavior));
    result = ast.jsonb_set(result, '{TruncateStmt, restart_seqs}', to_jsonb(v_restart_seqs));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_indices ( v_is_slice boolean DEFAULT NULL, v_lidx jsonb DEFAULT NULL, v_uidx jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"A_Indices":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{A_Indices, is_slice}', to_jsonb(v_is_slice));
    result = ast.jsonb_set(result, '{A_Indices, lidx}', v_lidx);
    result = ast.jsonb_set(result, '{A_Indices, uidx}', v_uidx);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.notify_stmt ( v_conditionname text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"NotifyStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{NotifyStmt, conditionname}', to_jsonb(v_conditionname));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.listen_stmt ( v_conditionname text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ListenStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ListenStmt, conditionname}', to_jsonb(v_conditionname));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.unlisten_stmt ( v_conditionname text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"UnlistenStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{UnlistenStmt, conditionname}', to_jsonb(v_conditionname));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.bit_string ( v_str text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"BitString":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{BitString, str}', to_jsonb(v_str));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.coalesce_expr ( v_args jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CoalesceExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CoalesceExpr, args}', v_args);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.cluster_stmt ( v_relation jsonb DEFAULT NULL, v_indexname text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ClusterStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ClusterStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{ClusterStmt, indexname}', to_jsonb(v_indexname));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.table_like_clause ( v_relation jsonb DEFAULT NULL, v_options int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"TableLikeClause":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{TableLikeClause, relation}', v_relation);
    result = ast.jsonb_set(result, '{TableLikeClause, options}', to_jsonb(v_options));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.with_clause ( v_ctes jsonb DEFAULT NULL, v_recursive boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"WithClause":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{WithClause, ctes}', v_ctes);
    result = ast.jsonb_set(result, '{WithClause, recursive}', to_jsonb(v_recursive));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.common_table_expr ( v_ctename text DEFAULT NULL, v_aliascolnames jsonb DEFAULT NULL, v_ctequery jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CommonTableExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CommonTableExpr, ctename}', to_jsonb(v_ctename));
    result = ast.jsonb_set(result, '{CommonTableExpr, aliascolnames}', v_aliascolnames);
    result = ast.jsonb_set(result, '{CommonTableExpr, ctequery}', v_ctequery);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_range_stmt ( v_typename jsonb DEFAULT NULL, v_params jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateRangeStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateRangeStmt, typeName}', v_typeName);
    result = ast.jsonb_set(result, '{CreateRangeStmt, params}', v_params);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.declare_cursor_stmt ( v_portalname text DEFAULT NULL, v_options int DEFAULT NULL, v_query jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DeclareCursorStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DeclareCursorStmt, portalname}', to_jsonb(v_portalname));
    result = ast.jsonb_set(result, '{DeclareCursorStmt, options}', to_jsonb(v_options));
    result = ast.jsonb_set(result, '{DeclareCursorStmt, query}', v_query);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.fetch_stmt ( v_direction int DEFAULT NULL, v_howmany int DEFAULT NULL, v_portalname text DEFAULT NULL, v_ismove boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.locking_clause ( v_strength int DEFAULT NULL, v_waitpolicy int DEFAULT NULL, v_lockedrels jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"LockingClause":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{LockingClause, strength}', to_jsonb(v_strength));
    result = ast.jsonb_set(result, '{LockingClause, waitPolicy}', to_jsonb(v_waitPolicy));
    result = ast.jsonb_set(result, '{LockingClause, lockedRels}', v_lockedRels);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_am_stmt ( v_amname text DEFAULT NULL, v_handler_name jsonb DEFAULT NULL, v_amtype text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateAmStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateAmStmt, amname}', to_jsonb(v_amname));
    result = ast.jsonb_set(result, '{CreateAmStmt, handler_name}', v_handler_name);
    result = ast.jsonb_set(result, '{CreateAmStmt, amtype}', to_jsonb(v_amtype));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_cast_stmt ( v_sourcetype jsonb DEFAULT NULL, v_targettype jsonb DEFAULT NULL, v_context int DEFAULT NULL, v_inout boolean DEFAULT NULL, v_func jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.reindex_stmt ( v_kind int DEFAULT NULL, v_relation jsonb DEFAULT NULL, v_options int DEFAULT NULL, v_name text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.drop_owned_stmt ( v_roles jsonb DEFAULT NULL, v_behavior int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DropOwnedStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DropOwnedStmt, roles}', v_roles);
    result = ast.jsonb_set(result, '{DropOwnedStmt, behavior}', to_jsonb(v_behavior));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.reassign_owned_stmt ( v_roles jsonb DEFAULT NULL, v_newrole jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ReassignOwnedStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ReassignOwnedStmt, roles}', v_roles);
    result = ast.jsonb_set(result, '{ReassignOwnedStmt, newrole}', v_newrole);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_seq_stmt ( v_sequence jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterSeqStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterSeqStmt, sequence}', v_sequence);
    result = ast.jsonb_set(result, '{AlterSeqStmt, options}', v_options);
    result = ast.jsonb_set(result, '{AlterSeqStmt, missing_ok}', to_jsonb(v_missing_ok));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_domain_stmt ( v_subtype text DEFAULT NULL, v_typename jsonb DEFAULT NULL, v_behavior int DEFAULT NULL, v_def jsonb DEFAULT NULL, v_name text DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.prepare_stmt ( v_name text DEFAULT NULL, v_query jsonb DEFAULT NULL, v_argtypes jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"PrepareStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{PrepareStmt, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{PrepareStmt, query}', v_query);
    result = ast.jsonb_set(result, '{PrepareStmt, argtypes}', v_argtypes);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.execute_stmt ( v_name text DEFAULT NULL, v_params jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ExecuteStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ExecuteStmt, name}', to_jsonb(v_name));
    result = ast.jsonb_set(result, '{ExecuteStmt, params}', v_params);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_enum_stmt ( v_typename jsonb DEFAULT NULL, v_newval text DEFAULT NULL, v_newvalisafter boolean DEFAULT NULL, v_newvalneighbor text DEFAULT NULL, v_skipifnewvalexists boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.create_event_trig_stmt ( v_trigname text DEFAULT NULL, v_eventname text DEFAULT NULL, v_funcname jsonb DEFAULT NULL, v_whenclause jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.alter_event_trig_stmt ( v_trigname text DEFAULT NULL, v_tgenabled text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterEventTrigStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterEventTrigStmt, trigname}', to_jsonb(v_trigname));
    result = ast.jsonb_set(result, '{AlterEventTrigStmt, tgenabled}', to_jsonb(v_tgenabled));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_user_mapping_stmt ( v_user jsonb DEFAULT NULL, v_servername text DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateUserMappingStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateUserMappingStmt, user}', v_user);
    result = ast.jsonb_set(result, '{CreateUserMappingStmt, servername}', to_jsonb(v_servername));
    result = ast.jsonb_set(result, '{CreateUserMappingStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_role_stmt ( v_role jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL, v_action int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterRoleStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterRoleStmt, role}', v_role);
    result = ast.jsonb_set(result, '{AlterRoleStmt, options}', v_options);
    result = ast.jsonb_set(result, '{AlterRoleStmt, action}', to_jsonb(v_action));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_policy_stmt ( v_policy_name text DEFAULT NULL, v_table jsonb DEFAULT NULL, v_qual jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterPolicyStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterPolicyStmt, policy_name}', to_jsonb(v_policy_name));
    result = ast.jsonb_set(result, '{AlterPolicyStmt, table}', v_table);
    result = ast.jsonb_set(result, '{AlterPolicyStmt, qual}', v_qual);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_fdw_stmt ( v_fdwname text DEFAULT NULL, v_func_options jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterFdwStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterFdwStmt, fdwname}', to_jsonb(v_fdwname));
    result = ast.jsonb_set(result, '{AlterFdwStmt, func_options}', v_func_options);
    result = ast.jsonb_set(result, '{AlterFdwStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_foreign_server_stmt ( v_servername text DEFAULT NULL, v_version text DEFAULT NULL, v_options jsonb DEFAULT NULL, v_has_version boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.alter_user_mapping_stmt ( v_user jsonb DEFAULT NULL, v_servername text DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterUserMappingStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterUserMappingStmt, user}', v_user);
    result = ast.jsonb_set(result, '{AlterUserMappingStmt, servername}', to_jsonb(v_servername));
    result = ast.jsonb_set(result, '{AlterUserMappingStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.drop_user_mapping_stmt ( v_user jsonb DEFAULT NULL, v_servername text DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DropUserMappingStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DropUserMappingStmt, user}', v_user);
    result = ast.jsonb_set(result, '{DropUserMappingStmt, servername}', to_jsonb(v_servername));
    result = ast.jsonb_set(result, '{DropUserMappingStmt, missing_ok}', to_jsonb(v_missing_ok));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_foreign_table_stmt ( v_base jsonb DEFAULT NULL, v_servername text DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CreateForeignTableStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CreateForeignTableStmt, base}', v_base);
    result = ast.jsonb_set(result, '{CreateForeignTableStmt, servername}', to_jsonb(v_servername));
    result = ast.jsonb_set(result, '{CreateForeignTableStmt, options}', v_options);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.import_foreign_schema_stmt ( v_server_name text DEFAULT NULL, v_remote_schema text DEFAULT NULL, v_local_schema text DEFAULT NULL, v_list_type int DEFAULT NULL, v_table_list jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.constraints_set_stmt ( v_deferred boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ConstraintsSetStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ConstraintsSetStmt, deferred}', to_jsonb(v_deferred));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grouping_func ( v_args jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"GroupingFunc":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{GroupingFunc, args}', v_args);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grouping_set ( v_kind int DEFAULT NULL, v_content jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"GroupingSet":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{GroupingSet, kind}', to_jsonb(v_kind));
    result = ast.jsonb_set(result, '{GroupingSet, content}', v_content);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.window_def ( v_orderclause jsonb DEFAULT NULL, v_frameoptions int DEFAULT NULL, v_partitionclause jsonb DEFAULT NULL, v_name text DEFAULT NULL, v_startoffset jsonb DEFAULT NULL, v_endoffset jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.discard_stmt ( v_target int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DiscardStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DiscardStmt, target}', to_jsonb(v_target));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.lock_stmt ( v_relations jsonb DEFAULT NULL, v_mode int DEFAULT NULL, v_nowait boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"LockStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{LockStmt, relations}', v_relations);
    result = ast.jsonb_set(result, '{LockStmt, mode}', to_jsonb(v_mode));
    result = ast.jsonb_set(result, '{LockStmt, nowait}', to_jsonb(v_nowait));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_role_set_stmt ( v_role jsonb DEFAULT NULL, v_setstmt jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"AlterRoleSetStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{AlterRoleSetStmt, role}', v_role);
    result = ast.jsonb_set(result, '{AlterRoleSetStmt, setstmt}', v_setstmt);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.refresh_mat_view_stmt ( v_relation jsonb DEFAULT NULL, v_concurrent boolean DEFAULT NULL, v_skipdata boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"RefreshMatViewStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{RefreshMatViewStmt, relation}', v_relation);
    result = ast.jsonb_set(result, '{RefreshMatViewStmt, concurrent}', to_jsonb(v_concurrent));
    result = ast.jsonb_set(result, '{RefreshMatViewStmt, skipData}', to_jsonb(v_skipData));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_transform_stmt ( v_type_name jsonb DEFAULT NULL, v_lang text DEFAULT NULL, v_fromsql jsonb DEFAULT NULL, v_tosql jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.close_portal_stmt ( v_portalname text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ClosePortalStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ClosePortalStmt, portalname}', to_jsonb(v_portalname));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.current_of_expr ( v_cursor_name text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CurrentOfExpr":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CurrentOfExpr, cursor_name}', to_jsonb(v_cursor_name));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.deallocate_stmt ( v_name text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"DeallocateStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{DeallocateStmt, name}', to_jsonb(v_name));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.replica_identity_stmt ( v_identity_type text DEFAULT NULL, v_name text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"ReplicaIdentityStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{ReplicaIdentityStmt, identity_type}', to_jsonb(v_identity_type));
    result = ast.jsonb_set(result, '{ReplicaIdentityStmt, name}', to_jsonb(v_name));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_table_sample ( v_relation jsonb DEFAULT NULL, v_method jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL, v_repeatable jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.sec_label_stmt ( v_objtype int DEFAULT NULL, v_object jsonb DEFAULT NULL, v_label text DEFAULT NULL, v_provider text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.copy_stmt ( v_query jsonb DEFAULT NULL, v_filename text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"CopyStmt":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{CopyStmt, query}', v_query);
    result = ast.jsonb_set(result, '{CopyStmt, filename}', to_jsonb(v_filename));
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_ts_configuration_stmt ( v_kind int DEFAULT NULL, v_cfgname jsonb DEFAULT NULL, v_tokentype jsonb DEFAULT NULL, v_dicts jsonb DEFAULT NULL, v_override boolean DEFAULT NULL, v_replace boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.xml_expr ( v_op int DEFAULT NULL, v_args jsonb DEFAULT NULL, v_name text DEFAULT NULL, v_xmloption int DEFAULT NULL, v_named_args jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.xml_serialize ( v_xmloption int DEFAULT NULL, v_expr jsonb DEFAULT NULL, v_typename jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = '{"XmlSerialize":{}}'::jsonb;
BEGIN
    result = ast.jsonb_set(result, '{XmlSerialize, xmloption}', to_jsonb(v_xmloption));
    result = ast.jsonb_set(result, '{XmlSerialize, expr}', v_expr);
    result = ast.jsonb_set(result, '{XmlSerialize, typeName}', v_typeName);
    RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.json_to_smart_tags ( tags jsonb ) RETURNS text[] AS $EOFCODE$
DECLARE
  key text;
  value jsonb;
  attrs text[] = ARRAY[]::text[];
  _key text;
  _value jsonb;
BEGIN
  FOR key IN SELECT jsonb_object_keys(tags)
  LOOP
    value = tags->key;
    IF (jsonb_typeof(value) = 'boolean') THEN
        IF (tags->>key = 'true') THEN
        attrs = array_append(attrs, concat('@', key));
        END IF;
    ELSIF (jsonb_typeof(value) = 'array') THEN
      FOR _value IN SELECT * FROM jsonb_array_elements(value)
      LOOP
        attrs = array_append(attrs, concat('@', key, ' ', _value#>>'{}'));
      END LOOP;
    ELSE
      attrs = array_append(attrs, concat('@', key, ' ', value#>>'{}'));
    END IF;
  END LOOP;

  RETURN attrs;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION ast_helpers.smart_comments ( tags jsonb, description text DEFAULT NULL ) RETURNS text AS $EOFCODE$
DECLARE
  attrs text[] = ARRAY[]::text[];
BEGIN

  attrs = ast_helpers.json_to_smart_tags(tags);

  IF (description IS NOT NULL) THEN
    attrs = array_append(attrs, description);
  END IF;

  IF (array_length(attrs, 1) > 0) THEN
    RETURN array_to_string(attrs, '\n');
  END IF;

  RETURN NULL;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION ast_helpers.equals ( v_lexpr jsonb, v_rexpr jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 0,
      v_name := to_jsonb(ARRAY[
          ast.string('=')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := v_rexpr
  );
  RETURN ast_expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.gt ( v_lexpr jsonb, v_rexpr jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 0,
      v_name := to_jsonb(ARRAY[
          ast.string('>')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := v_rexpr
  );
  RETURN ast_expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.lt ( v_lexpr jsonb, v_rexpr jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 0,
      v_name := to_jsonb(ARRAY[
          ast.string('<')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := v_rexpr
  );
  RETURN ast_expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.gte ( v_lexpr jsonb, v_rexpr jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 0,
      v_name := to_jsonb(ARRAY[
          ast.string('>=')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := v_rexpr
  );
  RETURN ast_expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.lte ( v_lexpr jsonb, v_rexpr jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 0,
      v_name := to_jsonb(ARRAY[
          ast.string('<=')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := v_rexpr
  );
  RETURN ast_expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.any ( v_lexpr jsonb, v_rexpr jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 1,
      v_name := to_jsonb(ARRAY[
          ast.string('=')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := v_rexpr
  );
  RETURN ast_expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.and ( VARIADIC nodes jsonb[] ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.bool_expr(
      v_boolop := 0,
      v_args := to_jsonb($1)
  );
  RETURN ast_expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.or ( VARIADIC nodes jsonb[] ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.bool_expr(
      v_boolop := 1,
      v_args := to_jsonb($1)
  );
  RETURN ast_expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.matches ( v_lexpr jsonb, v_regexp text ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 0,
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.array_of_strings ( VARIADIC strs text[] ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.range_var ( v_schemaname text, v_relname text, v_alias jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.col ( name text ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.col ( VARIADIC  text[] ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.rls_fn ( v_rls_schema text, v_fn_name text ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.coalesce ( field text, value text DEFAULT '' ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = ast.coalesce_expr(
      v_args := to_jsonb(ARRAY[ ast.string(''), ast.a_const(ast.string('')) ])
    );
BEGIN
	result = jsonb_set(result, '{CoalesceExpr, args, 0, String, str}', to_jsonb(field));
	result = jsonb_set(result, '{CoalesceExpr, args, 1, A_Const, String, str}', to_jsonb(value));
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.coalesce ( field jsonb, value text DEFAULT '' ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = ast.coalesce_expr(
      v_args := to_jsonb(ARRAY[ ast.string(''), ast.a_const(ast.string('')) ])
    );
BEGIN
	result = jsonb_set(result, '{CoalesceExpr, args, 0}', field);
	result = jsonb_set(result, '{CoalesceExpr, args, 1, A_Const, String, str}', to_jsonb(value));
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.tsvectorw ( input jsonb, weight text DEFAULT 'A' ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = ast.func_call(
      v_funcname := to_jsonb(ARRAY[ast.string('setweight')]),
      v_args := to_jsonb(ARRAY[input, ast.a_const(ast.string(weight))])
    );
BEGIN
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.tsvector ( input jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = ast.func_call(
      v_funcname := to_jsonb(ARRAY[ast.string('to_tsvector')]),
      v_args := to_jsonb(ARRAY[input])
    );
BEGIN
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.simple_param ( name text, type text ) RETURNS jsonb AS $EOFCODE$
BEGIN
	RETURN ast.function_parameter(
      v_name := name,
      v_argType := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string(type)])
      ),
      v_mode := 105
    );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.simple_param ( name text, type text, default_value text ) RETURNS jsonb AS $EOFCODE$
BEGIN
	RETURN ast.function_parameter(
      v_name := name,
      v_argType := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string(type)])
      ),
      v_mode := 105,
      v_defexpr := ast.string(default_value)
    );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.simple_param ( name text, type text, default_value jsonb ) RETURNS jsonb AS $EOFCODE$
BEGIN
	RETURN ast.function_parameter(
      v_name := name,
      v_argType := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string(type)])
      ),
      v_mode := 105,
      v_defexpr := default_value
    );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.tsvector ( lang text, input jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
    result jsonb = ast.func_call(
      v_funcname := to_jsonb(ARRAY[ast.string('to_tsvector')]),
      v_args := to_jsonb(ARRAY[ast.a_const(ast.string(lang)), input])
    );
BEGIN
	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.a_expr_distinct_tg_field ( field text ) RETURNS jsonb AS $EOFCODE$
BEGIN
	RETURN ast.a_expr(v_kind := 3, 
        v_lexpr := ast.column_ref(
          to_jsonb(ARRAY[ ast.string('old'),ast.string(field) ])
        ),
        v_name := to_jsonb(ARRAY[ast.string('=')]),
        v_rexpr := ast.column_ref(
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
          v_kind := 0,
          v_lexpr := results[i], 
          v_name := to_jsonb(ARRAY[ast.string('||')]),
          v_rexpr := result );
      END IF;
    END LOOP;

	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.create_trigger_distinct_fields ( v_trigger_name text, v_schema_name text, v_table_name text, v_trigger_fn_schema text, v_trigger_fn_name text, v_fields text[] DEFAULT ARRAY[]::text[], v_params text[] DEFAULT ARRAY[]::text[], v_timing int DEFAULT 2, v_events int DEFAULT 4 | 16 ) RETURNS jsonb AS $EOFCODE$
DECLARE
  results jsonb[];
  result jsonb;
  whenClause jsonb;
	i int;

  nodes jsonb[];
BEGIN

  FOR i IN SELECT * FROM generate_subscripts(v_fields, 1) g(i)
  LOOP
    nodes = array_append(nodes, ast_helpers.a_expr_distinct_tg_field(v_fields[i]));
  END LOOP;
 
  IF (cardinality(nodes) > 1) THEN
    whenClause = ast_helpers.or( variadic nodes := nodes );
  ELSEIF (cardinality(nodes) = 1) THEN
    whenClause = nodes[1];
  END IF;

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
    v_whenClause := whenClause
  );
	RETURN ast.raw_stmt(
    v_stmt := result,
    v_stmt_len := 1
  );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.drop_trigger ( v_trigger_name text, v_schema_name text, v_table_name text, v_cascade boolean DEFAULT FALSE ) RETURNS jsonb AS $EOFCODE$
  select ast.raw_stmt(
    v_stmt := ast.drop_stmt(
      v_objects := to_jsonb(ARRAY[ARRAY[
        ast.string(v_schema_name),
        ast.string(v_table_name),
        ast.string(v_trigger_name)
      ]]),
      v_removeType := ast_constants.object_type('OBJECT_TRIGGER'),
      v_behavior:= (CASE when v_cascade IS TRUE then 1 else 0 END)
    ),
    v_stmt_len := 1
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.create_function ( v_schema_name text, v_function_name text, v_type text, v_parameters jsonb, v_body text, v_language text, v_volatility text DEFAULT NULL, v_security int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast jsonb;
  options jsonb[];
BEGIN

  options = array_append(options, ast.def_elem(
    'as',
    to_jsonb(ARRAY[ast.string(v_body)])
  ));
  
  options = array_append(options, ast.def_elem(
    'language',
    ast.string(v_language)
  ));

  IF (v_volatility IS NOT NULL) THEN 
    options = array_append(options, ast.def_elem(
      'volatility',
      ast.string(v_volatility)
    ));
  END IF;

  IF (v_security IS NOT NULL) THEN 
    options = array_append(options, ast.def_elem(
      'security',
      ast.integer(v_security)
    ));
  END IF;

  select * FROM ast.create_function_stmt(
    v_funcname := ast_helpers.array_of_strings(v_schema_name, v_function_name),
    v_parameters := v_parameters,
    v_returnType := ast.type_name( 
        v_names := ast_helpers.array_of_strings(v_type)
    ),
    v_options := to_jsonb(options)
  ) INTO ast;

  RETURN ast.raw_stmt(
    v_stmt := ast,
    v_stmt_len := 1
  );

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.drop_function ( v_schema_name text DEFAULT NULL, v_function_name text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast jsonb;
BEGIN
  ast = ast.raw_stmt(
    v_stmt := ast.drop_stmt(
      v_objects := to_jsonb(ARRAY[ARRAY[
        ast.string(v_schema_name),
        ast.string(v_function_name)
      ]]),
      v_removeType := ast_constants.object_type('OBJECT_FUNCTION')
    ),
    v_stmt_len := 1
  );
  RETURN ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.create_policy ( v_policy_name text DEFAULT NULL, v_schema_name text DEFAULT NULL, v_table_name text DEFAULT NULL, v_roles text[] DEFAULT NULL, v_qual jsonb DEFAULT NULL, v_cmd_name text DEFAULT NULL, v_with_check jsonb DEFAULT NULL, v_permissive boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
        v_roletype:=ast_constants.role_spec_type(
          'ROLESPEC_PUBLIC'
        )
      ));
  ELSE
    FOR i IN 
    SELECT * FROM generate_series(1, cardinality(v_roles))
    LOOP
      roles = array_append(roles, ast.role_spec(
        v_roletype:=ast_constants.role_spec_type(
          'ROLESPEC_CSTRING'
        ),
        v_rolename:=v_roles[i]
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.drop_policy ( v_policy_name text DEFAULT NULL, v_schema_name text DEFAULT NULL, v_table_name text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
      v_removeType := ast_constants.object_type('OBJECT_POLICY')
    ),
    v_stmt_len := 1
  );
  RETURN ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.create_table ( v_schema_name text, v_table_name text ) RETURNS jsonb AS $EOFCODE$
  select ast.raw_stmt(
    v_stmt := ast.create_stmt(
      v_relation := ast.range_var(
        v_schemaname:= v_schema_name,
        v_relname:= v_table_name,
        v_inh := TRUE,
        v_relpersistence := 'p'
      ),
      v_oncommit := 0
    ),
    v_stmt_len := 1
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.drop_table ( v_schema_name text, v_table_name text, v_cascade boolean DEFAULT FALSE ) RETURNS jsonb AS $EOFCODE$
  select ast.raw_stmt(
    v_stmt := ast.drop_stmt(
      v_objects := to_jsonb(ARRAY[ARRAY[
        ast.string(v_schema_name),
        ast.string(v_table_name)
      ]]),
      v_removeType := ast_constants.object_type('OBJECT_TABLE'),
      v_behavior:= (CASE when v_cascade IS TRUE then 1 else 0 END)
    ),
    v_stmt_len := 1
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.create_index ( v_index_name text, v_schema_name text, v_table_name text, v_fields text[], v_accessmethod text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
  parameters jsonb[];

  item text;
  i int;

  ast jsonb;
BEGIN
  FOR i IN
    SELECT * FROM generate_series(1, cardinality(v_fields)) g (i)
  LOOP
    parameters = array_append(parameters, ast.index_elem(
      v_name := v_fields[i],
      v_ordering := 0,
      v_nulls_ordering := 0
    ));
  END LOOP;

  SELECT ast.raw_stmt(
    v_stmt := ast.index_stmt(
      v_idxname := v_index_name,
      v_relation := ast_helpers.range_var(
        v_schemaname := v_schema_name,
        v_relname := v_table_name
      ),
      v_accessMethod := v_accessMethod,
      v_indexParams := to_jsonb(parameters)
    ),
    v_stmt_len:= 1
  ) INTO ast;

  RETURN ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.drop_index ( v_schema_name text, v_index_name text ) RETURNS jsonb AS $EOFCODE$
  select ast.raw_stmt(
    v_stmt := ast.drop_stmt(
      v_objects:= to_jsonb(ARRAY[
        to_jsonb(ARRAY[
          ast.string(v_schema_name),
          ast.string(v_index_name)
        ])
      ]),
      v_removeType:= ast_constants.object_type('OBJECT_INDEX'),
      v_behavior:= 0
    ),
    v_stmt_len := 1
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.table_grant ( v_schema_name text, v_table_name text, v_priv_name text, v_is_grant boolean, v_role_name text, v_cols text[] DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
      v_targtype := 0, -- why?
      v_objtype := 1, --why?
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
          v_roletype:=ast_constants.role_spec_type(
          'ROLESPEC_CSTRING'
          ),
          v_rolename:= v_role_name
        )
      ])
    ),
    v_stmt_len:= 1
  ) INTO ast;

  RETURN ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_add_column ( v_schema_name text, v_table_name text, v_column_name text, v_column_type text ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_add_column ( v_schema_name text, v_table_name text, v_column_name text, v_column_type jsonb ) RETURNS jsonb AS $EOFCODE$
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
          v_subtype := ast_constants.alter_table_type('AT_AddColumn'),
          v_def := ast.column_def(
            v_colname := v_column_name,
            v_typeName := v_column_type,
            v_is_local := TRUE
          ),
          v_behavior := 0 
        )
      ]),
      v_relkind := ast_constants.object_type('OBJECT_TABLE')
    ),
    v_stmt_len:= 1
  );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_drop_column ( v_schema_name text, v_table_name text, v_column_name text ) RETURNS jsonb AS $EOFCODE$
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
          v_subtype := ast_constants.alter_table_type('AT_DropColumn'),
          v_name := v_column_name,
          v_behavior := 0 
        )
      ]),
      v_relkind := ast_constants.object_type('OBJECT_TABLE')
    ),
    v_stmt_len:= 1
  );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_rename_column ( v_schema_name text, v_table_name text, v_old_column_name text, v_new_column_name text ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast jsonb;
BEGIN
  RETURN ast.raw_stmt(
    v_stmt := ast.rename_stmt(
      v_renameType := ast_constants.object_type('OBJECT_COLUMN'),
      v_relationType := ast_constants.object_type('OBJECT_TABLE'),
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_set_column_data_type ( v_schema_name text, v_table_name text, v_column_name text, v_old_column_type text, v_new_column_type text ) RETURNS jsonb AS $EOFCODE$
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
          v_subtype := ast_constants.alter_table_type('AT_AlterColumnType'),
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
          v_behavior := 0 
        )
      ]),
      v_relkind := ast_constants.object_type('OBJECT_TABLE')
    ),
    v_stmt_len:= 1
  );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_add_check_constraint ( v_schema_name text, v_table_name text, v_constraint_name text, v_constraint_expr jsonb ) RETURNS jsonb AS $EOFCODE$
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
              v_subtype := ast_constants.alter_table_type('AT_AddConstraint'),
              v_def := ast.constraint(
                v_contype := ast_utils.constrainttypes('CHECK'),
                v_conname := v_constraint_name,
                v_raw_expr := v_constraint_expr,
                v_initially_valid := true
              ),
              v_behavior := 0 
            )
          ]),
          v_relkind := ast_constants.object_type('OBJECT_TABLE')
        ),
        v_stmt_len:= 1
      );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_drop_constraint ( v_schema_name text, v_table_name text, v_constraint_name text ) RETURNS jsonb AS $EOFCODE$
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
              v_subtype := ast_constants.alter_table_type('AT_DropConstraint'),
              v_name := v_constraint_name,
              v_behavior := 0 
            )
          ]),
          v_relkind := ast_constants.object_type('OBJECT_TABLE')
        ),
        v_stmt_len:= 1
      );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_modify_check_constraint ( v_schema_name text, v_table_name text, v_constraint_name text, v_constraint_expr jsonb ) RETURNS jsonb AS $EOFCODE$
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
              v_subtype := ast_constants.alter_table_type('AT_DropConstraint'),
              v_name := v_constraint_name,
              v_behavior := 0,
              v_missing_ok := TRUE
            ),
            -- ADD IT BACK
            ast.alter_table_cmd(
              v_subtype := ast_constants.alter_table_type('AT_AddConstraint'),
              v_def := ast.constraint(
                v_contype := ast_utils.constrainttypes('CHECK'),
                v_conname := v_constraint_name,
                v_raw_expr := v_constraint_expr,
                v_initially_valid := true
              ),
              v_behavior := 0 
            )
          ]),
          v_relkind := ast_constants.object_type('OBJECT_TABLE')
        ),
        v_stmt_len:= 1
      );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.set_comment_on_function ( v_function_name text, v_comment text DEFAULT NULL, v_param_types text[] DEFAULT ARRAY[]::text[], v_schema_name text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
        v_objtype := ast_constants.object_type('OBJECT_FUNCTION'),
        v_object := ast.object_with_args(
                v_objname := to_jsonb(names),
                v_objargs := to_jsonb(types)
            ),
            v_comment := v_comment
        ),
        v_stmt_len:= 1
      );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.set_comment_on_function ( v_function_name text, v_tags jsonb DEFAULT NULL, v_description text DEFAULT NULL, v_param_types text[] DEFAULT ARRAY[]::text[], v_schema_name text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.set_comment ( v_objtype int, v_comment text DEFAULT NULL, VARIADIC v_name text[] DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.set_comment ( v_objtype int, v_tags jsonb DEFAULT NULL, v_description text DEFAULT NULL, VARIADIC v_name text[] DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_own_records ( rls_schema text, role_fn text, policy_template_vars jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  policy_ast jsonb;
BEGIN

  -- Function(id), Field(id)
  -- SELECT db_migrate.text('policy_expression_current_role', 

  policy_ast = ast_helpers.equals(
      v_lexpr := ast_helpers.col(policy_template_vars->>'role_key'),
      v_rexpr := ast_helpers.rls_fn(rls_schema, role_fn)
  );

  RETURN policy_ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_owned_records ( rls_schema text, role_fn text, groups_fn text, policy_template_vars jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  policy_ast jsonb;
BEGIN
  -- Function(id), Field(id)

  -- TODO get both role_fn and groups_fn!!!!

  -- SELECT db_migrate.text('policy_expression_current_roles', 
  policy_ast = ast_helpers.or(
    ast_helpers.equals(
      v_lexpr := ast_helpers.col(policy_template_vars->>'role_key'),
      v_rexpr := ast_helpers.rls_fn(rls_schema, role_fn)
    ),
    ast_helpers.any(
      v_lexpr := ast_helpers.col(policy_template_vars->>'role_key'),
      v_rexpr := ast_helpers.rls_fn(rls_schema, groups_fn)
    )
  );

  -- policy_ast = ast_helpers.any(
  --   v_lexpr := ast_helpers.col(policy_template_vars->>'role_key'),
  --   v_rexpr := ast_helpers.rls_fn(rls_schema, groups_fn)
  -- );

  RETURN policy_ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_multi_owners ( rls_schema text, role_fn text, policy_template_vars jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  policy_ast jsonb;
  key_asts jsonb[];
  item jsonb;
BEGIN

  FOR item IN
    SELECT * FROM jsonb_array_elements(policy_template_vars->'role_keys')
    LOOP 
    key_asts = array_append(key_asts, ast_helpers.equals(
      -- NOTE if you have a string JSON element, item::text will keep " around it
      -- this just gets the root path unescaped.... a nice hack
      -- https://dba.stackexchange.com/questions/207984/unquoting-json-strings-print-json-strings-without-quotes
      v_lexpr := ast_helpers.col(item#>>'{}'),
      v_rexpr := ast_helpers.rls_fn(rls_schema, role_fn)
    ));
  END LOOP;

  policy_ast = ast_helpers.or( variadic nodes := key_asts );

  RETURN policy_ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_permission_name ( rls_schema text, groups_fn text, policy_template_vars jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  policy_ast jsonb;
BEGIN
  policy_ast = ast.select_stmt(
      v_op := 0,
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', policy_template_vars->>'permission_role_key'),
                  v_rexpr := ast_helpers.rls_fn(rls_schema, groups_fn)
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := policy_template_vars->>'permission_schema',
              v_relname := policy_template_vars->>'permission_table',
              v_alias := ast.alias(
                  v_aliasname := 'p'
              )
          )
      ]),
      v_whereClause := ast_helpers.equals(
          v_lexpr := ast_helpers.col('p', policy_template_vars->>'permission_name_key'),
          v_rexpr := ast.a_const(
              v_val := ast.string(policy_template_vars->>'this_value')
          )
      )
  );

  policy_ast = ast.sub_link(
    v_subLinkType := 4,
    v_subselect := policy_ast
  );

  RETURN policy_ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_owned_object_records ( rls_schema text, groups_fn text, policy_template_vars jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  policy_ast jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key', 

  policy_ast = ast.select_stmt(
      v_op := 0,
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', policy_template_vars->>'owned_table_key'),
                  v_rexpr := ast_helpers.rls_fn(rls_schema, groups_fn)
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := policy_template_vars->>'owned_schema',
              v_relname := policy_template_vars->>'owned_table',
              v_alias := ast.alias(
                  v_aliasname := 'p'
              )
          )
      ]),
      v_whereClause := ast_helpers.equals(
          v_lexpr := ast_helpers.col('p', policy_template_vars->>'owned_table_ref_key'),
          v_rexpr := ast_helpers.col(policy_template_vars->>'this_object_key')
      )
  );

  policy_ast = ast.sub_link(
    v_subLinkType := 4,
    v_subselect := policy_ast
  );

  RETURN policy_ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_child_of_owned_object_records ( rls_schema text, groups_fn text, policy_template_vars jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  policy_ast jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed', 

  policy_ast = ast.select_stmt(
      v_op := 0,
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', policy_template_vars->>'owned_table_key'),
                  v_rexpr := ast_helpers.rls_fn(rls_schema, groups_fn)
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast.join_expr(
              v_jointype := 0,
              v_larg := ast_helpers.range_var(
                  v_schemaname := policy_template_vars->>'object_schema',
                  v_relname := policy_template_vars->>'object_table',
                  v_alias := ast.alias(
                      v_aliasname := 'c'
                  )
              ),
              v_rarg := ast_helpers.range_var(
                  v_schemaname := policy_template_vars->>'owned_schema',
                  v_relname := policy_template_vars->>'owned_table',
                  v_alias := ast.alias(
                      v_aliasname := 'p'
                  )
              ),
              v_quals := ast_helpers.equals(
                  v_lexpr := ast_helpers.col('p',policy_template_vars->>'owned_table_ref_key'),
                  v_rexpr := ast_helpers.col('c',policy_template_vars->>'object_table_owned_key')
              )
          )
      ]),
      v_whereClause := ast_helpers.equals(
          v_lexpr := ast_helpers.col('c',policy_template_vars->>'object_table_ref_key'),
          v_rexpr := ast_helpers.col(policy_template_vars->>'this_object_key')
      )
  );

  policy_ast = ast.sub_link(
    v_subLinkType := 4,
    v_subselect := policy_ast
  );

  RETURN policy_ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_child_of_owned_object_records_group_array ( rls_schema text, role_fn text, policy_template_vars jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  policy_ast jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed', 

  policy_ast = ast.select_stmt(
      v_op := 0,
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.rls_fn(rls_schema, role_fn),
                  v_rexpr := ast_helpers.col('g', policy_template_vars->>'owned_table_key')
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast.join_expr(
              v_jointype := 0,
              v_larg := ast_helpers.range_var(
                  v_schemaname := policy_template_vars->>'object_schema',
                  v_relname := policy_template_vars->>'object_table',
                  v_alias := ast.alias(
                      v_aliasname := 'm'
                  )
              ),
              v_rarg := ast_helpers.range_var(
                  v_schemaname := policy_template_vars->>'owned_schema',
                  v_relname := policy_template_vars->>'owned_table',
                  v_alias := ast.alias(
                      v_aliasname := 'g'
                  )
              ),
              v_quals := ast_helpers.equals(
                  v_lexpr := ast_helpers.col('g',policy_template_vars->>'owned_table_ref_key'),
                  v_rexpr := ast_helpers.col('m',policy_template_vars->>'object_table_owned_key')
              )
          )
      ]),
      v_whereClause := ast_helpers.equals(
          v_lexpr := ast_helpers.col('m',policy_template_vars->>'object_table_ref_key'),
          v_rexpr := ast_helpers.col(policy_template_vars->>'this_object_key')
      )
  );

  policy_ast = ast.sub_link(
    v_subLinkType := 4,
    v_subselect := policy_ast
  );

  RETURN policy_ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_child_of_owned_object_records_with_ownership ( rls_schema text, groups_fn text, policy_template_vars jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  policy_ast jsonb;
BEGIN

  -- MODIFY policy since they are the same, except we just WRAP the JoinExpr with an AND
  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed_with_ownership', 

  policy_ast = ast_helpers.cpt_child_of_owned_object_records(
    rls_schema,
    groups_fn,
    policy_template_vars
  );

  policy_ast = jsonb_set(policy_ast, '{SubLink, subselect, SelectStmt, fromClause, 0, JoinExpr, quals}', ast.bool_expr(
    v_boolop := 0,
    v_args := to_jsonb(ARRAY[
        policy_ast->'SubLink'->'subselect'->'SelectStmt'->'fromClause'->0->'JoinExpr'->'quals',
        ast_helpers.equals(
            v_lexpr := ast_helpers.col('p', policy_template_vars->>'owned_table_ref_key'),
            v_rexpr := ast_helpers.col(policy_template_vars->>'this_owned_key')
        )
    ])
  ));

  RETURN policy_ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_owned_object_records_group_array ( rls_schema text, role_fn text, policy_template_vars jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  policy_ast jsonb;
BEGIN

  policy_ast = ast.select_stmt(
      v_op := 0,
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.rls_fn(rls_schema, role_fn),
                  v_rexpr := ast_helpers.col('p', policy_template_vars->>'owned_table_key')
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := policy_template_vars->>'owned_schema',
              v_relname := policy_template_vars->>'owned_table',
              v_alias := ast.alias(
                  v_aliasname := 'p'
              )
          )
      ]),
      v_whereClause := ast_helpers.equals(
          v_lexpr := ast_helpers.col('p', policy_template_vars->>'owned_table_ref_key'),
          v_rexpr := ast_helpers.col(
            policy_template_vars->>'this_object_key'
          )
      )
  );

  policy_ast = ast.sub_link(
    v_subLinkType := 4,
    v_subselect := policy_ast
  );

  RETURN policy_ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.create_policy_template ( rls_schema text, role_fn text, groups_fn text, policy_template_name text, policy_template_vars jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  policy_ast jsonb;
BEGIN

  -- Tag some functions, allow them to be "RLS functions"
  -- so they show up in the RLS UI

  IF (policy_template_name = 'own_records') THEN
      policy_ast = ast_helpers.cpt_own_records(
          rls_schema,
          role_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'owned_records') THEN
      policy_ast = ast_helpers.cpt_owned_records(
          rls_schema,
          role_fn,
          groups_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'multi_owners') THEN
      policy_ast = ast_helpers.cpt_multi_owners(
          rls_schema,
          role_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'permission_name') THEN
      policy_ast = ast_helpers.cpt_permission_name(
          rls_schema,
          groups_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'owned_object_records') THEN
      policy_ast = ast_helpers.cpt_owned_object_records(
          rls_schema,
          groups_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'child_of_owned_object_records') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records(
          rls_schema,
          groups_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'child_of_owned_object_records_with_ownership') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records_with_ownership(
          rls_schema,
          groups_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'child_of_owned_object_records_group_array') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records_group_array(
          rls_schema,
          role_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'owned_object_records_group_array') THEN
      policy_ast = ast_helpers.cpt_owned_object_records_group_array(
          rls_schema,
          role_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'open') THEN
      policy_ast = ast.string('TRUE');
  ELSE 
      RAISE EXCEPTION 'UNSUPPORTED POLICY';
  END IF;

  RETURN policy_ast;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.verify ( VARIADIC  text[] ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_schema ( v_schema_name text ) RETURNS jsonb AS $EOFCODE$
  select ast_helpers.verify(
    'verify_schema',
    v_schema_name
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_table ( v_schema_name text, v_table_name text ) RETURNS jsonb AS $EOFCODE$
  select ast_helpers.verify(
    'verify_table',
    v_schema_name || '.' || v_table_name
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_table_grant ( v_schema_name text, v_table_name text, v_priv_name text, v_role_name text ) RETURNS jsonb AS $EOFCODE$
  select ast_helpers.verify(
    'verify_table_grant',
    v_schema_name || '.' || v_table_name,
    v_priv_name,
    v_role_name
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_index ( v_schema_name text, v_table_name text, v_index_name text ) RETURNS jsonb AS $EOFCODE$
  select ast_helpers.verify(
    'verify_index',
    v_schema_name || '.' || v_table_name,
    v_index_name
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_policy ( v_policy_name text, v_schema_name text, v_table_name text ) RETURNS jsonb AS $EOFCODE$
  select ast_helpers.verify(
    'verify_policy',
    v_policy_name,
    v_schema_name || '.' || v_table_name
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_security ( v_schema_name text, v_table_name text ) RETURNS jsonb AS $EOFCODE$
  select ast_helpers.verify(
    'verify_security',
    v_schema_name || '.' || v_table_name
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_function ( v_schema_name text, v_function_name text, v_role_name text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_trigger ( v_schema_name text, v_trigger_name text ) RETURNS jsonb AS $EOFCODE$
  select ast_helpers.verify(
    'verify_trigger',
    v_schema_name || '.' || v_trigger_name
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_type ( v_schema_name text, v_type_name text ) RETURNS jsonb AS $EOFCODE$
  select ast_helpers.verify(
    'verify_type',
    v_schema_name || '.' || v_type_name
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_domain ( v_schema_name text, v_type_name text ) RETURNS jsonb AS $EOFCODE$
  select ast_helpers.verify(
    'verify_domain',
    v_schema_name || '.' || v_type_name
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_extension ( v_extname text ) RETURNS jsonb AS $EOFCODE$
  select ast_helpers.verify(
    'verify_extension',
    v_extname
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.verify_view ( v_schema_name text, v_view_name text ) RETURNS jsonb AS $EOFCODE$
  select ast_helpers.verify(
    'verify_view',
    v_schema_name || '.' || v_view_name
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

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
	select ARRAY[ 'ACCESS METHOD', 'AGGREGATE', NULL, NULL, 'ATTRIBUTE', 'CAST', 'COLUMN', 'COLLATION', 'CONVERSION', 'DATABASE', NULL, NULL, 'DOMAIN', 'CONSTRAINT', NULL, 'EXTENSION', 'FOREIGN DATA WRAPPER', 'SERVER', 'FOREIGN TABLE', 'FUNCTION', 'INDEX', 'LANGUAGE', 'LARGE OBJECT', 'MATERIALIZED VIEW', 'OPERATOR CLASS', 'OPERATOR', 'OPERATOR FAMILY', 'POLICY', NULL, NULL, 'ROLE', 'RULE', 'SCHEMA', 'SEQUENCE', NULL, 'STATISTICS', 'CONSTRAINT', 'TABLE', 'TABLESPACE', 'TRANSFORM', 'TRIGGER', 'TEXT SEARCH CONFIGURATION', 'TEXT SEARCH DICTIONARY', 'TEXT SEARCH PARSER', 'TEXT SEARCH TEMPLATE', 'TYPE', NULL, 'VIEW' ]::text[];
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_utils.objtype_name ( typenum int ) RETURNS text AS $EOFCODE$
	select (ast_utils.objtypes())[typenum + 1];
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_utils.constrainttypes ( contype int ) RETURNS text AS $EOFCODE$
  select (CASE contype
WHEN 0 THEN 'NULL'
WHEN 1 THEN 'NOT NULL'
WHEN 2 THEN 'DEFAULT'
WHEN 4 THEN 'CHECK'
WHEN 5 THEN 'PRIMARY KEY'
WHEN 6 THEN 'UNIQUE'
WHEN 7 THEN 'EXCLUDE'
WHEN 8 THEN 'REFERENCES'
END);
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_utils.constrainttypes ( contype text ) RETURNS int AS $EOFCODE$
  select (CASE contype
WHEN 'NULL' THEN 0
WHEN 'NOT NULL' THEN 1
WHEN 'DEFAULT' THEN 2
WHEN 'CHECK' THEN 4
WHEN 'PRIMARY KEY' THEN 5
WHEN 'UNIQUE' THEN 6
WHEN 'EXCLUDE' THEN 7
WHEN 'REFERENCES' THEN 8
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

CREATE FUNCTION deparser.compact ( vvalues text[], usetrim boolean DEFAULT FALSE ) RETURNS text[] AS $EOFCODE$
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
            WHEN (invl = 'second' AND cardinality(typmods) = 2) THEN 'second(' || typmods[2] || ')'
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

CREATE FUNCTION deparser.get_pg_catalog_type ( typ text, typemods text ) RETURNS text AS $EOFCODE$
SELECT (CASE typ
WHEN 'bpchar' THEN
        (CASE
            WHEN (typemods IS NOT NULL) THEN 'char'
            ELSE 'pg_catalog.bpchar'
        END)
WHEN 'bit' THEN 'bit'
WHEN 'bool' THEN 'boolean'
WHEN 'integer' THEN 'integer'
WHEN 'int' THEN 'int'
WHEN 'int2' THEN 'smallint'
WHEN 'int4' THEN 'int'
WHEN 'int8' THEN 'bigint'
WHEN 'interval' THEN 'interval'
WHEN 'numeric' THEN 'numeric'
WHEN 'time' THEN 'time'
WHEN 'timestamp' THEN 'timestamp'
WHEN 'varchar' THEN 'varchar'
ELSE 'pg_catalog.' || typ
END);
$EOFCODE$ LANGUAGE sql;

CREATE FUNCTION deparser.parse_type ( names jsonb, typemods text ) RETURNS text AS $EOFCODE$
DECLARE
  parsed text[];
  first text;
  typ text;
  ctx jsonb;
  typmod_text text = '';
BEGIN
  parsed = deparser.expressions_array(names);
  first = parsed[1];
  typ = parsed[2];

  -- NOT typ can be NULL
  IF (typ IS NULL AND lower(first) = 'trigger') THEN 
    RETURN 'TRIGGER';
  END IF;

  IF (typemods IS NOT NULL AND character_length(typemods) > 0) THEN 
    typmod_text = deparser.parens(typemods);
  END IF;

  -- "char" case
  IF (first = 'char' ) THEN 
      RETURN '"char"' || typmod_text;
  END IF;

  IF (typ = 'char' AND first = 'pg_catalog') THEN 
    RETURN 'pg_catalog."char"' || typmod_text;
  END IF;

  IF (first != 'pg_catalog') THEN 
    ctx = '{"type": true}'::jsonb;
    RETURN deparser.quoted_name(names, ctx) || typmod_text;
  END IF;

  typ = deparser.get_pg_catalog_type(typ, typemods);
  RETURN typ || typmod_text;

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.type_name ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
    ));

    IF (node->'arrayBounds') IS NOT NULL THEN
      typ = array_append(typ, '[]');
    END IF;

    output = array_append(output, array_to_string(typ, ''));

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.type_cast ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

    -- PARENS
    IF (node#>'{arg, A_Expr}' IS NOT NULL) THEN 
      arg = deparser.parens(deparser.expression(node->'arg', context));
    ELSE 
      arg = deparser.expression(node->'arg', context);
    END IF;

    IF (type = 'boolean') THEN
      IF (arg = '''f''') THEN
        RETURN 'FALSE';
      ELSEIF (arg = '''t''') THEN
        RETURN 'TRUE';
      END IF;
    END IF;

    RETURN format('%s::%s', arg, type);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.returning_list ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
        rets = array_append(rets, 
        deparser.expression(item->'ResTarget'->'val') ||
        ' AS ' ||
        quote_ident(item->'ResTarget'->>'name'));
      ELSE
        rets = array_append(rets, deparser.expression(item->'ResTarget'->'val'));
      END IF;

    END LOOP;

    output = array_append(output, array_to_string(deparser.compact(rets, true), ', '));

  END IF;

  RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.range_var ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
    
BEGIN
    IF (node->'RangeVar') IS NULL THEN  
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RangeVar';
    END IF;

    node = node->'RangeVar';

    IF ((node->'inh')::bool = FALSE) THEN
      output = array_append(output, 'ONLY');
    END IF;

    IF (node->>'relpersistence' = 'u') THEN
      output = array_append(output, 'UNLOGGED');
    END IF;

    IF (node->>'relpersistence' = 't') THEN
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

CREATE FUNCTION deparser.create_extension_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  item jsonb;
BEGIN
    IF (node->'CreateExtensionStmt') IS NULL THEN  
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateExtensionStmt';
    END IF;

    node = node->'CreateExtensionStmt';

    output = array_append(output, 'CREATE EXTENSION');
    IF (node->'if_not_exists' IS NOT NULL AND (node->'if_not_exists')::bool IS TRUE) THEN 
      output = array_append(output, 'IF NOT EXISTS');
    END IF;

    output = array_append(output, quote_ident(node->>'extname'));

    IF (node->'options') IS NOT NULL THEN
      FOR item IN SELECT * FROM jsonb_array_elements(node->'options')
      LOOP
        IF (item#>>'{DefElem, defname}' = 'cascade' AND (item#>>'{DefElem, arg, Integer, ival}')::int = 1) THEN 
          output = array_append(output, 'CASCADE');
        END IF;
      END LOOP;
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.raw_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
BEGIN
    IF (node->'RawStmt') IS NULL THEN  
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RawStmt';
    END IF;

    node = node->'RawStmt';

    IF (node->'stmt_len') IS NOT NULL THEN
      RETURN deparser.expression(node->'stmt') || ';';
    ELSE
      RETURN deparser.expression(node->'stmt');
    END IF;

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_between ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  right_expr text;
  right_expr2 text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr'->0, context);
  right_expr2 = deparser.expression(expr->'rexpr'->1, context);

  RETURN format('%s BETWEEN %s AND %s', left_expr, right_expr, right_expr2);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_between_sym ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  right_expr text;
  right_expr2 text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr'->0, context);
  right_expr2 = deparser.expression(expr->'rexpr'->1, context);

  RETURN format('%s BETWEEN SYMMETRIC %s AND %s', left_expr, right_expr, right_expr2);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_not_between ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  right_expr text;
  right_expr2 text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr'->0, context);
  right_expr2 = deparser.expression(expr->'rexpr'->1, context);

  RETURN format('%s NOT BETWEEN %s AND %s', left_expr, right_expr, right_expr2);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_not_between_sym ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  right_expr text;
  right_expr2 text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr'->0, context);
  right_expr2 = deparser.expression(expr->'rexpr'->1, context);

  RETURN format('%s NOT BETWEEN SYMMETRIC %s AND %s', left_expr, right_expr, right_expr2);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_similar ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_ilike ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

  IF (operator = '!~~*') THEN
    RETURN format('%s %s ( %s )', left_expr, 'NOT ILIKE', right_expr);
  ELSE
    RETURN format('%s %s ( %s )', left_expr, 'ILIKE', right_expr);
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_like ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);
  operator = deparser.expression(expr->'name'->0, context);

  IF (operator = '!~~') THEN
    RETURN format('%s %s ( %s )', left_expr, 'NOT LIKE', right_expr);
  ELSE
    RETURN format('%s %s ( %s )', left_expr, 'LIKE', right_expr);
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_of ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

  IF (operator = '=') THEN
    RETURN format('%s %s ( %s )', left_expr, 'IS OF', right_expr);
  ELSE
    RETURN format('%s %s ( %s )', left_expr, 'IS NOT OF', right_expr);
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_in ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
  
  IF (operator = '=') THEN
    RETURN format('%s %s ( %s )', left_expr, 'IN', right_expr);
  ELSE
    RETURN format('%s %s ( %s )', left_expr, 'NOT IN', right_expr);
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_nullif ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  right_expr text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);

  RETURN format('NULLIF(%s, %s)', left_expr, right_expr);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_op ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
    -- PARENS
    IF (expr#>'{lexpr, A_Expr}' IS NOT NULL) THEN 
      left_expr = deparser.parens(left_expr);
    END IF;
    output = array_append(output, left_expr);
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
    -- PARENS
    IF (expr#>'{rexpr, A_Expr}' IS NOT NULL) THEN 
      right_expr = deparser.parens(right_expr);
    END IF;
    output = array_append(output, right_expr);
  END IF;

  -- TODO too many parens (does removing this break anything?)
  -- TODO update pgsql-parser if not
  IF (cardinality(output) = 2) THEN 
    -- RETURN deparser.parens(array_to_string(output, ''));
    RETURN array_to_string(output, '');
  END IF;

  IF (operator = ANY(ARRAY['->', '->>']::text[])) THEN
    -- RETURN deparser.parens(array_to_string(output, ''));
    RETURN array_to_string(output, '');
  END IF;

  RETURN array_to_string(output, ' ');
  -- RETURN deparser.parens(array_to_string(output, ' '));

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_op_any ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  IF (expr->'name') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_OP_ANY)', 'A_Expr';
  END IF;

  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);
  operator = deparser.expression(expr->'name'->0);

  RETURN format('%s %s ANY( %s )', left_expr, operator, right_expr);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_op_all ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  IF (expr->'name') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (AEXPR_OP_ALL)', 'A_Expr';
  END IF;

  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);
  operator = deparser.expression(expr->'name'->0);

  RETURN format('%s %s ALL( %s )', left_expr, operator, right_expr);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_distinct ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);
  RETURN format('%s IS DISTINCT FROM %s', left_expr, right_expr);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr_not_distinct ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);
  RETURN format('%s IS NOT DISTINCT FROM %s', left_expr, right_expr);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.a_expr ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  kind int;
BEGIN

  IF (expr->>'A_Expr') IS NULL THEN  
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
  END IF;

  expr = expr->'A_Expr';

  IF (expr->'kind') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
  END IF;

  kind = (expr->>'kind')::int;

  IF (kind = ast_constants.a_expr_kind('AEXPR_OP')) THEN
    RETURN deparser.a_expr_op(expr, context);
  ELSEIF (kind = ast_constants.a_expr_kind('AEXPR_OP_ANY')) THEN
    RETURN deparser.a_expr_op_any(expr, context);
  ELSEIF (kind = ast_constants.a_expr_kind('AEXPR_OP_ALL')) THEN
    RETURN deparser.a_expr_op_all(expr, context);
  ELSEIF (kind = ast_constants.a_expr_kind('AEXPR_DISTINCT')) THEN
    RETURN deparser.a_expr_distinct(expr, context);
  ELSEIF (kind = ast_constants.a_expr_kind('AEXPR_NOT_DISTINCT')) THEN
    RETURN deparser.a_expr_not_distinct(expr, context);
  ELSEIF (kind = ast_constants.a_expr_kind('AEXPR_NULLIF')) THEN
    RETURN deparser.a_expr_nullif(expr, context);
  ELSEIF (kind = ast_constants.a_expr_kind('AEXPR_OF')) THEN
    RETURN deparser.a_expr_of(expr, context);
  ELSEIF (kind = ast_constants.a_expr_kind('AEXPR_IN')) THEN
    RETURN deparser.a_expr_in(expr, context);
  ELSEIF (kind = ast_constants.a_expr_kind('AEXPR_LIKE')) THEN
    RETURN deparser.a_expr_like(expr, context);
  ELSEIF (kind = ast_constants.a_expr_kind('AEXPR_ILIKE')) THEN
    RETURN deparser.a_expr_ilike(expr, context);
  ELSEIF (kind = ast_constants.a_expr_kind('AEXPR_SIMILAR')) THEN
    RETURN deparser.a_expr_similar(expr, context);
  ELSEIF (kind = ast_constants.a_expr_kind('AEXPR_BETWEEN')) THEN
    RETURN deparser.a_expr_between(expr, context);
  ELSEIF (kind = ast_constants.a_expr_kind('AEXPR_NOT_BETWEEN')) THEN
    RETURN deparser.a_expr_not_between(expr, context);
  ELSEIF (kind = ast_constants.a_expr_kind('AEXPR_BETWEEN_SYM')) THEN
    RETURN deparser.a_expr_between_sym(expr, context);
  ELSEIF (kind = ast_constants.a_expr_kind('AEXPR_NOT_BETWEEN_SYM')) THEN
    RETURN deparser.a_expr_not_between_sym(expr, context);
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION % (%)', 'A_Expr', expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.bool_expr ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  boolop int;
  ctx jsonb;
  fmt_str text = '%s';
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

  boolop = (node->'boolop')::int;

  IF ((context->'bool')::bool IS TRUE) THEN 
    fmt_str = '(%s)';
  END IF;
  ctx = jsonb_set(context, '{bool}', to_jsonb(TRUE));

  IF (boolop = ast_constants.bool_expr_type('AND_EXPR')) THEN
    RETURN format(fmt_str, array_to_string(deparser.expressions_array(node->'args', ctx), ' AND '));
  ELSEIF (boolop = ast_constants.bool_expr_type('OR_EXPR')) THEN
    RETURN format(fmt_str, array_to_string(deparser.expressions_array(node->'args', ctx), ' OR '));
  ELSEIF (boolop = 2) THEN -- purposely use original context for less parens
    RETURN format('NOT (%s)', deparser.expression(node->'args'->0, context));
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION %', 'BoolExpr';

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.column_ref ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  txt text;
BEGIN

  IF (node->'ColumnRef') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'ColumnRef';
  END IF;

  IF (node->'ColumnRef'->>'fields') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'ColumnRef';
  END IF;

  RETURN deparser.list(node->'ColumnRef'->'fields', '.', jsonb_set(context, '{ColumnRef}', to_jsonb(TRUE)));
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.explain_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.collate_clause ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.a_array_expr ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.column_def ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN

  IF (node->'ColumnDef') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'ColumnDef';
  END IF;

  IF (node->'ColumnDef'->'typeName') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (typeName)', 'ColumnDef';
  END IF;

  node = node->'ColumnDef';

  IF (node->'colname' IS NOT NULL) THEN
    output = array_append(output, quote_ident(node->>'colname'));
  END IF;

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

CREATE FUNCTION deparser.sql_value_function ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  op int;
  value text;
BEGIN

  IF (node->'SQLValueFunction') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'SQLValueFunction';
  END IF;

  IF (node->'SQLValueFunction'->'op') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (op)', 'SQLValueFunction';
  END IF;

  node = node->'SQLValueFunction';
  op = (node->'op')::int;

  SELECT (CASE
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_CURRENT_DATE'))
      THEN 'CURRENT_DATE' 
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_CURRENT_TIME'))
      THEN 'CURRENT_TIME' 
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_CURRENT_TIME_N'))
      THEN 'CURRENT_TIME_N' 
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_CURRENT_TIMESTAMP'))
      THEN 'CURRENT_TIMESTAMP' 
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_CURRENT_TIMESTAMP_N'))
      THEN 'CURRENT_TIMESTAMP_N' 
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_LOCALTIME'))
      THEN 'LOCALTIME' 
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_LOCALTIME_N'))
      THEN 'LOCALTIME_N' 
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_LOCALTIMESTAMP'))
      THEN 'LOCALTIMESTAMP' 
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_LOCALTIMESTAMP_N'))
      THEN 'LOCALTIMESTAMP_N' 
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_CURRENT_ROLE'))
      THEN 'CURRENT_ROLE' 
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_CURRENT_USER'))
      THEN 'CURRENT_USER'
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_USER'))
      THEN 'USER' 
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_SESSION_USER'))
      THEN 'SESSION_USER' 
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_CURRENT_CATALOG'))
      THEN 'CURRENT_CATALOG' 
  WHEN (op = ast_constants.sql_value_function_op('SVFOP_CURRENT_SCHEMA'))
      THEN 'CURRENT_SCHEMA'
  END)
  INTO value;

  RETURN value;

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.common_table_expr ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

  output = array_append(output, quote_ident(node->>'ctename'));

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

CREATE FUNCTION deparser.bit_string ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.a_const ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.boolean_test ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.create_trigger_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
        deparser.expression(node->'whenClause', jsonb_set(context, '{trigger}', to_jsonb(TRUE)))
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

CREATE FUNCTION deparser.string ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  txt text = expr->'String'->>'str';
BEGIN
  IF ((context->'trigger')::bool IS TRUE) THEN
    IF (upper(txt) = 'NEW') THEN
      RETURN 'NEW';
    ELSIF (upper(txt) = 'OLD') THEN
      RETURN 'OLD';
    ELSE 
      RETURN quote_ident(txt);
    END IF;
  ELSIF ((context->'ColumnRef')::bool IS TRUE) THEN
    IF (upper(txt) = 'EXCLUDED') THEN 
      RETURN 'EXCLUDED';
    END IF;
    RETURN quote_ident(txt);
  ELSIF ((context->'enum')::bool IS TRUE) THEN
    RETURN '''' || txt || '''';
  ELSIF ((context->'identifiers')::bool IS TRUE) THEN
    RETURN quote_ident(txt);
  END IF;
  RETURN txt;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.float ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
BEGIN
  IF (LEFT(node->'Float'->>'str', 1) = '-') THEN 
    RETURN deparser.parens(node->'Float'->>'str');
  END IF;
  RETURN node->'Float'->>'str';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.list ( node jsonb, delimiter text DEFAULT ', ', context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  txt text;
BEGIN
  RETURN array_to_string(deparser.expressions_array(node, context), delimiter);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.list_quotes ( node jsonb, delimiter text DEFAULT ', ', context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.create_policy_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  permissive bool;
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


    -- permissive is always on there and true, so if not, it's restrictive
    permissive = (node->'permissive' IS NOT NULL AND (node->'permissive')::bool IS TRUE);

    -- permissive is default so don't need to print it
    IF (permissive IS FALSE) THEN
      output = array_append(output, 'AS');
      output = array_append(output, 'RESTRICTIVE');
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

CREATE FUNCTION deparser.role_spec ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
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

    IF (roletype = ast_constants.role_spec_type('ROLESPEC_CSTRING')) THEN
      RETURN quote_ident(node->>'rolename');
    ELSIF (roletype = ast_constants.role_spec_type('ROLESPEC_CURRENT_USER')) THEN 
      RETURN 'CURRENT_USER';
    ELSIF (roletype = ast_constants.role_spec_type('ROLESPEC_SESSION_USER')) THEN 
      RETURN 'SESSION_USER';
    ELSIF (roletype = ast_constants.role_spec_type('ROLESPEC_PUBLIC')) THEN 
      RETURN 'PUBLIC';
    END IF;

    RAISE EXCEPTION 'BAD_EXPRESSION %', 'RoleSpec';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.insert_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.create_schema_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.exclusion_constraint ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  exclusion jsonb;
  a text[];
  b text[];
  i int;
  stmts text[];
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

      stmts = ARRAY[]::text[];
      FOR i IN
      SELECT * FROM generate_series(1, cardinality(a)) g (i)
      LOOP
        stmts = array_append(stmts, format('%s WITH %s', a[i], b[i]));
      END LOOP;
      output = array_append(output, array_to_string(stmts, ', '));
      output = array_append(output, ')');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.reference_constraint ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.constraint_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.create_seq_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
      output = array_append(output, deparser.list(node->'options', ' ', jsonb_set(context, '{sequence}', to_jsonb(TRUE))));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.do_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.create_table_as_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.constraint ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

    IF (contype = ast_constants.constr_type('CONSTR_FOREIGN')) THEN 
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

    IF (contype = ast_constants.constr_type('CONSTR_EXCLUSION')) THEN 
      output = array_append(output, deparser.exclusion_constraint(node));
    END IF;

    IF (node->'deferrable' IS NOT NULL AND (node->>'deferrable')::bool IS TRUE ) THEN 
      output = array_append(output, 'DEFERRABLE');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.def_elem ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

    IF ((context->'sequence')::bool IS TRUE) THEN
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
          RETURN defname || ' ' || deparser.expression(node->'arg', jsonb_set(context, '{simple}', to_jsonb(TRUE)));
        END IF;
      ELSIF (defname = 'maxvalue') THEN 
        IF (node->'arg' IS NULL) THEN
          RETURN 'NO MAXVALUE';
        ELSE 
          RETURN defname || ' ' || deparser.expression(node->'arg', jsonb_set(context, '{simple}', to_jsonb(TRUE)));
        END IF;
      ELSIF (node->'arg' IS NOT NULL) THEN
        RETURN defname || ' ' || deparser.expression(node->'arg', jsonb_set(context, '{simple}', to_jsonb(TRUE)));
      END IF;
    ELSE
        RETURN defname || '=' || deparser.expression(node->'arg');
    END IF;

    RETURN defname;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.comment_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  objtype int;

  cmt text;
BEGIN
    IF (node->'CommentStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CommentStmt';
    END IF;

    IF (node->'CommentStmt'->'objtype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CommentStmt';
    END IF;

    node = node->'CommentStmt';
    objtype = (node->'objtype')::int;
    output = array_append(output, 'COMMENT');
    output = array_append(output, 'ON');
    output = array_append(output, ast_utils.objtype_name(objtype));

    IF (objtype = ast_constants.object_type('OBJECT_CAST')) THEN
      output = array_append(output, '(');
      output = array_append(output, deparser.expression(node->'object'->0));
      output = array_append(output, 'AS');
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, ')');
    ELSIF (objtype = ast_constants.object_type('OBJECT_DOMCONSTRAINT')) THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'ON');
      output = array_append(output, 'DOMAIN');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = ast_constants.object_type('OBJECT_OPCLASS')) THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'USING');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = ast_constants.object_type('OBJECT_OPFAMILY')) THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'USING');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = ast_constants.object_type('OBJECT_OPERATOR')) THEN
      -- TODO lookup noquotes context in pgsql-parser
      output = array_append(output, deparser.expression(node->'object', 'noquotes'));
    ELSIF (objtype = ast_constants.object_type('OBJECT_POLICY')) THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'ON');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = ast_constants.object_type('OBJECT_ROLE')) THEN
      output = array_append(output, deparser.expression(node->'object'));
    ELSIF (objtype = ast_constants.object_type('OBJECT_RULE')) THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'ON');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = ast_constants.object_type('OBJECT_TABCONSTRAINT')) THEN
      IF (jsonb_array_length(node->'object') = 3) THEN 
        output = array_append(output, 
          quote_ident(deparser.expression(node->'object'->2))
        );
        output = array_append(output, 'ON');
        output = array_append(output,
          array_to_string(ARRAY[
            quote_ident(deparser.expression(node->'object'->0)),
            quote_ident(deparser.expression(node->'object'->1))
          ], '.')
        );

     ELSE 
        output = array_append(output, deparser.expression(node->'object'->1));
        output = array_append(output, 'ON');
        output = array_append(output, deparser.expression(node->'object'->0));
      END IF;
    ELSIF (objtype = ast_constants.object_type('OBJECT_TRANSFORM')) THEN
      output = array_append(output, 'FOR');
      output = array_append(output, deparser.expression(node->'object'->0));
      output = array_append(output, 'LANGUAGE');
      output = array_append(output, deparser.expression(node->'object'->1));
    ELSIF (objtype = ast_constants.object_type('OBJECT_TRIGGER')) THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'ON');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = ast_constants.object_type('OBJECT_LARGEOBJECT')) THEN
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
      cmt = node->>'comment';
      IF (cmt ~* '[^a-zA-Z0-9]') THEN 
        output = array_append(output, 'E' || '''' || cmt || '''');
        -- output = array_append(output, 'E' || '''' || REPLACE(cmt, '\', '\\') || '''');
      ELSE
        output = array_append(output, '''' || cmt || '''');
      END IF;

    ELSE
      output = array_append(output, 'NULL');
    END IF;
  
    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_default_privileges_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
        ELSIF ( def->'DefElem'->>'defname' = 'roles') THEN
          output = array_append(output, 'FOR ROLE');
          output = array_append(output, deparser.expression(def->'DefElem'->'arg'->0));
        END IF;
        output = array_append(output, E'\n');
      END IF;
    END IF;

    output = array_append(output, deparser.expression(node->'action'));

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.case_expr ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.case_when ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.with_clause ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
    IF ((node->'recursive')::bool IS TRUE) THEN 
      output = array_append(output, 'RECURSIVE');
    END IF;
    output = array_append(output, deparser.list(node->'ctes'));

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.variable_set_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

    kind = (node->'kind')::int;
    IF (kind = ast_constants.variable_set_kind('VAR_SET_VALUE')) THEN 
      IF (node->'is_local' IS NOT NULL AND (node->'is_local')::bool IS TRUE) THEN 
        local = 'LOCAL ';
      END IF;
      output = array_append(output, format('SET %s%s = %s', local, node->>'name', deparser.list(node->'args', ', ', jsonb_set(context, '{simple}', to_jsonb(TRUE)))));
    ELSIF (kind = ast_constants.variable_set_kind('VAR_SET_DEFAULT')) THEN
      output = array_append(output, format('SET %s TO DEFAULT', node->>'name'));
    ELSIF (kind = ast_constants.variable_set_kind('VAR_SET_CURRENT')) THEN
      output = array_append(output, format('SET %s FROM CURRENT', node->>'name'));
    ELSIF (kind = ast_constants.variable_set_kind('VAR_SET_MULTI')) THEN
      IF (node->>'name' = 'TRANSACTION') THEN
        multi = 'TRANSACTION';
      ELSIF (node->>'name' = 'SESSION CHARACTERISTICS') THEN
        multi = 'SESSION CHARACTERISTICS AS TRANSACTION';
      END IF;
      output = array_append(output, format('SET %s %s', multi, deparser.list(node->'args', ', ', jsonb_set(context, '{simple}', to_jsonb(TRUE)))));
    ELSIF (kind = ast_constants.variable_set_kind('VAR_RESET')) THEN
      output = array_append(output, format('RESET %s', node->>'name'));
    ELSIF (kind = ast_constants.variable_set_kind('VAR_RESET_ALL')) THEN
      output = array_append(output, 'RESET ALL');
    ELSE
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'VariableSetStmt';
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.variable_show_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
BEGIN
    IF (node->'VariableShowStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'VariableShowStmt';
    END IF;

    IF (node->'VariableShowStmt'->'name') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'VariableShowStmt';
    END IF;

    node = node->'VariableShowStmt';
    output = array_append(output, 'SHOW');
    output = array_append(output, node->>'name');
    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alias ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.range_subselect ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.delete_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.quoted_name ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  item text;
BEGIN
    -- NOTE: assumes array of names passed in 

    IF ((context->'type')::bool IS TRUE) THEN 


      FOREACH item IN array deparser.expressions_array(node)
      LOOP
        -- strip off the [] if it exists at the end
        -- TODO, not sure if we need this anymore... we fixed the quote stuff higher up...
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

CREATE FUNCTION deparser.create_domain_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.grant_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
      IF (node->'is_grant' IS NULL OR (node->'is_grant')::bool IS FALSE) THEN 
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
        IF ( objtype = ast_constants.object_type('OBJECT_DOMAIN') ) THEN 
          output = array_append(output, deparser.list(node->'objects'->0));
        ELSE
          output = array_append(output, deparser.list(node->'objects'));
        END IF;
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

CREATE FUNCTION deparser.composite_type_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.index_elem ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.create_enum_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
    output = array_append(output, deparser.list(node->'vals', E',\n', jsonb_set(context, '{enum}', to_jsonb(TRUE))));
    output = array_append(output, E'\n)');

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_table_cmd ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  subtype int;
  subtypeName text;
BEGIN
    IF (node->'AlterTableCmd') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterTableCmd';
    END IF;

    IF (node->'AlterTableCmd'->'subtype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterTableCmd';
    END IF;

    node = node->'AlterTableCmd';
    subtype = (node->'subtype')::int;
    
    subtypeName = 'COLUMN';
    IF ( context->>'alterType' = 'OBJECT_TYPE' ) THEN 
      subtypeName = 'ATTRIBUTE';
    END IF;

    IF (subtype = ast_constants.alter_table_type('AT_AddColumn')) THEN 
      output = array_append(output, 'ADD');
      output = array_append(output, subtypeName);
      IF ( (node->'missing_ok')::bool IS TRUE ) THEN 
        output = array_append(output, 'IF NOT EXISTS');
      END IF;
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = ast_constants.alter_table_type('AT_ColumnDefault')) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, subtypeName);
      output = array_append(output, quote_ident(node->>'name'));
      IF (node->'def' IS NOT NULL) THEN
        output = array_append(output, 'SET DEFAULT');
        output = array_append(output, deparser.expression(node->'def'));
      ELSE
        output = array_append(output, 'DROP DEFAULT');
      END IF;
    ELSIF (subtype = ast_constants.alter_table_type('AT_DropNotNull')) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, subtypeName);
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'DROP NOT NULL');
    ELSIF (subtype = ast_constants.alter_table_type('AT_SetNotNull')) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, subtypeName);
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'SET NOT NULL');
    ELSIF (subtype = ast_constants.alter_table_type('AT_SetStatistics')) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'SET STATISTICS');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = ast_constants.alter_table_type('AT_SetOptions')) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, subtypeName);
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'SET');
      output = array_append(output, deparser.parens(deparser.list(node->'def')));
    ELSIF (subtype = ast_constants.alter_table_type('AT_SetStorage')) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'SET STORAGE');
      IF (node->'def' IS NOT NULL) THEN
        output = array_append(output, deparser.expression(node->'def'));
      ELSE
        output = array_append(output, 'PLAIN');
      END IF;
    ELSIF (subtype = ast_constants.alter_table_type('AT_DropColumn')) THEN
      output = array_append(output, 'DROP');
      output = array_append(output, subtypeName);
      IF ( (node->'missing_ok')::bool IS TRUE ) THEN
        output = array_append(output, 'IF EXISTS');
      END IF;
      output = array_append(output, quote_ident(node->>'name'));
    ELSIF (subtype = ast_constants.alter_table_type('AT_AddConstraint')) THEN
      output = array_append(output, 'ADD');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = ast_constants.alter_table_type('AT_ValidateConstraint')) THEN
      output = array_append(output, 'VALIDATE CONSTRAINT');
      output = array_append(output, quote_ident(node->>'name'));
    ELSIF (subtype = ast_constants.alter_table_type('AT_DropConstraint')) THEN
      output = array_append(output, 'DROP CONSTRAINT');
      IF ( (node->'missing_ok')::bool IS TRUE ) THEN
        output = array_append(output, 'IF EXISTS');
      END IF;
      output = array_append(output, quote_ident(node->>'name'));
    ELSIF (subtype = ast_constants.alter_table_type('AT_AlterColumnType')) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, subtypeName);
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'TYPE');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = ast_constants.alter_table_type('AT_ChangeOwner')) THEN
      output = array_append(output, 'OWNER TO');
      output = array_append(output, deparser.expression(node->'newowner'));
    ELSIF (subtype = ast_constants.alter_table_type('AT_ClusterOn')) THEN
      output = array_append(output, 'CLUSTER ON');
      output = array_append(output, quote_ident(node->>'name'));
    ELSIF (subtype = ast_constants.alter_table_type('AT_DropCluster')) THEN
      output = array_append(output, 'SET WITHOUT CLUSTER');
    ELSIF (subtype = ast_constants.alter_table_type('AT_AddOids')) THEN
      output = array_append(output, 'SET WITH OIDS');
    ELSIF (subtype = ast_constants.alter_table_type('AT_DropOids')) THEN
      output = array_append(output, 'SET WITHOUT OIDS');
    ELSIF (subtype = ast_constants.alter_table_type('AT_SetRelOptions')) THEN
      output = array_append(output, 'SET');
      output = array_append(output, deparser.parens(deparser.list(node->'def')));
    ELSIF (subtype = ast_constants.alter_table_type('AT_ResetRelOptions')) THEN
      output = array_append(output, 'RESET');
      output = array_append(output, deparser.parens(deparser.list(node->'def')));
    ELSIF (subtype = ast_constants.alter_table_type('AT_AddInherit')) THEN
      output = array_append(output, 'INHERIT');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = ast_constants.alter_table_type('AT_DropInherit')) THEN
      output = array_append(output, 'NO INHERIT');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = ast_constants.alter_table_type('AT_AddOf')) THEN
      output = array_append(output, 'OF');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = ast_constants.alter_table_type('AT_DropOf')) THEN
      output = array_append(output, 'NOT OF');
    ELSIF (subtype = ast_constants.alter_table_type('AT_EnableRowSecurity')) THEN
      output = array_append(output, 'ENABLE ROW LEVEL SECURITY');
    ELSIF (subtype = ast_constants.alter_table_type('AT_DisableRowSecurity')) THEN
      output = array_append(output, 'DISABLE ROW LEVEL SECURITY');
    ELSIF (subtype = ast_constants.alter_table_type('AT_ForceRowSecurity')) THEN
      output = array_append(output, 'FORCE ROW SECURITY');
    ELSIF (subtype = ast_constants.alter_table_type('AT_NoForceRowSecurity')) THEN
      output = array_append(output, 'NO FORCE ROW SECURITY');
    ELSE 
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterTableCmd may need to implement more alter_table_type(s)';
    END IF;

    IF ( (node->'behavior')::int = 1 ) THEN
      output = array_append(output, 'CASCADE');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_table_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  relkind int;
  ninh bool;
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

    IF (relkind = ast_constants.object_type('OBJECT_TABLE') ) THEN 
      output = array_append(output, 'TABLE');

      ninh = (node->'relation'->'RangeVar'->'inh')::bool;
      IF ( ninh IS FALSE OR ninh IS NULL ) THEN 
        output = array_append(output, 'ONLY');
      END IF;

    ELSEIF (relkind = ast_constants.object_type('OBJECT_TYPE')) THEN 
      output = array_append(output, 'TYPE');
    ELSE 
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterTableStmt (relkind impl)';
    END IF;

    IF ( (node->'missing_ok')::bool IS TRUE ) THEN 
      output = array_append(output, 'IF EXISTS');
    END IF;

    context = jsonb_set(context, '{alterType}', to_jsonb(ast_constants.object_type(relkind)));

    output = array_append(output, deparser.expression(node->'relation', context));
    output = array_append(output, deparser.list(node->'cmds', ', ', context));

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.range_function ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  funcs text[];
  calls text[];
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
        calls = ARRAY[deparser.expression(func->0)]::text[];
        IF (func->1 IS NOT NULL AND jsonb_typeof(func->1) = 'array' AND jsonb_array_length(func->1) > 0) THEN 
          calls = array_append(calls, format(
            'AS (%s)',
            deparser.list(func->1)
          ));
        END IF;
        funcs = array_append(funcs, array_to_string(calls, ' '));
      END LOOP;

      IF ((node->'is_rowsfrom')::bool IS TRUE) THEN 
        output = array_append(output, format('ROWS FROM (%s)', array_to_string(funcs, ', ')));
      ELSE
        output = array_append(output, array_to_string(funcs, ', '));
      END IF;
    END IF;

    IF ((node->'ordinality')::bool IS TRUE) THEN
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

CREATE FUNCTION deparser.index_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

    -- BTREE is default, don't need to explicitly put it there
    IF (node->'accessMethod' IS NOT NULL AND upper(node->>'accessMethod') != 'BTREE') THEN
      output = array_append(output, 'USING');
      output = array_append(output, upper(node->>'accessMethod'));
    END IF;

    IF (node->'indexParams' IS NOT NULL AND jsonb_array_length(node->'indexParams') > 0) THEN 
      output = array_append(output, deparser.parens(deparser.list(node->'indexParams')));
    END IF; 

    IF (node->'whereClause' IS NOT NULL) THEN 
      output = array_append(output, 'WHERE');
      output = array_append(output, deparser.expression(node->'whereClause'));
    END IF; 

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.update_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
        output = array_append(output, deparser.list(node->'targetList', ', ', jsonb_set(context, '{update}', to_jsonb(TRUE))));
      END IF;
    END IF;

    IF (node->'fromClause' IS NOT NULL) THEN 
      output = array_append(output, 'FROM');
      output = array_append(output, deparser.list(node->'fromClause', ', '));
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

CREATE FUNCTION deparser.param_ref ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.set_to_default ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
BEGIN
    IF (node->'SetToDefault') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'SetToDefault';
    END IF;

    RETURN 'DEFAULT';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.multi_assign_ref ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
BEGIN
    IF (node->'MultiAssignRef') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'MultiAssignRef';
    END IF;
    IF (node->'MultiAssignRef'->'source') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'MultiAssignRef';
    END IF;
    node = node->'MultiAssignRef';

    RETURN deparser.expression(node->'source');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.join_expr ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

    output = array_append(output, deparser.expression(node->'larg'));

    IF (node->'isNatural' IS NOT NULL AND (node->'isNatural')::bool IS TRUE) THEN 
      output = array_append(output, 'NATURAL');
      is_natural = TRUE;
    END IF;

    jointype = (node->'jointype')::int;
    IF (jointype = ast_constants.join_type('JOIN_INNER')) THEN 
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
    ELSIF (jointype = ast_constants.join_type('JOIN_LEFT')) THEN
        jointxt = 'LEFT OUTER JOIN';
    ELSIF (jointype = ast_constants.join_type('JOIN_FULL')) THEN
        jointxt = 'FULL OUTER JOIN';
    ELSIF (jointype = ast_constants.join_type('JOIN_RIGHT')) THEN
        jointxt = 'RIGHT OUTER JOIN';
    ELSE
      -- TODO need to implement more joins
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
      output = array_append(output, deparser.parens(deparser.list(node->'usingClause')));
    END IF;

    IF ( (node->'rarg' IS NOT NULL AND node->'rarg'->'JoinExpr' IS NOT NULL ) OR node->'alias' IS NOT NULL) THEN 
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

CREATE FUNCTION deparser.a_indirection ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  subnode jsonb;
BEGIN
    IF (node->'A_Indirection') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Indirection';
    END IF;

    node = node->'A_Indirection';

    output = array_append(output, deparser.parens(deparser.expression(node->'arg')));

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

CREATE FUNCTION deparser.sub_link ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.a_star ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
BEGIN
    IF (node->'A_Star') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Star';
    END IF;
    RETURN '*';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.integer ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

    IF (ival < 0 AND context->'simple' IS NULL) THEN
      RETURN deparser.parens(node->>'ival');
    END IF;
    
    RETURN node->>'ival';
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.access_priv ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
      output = array_append(output, deparser.list_quotes(node->'cols', ', ', context));
      output = array_append(output, ')');
    END IF;

    RETURN array_to_string(output, ' ');

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.grouping_func ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.grouping_set ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.func_call ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.rule_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.create_role_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  stmt_type int;
  option jsonb;
  opts_len int;
  defname text;
BEGIN
    IF (node->'CreateRoleStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateRoleStmt';
    END IF;

    IF (node->'CreateRoleStmt'->'stmt_type') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateRoleStmt';
    END IF;

    node = node->'CreateRoleStmt';
    stmt_type = (node->'stmt_type')::int;

    output = array_append(output, 'CREATE');
    
    IF (stmt_type = ast_constants.role_stmt_type('ROLESTMT_ROLE')) THEN 
      output = array_append(output, 'ROLE');
    ELSEIF (stmt_type = ast_constants.role_stmt_type('ROLESTMT_USER')) THEN 
      output = array_append(output, 'USER');
    ELSEIF (stmt_type = ast_constants.role_stmt_type('ROLESTMT_GROUP')) THEN 
      output = array_append(output, 'GROUP');
    ELSE 
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateRoleStmt';
    END IF;

    output = array_append(output, quote_ident(node->>'role'));

    IF (node->'options' IS NOT NULL) THEN 
      opts_len = jsonb_array_length(node->'options');
      IF (opts_len != 1 OR node->'options'->0->'DefElem'->>'defname' != 'addroleto') THEN 
        output = array_append(output, 'WITH');
      END IF;

      FOR option IN SELECT * FROM jsonb_array_elements(node->'options')
      LOOP
        defname = option#>>'{DefElem, defname}';
        IF (defname = 'canlogin') THEN 
          IF ( (option#>'{DefElem, arg, Integer, ival}')::int > 0) THEN 
            output = array_append(output, 'LOGIN');
          ELSE
            output = array_append(output, 'NOLOGIN');
          END IF;
        ELSEIF (defname = 'addroleto') THEN
          output = array_append(output, 'IN ROLE');
          output = array_append(output, deparser.list(option->'DefElem'->'arg'));
        ELSEIF (defname = 'password') THEN
          output = array_append(output, 'PASSWORD');
          output = array_append(output, deparser.expression(option->'DefElem'->'arg'));
        ELSEIF (defname = 'adminmembers') THEN
          output = array_append(output, 'ADMIN');
          output = array_append(output, deparser.list(option->'DefElem'->'arg'));
        ELSEIF (defname = 'rolemembers') THEN
          output = array_append(output, 'USER');
          output = array_append(output, deparser.list(option->'DefElem'->'arg'));
        ELSEIF (defname = 'createdb') THEN
          IF ( (option#>'{DefElem, arg, Integer, ival}')::int > 0) THEN 
            output = array_append(output, 'CREATEDB');
          ELSE
            output = array_append(output, 'NOCREATEDB');
          END IF;
        ELSEIF (defname = 'isreplication') THEN
          IF ( (option#>'{DefElem, arg, Integer, ival}')::int > 0) THEN 
            output = array_append(output, 'REPLICATION');
          ELSE
            output = array_append(output, 'NOREPLICATION');
          END IF;
        ELSEIF (defname = 'bypassrls') THEN
          IF ( (option#>'{DefElem, arg, Integer, ival}')::int > 0) THEN 
            output = array_append(output, 'BYPASSRLS');
          ELSE
            output = array_append(output, 'NOBYPASSRLS');
          END IF;
        ELSEIF (defname = 'inherit') THEN
          IF ( (option#>'{DefElem, arg, Integer, ival}')::int > 0) THEN 
            output = array_append(output, 'INHERIT');
          ELSE
            output = array_append(output, 'NOINHERIT');
          END IF;
        ELSEIF (defname = 'superuser') THEN
          IF ( (option#>'{DefElem, arg, Integer, ival}')::int > 0) THEN 
            output = array_append(output, 'SUPERUSER');
          ELSE
            output = array_append(output, 'NOSUPERUSER');
          END IF;
        ELSEIF (defname = 'createrole') THEN
          IF ( (option#>'{DefElem, arg, Integer, ival}')::int > 0) THEN 
            output = array_append(output, 'CREATEROLE');
          ELSE
            output = array_append(output, 'NOCREATEROLE');
          END IF;
        ELSEIF (defname = 'validUntil') THEN
            output = array_append(output, 'VALID UNTIL');
            output = array_append(output, format('''%s''', deparser.expression(option->'DefElem'->'arg')));
        END IF;
      END LOOP;
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.create_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  relpersistence text;
  item jsonb;
BEGIN
    IF (node->'CreateStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateStmt';
    END IF;

    IF (node->'CreateStmt'->'relation') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CreateStmt';
    END IF;

    node = node->'CreateStmt';

    relpersistence = node#>>'{relation, RangeVar, relpersistence}';

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
        IF (node->'options') IS NOT NULL THEN
        FOR item IN SELECT * FROM jsonb_array_elements(node->'options')
        LOOP
          IF (item#>>'{DefElem, defname}' = 'oids' AND (item#>>'{DefElem, arg, Integer, ival}')::int = 1) THEN 
            output = array_append(output, 'WITH OIDS');
          ELSE
            output = array_append(output, 'WITHOUT OIDS');
          END IF;
        END LOOP;
      END IF;
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.transaction_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.view_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.sort_by ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

    dir = (node->'sortby_dir')::int;
    IF (dir = ast_constants.sort_by_dir('SORTBY_DEFAULT')) THEN 
      -- noop
    ELSIF (dir = ast_constants.sort_by_dir('SORTBY_ASC')) THEN
      output = array_append(output, 'ASC');
    ELSIF (dir = ast_constants.sort_by_dir('SORTBY_DESC')) THEN
      output = array_append(output, 'DESC');
    ELSIF (dir = ast_constants.sort_by_dir('SORTBY_USING')) THEN
      output = array_append(output, 'USING');
      output = array_append(output, deparser.list(node->'useOp'));
    ELSE 
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'SortBy (enum)';
    END IF;

    IF (node->'sortby_nulls' IS NOT NULL) THEN
      nulls = (node->'sortby_nulls')::int;
      IF (nulls = ast_constants.sort_by_nulls('SORTBY_NULLS_DEFAULT')) THEN 
        -- noop
      ELSIF (nulls = ast_constants.sort_by_nulls('SORTBY_NULLS_FIRST')) THEN
        output = array_append(output, 'NULLS FIRST');
      ELSIF (nulls = ast_constants.sort_by_nulls('SORTBY_NULLS_LAST')) THEN
        output = array_append(output, 'NULLS LAST');
      END IF;
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.res_target ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  event int;
BEGIN
    IF (node->'ResTarget') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'ResTarget';
    END IF;

    node = node->'ResTarget';

    -- NOTE seems like compact is required here, sometimes the name is NOT used!
    IF ((context->'select')::bool IS TRUE) THEN       
      output = array_append(output, array_to_string(deparser.compact(ARRAY[
        deparser.expression(node->'val', context),
        quote_ident(node->>'name')
      ]), ' AS '));
    ELSIF ((context->'update')::bool IS TRUE) THEN 
      output = array_append(output, array_to_string(deparser.compact(ARRAY[
        quote_ident(node->>'name'),
        deparser.expression(node->'val', context)
      ]), ' = '));
    ELSE
      output = array_append(output, quote_ident(node->>'name'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.object_with_args ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  rets text[];
  item jsonb;
BEGIN
    IF (node->'ObjectWithArgs') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'ObjectWithArgs';
    END IF;

    node = node->'ObjectWithArgs';

    IF ((context->'noquotes')::bool IS TRUE) THEN 
      output = array_append(output, deparser.list(node->'objname'));
    ELSE
      -- TODO why no '.' for the case above?
      output = array_append(output, deparser.list_quotes(node->'objname', '.'));
    END IF;

    -- TODO args_unspecified bool implies no objargs...
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

CREATE FUNCTION deparser.alter_domain_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  subtype text;
BEGIN
    IF (node->'AlterDomainStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterDomainStmt';
    END IF;

    node = node->'AlterDomainStmt';

    output = array_append(output, 'ALTER DOMAIN');
 
    output = array_append(output, deparser.quoted_name(node->'typeName'));

    subtype = node->>'subtype';
    IF (subtype = 'C') THEN 
      output = array_append(output, 'ADD');
      output = array_append(output, deparser.expression(node->'def'));
    ELSEIF (subtype = 'V') THEN 
      output = array_append(output, 'VALIDATE');
      output = array_append(output, 'CONSTRAINT');
      output = array_append(output, quote_ident(node->>'name'));
    ELSEIF (subtype = 'X') THEN 
      output = array_append(output, 'DROP');
      output = array_append(output, 'CONSTRAINT');
      output = array_append(output, quote_ident(node->>'name'));
    END IF;

    IF ((node->'behavior')::int = 1) THEN 
      output = array_append(output, 'CASCADE');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_enum_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  txt text;
BEGIN
    IF (node->'AlterEnumStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterEnumStmt';
    END IF;

    node = node->'AlterEnumStmt';
  
    output = array_append(output, 'ALTER TYPE');
    output = array_append(output, deparser.quoted_name(node->'typeName'));
    output = array_append(output, 'ADD VALUE');
    txt = replace(node->>'newVal', '''', '''''');
    output = array_append(output, '''' || txt || '''');
    IF (node->'newValNeighbor' IS NOT NULL) THEN 
      IF (node->'newValIsAfter' IS NOT NULL AND (node->'newValIsAfter')::bool IS TRUE) THEN 
        output = array_append(output, 'AFTER');
      ELSE
        output = array_append(output, 'BEFORE');
      END IF;
      txt = replace(node->>'newValNeighbor', '''', '''''');
      output = array_append(output, '''' || txt || '''');
    END IF;

    IF ((node->'behavior')::int = 1) THEN 
      output = array_append(output, 'CASCADE');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.execute_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.row_expr ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.a_indices ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.into_clause ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
BEGIN
    IF (node->'IntoClause') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'IntoClause';
    END IF;
    node = node->'IntoClause';
    RETURN deparser.expression(node->'rel');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.rename_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  renameType int;
  relationType int;
  typObj jsonb;
BEGIN
    IF (node->'RenameStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RenameStmt';
    END IF;

    node = node->'RenameStmt';
    renameType = (node->'renameType')::int;
    relationType = (node->'relationType')::int;
    IF (
      renameType = ast_constants.object_type('OBJECT_FUNCTION') OR
      renameType = ast_constants.object_type('OBJECT_FOREIGN_TABLE') OR
      renameType = ast_constants.object_type('OBJECT_FDW') OR
      renameType = ast_constants.object_type('OBJECT_FOREIGN_SERVER')
    ) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, ast_utils.objtype_name(renameType) );
      IF ((node->'missing_ok')::bool is TRUE) THEN
        output = array_append(output, 'IF EXISTS');
      END IF;
      output = array_append(output, deparser.expression(node->'object'));
      output = array_append(output, 'RENAME');
      output = array_append(output, 'TO');
      output = array_append(output, quote_ident(node->>'newname'));
    ELSEIF ( renameType = ast_constants.object_type('OBJECT_ATTRIBUTE') ) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, ast_utils.objtype_name(relationType) );
      IF ((node->'missing_ok')::bool is TRUE) THEN
        output = array_append(output, 'IF EXISTS');
      END IF;
      output = array_append(output, deparser.expression(node->'relation'));
      output = array_append(output, 'RENAME');
      output = array_append(output, ast_utils.objtype_name(renameType) );
      output = array_append(output, quote_ident(node->>'subname'));
      output = array_append(output, 'TO');
      output = array_append(output, quote_ident(node->>'newname'));
    ELSEIF ( 
      renameType = ast_constants.object_type('OBJECT_DOMAIN') OR
      renameType = ast_constants.object_type('OBJECT_TYPE') 
     ) THEN

      output = array_append(output, 'ALTER');
      output = array_append(output, ast_utils.objtype_name(renameType) );
      IF ((node->'missing_ok')::bool is TRUE) THEN
        output = array_append(output, 'IF EXISTS');
      END IF;

      typObj = '{"TypeName":{"names": []}}'::jsonb;
      typObj = jsonb_set(typObj, '{TypeName, names}', node->'object');
      output = array_append(output, deparser.expression(typObj));
      output = array_append(output, 'RENAME');
      output = array_append(output, 'TO');
      output = array_append(output, quote_ident(node->>'newname'));

    ELSEIF ( renameType = ast_constants.object_type('OBJECT_DOMCONSTRAINT') ) THEN

      output = array_append(output, 'ALTER');
      output = array_append(output, 'DOMAIN');
      IF ((node->'missing_ok')::bool is TRUE) THEN
        output = array_append(output, 'IF EXISTS');
      END IF;

      typObj = '{"TypeName":{"names": []}}'::jsonb;
      typObj = jsonb_set(typObj, '{TypeName, names}', node->'object');
      output = array_append(output, deparser.expression(typObj));
      output = array_append(output, 'RENAME CONSTRAINT');
      output = array_append(output, quote_ident(node->>'subname'));
      output = array_append(output, 'TO');
      output = array_append(output, quote_ident(node->>'newname'));

    ELSE
      output = array_append(output, 'ALTER');
      output = array_append(output, 'TABLE');
      IF ((node->'missing_ok')::bool is TRUE) THEN
        output = array_append(output, 'IF EXISTS');
      END IF;
      output = array_append(output, deparser.expression(node->'relation'));
      output = array_append(output, 'RENAME');
      IF (renameType = ast_constants.object_type('OBJECT_COLUMN')) THEN 
        -- not necessary, but why not
        output = array_append(output, 'COLUMN');
      END IF;
      output = array_append(output, quote_ident(node->>'subname'));
      output = array_append(output, 'TO');
      output = array_append(output, quote_ident(node->>'newname'));

    END IF;

    IF ( (node->'behavior')::int = 1 ) THEN
      output = array_append(output, 'CASCADE');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_owner_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  objectType int;
BEGIN
    IF (node->'AlterOwnerStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterOwnerStmt';
    END IF;

    node = node->'AlterOwnerStmt';
    objectType = (node->'objectType')::int;
    IF (
      objectType = ast_constants.object_type('OBJECT_FUNCTION') OR
      objectType = ast_constants.object_type('OBJECT_FOREIGN_TABLE') OR
      objectType = ast_constants.object_type('OBJECT_FDW') OR
      objectType = ast_constants.object_type('OBJECT_FOREIGN_SERVER')
    ) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, ast_utils.objtype_name(objectType) );
      output = array_append(output, deparser.expression(node->'object'));
      output = array_append(output, 'OWNER');
      output = array_append(output, 'TO');
      output = array_append(output, deparser.expression(node->'newowner'));
    ELSE
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterOwnerStmt new objectType';
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_object_schema_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  objectType int;
BEGIN
    IF (node->'AlterObjectSchemaStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterObjectSchemaStmt';
    END IF;

    node = node->'AlterObjectSchemaStmt';
    objectType = (node->'objectType')::int;
    IF ( objectType = ast_constants.object_type('OBJECT_TABLE') ) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, ast_utils.objtype_name(objectType) );
      IF ( (node->'missing_ok')::bool IS TRUE ) THEN 
        output = array_append(output, 'IF EXISTS');
      END IF;
      output = array_append(output, deparser.expression(node->'relation'));
      output = array_append(output, 'SET SCHEMA');
      output = array_append(output, quote_ident(node->>'newschema'));
    ELSE
      output = array_append(output, 'ALTER');
      output = array_append(output, ast_utils.objtype_name(objectType) );
      IF ( (node->'missing_ok')::bool IS TRUE ) THEN 
        output = array_append(output, 'IF EXISTS');
      END IF;
      output = array_append(output, deparser.expression(node->'object'));
      output = array_append(output, 'SET SCHEMA');
      output = array_append(output, quote_ident(node->>'newschema'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.vacuum_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.select_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
      output = array_append(output, deparser.expression(node->'withClause', context));
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
      IF (node->'distinctClause'->0 IS NOT NULL) THEN 
        IF (jsonb_typeof(node->'distinctClause'->0) = 'null') THEN 
          -- fix for custom.sql test case
          output = array_append(output, 'DISTINCT');
        ELSE
          output = array_append(output, 'DISTINCT ON');
          output = array_append(output, '(');
          output = array_append(output, deparser.list(node->'distinctClause', E',\n', context));
          output = array_append(output, ')');
        END IF;
      ELSE
        output = array_append(output, 'DISTINCT');
      END IF;
    END IF;

    -- target
    IF (node->'targetList') IS NOT NULL THEN 
      output = array_append(output, deparser.list(node->'targetList', E',\n', jsonb_set(context, '{select}', to_jsonb(TRUE))));
    END IF;

    -- into
    IF (node->'intoClause') IS NOT NULL THEN 
      output = array_append(output, 'INTO');
      output = array_append(output, deparser.expression(node->'intoClause', context));
    END IF;

    -- from
    IF (node->'fromClause') IS NOT NULL THEN 
      output = array_append(output, 'FROM');
      output = array_append(output, deparser.list(node->'fromClause', E',\n', context));
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
      output = array_append(output, deparser.list(node->'groupClause', E',\n', context));
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
      output = array_append(output, deparser.list(node->'sortClause', E',\n', context));
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

CREATE FUNCTION deparser.grant_role_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.locking_clause ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
    IF (strength = ast_constants.lock_clause_strength('LCS_NONE')) THEN 
      output = array_append(output, 'NONE');
    ELSIF (strength = ast_constants.lock_clause_strength('LCS_FORKEYSHARE')) THEN
      output = array_append(output, 'FOR KEY SHARE');
    ELSIF (strength = ast_constants.lock_clause_strength('LCS_FORSHARE')) THEN
      output = array_append(output, 'FOR SHARE');
    ELSIF (strength = ast_constants.lock_clause_strength('LCS_FORNOKEYUPDATE')) THEN
      output = array_append(output, 'FOR NO KEY UPDATE');
    ELSIF (strength = ast_constants.lock_clause_strength('LCS_FORUPDATE')) THEN
      output = array_append(output, 'FOR UPDATE');
    END IF;

    IF (node->'lockedRels' IS NOT NULL) THEN 
      output = array_append(output, 'OF');
      output = array_append(output, deparser.list(node->'lockedRels'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.coalesce_expr ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.min_max_expr ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.null_test ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

    IF (node->'NullTest'->'arg') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'NullTest';
    END IF;

    node = node->'NullTest';
    nulltesttype = (node->'nulltesttype')::int;

    output = array_append(output, deparser.expression(node->'arg'));
    IF (nulltesttype = ast_constants.null_test_type('IS_NULL')) THEN 
      output = array_append(output, 'IS NULL');
    ELSE 
      output = array_append(output, 'IS NOT NULL');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.named_arg_expr ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.drop_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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
    objtype = (node->'removeType')::int;
    output = array_append(output, ast_utils.objtype_name(objtype));
    
    IF (node->'missing_ok' IS NOT NULL AND (node->'missing_ok')::bool IS TRUE) THEN 
      output = array_append(output, 'IF EXISTS');
    END IF;

    
    FOR obj IN SELECT * FROM jsonb_array_elements(node->'objects')
    LOOP
      IF ( 
        objtype = ast_constants.object_type('OBJECT_POLICY')
        OR objtype = ast_constants.object_type('OBJECT_RULE')
        OR objtype = ast_constants.object_type('OBJECT_TRIGGER')
      ) THEN
        IF (jsonb_typeof(obj) = 'array') THEN
          IF (jsonb_array_length(obj) = 2) THEN
            output = array_append(output, deparser.quoted_name( 
              to_jsonb(ARRAY[
                obj->1
              ])
            ));
            output = array_append(output, 'ON');
            output = array_append(output, deparser.quoted_name( 
              to_jsonb(ARRAY[
                obj->0
              ])
            ));
          ELSEIF (jsonb_array_length(obj) = 3) THEN
            output = array_append(output, deparser.quoted_name( 
              to_jsonb(ARRAY[
                obj->2
              ])
            ));
            output = array_append(output, 'ON');
            output = array_append(output, deparser.quoted_name( 
              to_jsonb(ARRAY[
                obj->0,
                obj->1
              ])
            ));
          END IF;
        ELSE
          RAISE EXCEPTION 'BAD_EXPRESSION %', 'DropStmt (POLICY)';
        END IF;
      ELSEIF (objtype = ast_constants.object_type('OBJECT_CAST')) THEN 
        output = array_append(output, '(');
        output = array_append(output, deparser.expression(obj->0));
        output = array_append(output, 'AS');
        output = array_append(output, deparser.expression(obj->1));
        output = array_append(output, ')');
      ELSE
        IF (jsonb_typeof(obj) = 'array') THEN
          quoted = array_append(quoted, deparser.quoted_name(obj));
        ELSE
          quoted = array_append(quoted, deparser.expression(obj));
        END IF;
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

CREATE FUNCTION deparser.infer_clause ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.on_conflict_clause ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.create_function_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  param jsonb;
  option jsonb;
  params jsonb[];
  returnsTableElements jsonb[];
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
    output = array_append(output, deparser.list(node->'funcname', '.', jsonb_set(context, '{identifiers}', to_jsonb(TRUE))));

    returnsTableElements = ARRAY[]::jsonb[];

    -- params
    output = array_append(output, '(');
    IF (node->'parameters' IS NOT NULL) THEN

      FOR param IN
      SELECT * FROM jsonb_array_elements(node->'parameters')
      LOOP
        IF ((param->'FunctionParameter'->'mode')::int = ANY(ARRAY[118, 111, 98, 105]::int[])) THEN
          params = array_append(params, param);
        ELSEIF ((param->'FunctionParameter'->'mode')::int = 116) THEN
          returnsTableElements = array_append(returnsTableElements, param);
        END IF;
      END LOOP;

      output = array_append(output, deparser.list(to_jsonb(params)));

    END IF;
    output = array_append(output, ')');

    -- RETURNS

    IF (cardinality(returnsTableElements) > 0) THEN
      output = array_append(output, 'RETURNS');
      output = array_append(output, 'TABLE');
      output = array_append(output, '(');
      output = array_append(output, deparser.list(to_jsonb(returnsTableElements)));
      output = array_append(output, ')');      
    ELSE
      output = array_append(output, 'RETURNS');
      output = array_append(output, deparser.expression(node->'returnType'));
    END IF;

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
              IF ((option->'DefElem'->'arg'->'Integer'->'ival')::int > 0) THEN
                output = array_append(output, 'SECURITY' );
                output = array_append(output, 'DEFINER' );
              ELSE
                -- this is the default, no need to put it here...
                -- output = array_append(output, 'SECURITY' );
                -- output = array_append(output, 'INVOKER' );
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
            ELSIF (defname = 'set') THEN 
              output = array_append(output, deparser.expression(option)); 
            ELSIF (defname = 'volatility') THEN 
              output = array_append(output, upper(deparser.expression(option->'DefElem'->'arg')) );
            END IF;

        END IF;
      END LOOP;

    END IF;

  RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.function_parameter ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
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

CREATE FUNCTION deparser.expression ( expr jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
BEGIN

  -- TODO potentially remove this to help find issues...
  IF (expr IS NULL) THEN 
    RETURN '';
  END IF;

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
  ELSEIF (expr->>'AlterOwnerStmt') IS NOT NULL THEN
    RETURN deparser.alter_owner_stmt(expr, context);
  ELSEIF (expr->>'AlterObjectSchemaStmt') IS NOT NULL THEN
    RETURN deparser.alter_object_schema_stmt(expr, context);
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
  ELSEIF (expr->>'CreateExtensionStmt') IS NOT NULL THEN
    RETURN deparser.create_extension_stmt(expr, context);
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
    RETURN deparser.raw_stmt(expr, context);
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
  ELSEIF (expr->>'VariableShowStmt') IS NOT NULL THEN
    RETURN deparser.variable_show_stmt(expr, context);
  ELSEIF (expr->>'ViewStmt') IS NOT NULL THEN
    RETURN deparser.view_stmt(expr, context);
  ELSEIF (expr->>'WithClause') IS NOT NULL THEN
    RETURN deparser.with_clause(expr, context);
  ELSE
    RAISE EXCEPTION 'UNSUPPORTED_EXPRESSION %', expr::text;
  END IF;

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.expressions_array ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text[] AS $EOFCODE$
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