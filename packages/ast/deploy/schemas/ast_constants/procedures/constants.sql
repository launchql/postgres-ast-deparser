-- Deploy schemas/ast_constants/procedures/constants to pg

-- requires: schemas/ast_constants/schema

-- NOTE: generated from github.com:pyramation/ast-meta-gen.git

BEGIN;

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
 -- THIS IS FUTURE! 13 is artificial
 WHEN 'CONSTR_GENERATED' THEN 13 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

COMMIT;
