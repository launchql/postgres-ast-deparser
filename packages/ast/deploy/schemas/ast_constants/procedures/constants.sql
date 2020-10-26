-- Deploy schemas/ast_constants/procedures/constants to pg

-- requires: schemas/ast_constants/schema

-- NOTE: generated from github.com:pyramation/ast-meta-gen.git

BEGIN;

CREATE FUNCTION ast_constants.alter_table_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE
 WHEN ((val) = ('AT_AddColumn')) THEN 0
 WHEN ((val) = ('AT_AddColumnRecurse')) THEN 1
 WHEN ((val) = ('AT_AddColumnToView')) THEN 2
 WHEN ((val) = ('AT_ColumnDefault')) THEN 3
 WHEN ((val) = ('AT_DropNotNull')) THEN 4
 WHEN ((val) = ('AT_SetNotNull')) THEN 5
 WHEN ((val) = ('AT_SetStatistics')) THEN 6
 WHEN ((val) = ('AT_SetOptions')) THEN 7
 WHEN ((val) = ('AT_ResetOptions')) THEN 8
 WHEN ((val) = ('AT_SetStorage')) THEN 9
 WHEN ((val) = ('AT_DropColumn')) THEN 10
 WHEN ((val) = ('AT_DropColumnRecurse')) THEN 11
 WHEN ((val) = ('AT_AddIndex')) THEN 12
 WHEN ((val) = ('AT_ReAddIndex')) THEN 13
 WHEN ((val) = ('AT_AddConstraint')) THEN 14
 WHEN ((val) = ('AT_AddConstraintRecurse')) THEN 15
 WHEN ((val) = ('AT_ReAddConstraint')) THEN 16
 WHEN ((val) = ('AT_AlterConstraint')) THEN 17
 WHEN ((val) = ('AT_ValidateConstraint')) THEN 18
 WHEN ((val) = ('AT_ValidateConstraintRecurse')) THEN 19
 WHEN ((val) = ('AT_ProcessedConstraint')) THEN 20
 WHEN ((val) = ('AT_AddIndexConstraint')) THEN 21
 WHEN ((val) = ('AT_DropConstraint')) THEN 22
 WHEN ((val) = ('AT_DropConstraintRecurse')) THEN 23
 WHEN ((val) = ('AT_ReAddComment')) THEN 24
 WHEN ((val) = ('AT_AlterColumnType')) THEN 25
 WHEN ((val) = ('AT_AlterColumnGenericOptions')) THEN 26
 WHEN ((val) = ('AT_ChangeOwner')) THEN 27
 WHEN ((val) = ('AT_ClusterOn')) THEN 28
 WHEN ((val) = ('AT_DropCluster')) THEN 29
 WHEN ((val) = ('AT_SetLogged')) THEN 30
 WHEN ((val) = ('AT_SetUnLogged')) THEN 31
 WHEN ((val) = ('AT_AddOids')) THEN 32
 WHEN ((val) = ('AT_AddOidsRecurse')) THEN 33
 WHEN ((val) = ('AT_DropOids')) THEN 34
 WHEN ((val) = ('AT_SetTableSpace')) THEN 35
 WHEN ((val) = ('AT_SetRelOptions')) THEN 36
 WHEN ((val) = ('AT_ResetRelOptions')) THEN 37
 WHEN ((val) = ('AT_ReplaceRelOptions')) THEN 38
 WHEN ((val) = ('AT_EnableTrig')) THEN 39
 WHEN ((val) = ('AT_EnableAlwaysTrig')) THEN 40
 WHEN ((val) = ('AT_EnableReplicaTrig')) THEN 41
 WHEN ((val) = ('AT_DisableTrig')) THEN 42
 WHEN ((val) = ('AT_EnableTrigAll')) THEN 43
 WHEN ((val) = ('AT_DisableTrigAll')) THEN 44
 WHEN ((val) = ('AT_EnableTrigUser')) THEN 45
 WHEN ((val) = ('AT_DisableTrigUser')) THEN 46
 WHEN ((val) = ('AT_EnableRule')) THEN 47
 WHEN ((val) = ('AT_EnableAlwaysRule')) THEN 48
 WHEN ((val) = ('AT_EnableReplicaRule')) THEN 49
 WHEN ((val) = ('AT_DisableRule')) THEN 50
 WHEN ((val) = ('AT_AddInherit')) THEN 51
 WHEN ((val) = ('AT_DropInherit')) THEN 52
 WHEN ((val) = ('AT_AddOf')) THEN 53
 WHEN ((val) = ('AT_DropOf')) THEN 54
 WHEN ((val) = ('AT_ReplicaIdentity')) THEN 55
 WHEN ((val) = ('AT_EnableRowSecurity')) THEN 56
 WHEN ((val) = ('AT_DisableRowSecurity')) THEN 57
 WHEN ((val) = ('AT_ForceRowSecurity')) THEN 58
 WHEN ((val) = ('AT_NoForceRowSecurity')) THEN 59
 WHEN ((val) = ('AT_GenericOptions')) THEN 60
 WHEN ((val) = ('AT_AttachPartition')) THEN 61
 WHEN ((val) = ('AT_DetachPartition')) THEN 62
 WHEN ((val) = ('AT_AddIdentity')) THEN 63
 WHEN ((val) = ('AT_SetIdentity')) THEN 64
 WHEN ((val) = ('AT_DropIdentity')) THEN 65 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.join_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE
 WHEN ((val) = ('JOIN_INNER')) THEN 0
 WHEN ((val) = ('JOIN_LEFT')) THEN 1
 WHEN ((val) = ('JOIN_FULL')) THEN 2
 WHEN ((val) = ('JOIN_RIGHT')) THEN 3
 WHEN ((val) = ('JOIN_SEMI')) THEN 4
 WHEN ((val) = ('JOIN_ANTI')) THEN 5
 WHEN ((val) = ('JOIN_UNIQUE_OUTER')) THEN 6
 WHEN ((val) = ('JOIN_UNIQUE_INNER')) THEN 7 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.role_stmt_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE
 WHEN ((val) = ('ROLESTMT_ROLE')) THEN 0
 WHEN ((val) = ('ROLESTMT_USER')) THEN 1
 WHEN ((val) = ('ROLESTMT_GROUP')) THEN 2 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.role_spec_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE
 WHEN ((val) = ('ROLESPEC_CSTRING')) THEN 0
 WHEN ((val) = ('ROLESPEC_CURRENT_USER')) THEN 1
 WHEN ((val) = ('ROLESPEC_SESSION_USER')) THEN 2
 WHEN ((val) = ('ROLESPEC_PUBLIC')) THEN 3 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.sql_value_function_op ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE
 WHEN ((val) = ('SVFOP_CURRENT_DATE')) THEN 0
 WHEN ((val) = ('SVFOP_CURRENT_TIME')) THEN 1
 WHEN ((val) = ('SVFOP_CURRENT_TIME_N')) THEN 2
 WHEN ((val) = ('SVFOP_CURRENT_TIMESTAMP')) THEN 3
 WHEN ((val) = ('SVFOP_CURRENT_TIMESTAMP_N')) THEN 4
 WHEN ((val) = ('SVFOP_LOCALTIME')) THEN 5
 WHEN ((val) = ('SVFOP_LOCALTIME_N')) THEN 6
 WHEN ((val) = ('SVFOP_LOCALTIMESTAMP')) THEN 7
 WHEN ((val) = ('SVFOP_LOCALTIMESTAMP_N')) THEN 8
 WHEN ((val) = ('SVFOP_CURRENT_ROLE')) THEN 9
 WHEN ((val) = ('SVFOP_CURRENT_USER')) THEN 10
 WHEN ((val) = ('SVFOP_USER')) THEN 11
 WHEN ((val) = ('SVFOP_SESSION_USER')) THEN 12
 WHEN ((val) = ('SVFOP_CURRENT_CATALOG')) THEN 13
 WHEN ((val) = ('SVFOP_CURRENT_SCHEMA')) THEN 14 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.bool_expr_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE
 WHEN ((val) = ('AND_EXPR')) THEN 0
 WHEN ((val) = ('OR_EXPR')) THEN 1 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.a_expr_kind ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE
 WHEN ((val) = ('AEXPR_OP')) THEN 0
 WHEN ((val) = ('AEXPR_OP_ANY')) THEN 1
 WHEN ((val) = ('AEXPR_OP_ALL')) THEN 2
 WHEN ((val) = ('AEXPR_DISTINCT')) THEN 3
 WHEN ((val) = ('AEXPR_NOT_DISTINCT')) THEN 4
 WHEN ((val) = ('AEXPR_NULLIF')) THEN 5
 WHEN ((val) = ('AEXPR_OF')) THEN 6
 WHEN ((val) = ('AEXPR_IN')) THEN 7
 WHEN ((val) = ('AEXPR_LIKE')) THEN 8
 WHEN ((val) = ('AEXPR_ILIKE')) THEN 9
 WHEN ((val) = ('AEXPR_SIMILAR')) THEN 10
 WHEN ((val) = ('AEXPR_BETWEEN')) THEN 11
 WHEN ((val) = ('AEXPR_NOT_BETWEEN')) THEN 12
 WHEN ((val) = ('AEXPR_BETWEEN_SYM')) THEN 13
 WHEN ((val) = ('AEXPR_NOT_BETWEEN_SYM')) THEN 14
 WHEN ((val) = ('AEXPR_PAREN')) THEN 15 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.null_test_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE
 WHEN ((val) = ('IS_NULL')) THEN 0
 WHEN ((val) = ('IS_NOT_NULL')) THEN 1 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.lock_clause_strength ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE
 WHEN ((val) = ('LCS_NONE')) THEN 0
 WHEN ((val) = ('LCS_FORKEYSHARE')) THEN 1
 WHEN ((val) = ('LCS_FORSHARE')) THEN 2
 WHEN ((val) = ('LCS_FORNOKEYUPDATE')) THEN 3
 WHEN ((val) = ('LCS_FORUPDATE')) THEN 4 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.sort_by_dir ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE
 WHEN ((val) = ('SORTBY_DEFAULT')) THEN 0
 WHEN ((val) = ('SORTBY_ASC')) THEN 1
 WHEN ((val) = ('SORTBY_DESC')) THEN 2
 WHEN ((val) = ('SORTBY_USING')) THEN 3 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.sort_by_nulls ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE
 WHEN ((val) = ('SORTBY_NULLS_DEFAULT')) THEN 0
 WHEN ((val) = ('SORTBY_NULLS_FIRST')) THEN 1
 WHEN ((val) = ('SORTBY_NULLS_LAST')) THEN 2 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.variable_set_kind ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE
 WHEN ((val) = ('VAR_SET_VALUE')) THEN 0
 WHEN ((val) = ('VAR_SET_DEFAULT')) THEN 1
 WHEN ((val) = ('VAR_SET_CURRENT')) THEN 2
 WHEN ((val) = ('VAR_SET_MULTI')) THEN 3
 WHEN ((val) = ('VAR_RESET')) THEN 4
 WHEN ((val) = ('VAR_RESET_ALL')) THEN 5 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.object_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE
 WHEN ((val) = ('OBJECT_ACCESS_METHOD')) THEN 0
 WHEN ((val) = ('OBJECT_AGGREGATE')) THEN 1
 WHEN ((val) = ('OBJECT_AMOP')) THEN 2
 WHEN ((val) = ('OBJECT_AMPROC')) THEN 3
 WHEN ((val) = ('OBJECT_ATTRIBUTE')) THEN 4
 WHEN ((val) = ('OBJECT_CAST')) THEN 5
 WHEN ((val) = ('OBJECT_COLUMN')) THEN 6
 WHEN ((val) = ('OBJECT_COLLATION')) THEN 7
 WHEN ((val) = ('OBJECT_CONVERSION')) THEN 8
 WHEN ((val) = ('OBJECT_DATABASE')) THEN 9
 WHEN ((val) = ('OBJECT_DEFAULT')) THEN 10
 WHEN ((val) = ('OBJECT_DEFACL')) THEN 11
 WHEN ((val) = ('OBJECT_DOMAIN')) THEN 12
 WHEN ((val) = ('OBJECT_DOMCONSTRAINT')) THEN 13
 WHEN ((val) = ('OBJECT_EVENT_TRIGGER')) THEN 14
 WHEN ((val) = ('OBJECT_EXTENSION')) THEN 15
 WHEN ((val) = ('OBJECT_FDW')) THEN 16
 WHEN ((val) = ('OBJECT_FOREIGN_SERVER')) THEN 17
 WHEN ((val) = ('OBJECT_FOREIGN_TABLE')) THEN 18
 WHEN ((val) = ('OBJECT_FUNCTION')) THEN 19
 WHEN ((val) = ('OBJECT_INDEX')) THEN 20
 WHEN ((val) = ('OBJECT_LANGUAGE')) THEN 21
 WHEN ((val) = ('OBJECT_LARGEOBJECT')) THEN 22
 WHEN ((val) = ('OBJECT_MATVIEW')) THEN 23
 WHEN ((val) = ('OBJECT_OPCLASS')) THEN 24
 WHEN ((val) = ('OBJECT_OPERATOR')) THEN 25
 WHEN ((val) = ('OBJECT_OPFAMILY')) THEN 26
 WHEN ((val) = ('OBJECT_POLICY')) THEN 27
 WHEN ((val) = ('OBJECT_PUBLICATION')) THEN 28
 WHEN ((val) = ('OBJECT_PUBLICATION_REL')) THEN 29
 WHEN ((val) = ('OBJECT_ROLE')) THEN 30
 WHEN ((val) = ('OBJECT_RULE')) THEN 31
 WHEN ((val) = ('OBJECT_SCHEMA')) THEN 32
 WHEN ((val) = ('OBJECT_SEQUENCE')) THEN 33
 WHEN ((val) = ('OBJECT_SUBSCRIPTION')) THEN 34
 WHEN ((val) = ('OBJECT_STATISTIC_EXT')) THEN 35
 WHEN ((val) = ('OBJECT_TABCONSTRAINT')) THEN 36
 WHEN ((val) = ('OBJECT_TABLE')) THEN 37
 WHEN ((val) = ('OBJECT_TABLESPACE')) THEN 38
 WHEN ((val) = ('OBJECT_TRANSFORM')) THEN 39
 WHEN ((val) = ('OBJECT_TRIGGER')) THEN 40
 WHEN ((val) = ('OBJECT_TSCONFIGURATION')) THEN 41
 WHEN ((val) = ('OBJECT_TSDICTIONARY')) THEN 42
 WHEN ((val) = ('OBJECT_TSPARSER')) THEN 43
 WHEN ((val) = ('OBJECT_TSTEMPLATE')) THEN 44
 WHEN ((val) = ('OBJECT_TYPE')) THEN 45
 WHEN ((val) = ('OBJECT_USER_MAPPING')) THEN 46
 WHEN ((val) = ('OBJECT_VIEW')) THEN 47 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.object_type ( val int ) RETURNS text AS $EOFCODE$
SELECT CASE
 WHEN ((val) = (0)) THEN 'OBJECT_ACCESS_METHOD'
 WHEN ((val) = (1)) THEN 'OBJECT_AGGREGATE'
 WHEN ((val) = (2)) THEN 'OBJECT_AMOP'
 WHEN ((val) = (3)) THEN 'OBJECT_AMPROC'
 WHEN ((val) = (4)) THEN 'OBJECT_ATTRIBUTE'
 WHEN ((val) = (5)) THEN 'OBJECT_CAST'
 WHEN ((val) = (6)) THEN 'OBJECT_COLUMN'
 WHEN ((val) = (7)) THEN 'OBJECT_COLLATION'
 WHEN ((val) = (8)) THEN 'OBJECT_CONVERSION'
 WHEN ((val) = (9)) THEN 'OBJECT_DATABASE'
 WHEN ((val) = (10)) THEN 'OBJECT_DEFAULT'
 WHEN ((val) = (11)) THEN 'OBJECT_DEFACL'
 WHEN ((val) = (12)) THEN 'OBJECT_DOMAIN'
 WHEN ((val) = (13)) THEN 'OBJECT_DOMCONSTRAINT'
 WHEN ((val) = (14)) THEN 'OBJECT_EVENT_TRIGGER'
 WHEN ((val) = (15)) THEN 'OBJECT_EXTENSION'
 WHEN ((val) = (16)) THEN 'OBJECT_FDW'
 WHEN ((val) = (17)) THEN 'OBJECT_FOREIGN_SERVER'
 WHEN ((val) = (18)) THEN 'OBJECT_FOREIGN_TABLE'
 WHEN ((val) = (19)) THEN 'OBJECT_FUNCTION'
 WHEN ((val) = (20)) THEN 'OBJECT_INDEX'
 WHEN ((val) = (21)) THEN 'OBJECT_LANGUAGE'
 WHEN ((val) = (22)) THEN 'OBJECT_LARGEOBJECT'
 WHEN ((val) = (23)) THEN 'OBJECT_MATVIEW'
 WHEN ((val) = (24)) THEN 'OBJECT_OPCLASS'
 WHEN ((val) = (25)) THEN 'OBJECT_OPERATOR'
 WHEN ((val) = (26)) THEN 'OBJECT_OPFAMILY'
 WHEN ((val) = (27)) THEN 'OBJECT_POLICY'
 WHEN ((val) = (28)) THEN 'OBJECT_PUBLICATION'
 WHEN ((val) = (29)) THEN 'OBJECT_PUBLICATION_REL'
 WHEN ((val) = (30)) THEN 'OBJECT_ROLE'
 WHEN ((val) = (31)) THEN 'OBJECT_RULE'
 WHEN ((val) = (32)) THEN 'OBJECT_SCHEMA'
 WHEN ((val) = (33)) THEN 'OBJECT_SEQUENCE'
 WHEN ((val) = (34)) THEN 'OBJECT_SUBSCRIPTION'
 WHEN ((val) = (35)) THEN 'OBJECT_STATISTIC_EXT'
 WHEN ((val) = (36)) THEN 'OBJECT_TABCONSTRAINT'
 WHEN ((val) = (37)) THEN 'OBJECT_TABLE'
 WHEN ((val) = (38)) THEN 'OBJECT_TABLESPACE'
 WHEN ((val) = (39)) THEN 'OBJECT_TRANSFORM'
 WHEN ((val) = (40)) THEN 'OBJECT_TRIGGER'
 WHEN ((val) = (41)) THEN 'OBJECT_TSCONFIGURATION'
 WHEN ((val) = (42)) THEN 'OBJECT_TSDICTIONARY'
 WHEN ((val) = (43)) THEN 'OBJECT_TSPARSER'
 WHEN ((val) = (44)) THEN 'OBJECT_TSTEMPLATE'
 WHEN ((val) = (45)) THEN 'OBJECT_TYPE'
 WHEN ((val) = (46)) THEN 'OBJECT_USER_MAPPING'
 WHEN ((val) = (47)) THEN 'OBJECT_VIEW' END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_constants.constr_type ( val text ) RETURNS int AS $EOFCODE$
SELECT CASE
 WHEN ((val) = ('CONSTR_NULL')) THEN 0
 WHEN ((val) = ('CONSTR_NOTNULL')) THEN 1
 WHEN ((val) = ('CONSTR_DEFAULT')) THEN 2
 WHEN ((val) = ('CONSTR_IDENTITY')) THEN 3
 WHEN ((val) = ('CONSTR_CHECK')) THEN 4
 WHEN ((val) = ('CONSTR_PRIMARY')) THEN 5
 WHEN ((val) = ('CONSTR_UNIQUE')) THEN 6
 WHEN ((val) = ('CONSTR_EXCLUSION')) THEN 7
 WHEN ((val) = ('CONSTR_FOREIGN')) THEN 8
 WHEN ((val) = ('CONSTR_ATTR_DEFERRABLE')) THEN 9
 WHEN ((val) = ('CONSTR_ATTR_NOT_DEFERRABLE')) THEN 10
 WHEN ((val) = ('CONSTR_ATTR_DEFERRED')) THEN 11
 WHEN ((val) = ('CONSTR_ATTR_IMMEDIATE')) THEN 12 END;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

COMMIT;
