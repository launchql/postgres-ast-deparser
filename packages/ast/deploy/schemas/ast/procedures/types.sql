-- Deploy schemas/ast/procedures/types to pg

-- requires: schemas/ast/schema

-- NOTE: generated from github.com:pyramation/ast-meta-gen.git

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

---
--- CUSTOM (helpers)
---

CREATE FUNCTION ast.integer (
  v_ival int DEFAULT NULL -- bigint below
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"Integer":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{Integer, ival}', to_jsonb (v_ival));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;


CREATE FUNCTION ast.a_const (
  v_val jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"A_Const":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{A_Const, val}', v_val);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

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

---
--- GENERATED 
---

CREATE FUNCTION ast.alias (
  v_type text DEFAULT NULL, 
  v_aliasname text DEFAULT NULL, 
  v_colnames jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"Alias":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{Alias, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{Alias, aliasname}', to_jsonb (v_aliasname));
  result = ast.jsonb_set(result, '{Alias, colnames}', v_colnames);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.range_var (
  v_type text DEFAULT NULL, 
  v_catalogname text DEFAULT NULL, 
  v_schemaname text DEFAULT NULL, 
  v_relname text DEFAULT NULL, 
  v_inh boolean DEFAULT NULL, 
  v_relpersistence text DEFAULT NULL, 
  v_alias jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RangeVar":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RangeVar, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RangeVar, catalogname}', to_jsonb (v_catalogname));
  result = ast.jsonb_set(result, '{RangeVar, schemaname}', to_jsonb (v_schemaname));
  result = ast.jsonb_set(result, '{RangeVar, relname}', to_jsonb (v_relname));
  result = ast.jsonb_set(result, '{RangeVar, inh}', to_jsonb (v_inh));
  result = ast.jsonb_set(result, '{RangeVar, relpersistence}', to_jsonb (v_relpersistence));
  result = ast.jsonb_set(result, '{RangeVar, alias}', v_alias);
  result = ast.jsonb_set(result, '{RangeVar, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.table_func (
  v_type text DEFAULT NULL, 
  v_ns_uris jsonb DEFAULT NULL, 
  v_ns_names jsonb DEFAULT NULL, 
  v_docexpr jsonb DEFAULT NULL, 
  v_rowexpr jsonb DEFAULT NULL, 
  v_colnames jsonb DEFAULT NULL, 
  v_coltypes jsonb DEFAULT NULL, 
  v_coltypmods jsonb DEFAULT NULL, 
  v_colcollations jsonb DEFAULT NULL, 
  v_colexprs jsonb DEFAULT NULL, 
  v_coldefexprs jsonb DEFAULT NULL, 
  v_notnulls jsonb DEFAULT NULL, 
  v_ordinalitycol int DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"TableFunc":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{TableFunc, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{TableFunc, ns_uris}', v_ns_uris);
  result = ast.jsonb_set(result, '{TableFunc, ns_names}', v_ns_names);
  result = ast.jsonb_set(result, '{TableFunc, docexpr}', v_docexpr);
  result = ast.jsonb_set(result, '{TableFunc, rowexpr}', v_rowexpr);
  result = ast.jsonb_set(result, '{TableFunc, colnames}', v_colnames);
  result = ast.jsonb_set(result, '{TableFunc, coltypes}', v_coltypes);
  result = ast.jsonb_set(result, '{TableFunc, coltypmods}', v_coltypmods);
  result = ast.jsonb_set(result, '{TableFunc, colcollations}', v_colcollations);
  result = ast.jsonb_set(result, '{TableFunc, colexprs}', v_colexprs);
  result = ast.jsonb_set(result, '{TableFunc, coldefexprs}', v_coldefexprs);
  result = ast.jsonb_set(result, '{TableFunc, notnulls}', v_notnulls);
  result = ast.jsonb_set(result, '{TableFunc, ordinalitycol}', to_jsonb (v_ordinalitycol));
  result = ast.jsonb_set(result, '{TableFunc, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.into_clause (
  v_type text DEFAULT NULL, 
  v_rel jsonb DEFAULT NULL, 
  v_colNames jsonb DEFAULT NULL, 
  v_accessMethod text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_onCommit text DEFAULT NULL, 
  v_tableSpaceName text DEFAULT NULL, 
  v_viewQuery jsonb DEFAULT NULL, 
  v_skipData boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"IntoClause":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{IntoClause, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{IntoClause, rel}', v_rel);
  result = ast.jsonb_set(result, '{IntoClause, colNames}', v_colNames);
  result = ast.jsonb_set(result, '{IntoClause, accessMethod}', to_jsonb (v_accessMethod));
  result = ast.jsonb_set(result, '{IntoClause, options}', v_options);
  result = ast.jsonb_set(result, '{IntoClause, onCommit}', to_jsonb (v_onCommit));
  result = ast.jsonb_set(result, '{IntoClause, tableSpaceName}', to_jsonb (v_tableSpaceName));
  result = ast.jsonb_set(result, '{IntoClause, viewQuery}', v_viewQuery);
  result = ast.jsonb_set(result, '{IntoClause, skipData}', to_jsonb (v_skipData));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.expr (
  v_type text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"Expr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{Expr, type}', to_jsonb (v_type));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.var (
  v_xpr jsonb DEFAULT NULL, 
  v_varno jsonb DEFAULT NULL, 
  v_varattno int DEFAULT NULL, 
  v_vartype jsonb DEFAULT NULL, 
  v_vartypmod int DEFAULT NULL, 
  v_varcollid jsonb DEFAULT NULL, 
  v_varlevelsup jsonb DEFAULT NULL, 
  v_varnosyn jsonb DEFAULT NULL, 
  v_varattnosyn int DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"Var":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{Var, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{Var, varno}', v_varno);
  result = ast.jsonb_set(result, '{Var, varattno}', to_jsonb (v_varattno));
  result = ast.jsonb_set(result, '{Var, vartype}', v_vartype);
  result = ast.jsonb_set(result, '{Var, vartypmod}', to_jsonb (v_vartypmod));
  result = ast.jsonb_set(result, '{Var, varcollid}', v_varcollid);
  result = ast.jsonb_set(result, '{Var, varlevelsup}', v_varlevelsup);
  result = ast.jsonb_set(result, '{Var, varnosyn}', v_varnosyn);
  result = ast.jsonb_set(result, '{Var, varattnosyn}', to_jsonb (v_varattnosyn));
  result = ast.jsonb_set(result, '{Var, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.const (
  v_xpr jsonb DEFAULT NULL, 
  v_consttype jsonb DEFAULT NULL, 
  v_consttypmod int DEFAULT NULL, 
  v_constcollid jsonb DEFAULT NULL, 
  v_constlen int DEFAULT NULL, 
  v_constvalue jsonb DEFAULT NULL, 
  v_constisnull boolean DEFAULT NULL, 
  v_constbyval boolean DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"Const":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{Const, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{Const, consttype}', v_consttype);
  result = ast.jsonb_set(result, '{Const, consttypmod}', to_jsonb (v_consttypmod));
  result = ast.jsonb_set(result, '{Const, constcollid}', v_constcollid);
  result = ast.jsonb_set(result, '{Const, constlen}', to_jsonb (v_constlen));
  result = ast.jsonb_set(result, '{Const, constvalue}', v_constvalue);
  result = ast.jsonb_set(result, '{Const, constisnull}', to_jsonb (v_constisnull));
  result = ast.jsonb_set(result, '{Const, constbyval}', to_jsonb (v_constbyval));
  result = ast.jsonb_set(result, '{Const, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.param (
  v_xpr jsonb DEFAULT NULL, 
  v_paramkind text DEFAULT NULL, 
  v_paramid int DEFAULT NULL, 
  v_paramtype jsonb DEFAULT NULL, 
  v_paramtypmod int DEFAULT NULL, 
  v_paramcollid jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"Param":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{Param, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{Param, paramkind}', to_jsonb (v_paramkind));
  result = ast.jsonb_set(result, '{Param, paramid}', to_jsonb (v_paramid));
  result = ast.jsonb_set(result, '{Param, paramtype}', v_paramtype);
  result = ast.jsonb_set(result, '{Param, paramtypmod}', to_jsonb (v_paramtypmod));
  result = ast.jsonb_set(result, '{Param, paramcollid}', v_paramcollid);
  result = ast.jsonb_set(result, '{Param, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.aggref (
  v_xpr jsonb DEFAULT NULL, 
  v_aggfnoid jsonb DEFAULT NULL, 
  v_aggtype jsonb DEFAULT NULL, 
  v_aggcollid jsonb DEFAULT NULL, 
  v_inputcollid jsonb DEFAULT NULL, 
  v_aggtranstype jsonb DEFAULT NULL, 
  v_aggargtypes jsonb DEFAULT NULL, 
  v_aggdirectargs jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_aggorder jsonb DEFAULT NULL, 
  v_aggdistinct jsonb DEFAULT NULL, 
  v_aggfilter jsonb DEFAULT NULL, 
  v_aggstar boolean DEFAULT NULL, 
  v_aggvariadic boolean DEFAULT NULL, 
  v_aggkind text DEFAULT NULL, 
  v_agglevelsup jsonb DEFAULT NULL, 
  v_aggsplit text DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"Aggref":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{Aggref, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{Aggref, aggfnoid}', v_aggfnoid);
  result = ast.jsonb_set(result, '{Aggref, aggtype}', v_aggtype);
  result = ast.jsonb_set(result, '{Aggref, aggcollid}', v_aggcollid);
  result = ast.jsonb_set(result, '{Aggref, inputcollid}', v_inputcollid);
  result = ast.jsonb_set(result, '{Aggref, aggtranstype}', v_aggtranstype);
  result = ast.jsonb_set(result, '{Aggref, aggargtypes}', v_aggargtypes);
  result = ast.jsonb_set(result, '{Aggref, aggdirectargs}', v_aggdirectargs);
  result = ast.jsonb_set(result, '{Aggref, args}', v_args);
  result = ast.jsonb_set(result, '{Aggref, aggorder}', v_aggorder);
  result = ast.jsonb_set(result, '{Aggref, aggdistinct}', v_aggdistinct);
  result = ast.jsonb_set(result, '{Aggref, aggfilter}', v_aggfilter);
  result = ast.jsonb_set(result, '{Aggref, aggstar}', to_jsonb (v_aggstar));
  result = ast.jsonb_set(result, '{Aggref, aggvariadic}', to_jsonb (v_aggvariadic));
  result = ast.jsonb_set(result, '{Aggref, aggkind}', to_jsonb (v_aggkind));
  result = ast.jsonb_set(result, '{Aggref, agglevelsup}', v_agglevelsup);
  result = ast.jsonb_set(result, '{Aggref, aggsplit}', to_jsonb (v_aggsplit));
  result = ast.jsonb_set(result, '{Aggref, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.grouping_func (
  v_xpr jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_refs jsonb DEFAULT NULL, 
  v_cols jsonb DEFAULT NULL, 
  v_agglevelsup jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"GroupingFunc":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{GroupingFunc, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{GroupingFunc, args}', v_args);
  result = ast.jsonb_set(result, '{GroupingFunc, refs}', v_refs);
  result = ast.jsonb_set(result, '{GroupingFunc, cols}', v_cols);
  result = ast.jsonb_set(result, '{GroupingFunc, agglevelsup}', v_agglevelsup);
  result = ast.jsonb_set(result, '{GroupingFunc, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.window_func (
  v_xpr jsonb DEFAULT NULL, 
  v_winfnoid jsonb DEFAULT NULL, 
  v_wintype jsonb DEFAULT NULL, 
  v_wincollid jsonb DEFAULT NULL, 
  v_inputcollid jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_aggfilter jsonb DEFAULT NULL, 
  v_winref jsonb DEFAULT NULL, 
  v_winstar boolean DEFAULT NULL, 
  v_winagg boolean DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"WindowFunc":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{WindowFunc, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{WindowFunc, winfnoid}', v_winfnoid);
  result = ast.jsonb_set(result, '{WindowFunc, wintype}', v_wintype);
  result = ast.jsonb_set(result, '{WindowFunc, wincollid}', v_wincollid);
  result = ast.jsonb_set(result, '{WindowFunc, inputcollid}', v_inputcollid);
  result = ast.jsonb_set(result, '{WindowFunc, args}', v_args);
  result = ast.jsonb_set(result, '{WindowFunc, aggfilter}', v_aggfilter);
  result = ast.jsonb_set(result, '{WindowFunc, winref}', v_winref);
  result = ast.jsonb_set(result, '{WindowFunc, winstar}', to_jsonb (v_winstar));
  result = ast.jsonb_set(result, '{WindowFunc, winagg}', to_jsonb (v_winagg));
  result = ast.jsonb_set(result, '{WindowFunc, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.subscripting_ref (
  v_xpr jsonb DEFAULT NULL, 
  v_refcontainertype jsonb DEFAULT NULL, 
  v_refelemtype jsonb DEFAULT NULL, 
  v_reftypmod int DEFAULT NULL, 
  v_refcollid jsonb DEFAULT NULL, 
  v_refupperindexpr jsonb DEFAULT NULL, 
  v_reflowerindexpr jsonb DEFAULT NULL, 
  v_refexpr jsonb DEFAULT NULL, 
  v_refassgnexpr jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"SubscriptingRef":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{SubscriptingRef, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{SubscriptingRef, refcontainertype}', v_refcontainertype);
  result = ast.jsonb_set(result, '{SubscriptingRef, refelemtype}', v_refelemtype);
  result = ast.jsonb_set(result, '{SubscriptingRef, reftypmod}', to_jsonb (v_reftypmod));
  result = ast.jsonb_set(result, '{SubscriptingRef, refcollid}', v_refcollid);
  result = ast.jsonb_set(result, '{SubscriptingRef, refupperindexpr}', v_refupperindexpr);
  result = ast.jsonb_set(result, '{SubscriptingRef, reflowerindexpr}', v_reflowerindexpr);
  result = ast.jsonb_set(result, '{SubscriptingRef, refexpr}', v_refexpr);
  result = ast.jsonb_set(result, '{SubscriptingRef, refassgnexpr}', v_refassgnexpr);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.func_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_funcid jsonb DEFAULT NULL, 
  v_funcresulttype jsonb DEFAULT NULL, 
  v_funcretset boolean DEFAULT NULL, 
  v_funcvariadic boolean DEFAULT NULL, 
  v_funcformat text DEFAULT NULL, 
  v_funccollid jsonb DEFAULT NULL, 
  v_inputcollid jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"FuncExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{FuncExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{FuncExpr, funcid}', v_funcid);
  result = ast.jsonb_set(result, '{FuncExpr, funcresulttype}', v_funcresulttype);
  result = ast.jsonb_set(result, '{FuncExpr, funcretset}', to_jsonb (v_funcretset));
  result = ast.jsonb_set(result, '{FuncExpr, funcvariadic}', to_jsonb (v_funcvariadic));
  result = ast.jsonb_set(result, '{FuncExpr, funcformat}', to_jsonb (v_funcformat));
  result = ast.jsonb_set(result, '{FuncExpr, funccollid}', v_funccollid);
  result = ast.jsonb_set(result, '{FuncExpr, inputcollid}', v_inputcollid);
  result = ast.jsonb_set(result, '{FuncExpr, args}', v_args);
  result = ast.jsonb_set(result, '{FuncExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.named_arg_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_argnumber int DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"NamedArgExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{NamedArgExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{NamedArgExpr, arg}', v_arg);
  result = ast.jsonb_set(result, '{NamedArgExpr, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{NamedArgExpr, argnumber}', to_jsonb (v_argnumber));
  result = ast.jsonb_set(result, '{NamedArgExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.op_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_opno jsonb DEFAULT NULL, 
  v_opfuncid jsonb DEFAULT NULL, 
  v_opresulttype jsonb DEFAULT NULL, 
  v_opretset boolean DEFAULT NULL, 
  v_opcollid jsonb DEFAULT NULL, 
  v_inputcollid jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"OpExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{OpExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{OpExpr, opno}', v_opno);
  result = ast.jsonb_set(result, '{OpExpr, opfuncid}', v_opfuncid);
  result = ast.jsonb_set(result, '{OpExpr, opresulttype}', v_opresulttype);
  result = ast.jsonb_set(result, '{OpExpr, opretset}', to_jsonb (v_opretset));
  result = ast.jsonb_set(result, '{OpExpr, opcollid}', v_opcollid);
  result = ast.jsonb_set(result, '{OpExpr, inputcollid}', v_inputcollid);
  result = ast.jsonb_set(result, '{OpExpr, args}', v_args);
  result = ast.jsonb_set(result, '{OpExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.scalar_array_op_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_opno jsonb DEFAULT NULL, 
  v_opfuncid jsonb DEFAULT NULL, 
  v_useOr boolean DEFAULT NULL, 
  v_inputcollid jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ScalarArrayOpExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ScalarArrayOpExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{ScalarArrayOpExpr, opno}', v_opno);
  result = ast.jsonb_set(result, '{ScalarArrayOpExpr, opfuncid}', v_opfuncid);
  result = ast.jsonb_set(result, '{ScalarArrayOpExpr, useOr}', to_jsonb (v_useOr));
  result = ast.jsonb_set(result, '{ScalarArrayOpExpr, inputcollid}', v_inputcollid);
  result = ast.jsonb_set(result, '{ScalarArrayOpExpr, args}', v_args);
  result = ast.jsonb_set(result, '{ScalarArrayOpExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.bool_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_boolop text DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"BoolExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{BoolExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{BoolExpr, boolop}', to_jsonb (v_boolop));
  result = ast.jsonb_set(result, '{BoolExpr, args}', v_args);
  result = ast.jsonb_set(result, '{BoolExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.sub_link (
  v_xpr jsonb DEFAULT NULL, 
  v_subLinkType text DEFAULT NULL, 
  v_subLinkId int DEFAULT NULL, 
  v_testexpr jsonb DEFAULT NULL, 
  v_operName jsonb DEFAULT NULL, 
  v_subselect jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"SubLink":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{SubLink, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{SubLink, subLinkType}', to_jsonb (v_subLinkType));
  result = ast.jsonb_set(result, '{SubLink, subLinkId}', to_jsonb (v_subLinkId));
  result = ast.jsonb_set(result, '{SubLink, testexpr}', v_testexpr);
  result = ast.jsonb_set(result, '{SubLink, operName}', v_operName);
  result = ast.jsonb_set(result, '{SubLink, subselect}', v_subselect);
  result = ast.jsonb_set(result, '{SubLink, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.sub_plan (
  v_xpr jsonb DEFAULT NULL, 
  v_subLinkType text DEFAULT NULL, 
  v_testexpr jsonb DEFAULT NULL, 
  v_paramIds jsonb DEFAULT NULL, 
  v_plan_id int DEFAULT NULL, 
  v_plan_name text DEFAULT NULL, 
  v_firstColType jsonb DEFAULT NULL, 
  v_firstColTypmod int DEFAULT NULL, 
  v_firstColCollation jsonb DEFAULT NULL, 
  v_useHashTable boolean DEFAULT NULL, 
  v_unknownEqFalse boolean DEFAULT NULL, 
  v_parallel_safe boolean DEFAULT NULL, 
  v_setParam jsonb DEFAULT NULL, 
  v_parParam jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_startup_cost jsonb DEFAULT NULL, 
  v_per_call_cost jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"SubPlan":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{SubPlan, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{SubPlan, subLinkType}', to_jsonb (v_subLinkType));
  result = ast.jsonb_set(result, '{SubPlan, testexpr}', v_testexpr);
  result = ast.jsonb_set(result, '{SubPlan, paramIds}', v_paramIds);
  result = ast.jsonb_set(result, '{SubPlan, plan_id}', to_jsonb (v_plan_id));
  result = ast.jsonb_set(result, '{SubPlan, plan_name}', to_jsonb (v_plan_name));
  result = ast.jsonb_set(result, '{SubPlan, firstColType}', v_firstColType);
  result = ast.jsonb_set(result, '{SubPlan, firstColTypmod}', to_jsonb (v_firstColTypmod));
  result = ast.jsonb_set(result, '{SubPlan, firstColCollation}', v_firstColCollation);
  result = ast.jsonb_set(result, '{SubPlan, useHashTable}', to_jsonb (v_useHashTable));
  result = ast.jsonb_set(result, '{SubPlan, unknownEqFalse}', to_jsonb (v_unknownEqFalse));
  result = ast.jsonb_set(result, '{SubPlan, parallel_safe}', to_jsonb (v_parallel_safe));
  result = ast.jsonb_set(result, '{SubPlan, setParam}', v_setParam);
  result = ast.jsonb_set(result, '{SubPlan, parParam}', v_parParam);
  result = ast.jsonb_set(result, '{SubPlan, args}', v_args);
  result = ast.jsonb_set(result, '{SubPlan, startup_cost}', v_startup_cost);
  result = ast.jsonb_set(result, '{SubPlan, per_call_cost}', v_per_call_cost);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alternative_sub_plan (
  v_xpr jsonb DEFAULT NULL, 
  v_subplans jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlternativeSubPlan":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlternativeSubPlan, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{AlternativeSubPlan, subplans}', v_subplans);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.field_select (
  v_xpr jsonb DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_fieldnum int DEFAULT NULL, 
  v_resulttype jsonb DEFAULT NULL, 
  v_resulttypmod int DEFAULT NULL, 
  v_resultcollid jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"FieldSelect":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{FieldSelect, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{FieldSelect, arg}', v_arg);
  result = ast.jsonb_set(result, '{FieldSelect, fieldnum}', to_jsonb (v_fieldnum));
  result = ast.jsonb_set(result, '{FieldSelect, resulttype}', v_resulttype);
  result = ast.jsonb_set(result, '{FieldSelect, resulttypmod}', to_jsonb (v_resulttypmod));
  result = ast.jsonb_set(result, '{FieldSelect, resultcollid}', v_resultcollid);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.field_store (
  v_xpr jsonb DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_newvals jsonb DEFAULT NULL, 
  v_fieldnums jsonb DEFAULT NULL, 
  v_resulttype jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"FieldStore":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{FieldStore, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{FieldStore, arg}', v_arg);
  result = ast.jsonb_set(result, '{FieldStore, newvals}', v_newvals);
  result = ast.jsonb_set(result, '{FieldStore, fieldnums}', v_fieldnums);
  result = ast.jsonb_set(result, '{FieldStore, resulttype}', v_resulttype);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.relabel_type (
  v_xpr jsonb DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_resulttype jsonb DEFAULT NULL, 
  v_resulttypmod int DEFAULT NULL, 
  v_resultcollid jsonb DEFAULT NULL, 
  v_relabelformat text DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RelabelType":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RelabelType, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{RelabelType, arg}', v_arg);
  result = ast.jsonb_set(result, '{RelabelType, resulttype}', v_resulttype);
  result = ast.jsonb_set(result, '{RelabelType, resulttypmod}', to_jsonb (v_resulttypmod));
  result = ast.jsonb_set(result, '{RelabelType, resultcollid}', v_resultcollid);
  result = ast.jsonb_set(result, '{RelabelType, relabelformat}', to_jsonb (v_relabelformat));
  result = ast.jsonb_set(result, '{RelabelType, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.coerce_via_io (
  v_xpr jsonb DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_resulttype jsonb DEFAULT NULL, 
  v_resultcollid jsonb DEFAULT NULL, 
  v_coerceformat text DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CoerceViaIO":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CoerceViaIO, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{CoerceViaIO, arg}', v_arg);
  result = ast.jsonb_set(result, '{CoerceViaIO, resulttype}', v_resulttype);
  result = ast.jsonb_set(result, '{CoerceViaIO, resultcollid}', v_resultcollid);
  result = ast.jsonb_set(result, '{CoerceViaIO, coerceformat}', to_jsonb (v_coerceformat));
  result = ast.jsonb_set(result, '{CoerceViaIO, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.array_coerce_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_elemexpr jsonb DEFAULT NULL, 
  v_resulttype jsonb DEFAULT NULL, 
  v_resulttypmod int DEFAULT NULL, 
  v_resultcollid jsonb DEFAULT NULL, 
  v_coerceformat text DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ArrayCoerceExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ArrayCoerceExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{ArrayCoerceExpr, arg}', v_arg);
  result = ast.jsonb_set(result, '{ArrayCoerceExpr, elemexpr}', v_elemexpr);
  result = ast.jsonb_set(result, '{ArrayCoerceExpr, resulttype}', v_resulttype);
  result = ast.jsonb_set(result, '{ArrayCoerceExpr, resulttypmod}', to_jsonb (v_resulttypmod));
  result = ast.jsonb_set(result, '{ArrayCoerceExpr, resultcollid}', v_resultcollid);
  result = ast.jsonb_set(result, '{ArrayCoerceExpr, coerceformat}', to_jsonb (v_coerceformat));
  result = ast.jsonb_set(result, '{ArrayCoerceExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.convert_rowtype_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_resulttype jsonb DEFAULT NULL, 
  v_convertformat text DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ConvertRowtypeExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ConvertRowtypeExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{ConvertRowtypeExpr, arg}', v_arg);
  result = ast.jsonb_set(result, '{ConvertRowtypeExpr, resulttype}', v_resulttype);
  result = ast.jsonb_set(result, '{ConvertRowtypeExpr, convertformat}', to_jsonb (v_convertformat));
  result = ast.jsonb_set(result, '{ConvertRowtypeExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.collate_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_collOid jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CollateExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CollateExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{CollateExpr, arg}', v_arg);
  result = ast.jsonb_set(result, '{CollateExpr, collOid}', v_collOid);
  result = ast.jsonb_set(result, '{CollateExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.case_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_casetype jsonb DEFAULT NULL, 
  v_casecollid jsonb DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_defresult jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CaseExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CaseExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{CaseExpr, casetype}', v_casetype);
  result = ast.jsonb_set(result, '{CaseExpr, casecollid}', v_casecollid);
  result = ast.jsonb_set(result, '{CaseExpr, arg}', v_arg);
  result = ast.jsonb_set(result, '{CaseExpr, args}', v_args);
  result = ast.jsonb_set(result, '{CaseExpr, defresult}', v_defresult);
  result = ast.jsonb_set(result, '{CaseExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.case_when (
  v_xpr jsonb DEFAULT NULL, 
  v_expr jsonb DEFAULT NULL, 
  v_result jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CaseWhen":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CaseWhen, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{CaseWhen, expr}', v_expr);
  result = ast.jsonb_set(result, '{CaseWhen, result}', v_result);
  result = ast.jsonb_set(result, '{CaseWhen, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.case_test_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_typeId jsonb DEFAULT NULL, 
  v_typeMod int DEFAULT NULL, 
  v_collation jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CaseTestExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CaseTestExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{CaseTestExpr, typeId}', v_typeId);
  result = ast.jsonb_set(result, '{CaseTestExpr, typeMod}', to_jsonb (v_typeMod));
  result = ast.jsonb_set(result, '{CaseTestExpr, collation}', v_collation);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.array_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_array_typeid jsonb DEFAULT NULL, 
  v_array_collid jsonb DEFAULT NULL, 
  v_element_typeid jsonb DEFAULT NULL, 
  v_elements jsonb DEFAULT NULL, 
  v_multidims boolean DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ArrayExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ArrayExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{ArrayExpr, array_typeid}', v_array_typeid);
  result = ast.jsonb_set(result, '{ArrayExpr, array_collid}', v_array_collid);
  result = ast.jsonb_set(result, '{ArrayExpr, element_typeid}', v_element_typeid);
  result = ast.jsonb_set(result, '{ArrayExpr, elements}', v_elements);
  result = ast.jsonb_set(result, '{ArrayExpr, multidims}', to_jsonb (v_multidims));
  result = ast.jsonb_set(result, '{ArrayExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.row_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_row_typeid jsonb DEFAULT NULL, 
  v_row_format text DEFAULT NULL, 
  v_colnames jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RowExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RowExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{RowExpr, args}', v_args);
  result = ast.jsonb_set(result, '{RowExpr, row_typeid}', v_row_typeid);
  result = ast.jsonb_set(result, '{RowExpr, row_format}', to_jsonb (v_row_format));
  result = ast.jsonb_set(result, '{RowExpr, colnames}', v_colnames);
  result = ast.jsonb_set(result, '{RowExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.row_compare_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_rctype text DEFAULT NULL, 
  v_opnos jsonb DEFAULT NULL, 
  v_opfamilies jsonb DEFAULT NULL, 
  v_inputcollids jsonb DEFAULT NULL, 
  v_largs jsonb DEFAULT NULL, 
  v_rargs jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RowCompareExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RowCompareExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{RowCompareExpr, rctype}', to_jsonb (v_rctype));
  result = ast.jsonb_set(result, '{RowCompareExpr, opnos}', v_opnos);
  result = ast.jsonb_set(result, '{RowCompareExpr, opfamilies}', v_opfamilies);
  result = ast.jsonb_set(result, '{RowCompareExpr, inputcollids}', v_inputcollids);
  result = ast.jsonb_set(result, '{RowCompareExpr, largs}', v_largs);
  result = ast.jsonb_set(result, '{RowCompareExpr, rargs}', v_rargs);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.coalesce_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_coalescetype jsonb DEFAULT NULL, 
  v_coalescecollid jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CoalesceExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CoalesceExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{CoalesceExpr, coalescetype}', v_coalescetype);
  result = ast.jsonb_set(result, '{CoalesceExpr, coalescecollid}', v_coalescecollid);
  result = ast.jsonb_set(result, '{CoalesceExpr, args}', v_args);
  result = ast.jsonb_set(result, '{CoalesceExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.min_max_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_minmaxtype jsonb DEFAULT NULL, 
  v_minmaxcollid jsonb DEFAULT NULL, 
  v_inputcollid jsonb DEFAULT NULL, 
  v_op text DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"MinMaxExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{MinMaxExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{MinMaxExpr, minmaxtype}', v_minmaxtype);
  result = ast.jsonb_set(result, '{MinMaxExpr, minmaxcollid}', v_minmaxcollid);
  result = ast.jsonb_set(result, '{MinMaxExpr, inputcollid}', v_inputcollid);
  result = ast.jsonb_set(result, '{MinMaxExpr, op}', to_jsonb (v_op));
  result = ast.jsonb_set(result, '{MinMaxExpr, args}', v_args);
  result = ast.jsonb_set(result, '{MinMaxExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.sql_value_function (
  v_xpr jsonb DEFAULT NULL, 
  v_op text DEFAULT NULL, 
  v_type jsonb DEFAULT NULL, 
  v_typmod int DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"SQLValueFunction":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{SQLValueFunction, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{SQLValueFunction, op}', to_jsonb (v_op));
  result = ast.jsonb_set(result, '{SQLValueFunction, type}', v_type);
  result = ast.jsonb_set(result, '{SQLValueFunction, typmod}', to_jsonb (v_typmod));
  result = ast.jsonb_set(result, '{SQLValueFunction, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.xml_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_op text DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_named_args jsonb DEFAULT NULL, 
  v_arg_names jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_xmloption text DEFAULT NULL, 
  v_type jsonb DEFAULT NULL, 
  v_typmod int DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"XmlExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{XmlExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{XmlExpr, op}', to_jsonb (v_op));
  result = ast.jsonb_set(result, '{XmlExpr, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{XmlExpr, named_args}', v_named_args);
  result = ast.jsonb_set(result, '{XmlExpr, arg_names}', v_arg_names);
  result = ast.jsonb_set(result, '{XmlExpr, args}', v_args);
  result = ast.jsonb_set(result, '{XmlExpr, xmloption}', to_jsonb (v_xmloption));
  result = ast.jsonb_set(result, '{XmlExpr, type}', v_type);
  result = ast.jsonb_set(result, '{XmlExpr, typmod}', to_jsonb (v_typmod));
  result = ast.jsonb_set(result, '{XmlExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.null_test (
  v_xpr jsonb DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_nulltesttype text DEFAULT NULL, 
  v_argisrow boolean DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"NullTest":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{NullTest, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{NullTest, arg}', v_arg);
  result = ast.jsonb_set(result, '{NullTest, nulltesttype}', to_jsonb (v_nulltesttype));
  result = ast.jsonb_set(result, '{NullTest, argisrow}', to_jsonb (v_argisrow));
  result = ast.jsonb_set(result, '{NullTest, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.boolean_test (
  v_xpr jsonb DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_booltesttype text DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"BooleanTest":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{BooleanTest, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{BooleanTest, arg}', v_arg);
  result = ast.jsonb_set(result, '{BooleanTest, booltesttype}', to_jsonb (v_booltesttype));
  result = ast.jsonb_set(result, '{BooleanTest, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.coerce_to_domain (
  v_xpr jsonb DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_resulttype jsonb DEFAULT NULL, 
  v_resulttypmod int DEFAULT NULL, 
  v_resultcollid jsonb DEFAULT NULL, 
  v_coercionformat text DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CoerceToDomain":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CoerceToDomain, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{CoerceToDomain, arg}', v_arg);
  result = ast.jsonb_set(result, '{CoerceToDomain, resulttype}', v_resulttype);
  result = ast.jsonb_set(result, '{CoerceToDomain, resulttypmod}', to_jsonb (v_resulttypmod));
  result = ast.jsonb_set(result, '{CoerceToDomain, resultcollid}', v_resultcollid);
  result = ast.jsonb_set(result, '{CoerceToDomain, coercionformat}', to_jsonb (v_coercionformat));
  result = ast.jsonb_set(result, '{CoerceToDomain, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.coerce_to_domain_value (
  v_xpr jsonb DEFAULT NULL, 
  v_typeId jsonb DEFAULT NULL, 
  v_typeMod int DEFAULT NULL, 
  v_collation jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CoerceToDomainValue":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CoerceToDomainValue, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{CoerceToDomainValue, typeId}', v_typeId);
  result = ast.jsonb_set(result, '{CoerceToDomainValue, typeMod}', to_jsonb (v_typeMod));
  result = ast.jsonb_set(result, '{CoerceToDomainValue, collation}', v_collation);
  result = ast.jsonb_set(result, '{CoerceToDomainValue, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.set_to_default (
  v_xpr jsonb DEFAULT NULL, 
  v_typeId jsonb DEFAULT NULL, 
  v_typeMod int DEFAULT NULL, 
  v_collation jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"SetToDefault":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{SetToDefault, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{SetToDefault, typeId}', v_typeId);
  result = ast.jsonb_set(result, '{SetToDefault, typeMod}', to_jsonb (v_typeMod));
  result = ast.jsonb_set(result, '{SetToDefault, collation}', v_collation);
  result = ast.jsonb_set(result, '{SetToDefault, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.current_of_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_cvarno jsonb DEFAULT NULL, 
  v_cursor_name text DEFAULT NULL, 
  v_cursor_param int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CurrentOfExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CurrentOfExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{CurrentOfExpr, cvarno}', v_cvarno);
  result = ast.jsonb_set(result, '{CurrentOfExpr, cursor_name}', to_jsonb (v_cursor_name));
  result = ast.jsonb_set(result, '{CurrentOfExpr, cursor_param}', to_jsonb (v_cursor_param));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.next_value_expr (
  v_xpr jsonb DEFAULT NULL, 
  v_seqid jsonb DEFAULT NULL, 
  v_typeId jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"NextValueExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{NextValueExpr, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{NextValueExpr, seqid}', v_seqid);
  result = ast.jsonb_set(result, '{NextValueExpr, typeId}', v_typeId);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.inference_elem (
  v_xpr jsonb DEFAULT NULL, 
  v_expr jsonb DEFAULT NULL, 
  v_infercollid jsonb DEFAULT NULL, 
  v_inferopclass jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"InferenceElem":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{InferenceElem, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{InferenceElem, expr}', v_expr);
  result = ast.jsonb_set(result, '{InferenceElem, infercollid}', v_infercollid);
  result = ast.jsonb_set(result, '{InferenceElem, inferopclass}', v_inferopclass);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.target_entry (
  v_xpr jsonb DEFAULT NULL, 
  v_expr jsonb DEFAULT NULL, 
  v_resno int DEFAULT NULL, 
  v_resname text DEFAULT NULL, 
  v_ressortgroupref jsonb DEFAULT NULL, 
  v_resorigtbl jsonb DEFAULT NULL, 
  v_resorigcol int DEFAULT NULL, 
  v_resjunk boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"TargetEntry":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{TargetEntry, xpr}', v_xpr);
  result = ast.jsonb_set(result, '{TargetEntry, expr}', v_expr);
  result = ast.jsonb_set(result, '{TargetEntry, resno}', to_jsonb (v_resno));
  result = ast.jsonb_set(result, '{TargetEntry, resname}', to_jsonb (v_resname));
  result = ast.jsonb_set(result, '{TargetEntry, ressortgroupref}', v_ressortgroupref);
  result = ast.jsonb_set(result, '{TargetEntry, resorigtbl}', v_resorigtbl);
  result = ast.jsonb_set(result, '{TargetEntry, resorigcol}', to_jsonb (v_resorigcol));
  result = ast.jsonb_set(result, '{TargetEntry, resjunk}', to_jsonb (v_resjunk));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.range_tbl_ref (
  v_type text DEFAULT NULL, 
  v_rtindex int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RangeTblRef":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RangeTblRef, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RangeTblRef, rtindex}', to_jsonb (v_rtindex));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.join_expr (
  v_type text DEFAULT NULL, 
  v_jointype text DEFAULT NULL, 
  v_isNatural boolean DEFAULT NULL, 
  v_larg jsonb DEFAULT NULL, 
  v_rarg jsonb DEFAULT NULL, 
  v_usingClause jsonb DEFAULT NULL, 
  v_quals jsonb DEFAULT NULL, 
  v_alias jsonb DEFAULT NULL, 
  v_rtindex int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"JoinExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{JoinExpr, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{JoinExpr, jointype}', to_jsonb (v_jointype));
  result = ast.jsonb_set(result, '{JoinExpr, isNatural}', to_jsonb (v_isNatural));
  result = ast.jsonb_set(result, '{JoinExpr, larg}', v_larg);
  result = ast.jsonb_set(result, '{JoinExpr, rarg}', v_rarg);
  result = ast.jsonb_set(result, '{JoinExpr, usingClause}', v_usingClause);
  result = ast.jsonb_set(result, '{JoinExpr, quals}', v_quals);
  result = ast.jsonb_set(result, '{JoinExpr, alias}', v_alias);
  result = ast.jsonb_set(result, '{JoinExpr, rtindex}', to_jsonb (v_rtindex));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.from_expr (
  v_type text DEFAULT NULL, 
  v_fromlist jsonb DEFAULT NULL, 
  v_quals jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"FromExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{FromExpr, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{FromExpr, fromlist}', v_fromlist);
  result = ast.jsonb_set(result, '{FromExpr, quals}', v_quals);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.on_conflict_expr (
  v_type text DEFAULT NULL, 
  v_action text DEFAULT NULL, 
  v_arbiterElems jsonb DEFAULT NULL, 
  v_arbiterWhere jsonb DEFAULT NULL, 
  v_constraint jsonb DEFAULT NULL, 
  v_onConflictSet jsonb DEFAULT NULL, 
  v_onConflictWhere jsonb DEFAULT NULL, 
  v_exclRelIndex int DEFAULT NULL, 
  v_exclRelTlist jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"OnConflictExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{OnConflictExpr, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{OnConflictExpr, action}', to_jsonb (v_action));
  result = ast.jsonb_set(result, '{OnConflictExpr, arbiterElems}', v_arbiterElems);
  result = ast.jsonb_set(result, '{OnConflictExpr, arbiterWhere}', v_arbiterWhere);
  result = ast.jsonb_set(result, '{OnConflictExpr, constraint}', v_constraint);
  result = ast.jsonb_set(result, '{OnConflictExpr, onConflictSet}', v_onConflictSet);
  result = ast.jsonb_set(result, '{OnConflictExpr, onConflictWhere}', v_onConflictWhere);
  result = ast.jsonb_set(result, '{OnConflictExpr, exclRelIndex}', to_jsonb (v_exclRelIndex));
  result = ast.jsonb_set(result, '{OnConflictExpr, exclRelTlist}', v_exclRelTlist);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.query (
  v_type text DEFAULT NULL, 
  v_commandType text DEFAULT NULL, 
  v_querySource text DEFAULT NULL, 
  v_queryId int DEFAULT NULL, 
  v_canSetTag boolean DEFAULT NULL, 
  v_utilityStmt jsonb DEFAULT NULL, 
  v_resultRelation int DEFAULT NULL, 
  v_hasAggs boolean DEFAULT NULL, 
  v_hasWindowFuncs boolean DEFAULT NULL, 
  v_hasTargetSRFs boolean DEFAULT NULL, 
  v_hasSubLinks boolean DEFAULT NULL, 
  v_hasDistinctOn boolean DEFAULT NULL, 
  v_hasRecursive boolean DEFAULT NULL, 
  v_hasModifyingCTE boolean DEFAULT NULL, 
  v_hasForUpdate boolean DEFAULT NULL, 
  v_hasRowSecurity boolean DEFAULT NULL, 
  v_cteList jsonb DEFAULT NULL, 
  v_rtable jsonb DEFAULT NULL, 
  v_jointree jsonb DEFAULT NULL, 
  v_targetList jsonb DEFAULT NULL, 
  v_override text DEFAULT NULL, 
  v_onConflict jsonb DEFAULT NULL, 
  v_returningList jsonb DEFAULT NULL, 
  v_groupClause jsonb DEFAULT NULL, 
  v_groupingSets jsonb DEFAULT NULL, 
  v_havingQual jsonb DEFAULT NULL, 
  v_windowClause jsonb DEFAULT NULL, 
  v_distinctClause jsonb DEFAULT NULL, 
  v_sortClause jsonb DEFAULT NULL, 
  v_limitOffset jsonb DEFAULT NULL, 
  v_limitCount jsonb DEFAULT NULL, 
  v_limitOption text DEFAULT NULL, 
  v_rowMarks jsonb DEFAULT NULL, 
  v_setOperations jsonb DEFAULT NULL, 
  v_constraintDeps jsonb DEFAULT NULL, 
  v_withCheckOptions jsonb DEFAULT NULL, 
  v_stmt_location int DEFAULT NULL, 
  v_stmt_len int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"Query":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{Query, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{Query, commandType}', to_jsonb (v_commandType));
  result = ast.jsonb_set(result, '{Query, querySource}', to_jsonb (v_querySource));
  result = ast.jsonb_set(result, '{Query, queryId}', to_jsonb (v_queryId));
  result = ast.jsonb_set(result, '{Query, canSetTag}', to_jsonb (v_canSetTag));
  result = ast.jsonb_set(result, '{Query, utilityStmt}', v_utilityStmt);
  result = ast.jsonb_set(result, '{Query, resultRelation}', to_jsonb (v_resultRelation));
  result = ast.jsonb_set(result, '{Query, hasAggs}', to_jsonb (v_hasAggs));
  result = ast.jsonb_set(result, '{Query, hasWindowFuncs}', to_jsonb (v_hasWindowFuncs));
  result = ast.jsonb_set(result, '{Query, hasTargetSRFs}', to_jsonb (v_hasTargetSRFs));
  result = ast.jsonb_set(result, '{Query, hasSubLinks}', to_jsonb (v_hasSubLinks));
  result = ast.jsonb_set(result, '{Query, hasDistinctOn}', to_jsonb (v_hasDistinctOn));
  result = ast.jsonb_set(result, '{Query, hasRecursive}', to_jsonb (v_hasRecursive));
  result = ast.jsonb_set(result, '{Query, hasModifyingCTE}', to_jsonb (v_hasModifyingCTE));
  result = ast.jsonb_set(result, '{Query, hasForUpdate}', to_jsonb (v_hasForUpdate));
  result = ast.jsonb_set(result, '{Query, hasRowSecurity}', to_jsonb (v_hasRowSecurity));
  result = ast.jsonb_set(result, '{Query, cteList}', v_cteList);
  result = ast.jsonb_set(result, '{Query, rtable}', v_rtable);
  result = ast.jsonb_set(result, '{Query, jointree}', v_jointree);
  result = ast.jsonb_set(result, '{Query, targetList}', v_targetList);
  result = ast.jsonb_set(result, '{Query, override}', to_jsonb (v_override));
  result = ast.jsonb_set(result, '{Query, onConflict}', v_onConflict);
  result = ast.jsonb_set(result, '{Query, returningList}', v_returningList);
  result = ast.jsonb_set(result, '{Query, groupClause}', v_groupClause);
  result = ast.jsonb_set(result, '{Query, groupingSets}', v_groupingSets);
  result = ast.jsonb_set(result, '{Query, havingQual}', v_havingQual);
  result = ast.jsonb_set(result, '{Query, windowClause}', v_windowClause);
  result = ast.jsonb_set(result, '{Query, distinctClause}', v_distinctClause);
  result = ast.jsonb_set(result, '{Query, sortClause}', v_sortClause);
  result = ast.jsonb_set(result, '{Query, limitOffset}', v_limitOffset);
  result = ast.jsonb_set(result, '{Query, limitCount}', v_limitCount);
  result = ast.jsonb_set(result, '{Query, limitOption}', to_jsonb (v_limitOption));
  result = ast.jsonb_set(result, '{Query, rowMarks}', v_rowMarks);
  result = ast.jsonb_set(result, '{Query, setOperations}', v_setOperations);
  result = ast.jsonb_set(result, '{Query, constraintDeps}', v_constraintDeps);
  result = ast.jsonb_set(result, '{Query, withCheckOptions}', v_withCheckOptions);
  result = ast.jsonb_set(result, '{Query, stmt_location}', to_jsonb (v_stmt_location));
  result = ast.jsonb_set(result, '{Query, stmt_len}', to_jsonb (v_stmt_len));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.type_name (
  v_type text DEFAULT NULL, 
  v_names jsonb DEFAULT NULL, 
  v_typeOid jsonb DEFAULT NULL, 
  v_setof boolean DEFAULT NULL, 
  v_pct_type boolean DEFAULT NULL, 
  v_typmods jsonb DEFAULT NULL, 
  v_typemod int DEFAULT NULL, 
  v_arrayBounds jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"TypeName":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{TypeName, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{TypeName, names}', v_names);
  result = ast.jsonb_set(result, '{TypeName, typeOid}', v_typeOid);
  result = ast.jsonb_set(result, '{TypeName, setof}', to_jsonb (v_setof));
  result = ast.jsonb_set(result, '{TypeName, pct_type}', to_jsonb (v_pct_type));
  result = ast.jsonb_set(result, '{TypeName, typmods}', v_typmods);
  result = ast.jsonb_set(result, '{TypeName, typemod}', to_jsonb (v_typemod));
  result = ast.jsonb_set(result, '{TypeName, arrayBounds}', v_arrayBounds);
  result = ast.jsonb_set(result, '{TypeName, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.column_ref (
  v_type text DEFAULT NULL, 
  v_fields jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ColumnRef":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ColumnRef, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ColumnRef, fields}', v_fields);
  result = ast.jsonb_set(result, '{ColumnRef, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.param_ref (
  v_type text DEFAULT NULL, 
  v_number int DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ParamRef":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ParamRef, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ParamRef, number}', to_jsonb (v_number));
  result = ast.jsonb_set(result, '{ParamRef, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.a_expr (
  v_type text DEFAULT NULL, 
  v_kind text DEFAULT NULL, 
  v_name jsonb DEFAULT NULL, 
  v_lexpr jsonb DEFAULT NULL, 
  v_rexpr jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"A_Expr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{A_Expr, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{A_Expr, kind}', to_jsonb (v_kind));
  result = ast.jsonb_set(result, '{A_Expr, name}', v_name);
  result = ast.jsonb_set(result, '{A_Expr, lexpr}', v_lexpr);
  result = ast.jsonb_set(result, '{A_Expr, rexpr}', v_rexpr);
  result = ast.jsonb_set(result, '{A_Expr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.a_const (
  v_type text DEFAULT NULL, 
  v_val jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"A_Const":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{A_Const, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{A_Const, val}', v_val);
  result = ast.jsonb_set(result, '{A_Const, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.type_cast (
  v_type text DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_typeName jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"TypeCast":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{TypeCast, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{TypeCast, arg}', v_arg);
  result = ast.jsonb_set(result, '{TypeCast, typeName}', v_typeName);
  result = ast.jsonb_set(result, '{TypeCast, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.collate_clause (
  v_type text DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_collname jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CollateClause":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CollateClause, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CollateClause, arg}', v_arg);
  result = ast.jsonb_set(result, '{CollateClause, collname}', v_collname);
  result = ast.jsonb_set(result, '{CollateClause, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.role_spec (
  v_type text DEFAULT NULL, 
  v_roletype text DEFAULT NULL, 
  v_rolename text DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RoleSpec":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RoleSpec, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RoleSpec, roletype}', to_jsonb (v_roletype));
  result = ast.jsonb_set(result, '{RoleSpec, rolename}', to_jsonb (v_rolename));
  result = ast.jsonb_set(result, '{RoleSpec, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.func_call (
  v_type text DEFAULT NULL, 
  v_funcname jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_agg_order jsonb DEFAULT NULL, 
  v_agg_filter jsonb DEFAULT NULL, 
  v_agg_within_group boolean DEFAULT NULL, 
  v_agg_star boolean DEFAULT NULL, 
  v_agg_distinct boolean DEFAULT NULL, 
  v_func_variadic boolean DEFAULT NULL, 
  v_over jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"FuncCall":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{FuncCall, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{FuncCall, funcname}', v_funcname);
  result = ast.jsonb_set(result, '{FuncCall, args}', v_args);
  result = ast.jsonb_set(result, '{FuncCall, agg_order}', v_agg_order);
  result = ast.jsonb_set(result, '{FuncCall, agg_filter}', v_agg_filter);
  result = ast.jsonb_set(result, '{FuncCall, agg_within_group}', to_jsonb (v_agg_within_group));
  result = ast.jsonb_set(result, '{FuncCall, agg_star}', to_jsonb (v_agg_star));
  result = ast.jsonb_set(result, '{FuncCall, agg_distinct}', to_jsonb (v_agg_distinct));
  result = ast.jsonb_set(result, '{FuncCall, func_variadic}', to_jsonb (v_func_variadic));
  result = ast.jsonb_set(result, '{FuncCall, over}', v_over);
  result = ast.jsonb_set(result, '{FuncCall, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.a_star (
  v_type text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"A_Star":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{A_Star, type}', to_jsonb (v_type));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.a_indices (
  v_type text DEFAULT NULL, 
  v_is_slice boolean DEFAULT NULL, 
  v_lidx jsonb DEFAULT NULL, 
  v_uidx jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"A_Indices":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{A_Indices, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{A_Indices, is_slice}', to_jsonb (v_is_slice));
  result = ast.jsonb_set(result, '{A_Indices, lidx}', v_lidx);
  result = ast.jsonb_set(result, '{A_Indices, uidx}', v_uidx);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.a_indirection (
  v_type text DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_indirection jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"A_Indirection":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{A_Indirection, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{A_Indirection, arg}', v_arg);
  result = ast.jsonb_set(result, '{A_Indirection, indirection}', v_indirection);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.a_array_expr (
  v_type text DEFAULT NULL, 
  v_elements jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"A_ArrayExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{A_ArrayExpr, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{A_ArrayExpr, elements}', v_elements);
  result = ast.jsonb_set(result, '{A_ArrayExpr, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.res_target (
  v_type text DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_indirection jsonb DEFAULT NULL, 
  v_val jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ResTarget":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ResTarget, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ResTarget, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{ResTarget, indirection}', v_indirection);
  result = ast.jsonb_set(result, '{ResTarget, val}', v_val);
  result = ast.jsonb_set(result, '{ResTarget, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.multi_assign_ref (
  v_type text DEFAULT NULL, 
  v_source jsonb DEFAULT NULL, 
  v_colno int DEFAULT NULL, 
  v_ncolumns int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"MultiAssignRef":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{MultiAssignRef, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{MultiAssignRef, source}', v_source);
  result = ast.jsonb_set(result, '{MultiAssignRef, colno}', to_jsonb (v_colno));
  result = ast.jsonb_set(result, '{MultiAssignRef, ncolumns}', to_jsonb (v_ncolumns));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.sort_by (
  v_type text DEFAULT NULL, 
  v_node jsonb DEFAULT NULL, 
  v_sortby_dir text DEFAULT NULL, 
  v_sortby_nulls text DEFAULT NULL, 
  v_useOp jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"SortBy":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{SortBy, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{SortBy, node}', v_node);
  result = ast.jsonb_set(result, '{SortBy, sortby_dir}', to_jsonb (v_sortby_dir));
  result = ast.jsonb_set(result, '{SortBy, sortby_nulls}', to_jsonb (v_sortby_nulls));
  result = ast.jsonb_set(result, '{SortBy, useOp}', v_useOp);
  result = ast.jsonb_set(result, '{SortBy, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.window_def (
  v_type text DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_refname text DEFAULT NULL, 
  v_partitionClause jsonb DEFAULT NULL, 
  v_orderClause jsonb DEFAULT NULL, 
  v_frameOptions int DEFAULT NULL, 
  v_startOffset jsonb DEFAULT NULL, 
  v_endOffset jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"WindowDef":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{WindowDef, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{WindowDef, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{WindowDef, refname}', to_jsonb (v_refname));
  result = ast.jsonb_set(result, '{WindowDef, partitionClause}', v_partitionClause);
  result = ast.jsonb_set(result, '{WindowDef, orderClause}', v_orderClause);
  result = ast.jsonb_set(result, '{WindowDef, frameOptions}', to_jsonb (v_frameOptions));
  result = ast.jsonb_set(result, '{WindowDef, startOffset}', v_startOffset);
  result = ast.jsonb_set(result, '{WindowDef, endOffset}', v_endOffset);
  result = ast.jsonb_set(result, '{WindowDef, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.range_subselect (
  v_type text DEFAULT NULL, 
  v_lateral boolean DEFAULT NULL, 
  v_subquery jsonb DEFAULT NULL, 
  v_alias jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RangeSubselect":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RangeSubselect, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RangeSubselect, lateral}', to_jsonb (v_lateral));
  result = ast.jsonb_set(result, '{RangeSubselect, subquery}', v_subquery);
  result = ast.jsonb_set(result, '{RangeSubselect, alias}', v_alias);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.range_function (
  v_type text DEFAULT NULL, 
  v_lateral boolean DEFAULT NULL, 
  v_ordinality boolean DEFAULT NULL, 
  v_is_rowsfrom boolean DEFAULT NULL, 
  v_functions jsonb DEFAULT NULL, 
  v_alias jsonb DEFAULT NULL, 
  v_coldeflist jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RangeFunction":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RangeFunction, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RangeFunction, lateral}', to_jsonb (v_lateral));
  result = ast.jsonb_set(result, '{RangeFunction, ordinality}', to_jsonb (v_ordinality));
  result = ast.jsonb_set(result, '{RangeFunction, is_rowsfrom}', to_jsonb (v_is_rowsfrom));
  result = ast.jsonb_set(result, '{RangeFunction, functions}', v_functions);
  result = ast.jsonb_set(result, '{RangeFunction, alias}', v_alias);
  result = ast.jsonb_set(result, '{RangeFunction, coldeflist}', v_coldeflist);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.range_table_func (
  v_type text DEFAULT NULL, 
  v_lateral boolean DEFAULT NULL, 
  v_docexpr jsonb DEFAULT NULL, 
  v_rowexpr jsonb DEFAULT NULL, 
  v_namespaces jsonb DEFAULT NULL, 
  v_columns jsonb DEFAULT NULL, 
  v_alias jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RangeTableFunc":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RangeTableFunc, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RangeTableFunc, lateral}', to_jsonb (v_lateral));
  result = ast.jsonb_set(result, '{RangeTableFunc, docexpr}', v_docexpr);
  result = ast.jsonb_set(result, '{RangeTableFunc, rowexpr}', v_rowexpr);
  result = ast.jsonb_set(result, '{RangeTableFunc, namespaces}', v_namespaces);
  result = ast.jsonb_set(result, '{RangeTableFunc, columns}', v_columns);
  result = ast.jsonb_set(result, '{RangeTableFunc, alias}', v_alias);
  result = ast.jsonb_set(result, '{RangeTableFunc, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.range_table_func_col (
  v_type text DEFAULT NULL, 
  v_colname text DEFAULT NULL, 
  v_typeName jsonb DEFAULT NULL, 
  v_for_ordinality boolean DEFAULT NULL, 
  v_is_not_null boolean DEFAULT NULL, 
  v_colexpr jsonb DEFAULT NULL, 
  v_coldefexpr jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RangeTableFuncCol":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RangeTableFuncCol, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RangeTableFuncCol, colname}', to_jsonb (v_colname));
  result = ast.jsonb_set(result, '{RangeTableFuncCol, typeName}', v_typeName);
  result = ast.jsonb_set(result, '{RangeTableFuncCol, for_ordinality}', to_jsonb (v_for_ordinality));
  result = ast.jsonb_set(result, '{RangeTableFuncCol, is_not_null}', to_jsonb (v_is_not_null));
  result = ast.jsonb_set(result, '{RangeTableFuncCol, colexpr}', v_colexpr);
  result = ast.jsonb_set(result, '{RangeTableFuncCol, coldefexpr}', v_coldefexpr);
  result = ast.jsonb_set(result, '{RangeTableFuncCol, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.range_table_sample (
  v_type text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_method jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_repeatable jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RangeTableSample":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RangeTableSample, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RangeTableSample, relation}', v_relation);
  result = ast.jsonb_set(result, '{RangeTableSample, method}', v_method);
  result = ast.jsonb_set(result, '{RangeTableSample, args}', v_args);
  result = ast.jsonb_set(result, '{RangeTableSample, repeatable}', v_repeatable);
  result = ast.jsonb_set(result, '{RangeTableSample, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.column_def (
  v_type text DEFAULT NULL, 
  v_colname text DEFAULT NULL, 
  v_typeName jsonb DEFAULT NULL, 
  v_inhcount int DEFAULT NULL, 
  v_is_local boolean DEFAULT NULL, 
  v_is_not_null boolean DEFAULT NULL, 
  v_is_from_type boolean DEFAULT NULL, 
  v_storage text DEFAULT NULL, 
  v_raw_default jsonb DEFAULT NULL, 
  v_cooked_default jsonb DEFAULT NULL, 
  v_identity text DEFAULT NULL, 
  v_identitySequence jsonb DEFAULT NULL, 
  v_generated text DEFAULT NULL, 
  v_collClause jsonb DEFAULT NULL, 
  v_collOid jsonb DEFAULT NULL, 
  v_constraints jsonb DEFAULT NULL, 
  v_fdwoptions jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ColumnDef":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ColumnDef, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ColumnDef, colname}', to_jsonb (v_colname));
  result = ast.jsonb_set(result, '{ColumnDef, typeName}', v_typeName);
  result = ast.jsonb_set(result, '{ColumnDef, inhcount}', to_jsonb (v_inhcount));
  result = ast.jsonb_set(result, '{ColumnDef, is_local}', to_jsonb (v_is_local));
  result = ast.jsonb_set(result, '{ColumnDef, is_not_null}', to_jsonb (v_is_not_null));
  result = ast.jsonb_set(result, '{ColumnDef, is_from_type}', to_jsonb (v_is_from_type));
  result = ast.jsonb_set(result, '{ColumnDef, storage}', to_jsonb (v_storage));
  result = ast.jsonb_set(result, '{ColumnDef, raw_default}', v_raw_default);
  result = ast.jsonb_set(result, '{ColumnDef, cooked_default}', v_cooked_default);
  result = ast.jsonb_set(result, '{ColumnDef, identity}', to_jsonb (v_identity));
  result = ast.jsonb_set(result, '{ColumnDef, identitySequence}', v_identitySequence);
  result = ast.jsonb_set(result, '{ColumnDef, generated}', to_jsonb (v_generated));
  result = ast.jsonb_set(result, '{ColumnDef, collClause}', v_collClause);
  result = ast.jsonb_set(result, '{ColumnDef, collOid}', v_collOid);
  result = ast.jsonb_set(result, '{ColumnDef, constraints}', v_constraints);
  result = ast.jsonb_set(result, '{ColumnDef, fdwoptions}', v_fdwoptions);
  result = ast.jsonb_set(result, '{ColumnDef, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.table_like_clause (
  v_type text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"TableLikeClause":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{TableLikeClause, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{TableLikeClause, relation}', v_relation);
  result = ast.jsonb_set(result, '{TableLikeClause, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.index_elem (
  v_type text DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_expr jsonb DEFAULT NULL, 
  v_indexcolname text DEFAULT NULL, 
  v_collation jsonb DEFAULT NULL, 
  v_opclass jsonb DEFAULT NULL, 
  v_opclassopts jsonb DEFAULT NULL, 
  v_ordering text DEFAULT NULL, 
  v_nulls_ordering text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"IndexElem":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{IndexElem, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{IndexElem, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{IndexElem, expr}', v_expr);
  result = ast.jsonb_set(result, '{IndexElem, indexcolname}', to_jsonb (v_indexcolname));
  result = ast.jsonb_set(result, '{IndexElem, collation}', v_collation);
  result = ast.jsonb_set(result, '{IndexElem, opclass}', v_opclass);
  result = ast.jsonb_set(result, '{IndexElem, opclassopts}', v_opclassopts);
  result = ast.jsonb_set(result, '{IndexElem, ordering}', to_jsonb (v_ordering));
  result = ast.jsonb_set(result, '{IndexElem, nulls_ordering}', to_jsonb (v_nulls_ordering));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.def_elem (
  v_type text DEFAULT NULL, 
  v_defnamespace text DEFAULT NULL, 
  v_defname text DEFAULT NULL, 
  v_arg jsonb DEFAULT NULL, 
  v_defaction text DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"DefElem":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{DefElem, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{DefElem, defnamespace}', to_jsonb (v_defnamespace));
  result = ast.jsonb_set(result, '{DefElem, defname}', to_jsonb (v_defname));
  result = ast.jsonb_set(result, '{DefElem, arg}', v_arg);
  result = ast.jsonb_set(result, '{DefElem, defaction}', to_jsonb (v_defaction));
  result = ast.jsonb_set(result, '{DefElem, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.locking_clause (
  v_type text DEFAULT NULL, 
  v_lockedRels jsonb DEFAULT NULL, 
  v_strength text DEFAULT NULL, 
  v_waitPolicy text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"LockingClause":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{LockingClause, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{LockingClause, lockedRels}', v_lockedRels);
  result = ast.jsonb_set(result, '{LockingClause, strength}', to_jsonb (v_strength));
  result = ast.jsonb_set(result, '{LockingClause, waitPolicy}', to_jsonb (v_waitPolicy));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.xml_serialize (
  v_type text DEFAULT NULL, 
  v_xmloption text DEFAULT NULL, 
  v_expr jsonb DEFAULT NULL, 
  v_typeName jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"XmlSerialize":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{XmlSerialize, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{XmlSerialize, xmloption}', to_jsonb (v_xmloption));
  result = ast.jsonb_set(result, '{XmlSerialize, expr}', v_expr);
  result = ast.jsonb_set(result, '{XmlSerialize, typeName}', v_typeName);
  result = ast.jsonb_set(result, '{XmlSerialize, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.partition_elem (
  v_type text DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_expr jsonb DEFAULT NULL, 
  v_collation jsonb DEFAULT NULL, 
  v_opclass jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"PartitionElem":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{PartitionElem, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{PartitionElem, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{PartitionElem, expr}', v_expr);
  result = ast.jsonb_set(result, '{PartitionElem, collation}', v_collation);
  result = ast.jsonb_set(result, '{PartitionElem, opclass}', v_opclass);
  result = ast.jsonb_set(result, '{PartitionElem, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.partition_spec (
  v_type text DEFAULT NULL, 
  v_strategy text DEFAULT NULL, 
  v_partParams jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"PartitionSpec":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{PartitionSpec, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{PartitionSpec, strategy}', to_jsonb (v_strategy));
  result = ast.jsonb_set(result, '{PartitionSpec, partParams}', v_partParams);
  result = ast.jsonb_set(result, '{PartitionSpec, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.partition_bound_spec (
  v_type text DEFAULT NULL, 
  v_strategy text DEFAULT NULL, 
  v_is_default boolean DEFAULT NULL, 
  v_modulus int DEFAULT NULL, 
  v_remainder int DEFAULT NULL, 
  v_listdatums jsonb DEFAULT NULL, 
  v_lowerdatums jsonb DEFAULT NULL, 
  v_upperdatums jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"PartitionBoundSpec":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{PartitionBoundSpec, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{PartitionBoundSpec, strategy}', to_jsonb (v_strategy));
  result = ast.jsonb_set(result, '{PartitionBoundSpec, is_default}', to_jsonb (v_is_default));
  result = ast.jsonb_set(result, '{PartitionBoundSpec, modulus}', to_jsonb (v_modulus));
  result = ast.jsonb_set(result, '{PartitionBoundSpec, remainder}', to_jsonb (v_remainder));
  result = ast.jsonb_set(result, '{PartitionBoundSpec, listdatums}', v_listdatums);
  result = ast.jsonb_set(result, '{PartitionBoundSpec, lowerdatums}', v_lowerdatums);
  result = ast.jsonb_set(result, '{PartitionBoundSpec, upperdatums}', v_upperdatums);
  result = ast.jsonb_set(result, '{PartitionBoundSpec, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.partition_range_datum (
  v_type text DEFAULT NULL, 
  v_kind text DEFAULT NULL, 
  v_value jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"PartitionRangeDatum":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{PartitionRangeDatum, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{PartitionRangeDatum, kind}', to_jsonb (v_kind));
  result = ast.jsonb_set(result, '{PartitionRangeDatum, value}', v_value);
  result = ast.jsonb_set(result, '{PartitionRangeDatum, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.partition_cmd (
  v_type text DEFAULT NULL, 
  v_name jsonb DEFAULT NULL, 
  v_bound jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"PartitionCmd":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{PartitionCmd, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{PartitionCmd, name}', v_name);
  result = ast.jsonb_set(result, '{PartitionCmd, bound}', v_bound);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.range_tbl_entry (
  v_type text DEFAULT NULL, 
  v_rtekind text DEFAULT NULL, 
  v_relid jsonb DEFAULT NULL, 
  v_relkind text DEFAULT NULL, 
  v_rellockmode int DEFAULT NULL, 
  v_tablesample jsonb DEFAULT NULL, 
  v_subquery jsonb DEFAULT NULL, 
  v_security_barrier boolean DEFAULT NULL, 
  v_jointype text DEFAULT NULL, 
  v_joinmergedcols int DEFAULT NULL, 
  v_joinaliasvars jsonb DEFAULT NULL, 
  v_joinleftcols jsonb DEFAULT NULL, 
  v_joinrightcols jsonb DEFAULT NULL, 
  v_functions jsonb DEFAULT NULL, 
  v_funcordinality boolean DEFAULT NULL, 
  v_tablefunc jsonb DEFAULT NULL, 
  v_values_lists jsonb DEFAULT NULL, 
  v_ctename text DEFAULT NULL, 
  v_ctelevelsup jsonb DEFAULT NULL, 
  v_self_reference boolean DEFAULT NULL, 
  v_coltypes jsonb DEFAULT NULL, 
  v_coltypmods jsonb DEFAULT NULL, 
  v_colcollations jsonb DEFAULT NULL, 
  v_enrname text DEFAULT NULL, 
  v_enrtuples float DEFAULT NULL, 
  v_alias jsonb DEFAULT NULL, 
  v_eref jsonb DEFAULT NULL, 
  v_lateral boolean DEFAULT NULL, 
  v_inh boolean DEFAULT NULL, 
  v_inFromCl boolean DEFAULT NULL, 
  v_requiredPerms jsonb DEFAULT NULL, 
  v_checkAsUser jsonb DEFAULT NULL, 
  v_selectedCols jsonb DEFAULT NULL, 
  v_insertedCols jsonb DEFAULT NULL, 
  v_updatedCols jsonb DEFAULT NULL, 
  v_extraUpdatedCols jsonb DEFAULT NULL, 
  v_securityQuals jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RangeTblEntry":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RangeTblEntry, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RangeTblEntry, rtekind}', to_jsonb (v_rtekind));
  result = ast.jsonb_set(result, '{RangeTblEntry, relid}', v_relid);
  result = ast.jsonb_set(result, '{RangeTblEntry, relkind}', to_jsonb (v_relkind));
  result = ast.jsonb_set(result, '{RangeTblEntry, rellockmode}', to_jsonb (v_rellockmode));
  result = ast.jsonb_set(result, '{RangeTblEntry, tablesample}', v_tablesample);
  result = ast.jsonb_set(result, '{RangeTblEntry, subquery}', v_subquery);
  result = ast.jsonb_set(result, '{RangeTblEntry, security_barrier}', to_jsonb (v_security_barrier));
  result = ast.jsonb_set(result, '{RangeTblEntry, jointype}', to_jsonb (v_jointype));
  result = ast.jsonb_set(result, '{RangeTblEntry, joinmergedcols}', to_jsonb (v_joinmergedcols));
  result = ast.jsonb_set(result, '{RangeTblEntry, joinaliasvars}', v_joinaliasvars);
  result = ast.jsonb_set(result, '{RangeTblEntry, joinleftcols}', v_joinleftcols);
  result = ast.jsonb_set(result, '{RangeTblEntry, joinrightcols}', v_joinrightcols);
  result = ast.jsonb_set(result, '{RangeTblEntry, functions}', v_functions);
  result = ast.jsonb_set(result, '{RangeTblEntry, funcordinality}', to_jsonb (v_funcordinality));
  result = ast.jsonb_set(result, '{RangeTblEntry, tablefunc}', v_tablefunc);
  result = ast.jsonb_set(result, '{RangeTblEntry, values_lists}', v_values_lists);
  result = ast.jsonb_set(result, '{RangeTblEntry, ctename}', to_jsonb (v_ctename));
  result = ast.jsonb_set(result, '{RangeTblEntry, ctelevelsup}', v_ctelevelsup);
  result = ast.jsonb_set(result, '{RangeTblEntry, self_reference}', to_jsonb (v_self_reference));
  result = ast.jsonb_set(result, '{RangeTblEntry, coltypes}', v_coltypes);
  result = ast.jsonb_set(result, '{RangeTblEntry, coltypmods}', v_coltypmods);
  result = ast.jsonb_set(result, '{RangeTblEntry, colcollations}', v_colcollations);
  result = ast.jsonb_set(result, '{RangeTblEntry, enrname}', to_jsonb (v_enrname));
  result = ast.jsonb_set(result, '{RangeTblEntry, enrtuples}', to_jsonb (v_enrtuples));
  result = ast.jsonb_set(result, '{RangeTblEntry, alias}', v_alias);
  result = ast.jsonb_set(result, '{RangeTblEntry, eref}', v_eref);
  result = ast.jsonb_set(result, '{RangeTblEntry, lateral}', to_jsonb (v_lateral));
  result = ast.jsonb_set(result, '{RangeTblEntry, inh}', to_jsonb (v_inh));
  result = ast.jsonb_set(result, '{RangeTblEntry, inFromCl}', to_jsonb (v_inFromCl));
  result = ast.jsonb_set(result, '{RangeTblEntry, requiredPerms}', v_requiredPerms);
  result = ast.jsonb_set(result, '{RangeTblEntry, checkAsUser}', v_checkAsUser);
  result = ast.jsonb_set(result, '{RangeTblEntry, selectedCols}', v_selectedCols);
  result = ast.jsonb_set(result, '{RangeTblEntry, insertedCols}', v_insertedCols);
  result = ast.jsonb_set(result, '{RangeTblEntry, updatedCols}', v_updatedCols);
  result = ast.jsonb_set(result, '{RangeTblEntry, extraUpdatedCols}', v_extraUpdatedCols);
  result = ast.jsonb_set(result, '{RangeTblEntry, securityQuals}', v_securityQuals);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.range_tbl_function (
  v_type text DEFAULT NULL, 
  v_funcexpr jsonb DEFAULT NULL, 
  v_funccolcount int DEFAULT NULL, 
  v_funccolnames jsonb DEFAULT NULL, 
  v_funccoltypes jsonb DEFAULT NULL, 
  v_funccoltypmods jsonb DEFAULT NULL, 
  v_funccolcollations jsonb DEFAULT NULL, 
  v_funcparams jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RangeTblFunction":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RangeTblFunction, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RangeTblFunction, funcexpr}', v_funcexpr);
  result = ast.jsonb_set(result, '{RangeTblFunction, funccolcount}', to_jsonb (v_funccolcount));
  result = ast.jsonb_set(result, '{RangeTblFunction, funccolnames}', v_funccolnames);
  result = ast.jsonb_set(result, '{RangeTblFunction, funccoltypes}', v_funccoltypes);
  result = ast.jsonb_set(result, '{RangeTblFunction, funccoltypmods}', v_funccoltypmods);
  result = ast.jsonb_set(result, '{RangeTblFunction, funccolcollations}', v_funccolcollations);
  result = ast.jsonb_set(result, '{RangeTblFunction, funcparams}', v_funcparams);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.table_sample_clause (
  v_type text DEFAULT NULL, 
  v_tsmhandler jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_repeatable jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"TableSampleClause":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{TableSampleClause, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{TableSampleClause, tsmhandler}', v_tsmhandler);
  result = ast.jsonb_set(result, '{TableSampleClause, args}', v_args);
  result = ast.jsonb_set(result, '{TableSampleClause, repeatable}', v_repeatable);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.with_check_option (
  v_type text DEFAULT NULL, 
  v_kind text DEFAULT NULL, 
  v_relname text DEFAULT NULL, 
  v_polname text DEFAULT NULL, 
  v_qual jsonb DEFAULT NULL, 
  v_cascaded boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"WithCheckOption":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{WithCheckOption, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{WithCheckOption, kind}', to_jsonb (v_kind));
  result = ast.jsonb_set(result, '{WithCheckOption, relname}', to_jsonb (v_relname));
  result = ast.jsonb_set(result, '{WithCheckOption, polname}', to_jsonb (v_polname));
  result = ast.jsonb_set(result, '{WithCheckOption, qual}', v_qual);
  result = ast.jsonb_set(result, '{WithCheckOption, cascaded}', to_jsonb (v_cascaded));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.sort_group_clause (
  v_type text DEFAULT NULL, 
  v_tleSortGroupRef jsonb DEFAULT NULL, 
  v_eqop jsonb DEFAULT NULL, 
  v_sortop jsonb DEFAULT NULL, 
  v_nulls_first boolean DEFAULT NULL, 
  v_hashable boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"SortGroupClause":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{SortGroupClause, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{SortGroupClause, tleSortGroupRef}', v_tleSortGroupRef);
  result = ast.jsonb_set(result, '{SortGroupClause, eqop}', v_eqop);
  result = ast.jsonb_set(result, '{SortGroupClause, sortop}', v_sortop);
  result = ast.jsonb_set(result, '{SortGroupClause, nulls_first}', to_jsonb (v_nulls_first));
  result = ast.jsonb_set(result, '{SortGroupClause, hashable}', to_jsonb (v_hashable));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.grouping_set (
  v_type text DEFAULT NULL, 
  v_kind text DEFAULT NULL, 
  v_content jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"GroupingSet":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{GroupingSet, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{GroupingSet, kind}', to_jsonb (v_kind));
  result = ast.jsonb_set(result, '{GroupingSet, content}', v_content);
  result = ast.jsonb_set(result, '{GroupingSet, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.window_clause (
  v_type text DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_refname text DEFAULT NULL, 
  v_partitionClause jsonb DEFAULT NULL, 
  v_orderClause jsonb DEFAULT NULL, 
  v_frameOptions int DEFAULT NULL, 
  v_startOffset jsonb DEFAULT NULL, 
  v_endOffset jsonb DEFAULT NULL, 
  v_startInRangeFunc jsonb DEFAULT NULL, 
  v_endInRangeFunc jsonb DEFAULT NULL, 
  v_inRangeColl jsonb DEFAULT NULL, 
  v_inRangeAsc boolean DEFAULT NULL, 
  v_inRangeNullsFirst boolean DEFAULT NULL, 
  v_winref jsonb DEFAULT NULL, 
  v_copiedOrder boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"WindowClause":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{WindowClause, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{WindowClause, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{WindowClause, refname}', to_jsonb (v_refname));
  result = ast.jsonb_set(result, '{WindowClause, partitionClause}', v_partitionClause);
  result = ast.jsonb_set(result, '{WindowClause, orderClause}', v_orderClause);
  result = ast.jsonb_set(result, '{WindowClause, frameOptions}', to_jsonb (v_frameOptions));
  result = ast.jsonb_set(result, '{WindowClause, startOffset}', v_startOffset);
  result = ast.jsonb_set(result, '{WindowClause, endOffset}', v_endOffset);
  result = ast.jsonb_set(result, '{WindowClause, startInRangeFunc}', v_startInRangeFunc);
  result = ast.jsonb_set(result, '{WindowClause, endInRangeFunc}', v_endInRangeFunc);
  result = ast.jsonb_set(result, '{WindowClause, inRangeColl}', v_inRangeColl);
  result = ast.jsonb_set(result, '{WindowClause, inRangeAsc}', to_jsonb (v_inRangeAsc));
  result = ast.jsonb_set(result, '{WindowClause, inRangeNullsFirst}', to_jsonb (v_inRangeNullsFirst));
  result = ast.jsonb_set(result, '{WindowClause, winref}', v_winref);
  result = ast.jsonb_set(result, '{WindowClause, copiedOrder}', to_jsonb (v_copiedOrder));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.row_mark_clause (
  v_type text DEFAULT NULL, 
  v_rti jsonb DEFAULT NULL, 
  v_strength text DEFAULT NULL, 
  v_waitPolicy text DEFAULT NULL, 
  v_pushedDown boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RowMarkClause":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RowMarkClause, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RowMarkClause, rti}', v_rti);
  result = ast.jsonb_set(result, '{RowMarkClause, strength}', to_jsonb (v_strength));
  result = ast.jsonb_set(result, '{RowMarkClause, waitPolicy}', to_jsonb (v_waitPolicy));
  result = ast.jsonb_set(result, '{RowMarkClause, pushedDown}', to_jsonb (v_pushedDown));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.with_clause (
  v_type text DEFAULT NULL, 
  v_ctes jsonb DEFAULT NULL, 
  v_recursive boolean DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"WithClause":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{WithClause, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{WithClause, ctes}', v_ctes);
  result = ast.jsonb_set(result, '{WithClause, recursive}', to_jsonb (v_recursive));
  result = ast.jsonb_set(result, '{WithClause, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.infer_clause (
  v_type text DEFAULT NULL, 
  v_indexElems jsonb DEFAULT NULL, 
  v_whereClause jsonb DEFAULT NULL, 
  v_conname text DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"InferClause":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{InferClause, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{InferClause, indexElems}', v_indexElems);
  result = ast.jsonb_set(result, '{InferClause, whereClause}', v_whereClause);
  result = ast.jsonb_set(result, '{InferClause, conname}', to_jsonb (v_conname));
  result = ast.jsonb_set(result, '{InferClause, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.on_conflict_clause (
  v_type text DEFAULT NULL, 
  v_action text DEFAULT NULL, 
  v_infer jsonb DEFAULT NULL, 
  v_targetList jsonb DEFAULT NULL, 
  v_whereClause jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"OnConflictClause":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{OnConflictClause, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{OnConflictClause, action}', to_jsonb (v_action));
  result = ast.jsonb_set(result, '{OnConflictClause, infer}', v_infer);
  result = ast.jsonb_set(result, '{OnConflictClause, targetList}', v_targetList);
  result = ast.jsonb_set(result, '{OnConflictClause, whereClause}', v_whereClause);
  result = ast.jsonb_set(result, '{OnConflictClause, location}', to_jsonb (v_location));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.common_table_expr (
  v_type text DEFAULT NULL, 
  v_ctename text DEFAULT NULL, 
  v_aliascolnames jsonb DEFAULT NULL, 
  v_ctematerialized text DEFAULT NULL, 
  v_ctequery jsonb DEFAULT NULL, 
  v_location int DEFAULT NULL, 
  v_cterecursive boolean DEFAULT NULL, 
  v_cterefcount int DEFAULT NULL, 
  v_ctecolnames jsonb DEFAULT NULL, 
  v_ctecoltypes jsonb DEFAULT NULL, 
  v_ctecoltypmods jsonb DEFAULT NULL, 
  v_ctecolcollations jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CommonTableExpr":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CommonTableExpr, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CommonTableExpr, ctename}', to_jsonb (v_ctename));
  result = ast.jsonb_set(result, '{CommonTableExpr, aliascolnames}', v_aliascolnames);
  result = ast.jsonb_set(result, '{CommonTableExpr, ctematerialized}', to_jsonb (v_ctematerialized));
  result = ast.jsonb_set(result, '{CommonTableExpr, ctequery}', v_ctequery);
  result = ast.jsonb_set(result, '{CommonTableExpr, location}', to_jsonb (v_location));
  result = ast.jsonb_set(result, '{CommonTableExpr, cterecursive}', to_jsonb (v_cterecursive));
  result = ast.jsonb_set(result, '{CommonTableExpr, cterefcount}', to_jsonb (v_cterefcount));
  result = ast.jsonb_set(result, '{CommonTableExpr, ctecolnames}', v_ctecolnames);
  result = ast.jsonb_set(result, '{CommonTableExpr, ctecoltypes}', v_ctecoltypes);
  result = ast.jsonb_set(result, '{CommonTableExpr, ctecoltypmods}', v_ctecoltypmods);
  result = ast.jsonb_set(result, '{CommonTableExpr, ctecolcollations}', v_ctecolcollations);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.trigger_transition (
  v_type text DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_isNew boolean DEFAULT NULL, 
  v_isTable boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"TriggerTransition":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{TriggerTransition, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{TriggerTransition, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{TriggerTransition, isNew}', to_jsonb (v_isNew));
  result = ast.jsonb_set(result, '{TriggerTransition, isTable}', to_jsonb (v_isTable));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.raw_stmt (
  v_type text DEFAULT NULL, 
  v_stmt jsonb DEFAULT NULL, 
  v_stmt_location int DEFAULT NULL, 
  v_stmt_len int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RawStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RawStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RawStmt, stmt}', v_stmt);
  result = ast.jsonb_set(result, '{RawStmt, stmt_location}', to_jsonb (v_stmt_location));
  result = ast.jsonb_set(result, '{RawStmt, stmt_len}', to_jsonb (v_stmt_len));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.insert_stmt (
  v_type text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_cols jsonb DEFAULT NULL, 
  v_selectStmt jsonb DEFAULT NULL, 
  v_onConflictClause jsonb DEFAULT NULL, 
  v_returningList jsonb DEFAULT NULL, 
  v_withClause jsonb DEFAULT NULL, 
  v_override text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"InsertStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{InsertStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{InsertStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{InsertStmt, cols}', v_cols);
  result = ast.jsonb_set(result, '{InsertStmt, selectStmt}', v_selectStmt);
  result = ast.jsonb_set(result, '{InsertStmt, onConflictClause}', v_onConflictClause);
  result = ast.jsonb_set(result, '{InsertStmt, returningList}', v_returningList);
  result = ast.jsonb_set(result, '{InsertStmt, withClause}', v_withClause);
  result = ast.jsonb_set(result, '{InsertStmt, override}', to_jsonb (v_override));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.delete_stmt (
  v_type text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_usingClause jsonb DEFAULT NULL, 
  v_whereClause jsonb DEFAULT NULL, 
  v_returningList jsonb DEFAULT NULL, 
  v_withClause jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"DeleteStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{DeleteStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{DeleteStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{DeleteStmt, usingClause}', v_usingClause);
  result = ast.jsonb_set(result, '{DeleteStmt, whereClause}', v_whereClause);
  result = ast.jsonb_set(result, '{DeleteStmt, returningList}', v_returningList);
  result = ast.jsonb_set(result, '{DeleteStmt, withClause}', v_withClause);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.update_stmt (
  v_type text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_targetList jsonb DEFAULT NULL, 
  v_whereClause jsonb DEFAULT NULL, 
  v_fromClause jsonb DEFAULT NULL, 
  v_returningList jsonb DEFAULT NULL, 
  v_withClause jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"UpdateStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{UpdateStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{UpdateStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{UpdateStmt, targetList}', v_targetList);
  result = ast.jsonb_set(result, '{UpdateStmt, whereClause}', v_whereClause);
  result = ast.jsonb_set(result, '{UpdateStmt, fromClause}', v_fromClause);
  result = ast.jsonb_set(result, '{UpdateStmt, returningList}', v_returningList);
  result = ast.jsonb_set(result, '{UpdateStmt, withClause}', v_withClause);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.select_stmt (
  v_type text DEFAULT NULL, 
  v_distinctClause jsonb DEFAULT NULL, 
  v_intoClause jsonb DEFAULT NULL, 
  v_targetList jsonb DEFAULT NULL, 
  v_fromClause jsonb DEFAULT NULL, 
  v_whereClause jsonb DEFAULT NULL, 
  v_groupClause jsonb DEFAULT NULL, 
  v_havingClause jsonb DEFAULT NULL, 
  v_windowClause jsonb DEFAULT NULL, 
  v_valuesLists jsonb DEFAULT NULL, 
  v_sortClause jsonb DEFAULT NULL, 
  v_limitOffset jsonb DEFAULT NULL, 
  v_limitCount jsonb DEFAULT NULL, 
  v_limitOption text DEFAULT NULL, 
  v_lockingClause jsonb DEFAULT NULL, 
  v_withClause jsonb DEFAULT NULL, 
  v_op text DEFAULT NULL, 
  v_all boolean DEFAULT NULL, 
  v_larg jsonb DEFAULT NULL, 
  v_rarg jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"SelectStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{SelectStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{SelectStmt, distinctClause}', v_distinctClause);
  result = ast.jsonb_set(result, '{SelectStmt, intoClause}', v_intoClause);
  result = ast.jsonb_set(result, '{SelectStmt, targetList}', v_targetList);
  result = ast.jsonb_set(result, '{SelectStmt, fromClause}', v_fromClause);
  result = ast.jsonb_set(result, '{SelectStmt, whereClause}', v_whereClause);
  result = ast.jsonb_set(result, '{SelectStmt, groupClause}', v_groupClause);
  result = ast.jsonb_set(result, '{SelectStmt, havingClause}', v_havingClause);
  result = ast.jsonb_set(result, '{SelectStmt, windowClause}', v_windowClause);
  result = ast.jsonb_set(result, '{SelectStmt, valuesLists}', v_valuesLists);
  result = ast.jsonb_set(result, '{SelectStmt, sortClause}', v_sortClause);
  result = ast.jsonb_set(result, '{SelectStmt, limitOffset}', v_limitOffset);
  result = ast.jsonb_set(result, '{SelectStmt, limitCount}', v_limitCount);
  result = ast.jsonb_set(result, '{SelectStmt, limitOption}', to_jsonb (v_limitOption));
  result = ast.jsonb_set(result, '{SelectStmt, lockingClause}', v_lockingClause);
  result = ast.jsonb_set(result, '{SelectStmt, withClause}', v_withClause);
  result = ast.jsonb_set(result, '{SelectStmt, op}', to_jsonb (v_op));
  result = ast.jsonb_set(result, '{SelectStmt, all}', to_jsonb (v_all));
  result = ast.jsonb_set(result, '{SelectStmt, larg}', v_larg);
  result = ast.jsonb_set(result, '{SelectStmt, rarg}', v_rarg);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.set_operation_stmt (
  v_type text DEFAULT NULL, 
  v_op text DEFAULT NULL, 
  v_all boolean DEFAULT NULL, 
  v_larg jsonb DEFAULT NULL, 
  v_rarg jsonb DEFAULT NULL, 
  v_colTypes jsonb DEFAULT NULL, 
  v_colTypmods jsonb DEFAULT NULL, 
  v_colCollations jsonb DEFAULT NULL, 
  v_groupClauses jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"SetOperationStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{SetOperationStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{SetOperationStmt, op}', to_jsonb (v_op));
  result = ast.jsonb_set(result, '{SetOperationStmt, all}', to_jsonb (v_all));
  result = ast.jsonb_set(result, '{SetOperationStmt, larg}', v_larg);
  result = ast.jsonb_set(result, '{SetOperationStmt, rarg}', v_rarg);
  result = ast.jsonb_set(result, '{SetOperationStmt, colTypes}', v_colTypes);
  result = ast.jsonb_set(result, '{SetOperationStmt, colTypmods}', v_colTypmods);
  result = ast.jsonb_set(result, '{SetOperationStmt, colCollations}', v_colCollations);
  result = ast.jsonb_set(result, '{SetOperationStmt, groupClauses}', v_groupClauses);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_schema_stmt (
  v_type text DEFAULT NULL, 
  v_schemaname text DEFAULT NULL, 
  v_authrole jsonb DEFAULT NULL, 
  v_schemaElts jsonb DEFAULT NULL, 
  v_if_not_exists boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateSchemaStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateSchemaStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateSchemaStmt, schemaname}', to_jsonb (v_schemaname));
  result = ast.jsonb_set(result, '{CreateSchemaStmt, authrole}', v_authrole);
  result = ast.jsonb_set(result, '{CreateSchemaStmt, schemaElts}', v_schemaElts);
  result = ast.jsonb_set(result, '{CreateSchemaStmt, if_not_exists}', to_jsonb (v_if_not_exists));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_table_stmt (
  v_type text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_cmds jsonb DEFAULT NULL, 
  v_relkind text DEFAULT NULL, 
  v_missing_ok boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterTableStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterTableStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterTableStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{AlterTableStmt, cmds}', v_cmds);
  result = ast.jsonb_set(result, '{AlterTableStmt, relkind}', to_jsonb (v_relkind));
  result = ast.jsonb_set(result, '{AlterTableStmt, missing_ok}', to_jsonb (v_missing_ok));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.replica_identity_stmt (
  v_type text DEFAULT NULL, 
  v_identity_type text DEFAULT NULL, 
  v_name text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ReplicaIdentityStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ReplicaIdentityStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ReplicaIdentityStmt, identity_type}', to_jsonb (v_identity_type));
  result = ast.jsonb_set(result, '{ReplicaIdentityStmt, name}', to_jsonb (v_name));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_table_cmd (
  v_type text DEFAULT NULL, 
  v_subtype text DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_num int DEFAULT NULL, 
  v_newowner jsonb DEFAULT NULL, 
  v_def jsonb DEFAULT NULL, 
  v_behavior text DEFAULT NULL, 
  v_missing_ok boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterTableCmd":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterTableCmd, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterTableCmd, subtype}', to_jsonb (v_subtype));
  result = ast.jsonb_set(result, '{AlterTableCmd, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{AlterTableCmd, num}', to_jsonb (v_num));
  result = ast.jsonb_set(result, '{AlterTableCmd, newowner}', v_newowner);
  result = ast.jsonb_set(result, '{AlterTableCmd, def}', v_def);
  result = ast.jsonb_set(result, '{AlterTableCmd, behavior}', to_jsonb (v_behavior));
  result = ast.jsonb_set(result, '{AlterTableCmd, missing_ok}', to_jsonb (v_missing_ok));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_collation_stmt (
  v_type text DEFAULT NULL, 
  v_collname jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterCollationStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterCollationStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterCollationStmt, collname}', v_collname);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_domain_stmt (
  v_type text DEFAULT NULL, 
  v_subtype text DEFAULT NULL, 
  v_typeName jsonb DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_def jsonb DEFAULT NULL, 
  v_behavior text DEFAULT NULL, 
  v_missing_ok boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterDomainStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterDomainStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterDomainStmt, subtype}', to_jsonb (v_subtype));
  result = ast.jsonb_set(result, '{AlterDomainStmt, typeName}', v_typeName);
  result = ast.jsonb_set(result, '{AlterDomainStmt, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{AlterDomainStmt, def}', v_def);
  result = ast.jsonb_set(result, '{AlterDomainStmt, behavior}', to_jsonb (v_behavior));
  result = ast.jsonb_set(result, '{AlterDomainStmt, missing_ok}', to_jsonb (v_missing_ok));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.grant_stmt (
  v_type text DEFAULT NULL, 
  v_is_grant boolean DEFAULT NULL, 
  v_targtype text DEFAULT NULL, 
  v_objtype text DEFAULT NULL, 
  v_objects jsonb DEFAULT NULL, 
  v_privileges jsonb DEFAULT NULL, 
  v_grantees jsonb DEFAULT NULL, 
  v_grant_option boolean DEFAULT NULL, 
  v_behavior text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"GrantStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{GrantStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{GrantStmt, is_grant}', to_jsonb (v_is_grant));
  result = ast.jsonb_set(result, '{GrantStmt, targtype}', to_jsonb (v_targtype));
  result = ast.jsonb_set(result, '{GrantStmt, objtype}', to_jsonb (v_objtype));
  result = ast.jsonb_set(result, '{GrantStmt, objects}', v_objects);
  result = ast.jsonb_set(result, '{GrantStmt, privileges}', v_privileges);
  result = ast.jsonb_set(result, '{GrantStmt, grantees}', v_grantees);
  result = ast.jsonb_set(result, '{GrantStmt, grant_option}', to_jsonb (v_grant_option));
  result = ast.jsonb_set(result, '{GrantStmt, behavior}', to_jsonb (v_behavior));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.object_with_args (
  v_type text DEFAULT NULL, 
  v_objname jsonb DEFAULT NULL, 
  v_objargs jsonb DEFAULT NULL, 
  v_args_unspecified boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ObjectWithArgs":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ObjectWithArgs, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ObjectWithArgs, objname}', v_objname);
  result = ast.jsonb_set(result, '{ObjectWithArgs, objargs}', v_objargs);
  result = ast.jsonb_set(result, '{ObjectWithArgs, args_unspecified}', to_jsonb (v_args_unspecified));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.access_priv (
  v_type text DEFAULT NULL, 
  v_priv_name text DEFAULT NULL, 
  v_cols jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AccessPriv":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AccessPriv, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AccessPriv, priv_name}', to_jsonb (v_priv_name));
  result = ast.jsonb_set(result, '{AccessPriv, cols}', v_cols);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.grant_role_stmt (
  v_type text DEFAULT NULL, 
  v_granted_roles jsonb DEFAULT NULL, 
  v_grantee_roles jsonb DEFAULT NULL, 
  v_is_grant boolean DEFAULT NULL, 
  v_admin_opt boolean DEFAULT NULL, 
  v_grantor jsonb DEFAULT NULL, 
  v_behavior text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"GrantRoleStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{GrantRoleStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{GrantRoleStmt, granted_roles}', v_granted_roles);
  result = ast.jsonb_set(result, '{GrantRoleStmt, grantee_roles}', v_grantee_roles);
  result = ast.jsonb_set(result, '{GrantRoleStmt, is_grant}', to_jsonb (v_is_grant));
  result = ast.jsonb_set(result, '{GrantRoleStmt, admin_opt}', to_jsonb (v_admin_opt));
  result = ast.jsonb_set(result, '{GrantRoleStmt, grantor}', v_grantor);
  result = ast.jsonb_set(result, '{GrantRoleStmt, behavior}', to_jsonb (v_behavior));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_default_privileges_stmt (
  v_type text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_action jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterDefaultPrivilegesStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterDefaultPrivilegesStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterDefaultPrivilegesStmt, options}', v_options);
  result = ast.jsonb_set(result, '{AlterDefaultPrivilegesStmt, action}', v_action);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.copy_stmt (
  v_type text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_query jsonb DEFAULT NULL, 
  v_attlist jsonb DEFAULT NULL, 
  v_is_from boolean DEFAULT NULL, 
  v_is_program boolean DEFAULT NULL, 
  v_filename text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_whereClause jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CopyStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CopyStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CopyStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{CopyStmt, query}', v_query);
  result = ast.jsonb_set(result, '{CopyStmt, attlist}', v_attlist);
  result = ast.jsonb_set(result, '{CopyStmt, is_from}', to_jsonb (v_is_from));
  result = ast.jsonb_set(result, '{CopyStmt, is_program}', to_jsonb (v_is_program));
  result = ast.jsonb_set(result, '{CopyStmt, filename}', to_jsonb (v_filename));
  result = ast.jsonb_set(result, '{CopyStmt, options}', v_options);
  result = ast.jsonb_set(result, '{CopyStmt, whereClause}', v_whereClause);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.variable_set_stmt (
  v_type text DEFAULT NULL, 
  v_kind text DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_is_local boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"VariableSetStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{VariableSetStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{VariableSetStmt, kind}', to_jsonb (v_kind));
  result = ast.jsonb_set(result, '{VariableSetStmt, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{VariableSetStmt, args}', v_args);
  result = ast.jsonb_set(result, '{VariableSetStmt, is_local}', to_jsonb (v_is_local));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.variable_show_stmt (
  v_type text DEFAULT NULL, 
  v_name text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"VariableShowStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{VariableShowStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{VariableShowStmt, name}', to_jsonb (v_name));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_stmt (
  v_type text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_tableElts jsonb DEFAULT NULL, 
  v_inhRelations jsonb DEFAULT NULL, 
  v_partbound jsonb DEFAULT NULL, 
  v_partspec jsonb DEFAULT NULL, 
  v_ofTypename jsonb DEFAULT NULL, 
  v_constraints jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_oncommit text DEFAULT NULL, 
  v_tablespacename text DEFAULT NULL, 
  v_accessMethod text DEFAULT NULL, 
  v_if_not_exists boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{CreateStmt, tableElts}', v_tableElts);
  result = ast.jsonb_set(result, '{CreateStmt, inhRelations}', v_inhRelations);
  result = ast.jsonb_set(result, '{CreateStmt, partbound}', v_partbound);
  result = ast.jsonb_set(result, '{CreateStmt, partspec}', v_partspec);
  result = ast.jsonb_set(result, '{CreateStmt, ofTypename}', v_ofTypename);
  result = ast.jsonb_set(result, '{CreateStmt, constraints}', v_constraints);
  result = ast.jsonb_set(result, '{CreateStmt, options}', v_options);
  result = ast.jsonb_set(result, '{CreateStmt, oncommit}', to_jsonb (v_oncommit));
  result = ast.jsonb_set(result, '{CreateStmt, tablespacename}', to_jsonb (v_tablespacename));
  result = ast.jsonb_set(result, '{CreateStmt, accessMethod}', to_jsonb (v_accessMethod));
  result = ast.jsonb_set(result, '{CreateStmt, if_not_exists}', to_jsonb (v_if_not_exists));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.constraint (
  v_type text DEFAULT NULL, 
  v_contype text DEFAULT NULL, 
  v_conname text DEFAULT NULL, 
  v_deferrable boolean DEFAULT NULL, 
  v_initdeferred boolean DEFAULT NULL, 
  v_location int DEFAULT NULL, 
  v_is_no_inherit boolean DEFAULT NULL, 
  v_raw_expr jsonb DEFAULT NULL, 
  v_cooked_expr text DEFAULT NULL, 
  v_generated_when text DEFAULT NULL, 
  v_keys jsonb DEFAULT NULL, 
  v_including jsonb DEFAULT NULL, 
  v_exclusions jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_indexname text DEFAULT NULL, 
  v_indexspace text DEFAULT NULL, 
  v_reset_default_tblspc boolean DEFAULT NULL, 
  v_access_method text DEFAULT NULL, 
  v_where_clause jsonb DEFAULT NULL, 
  v_pktable jsonb DEFAULT NULL, 
  v_fk_attrs jsonb DEFAULT NULL, 
  v_pk_attrs jsonb DEFAULT NULL, 
  v_fk_matchtype text DEFAULT NULL, 
  v_fk_upd_action text DEFAULT NULL, 
  v_fk_del_action text DEFAULT NULL, 
  v_old_conpfeqop jsonb DEFAULT NULL, 
  v_old_pktable_oid jsonb DEFAULT NULL, 
  v_skip_validation boolean DEFAULT NULL, 
  v_initially_valid boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"Constraint":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{Constraint, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{Constraint, contype}', to_jsonb (v_contype));
  result = ast.jsonb_set(result, '{Constraint, conname}', to_jsonb (v_conname));
  result = ast.jsonb_set(result, '{Constraint, deferrable}', to_jsonb (v_deferrable));
  result = ast.jsonb_set(result, '{Constraint, initdeferred}', to_jsonb (v_initdeferred));
  result = ast.jsonb_set(result, '{Constraint, location}', to_jsonb (v_location));
  result = ast.jsonb_set(result, '{Constraint, is_no_inherit}', to_jsonb (v_is_no_inherit));
  result = ast.jsonb_set(result, '{Constraint, raw_expr}', v_raw_expr);
  result = ast.jsonb_set(result, '{Constraint, cooked_expr}', to_jsonb (v_cooked_expr));
  result = ast.jsonb_set(result, '{Constraint, generated_when}', to_jsonb (v_generated_when));
  result = ast.jsonb_set(result, '{Constraint, keys}', v_keys);
  result = ast.jsonb_set(result, '{Constraint, including}', v_including);
  result = ast.jsonb_set(result, '{Constraint, exclusions}', v_exclusions);
  result = ast.jsonb_set(result, '{Constraint, options}', v_options);
  result = ast.jsonb_set(result, '{Constraint, indexname}', to_jsonb (v_indexname));
  result = ast.jsonb_set(result, '{Constraint, indexspace}', to_jsonb (v_indexspace));
  result = ast.jsonb_set(result, '{Constraint, reset_default_tblspc}', to_jsonb (v_reset_default_tblspc));
  result = ast.jsonb_set(result, '{Constraint, access_method}', to_jsonb (v_access_method));
  result = ast.jsonb_set(result, '{Constraint, where_clause}', v_where_clause);
  result = ast.jsonb_set(result, '{Constraint, pktable}', v_pktable);
  result = ast.jsonb_set(result, '{Constraint, fk_attrs}', v_fk_attrs);
  result = ast.jsonb_set(result, '{Constraint, pk_attrs}', v_pk_attrs);
  result = ast.jsonb_set(result, '{Constraint, fk_matchtype}', to_jsonb (v_fk_matchtype));
  result = ast.jsonb_set(result, '{Constraint, fk_upd_action}', to_jsonb (v_fk_upd_action));
  result = ast.jsonb_set(result, '{Constraint, fk_del_action}', to_jsonb (v_fk_del_action));
  result = ast.jsonb_set(result, '{Constraint, old_conpfeqop}', v_old_conpfeqop);
  result = ast.jsonb_set(result, '{Constraint, old_pktable_oid}', v_old_pktable_oid);
  result = ast.jsonb_set(result, '{Constraint, skip_validation}', to_jsonb (v_skip_validation));
  result = ast.jsonb_set(result, '{Constraint, initially_valid}', to_jsonb (v_initially_valid));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_table_space_stmt (
  v_type text DEFAULT NULL, 
  v_tablespacename text DEFAULT NULL, 
  v_owner jsonb DEFAULT NULL, 
  v_location text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateTableSpaceStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateTableSpaceStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateTableSpaceStmt, tablespacename}', to_jsonb (v_tablespacename));
  result = ast.jsonb_set(result, '{CreateTableSpaceStmt, owner}', v_owner);
  result = ast.jsonb_set(result, '{CreateTableSpaceStmt, location}', to_jsonb (v_location));
  result = ast.jsonb_set(result, '{CreateTableSpaceStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.drop_table_space_stmt (
  v_type text DEFAULT NULL, 
  v_tablespacename text DEFAULT NULL, 
  v_missing_ok boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"DropTableSpaceStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{DropTableSpaceStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{DropTableSpaceStmt, tablespacename}', to_jsonb (v_tablespacename));
  result = ast.jsonb_set(result, '{DropTableSpaceStmt, missing_ok}', to_jsonb (v_missing_ok));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_table_space_options_stmt (
  v_type text DEFAULT NULL, 
  v_tablespacename text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_isReset boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterTableSpaceOptionsStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterTableSpaceOptionsStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterTableSpaceOptionsStmt, tablespacename}', to_jsonb (v_tablespacename));
  result = ast.jsonb_set(result, '{AlterTableSpaceOptionsStmt, options}', v_options);
  result = ast.jsonb_set(result, '{AlterTableSpaceOptionsStmt, isReset}', to_jsonb (v_isReset));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_table_move_all_stmt (
  v_type text DEFAULT NULL, 
  v_orig_tablespacename text DEFAULT NULL, 
  v_objtype text DEFAULT NULL, 
  v_roles jsonb DEFAULT NULL, 
  v_new_tablespacename text DEFAULT NULL, 
  v_nowait boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterTableMoveAllStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterTableMoveAllStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterTableMoveAllStmt, orig_tablespacename}', to_jsonb (v_orig_tablespacename));
  result = ast.jsonb_set(result, '{AlterTableMoveAllStmt, objtype}', to_jsonb (v_objtype));
  result = ast.jsonb_set(result, '{AlterTableMoveAllStmt, roles}', v_roles);
  result = ast.jsonb_set(result, '{AlterTableMoveAllStmt, new_tablespacename}', to_jsonb (v_new_tablespacename));
  result = ast.jsonb_set(result, '{AlterTableMoveAllStmt, nowait}', to_jsonb (v_nowait));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_extension_stmt (
  v_type text DEFAULT NULL, 
  v_extname text DEFAULT NULL, 
  v_if_not_exists boolean DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateExtensionStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateExtensionStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateExtensionStmt, extname}', to_jsonb (v_extname));
  result = ast.jsonb_set(result, '{CreateExtensionStmt, if_not_exists}', to_jsonb (v_if_not_exists));
  result = ast.jsonb_set(result, '{CreateExtensionStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_extension_stmt (
  v_type text DEFAULT NULL, 
  v_extname text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterExtensionStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterExtensionStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterExtensionStmt, extname}', to_jsonb (v_extname));
  result = ast.jsonb_set(result, '{AlterExtensionStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_extension_contents_stmt (
  v_type text DEFAULT NULL, 
  v_extname text DEFAULT NULL, 
  v_action int DEFAULT NULL, 
  v_objtype text DEFAULT NULL, 
  v_object jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterExtensionContentsStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterExtensionContentsStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterExtensionContentsStmt, extname}', to_jsonb (v_extname));
  result = ast.jsonb_set(result, '{AlterExtensionContentsStmt, action}', to_jsonb (v_action));
  result = ast.jsonb_set(result, '{AlterExtensionContentsStmt, objtype}', to_jsonb (v_objtype));
  result = ast.jsonb_set(result, '{AlterExtensionContentsStmt, object}', v_object);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_fdw_stmt (
  v_type text DEFAULT NULL, 
  v_fdwname text DEFAULT NULL, 
  v_func_options jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateFdwStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateFdwStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateFdwStmt, fdwname}', to_jsonb (v_fdwname));
  result = ast.jsonb_set(result, '{CreateFdwStmt, func_options}', v_func_options);
  result = ast.jsonb_set(result, '{CreateFdwStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_fdw_stmt (
  v_type text DEFAULT NULL, 
  v_fdwname text DEFAULT NULL, 
  v_func_options jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterFdwStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterFdwStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterFdwStmt, fdwname}', to_jsonb (v_fdwname));
  result = ast.jsonb_set(result, '{AlterFdwStmt, func_options}', v_func_options);
  result = ast.jsonb_set(result, '{AlterFdwStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_foreign_server_stmt (
  v_type text DEFAULT NULL, 
  v_servername text DEFAULT NULL, 
  v_servertype text DEFAULT NULL, 
  v_version text DEFAULT NULL, 
  v_fdwname text DEFAULT NULL, 
  v_if_not_exists boolean DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateForeignServerStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateForeignServerStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateForeignServerStmt, servername}', to_jsonb (v_servername));
  result = ast.jsonb_set(result, '{CreateForeignServerStmt, servertype}', to_jsonb (v_servertype));
  result = ast.jsonb_set(result, '{CreateForeignServerStmt, version}', to_jsonb (v_version));
  result = ast.jsonb_set(result, '{CreateForeignServerStmt, fdwname}', to_jsonb (v_fdwname));
  result = ast.jsonb_set(result, '{CreateForeignServerStmt, if_not_exists}', to_jsonb (v_if_not_exists));
  result = ast.jsonb_set(result, '{CreateForeignServerStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_foreign_server_stmt (
  v_type text DEFAULT NULL, 
  v_servername text DEFAULT NULL, 
  v_version text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_has_version boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterForeignServerStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterForeignServerStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterForeignServerStmt, servername}', to_jsonb (v_servername));
  result = ast.jsonb_set(result, '{AlterForeignServerStmt, version}', to_jsonb (v_version));
  result = ast.jsonb_set(result, '{AlterForeignServerStmt, options}', v_options);
  result = ast.jsonb_set(result, '{AlterForeignServerStmt, has_version}', to_jsonb (v_has_version));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_foreign_table_stmt (
  v_base jsonb DEFAULT NULL, 
  v_servername text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateForeignTableStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateForeignTableStmt, base}', v_base);
  result = ast.jsonb_set(result, '{CreateForeignTableStmt, servername}', to_jsonb (v_servername));
  result = ast.jsonb_set(result, '{CreateForeignTableStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_user_mapping_stmt (
  v_type text DEFAULT NULL, 
  v_user jsonb DEFAULT NULL, 
  v_servername text DEFAULT NULL, 
  v_if_not_exists boolean DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateUserMappingStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateUserMappingStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateUserMappingStmt, user}', v_user);
  result = ast.jsonb_set(result, '{CreateUserMappingStmt, servername}', to_jsonb (v_servername));
  result = ast.jsonb_set(result, '{CreateUserMappingStmt, if_not_exists}', to_jsonb (v_if_not_exists));
  result = ast.jsonb_set(result, '{CreateUserMappingStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_user_mapping_stmt (
  v_type text DEFAULT NULL, 
  v_user jsonb DEFAULT NULL, 
  v_servername text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterUserMappingStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterUserMappingStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterUserMappingStmt, user}', v_user);
  result = ast.jsonb_set(result, '{AlterUserMappingStmt, servername}', to_jsonb (v_servername));
  result = ast.jsonb_set(result, '{AlterUserMappingStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.drop_user_mapping_stmt (
  v_type text DEFAULT NULL, 
  v_user jsonb DEFAULT NULL, 
  v_servername text DEFAULT NULL, 
  v_missing_ok boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"DropUserMappingStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{DropUserMappingStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{DropUserMappingStmt, user}', v_user);
  result = ast.jsonb_set(result, '{DropUserMappingStmt, servername}', to_jsonb (v_servername));
  result = ast.jsonb_set(result, '{DropUserMappingStmt, missing_ok}', to_jsonb (v_missing_ok));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.import_foreign_schema_stmt (
  v_type text DEFAULT NULL, 
  v_server_name text DEFAULT NULL, 
  v_remote_schema text DEFAULT NULL, 
  v_local_schema text DEFAULT NULL, 
  v_list_type text DEFAULT NULL, 
  v_table_list jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ImportForeignSchemaStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ImportForeignSchemaStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ImportForeignSchemaStmt, server_name}', to_jsonb (v_server_name));
  result = ast.jsonb_set(result, '{ImportForeignSchemaStmt, remote_schema}', to_jsonb (v_remote_schema));
  result = ast.jsonb_set(result, '{ImportForeignSchemaStmt, local_schema}', to_jsonb (v_local_schema));
  result = ast.jsonb_set(result, '{ImportForeignSchemaStmt, list_type}', to_jsonb (v_list_type));
  result = ast.jsonb_set(result, '{ImportForeignSchemaStmt, table_list}', v_table_list);
  result = ast.jsonb_set(result, '{ImportForeignSchemaStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_policy_stmt (
  v_type text DEFAULT NULL, 
  v_policy_name text DEFAULT NULL, 
  v_table jsonb DEFAULT NULL, 
  v_cmd_name text DEFAULT NULL, 
  v_permissive boolean DEFAULT NULL, 
  v_roles jsonb DEFAULT NULL, 
  v_qual jsonb DEFAULT NULL, 
  v_with_check jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreatePolicyStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreatePolicyStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreatePolicyStmt, policy_name}', to_jsonb (v_policy_name));
  result = ast.jsonb_set(result, '{CreatePolicyStmt, table}', v_table);
  result = ast.jsonb_set(result, '{CreatePolicyStmt, cmd_name}', to_jsonb (v_cmd_name));
  result = ast.jsonb_set(result, '{CreatePolicyStmt, permissive}', to_jsonb (v_permissive));
  result = ast.jsonb_set(result, '{CreatePolicyStmt, roles}', v_roles);
  result = ast.jsonb_set(result, '{CreatePolicyStmt, qual}', v_qual);
  result = ast.jsonb_set(result, '{CreatePolicyStmt, with_check}', v_with_check);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_policy_stmt (
  v_type text DEFAULT NULL, 
  v_policy_name text DEFAULT NULL, 
  v_table jsonb DEFAULT NULL, 
  v_roles jsonb DEFAULT NULL, 
  v_qual jsonb DEFAULT NULL, 
  v_with_check jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterPolicyStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterPolicyStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterPolicyStmt, policy_name}', to_jsonb (v_policy_name));
  result = ast.jsonb_set(result, '{AlterPolicyStmt, table}', v_table);
  result = ast.jsonb_set(result, '{AlterPolicyStmt, roles}', v_roles);
  result = ast.jsonb_set(result, '{AlterPolicyStmt, qual}', v_qual);
  result = ast.jsonb_set(result, '{AlterPolicyStmt, with_check}', v_with_check);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_am_stmt (
  v_type text DEFAULT NULL, 
  v_amname text DEFAULT NULL, 
  v_handler_name jsonb DEFAULT NULL, 
  v_amtype text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateAmStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateAmStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateAmStmt, amname}', to_jsonb (v_amname));
  result = ast.jsonb_set(result, '{CreateAmStmt, handler_name}', v_handler_name);
  result = ast.jsonb_set(result, '{CreateAmStmt, amtype}', to_jsonb (v_amtype));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_trig_stmt (
  v_type text DEFAULT NULL, 
  v_trigname text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_funcname jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_row boolean DEFAULT NULL, 
  v_timing int DEFAULT NULL, 
  v_events int DEFAULT NULL, 
  v_columns jsonb DEFAULT NULL, 
  v_whenClause jsonb DEFAULT NULL, 
  v_isconstraint boolean DEFAULT NULL, 
  v_transitionRels jsonb DEFAULT NULL, 
  v_deferrable boolean DEFAULT NULL, 
  v_initdeferred boolean DEFAULT NULL, 
  v_constrrel jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateTrigStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateTrigStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateTrigStmt, trigname}', to_jsonb (v_trigname));
  result = ast.jsonb_set(result, '{CreateTrigStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{CreateTrigStmt, funcname}', v_funcname);
  result = ast.jsonb_set(result, '{CreateTrigStmt, args}', v_args);
  result = ast.jsonb_set(result, '{CreateTrigStmt, row}', to_jsonb (v_row));
  result = ast.jsonb_set(result, '{CreateTrigStmt, timing}', to_jsonb (v_timing));
  result = ast.jsonb_set(result, '{CreateTrigStmt, events}', to_jsonb (v_events));
  result = ast.jsonb_set(result, '{CreateTrigStmt, columns}', v_columns);
  result = ast.jsonb_set(result, '{CreateTrigStmt, whenClause}', v_whenClause);
  result = ast.jsonb_set(result, '{CreateTrigStmt, isconstraint}', to_jsonb (v_isconstraint));
  result = ast.jsonb_set(result, '{CreateTrigStmt, transitionRels}', v_transitionRels);
  result = ast.jsonb_set(result, '{CreateTrigStmt, deferrable}', to_jsonb (v_deferrable));
  result = ast.jsonb_set(result, '{CreateTrigStmt, initdeferred}', to_jsonb (v_initdeferred));
  result = ast.jsonb_set(result, '{CreateTrigStmt, constrrel}', v_constrrel);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_event_trig_stmt (
  v_type text DEFAULT NULL, 
  v_trigname text DEFAULT NULL, 
  v_eventname text DEFAULT NULL, 
  v_whenclause jsonb DEFAULT NULL, 
  v_funcname jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateEventTrigStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateEventTrigStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateEventTrigStmt, trigname}', to_jsonb (v_trigname));
  result = ast.jsonb_set(result, '{CreateEventTrigStmt, eventname}', to_jsonb (v_eventname));
  result = ast.jsonb_set(result, '{CreateEventTrigStmt, whenclause}', v_whenclause);
  result = ast.jsonb_set(result, '{CreateEventTrigStmt, funcname}', v_funcname);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_event_trig_stmt (
  v_type text DEFAULT NULL, 
  v_trigname text DEFAULT NULL, 
  v_tgenabled text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterEventTrigStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterEventTrigStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterEventTrigStmt, trigname}', to_jsonb (v_trigname));
  result = ast.jsonb_set(result, '{AlterEventTrigStmt, tgenabled}', to_jsonb (v_tgenabled));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_p_lang_stmt (
  v_type text DEFAULT NULL, 
  v_replace boolean DEFAULT NULL, 
  v_plname text DEFAULT NULL, 
  v_plhandler jsonb DEFAULT NULL, 
  v_plinline jsonb DEFAULT NULL, 
  v_plvalidator jsonb DEFAULT NULL, 
  v_pltrusted boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreatePLangStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreatePLangStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreatePLangStmt, replace}', to_jsonb (v_replace));
  result = ast.jsonb_set(result, '{CreatePLangStmt, plname}', to_jsonb (v_plname));
  result = ast.jsonb_set(result, '{CreatePLangStmt, plhandler}', v_plhandler);
  result = ast.jsonb_set(result, '{CreatePLangStmt, plinline}', v_plinline);
  result = ast.jsonb_set(result, '{CreatePLangStmt, plvalidator}', v_plvalidator);
  result = ast.jsonb_set(result, '{CreatePLangStmt, pltrusted}', to_jsonb (v_pltrusted));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_role_stmt (
  v_type text DEFAULT NULL, 
  v_stmt_type text DEFAULT NULL, 
  v_role text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateRoleStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateRoleStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateRoleStmt, stmt_type}', to_jsonb (v_stmt_type));
  result = ast.jsonb_set(result, '{CreateRoleStmt, role}', to_jsonb (v_role));
  result = ast.jsonb_set(result, '{CreateRoleStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_role_stmt (
  v_type text DEFAULT NULL, 
  v_role jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_action int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterRoleStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterRoleStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterRoleStmt, role}', v_role);
  result = ast.jsonb_set(result, '{AlterRoleStmt, options}', v_options);
  result = ast.jsonb_set(result, '{AlterRoleStmt, action}', to_jsonb (v_action));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_role_set_stmt (
  v_type text DEFAULT NULL, 
  v_role jsonb DEFAULT NULL, 
  v_database text DEFAULT NULL, 
  v_setstmt jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterRoleSetStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterRoleSetStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterRoleSetStmt, role}', v_role);
  result = ast.jsonb_set(result, '{AlterRoleSetStmt, database}', to_jsonb (v_database));
  result = ast.jsonb_set(result, '{AlterRoleSetStmt, setstmt}', v_setstmt);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.drop_role_stmt (
  v_type text DEFAULT NULL, 
  v_roles jsonb DEFAULT NULL, 
  v_missing_ok boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"DropRoleStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{DropRoleStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{DropRoleStmt, roles}', v_roles);
  result = ast.jsonb_set(result, '{DropRoleStmt, missing_ok}', to_jsonb (v_missing_ok));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_seq_stmt (
  v_type text DEFAULT NULL, 
  v_sequence jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_ownerId jsonb DEFAULT NULL, 
  v_for_identity boolean DEFAULT NULL, 
  v_if_not_exists boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateSeqStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateSeqStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateSeqStmt, sequence}', v_sequence);
  result = ast.jsonb_set(result, '{CreateSeqStmt, options}', v_options);
  result = ast.jsonb_set(result, '{CreateSeqStmt, ownerId}', v_ownerId);
  result = ast.jsonb_set(result, '{CreateSeqStmt, for_identity}', to_jsonb (v_for_identity));
  result = ast.jsonb_set(result, '{CreateSeqStmt, if_not_exists}', to_jsonb (v_if_not_exists));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_seq_stmt (
  v_type text DEFAULT NULL, 
  v_sequence jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_for_identity boolean DEFAULT NULL, 
  v_missing_ok boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterSeqStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterSeqStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterSeqStmt, sequence}', v_sequence);
  result = ast.jsonb_set(result, '{AlterSeqStmt, options}', v_options);
  result = ast.jsonb_set(result, '{AlterSeqStmt, for_identity}', to_jsonb (v_for_identity));
  result = ast.jsonb_set(result, '{AlterSeqStmt, missing_ok}', to_jsonb (v_missing_ok));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.define_stmt (
  v_type text DEFAULT NULL, 
  v_kind text DEFAULT NULL, 
  v_oldstyle boolean DEFAULT NULL, 
  v_defnames jsonb DEFAULT NULL, 
  v_args jsonb DEFAULT NULL, 
  v_definition jsonb DEFAULT NULL, 
  v_if_not_exists boolean DEFAULT NULL, 
  v_replace boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"DefineStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{DefineStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{DefineStmt, kind}', to_jsonb (v_kind));
  result = ast.jsonb_set(result, '{DefineStmt, oldstyle}', to_jsonb (v_oldstyle));
  result = ast.jsonb_set(result, '{DefineStmt, defnames}', v_defnames);
  result = ast.jsonb_set(result, '{DefineStmt, args}', v_args);
  result = ast.jsonb_set(result, '{DefineStmt, definition}', v_definition);
  result = ast.jsonb_set(result, '{DefineStmt, if_not_exists}', to_jsonb (v_if_not_exists));
  result = ast.jsonb_set(result, '{DefineStmt, replace}', to_jsonb (v_replace));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_domain_stmt (
  v_type text DEFAULT NULL, 
  v_domainname jsonb DEFAULT NULL, 
  v_typeName jsonb DEFAULT NULL, 
  v_collClause jsonb DEFAULT NULL, 
  v_constraints jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateDomainStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateDomainStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateDomainStmt, domainname}', v_domainname);
  result = ast.jsonb_set(result, '{CreateDomainStmt, typeName}', v_typeName);
  result = ast.jsonb_set(result, '{CreateDomainStmt, collClause}', v_collClause);
  result = ast.jsonb_set(result, '{CreateDomainStmt, constraints}', v_constraints);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_op_class_stmt (
  v_type text DEFAULT NULL, 
  v_opclassname jsonb DEFAULT NULL, 
  v_opfamilyname jsonb DEFAULT NULL, 
  v_amname text DEFAULT NULL, 
  v_datatype jsonb DEFAULT NULL, 
  v_items jsonb DEFAULT NULL, 
  v_isDefault boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateOpClassStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateOpClassStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateOpClassStmt, opclassname}', v_opclassname);
  result = ast.jsonb_set(result, '{CreateOpClassStmt, opfamilyname}', v_opfamilyname);
  result = ast.jsonb_set(result, '{CreateOpClassStmt, amname}', to_jsonb (v_amname));
  result = ast.jsonb_set(result, '{CreateOpClassStmt, datatype}', v_datatype);
  result = ast.jsonb_set(result, '{CreateOpClassStmt, items}', v_items);
  result = ast.jsonb_set(result, '{CreateOpClassStmt, isDefault}', to_jsonb (v_isDefault));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_op_class_item (
  v_type text DEFAULT NULL, 
  v_itemtype int DEFAULT NULL, 
  v_name jsonb DEFAULT NULL, 
  v_number int DEFAULT NULL, 
  v_order_family jsonb DEFAULT NULL, 
  v_class_args jsonb DEFAULT NULL, 
  v_storedtype jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateOpClassItem":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateOpClassItem, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateOpClassItem, itemtype}', to_jsonb (v_itemtype));
  result = ast.jsonb_set(result, '{CreateOpClassItem, name}', v_name);
  result = ast.jsonb_set(result, '{CreateOpClassItem, number}', to_jsonb (v_number));
  result = ast.jsonb_set(result, '{CreateOpClassItem, order_family}', v_order_family);
  result = ast.jsonb_set(result, '{CreateOpClassItem, class_args}', v_class_args);
  result = ast.jsonb_set(result, '{CreateOpClassItem, storedtype}', v_storedtype);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_op_family_stmt (
  v_type text DEFAULT NULL, 
  v_opfamilyname jsonb DEFAULT NULL, 
  v_amname text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateOpFamilyStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateOpFamilyStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateOpFamilyStmt, opfamilyname}', v_opfamilyname);
  result = ast.jsonb_set(result, '{CreateOpFamilyStmt, amname}', to_jsonb (v_amname));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_op_family_stmt (
  v_type text DEFAULT NULL, 
  v_opfamilyname jsonb DEFAULT NULL, 
  v_amname text DEFAULT NULL, 
  v_isDrop boolean DEFAULT NULL, 
  v_items jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterOpFamilyStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterOpFamilyStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterOpFamilyStmt, opfamilyname}', v_opfamilyname);
  result = ast.jsonb_set(result, '{AlterOpFamilyStmt, amname}', to_jsonb (v_amname));
  result = ast.jsonb_set(result, '{AlterOpFamilyStmt, isDrop}', to_jsonb (v_isDrop));
  result = ast.jsonb_set(result, '{AlterOpFamilyStmt, items}', v_items);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.drop_stmt (
  v_type text DEFAULT NULL, 
  v_objects jsonb DEFAULT NULL, 
  v_removeType text DEFAULT NULL, 
  v_behavior text DEFAULT NULL, 
  v_missing_ok boolean DEFAULT NULL, 
  v_concurrent boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"DropStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{DropStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{DropStmt, objects}', v_objects);
  result = ast.jsonb_set(result, '{DropStmt, removeType}', to_jsonb (v_removeType));
  result = ast.jsonb_set(result, '{DropStmt, behavior}', to_jsonb (v_behavior));
  result = ast.jsonb_set(result, '{DropStmt, missing_ok}', to_jsonb (v_missing_ok));
  result = ast.jsonb_set(result, '{DropStmt, concurrent}', to_jsonb (v_concurrent));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.truncate_stmt (
  v_type text DEFAULT NULL, 
  v_relations jsonb DEFAULT NULL, 
  v_restart_seqs boolean DEFAULT NULL, 
  v_behavior text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"TruncateStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{TruncateStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{TruncateStmt, relations}', v_relations);
  result = ast.jsonb_set(result, '{TruncateStmt, restart_seqs}', to_jsonb (v_restart_seqs));
  result = ast.jsonb_set(result, '{TruncateStmt, behavior}', to_jsonb (v_behavior));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.comment_stmt (
  v_type text DEFAULT NULL, 
  v_objtype text DEFAULT NULL, 
  v_object jsonb DEFAULT NULL, 
  v_comment text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CommentStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CommentStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CommentStmt, objtype}', to_jsonb (v_objtype));
  result = ast.jsonb_set(result, '{CommentStmt, object}', v_object);
  result = ast.jsonb_set(result, '{CommentStmt, comment}', to_jsonb (v_comment));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.sec_label_stmt (
  v_type text DEFAULT NULL, 
  v_objtype text DEFAULT NULL, 
  v_object jsonb DEFAULT NULL, 
  v_provider text DEFAULT NULL, 
  v_label text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"SecLabelStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{SecLabelStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{SecLabelStmt, objtype}', to_jsonb (v_objtype));
  result = ast.jsonb_set(result, '{SecLabelStmt, object}', v_object);
  result = ast.jsonb_set(result, '{SecLabelStmt, provider}', to_jsonb (v_provider));
  result = ast.jsonb_set(result, '{SecLabelStmt, label}', to_jsonb (v_label));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.declare_cursor_stmt (
  v_type text DEFAULT NULL, 
  v_portalname text DEFAULT NULL, 
  v_options int DEFAULT NULL, 
  v_query jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"DeclareCursorStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{DeclareCursorStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{DeclareCursorStmt, portalname}', to_jsonb (v_portalname));
  result = ast.jsonb_set(result, '{DeclareCursorStmt, options}', to_jsonb (v_options));
  result = ast.jsonb_set(result, '{DeclareCursorStmt, query}', v_query);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.close_portal_stmt (
  v_type text DEFAULT NULL, 
  v_portalname text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ClosePortalStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ClosePortalStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ClosePortalStmt, portalname}', to_jsonb (v_portalname));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.fetch_stmt (
  v_type text DEFAULT NULL, 
  v_direction text DEFAULT NULL, 
  v_howMany bigint DEFAULT NULL, 
  v_portalname text DEFAULT NULL, 
  v_ismove boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"FetchStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{FetchStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{FetchStmt, direction}', to_jsonb (v_direction));
  result = ast.jsonb_set(result, '{FetchStmt, howMany}', to_jsonb (v_howMany));
  result = ast.jsonb_set(result, '{FetchStmt, portalname}', to_jsonb (v_portalname));
  result = ast.jsonb_set(result, '{FetchStmt, ismove}', to_jsonb (v_ismove));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.index_stmt (
  v_type text DEFAULT NULL, 
  v_idxname text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_accessMethod text DEFAULT NULL, 
  v_tableSpace text DEFAULT NULL, 
  v_indexParams jsonb DEFAULT NULL, 
  v_indexIncludingParams jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_whereClause jsonb DEFAULT NULL, 
  v_excludeOpNames jsonb DEFAULT NULL, 
  v_idxcomment text DEFAULT NULL, 
  v_indexOid jsonb DEFAULT NULL, 
  v_oldNode jsonb DEFAULT NULL, 
  v_oldCreateSubid jsonb DEFAULT NULL, 
  v_oldFirstRelfilenodeSubid jsonb DEFAULT NULL, 
  v_unique boolean DEFAULT NULL, 
  v_primary boolean DEFAULT NULL, 
  v_isconstraint boolean DEFAULT NULL, 
  v_deferrable boolean DEFAULT NULL, 
  v_initdeferred boolean DEFAULT NULL, 
  v_transformed boolean DEFAULT NULL, 
  v_concurrent boolean DEFAULT NULL, 
  v_if_not_exists boolean DEFAULT NULL, 
  v_reset_default_tblspc boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"IndexStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{IndexStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{IndexStmt, idxname}', to_jsonb (v_idxname));
  result = ast.jsonb_set(result, '{IndexStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{IndexStmt, accessMethod}', to_jsonb (v_accessMethod));
  result = ast.jsonb_set(result, '{IndexStmt, tableSpace}', to_jsonb (v_tableSpace));
  result = ast.jsonb_set(result, '{IndexStmt, indexParams}', v_indexParams);
  result = ast.jsonb_set(result, '{IndexStmt, indexIncludingParams}', v_indexIncludingParams);
  result = ast.jsonb_set(result, '{IndexStmt, options}', v_options);
  result = ast.jsonb_set(result, '{IndexStmt, whereClause}', v_whereClause);
  result = ast.jsonb_set(result, '{IndexStmt, excludeOpNames}', v_excludeOpNames);
  result = ast.jsonb_set(result, '{IndexStmt, idxcomment}', to_jsonb (v_idxcomment));
  result = ast.jsonb_set(result, '{IndexStmt, indexOid}', v_indexOid);
  result = ast.jsonb_set(result, '{IndexStmt, oldNode}', v_oldNode);
  result = ast.jsonb_set(result, '{IndexStmt, oldCreateSubid}', v_oldCreateSubid);
  result = ast.jsonb_set(result, '{IndexStmt, oldFirstRelfilenodeSubid}', v_oldFirstRelfilenodeSubid);
  result = ast.jsonb_set(result, '{IndexStmt, unique}', to_jsonb (v_unique));
  result = ast.jsonb_set(result, '{IndexStmt, primary}', to_jsonb (v_primary));
  result = ast.jsonb_set(result, '{IndexStmt, isconstraint}', to_jsonb (v_isconstraint));
  result = ast.jsonb_set(result, '{IndexStmt, deferrable}', to_jsonb (v_deferrable));
  result = ast.jsonb_set(result, '{IndexStmt, initdeferred}', to_jsonb (v_initdeferred));
  result = ast.jsonb_set(result, '{IndexStmt, transformed}', to_jsonb (v_transformed));
  result = ast.jsonb_set(result, '{IndexStmt, concurrent}', to_jsonb (v_concurrent));
  result = ast.jsonb_set(result, '{IndexStmt, if_not_exists}', to_jsonb (v_if_not_exists));
  result = ast.jsonb_set(result, '{IndexStmt, reset_default_tblspc}', to_jsonb (v_reset_default_tblspc));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_stats_stmt (
  v_type text DEFAULT NULL, 
  v_defnames jsonb DEFAULT NULL, 
  v_stat_types jsonb DEFAULT NULL, 
  v_exprs jsonb DEFAULT NULL, 
  v_relations jsonb DEFAULT NULL, 
  v_stxcomment text DEFAULT NULL, 
  v_if_not_exists boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateStatsStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateStatsStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateStatsStmt, defnames}', v_defnames);
  result = ast.jsonb_set(result, '{CreateStatsStmt, stat_types}', v_stat_types);
  result = ast.jsonb_set(result, '{CreateStatsStmt, exprs}', v_exprs);
  result = ast.jsonb_set(result, '{CreateStatsStmt, relations}', v_relations);
  result = ast.jsonb_set(result, '{CreateStatsStmt, stxcomment}', to_jsonb (v_stxcomment));
  result = ast.jsonb_set(result, '{CreateStatsStmt, if_not_exists}', to_jsonb (v_if_not_exists));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_stats_stmt (
  v_type text DEFAULT NULL, 
  v_defnames jsonb DEFAULT NULL, 
  v_stxstattarget int DEFAULT NULL, 
  v_missing_ok boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterStatsStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterStatsStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterStatsStmt, defnames}', v_defnames);
  result = ast.jsonb_set(result, '{AlterStatsStmt, stxstattarget}', to_jsonb (v_stxstattarget));
  result = ast.jsonb_set(result, '{AlterStatsStmt, missing_ok}', to_jsonb (v_missing_ok));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_function_stmt (
  v_type text DEFAULT NULL, 
  v_is_procedure boolean DEFAULT NULL, 
  v_replace boolean DEFAULT NULL, 
  v_funcname jsonb DEFAULT NULL, 
  v_parameters jsonb DEFAULT NULL, 
  v_returnType jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateFunctionStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateFunctionStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateFunctionStmt, is_procedure}', to_jsonb (v_is_procedure));
  result = ast.jsonb_set(result, '{CreateFunctionStmt, replace}', to_jsonb (v_replace));
  result = ast.jsonb_set(result, '{CreateFunctionStmt, funcname}', v_funcname);
  result = ast.jsonb_set(result, '{CreateFunctionStmt, parameters}', v_parameters);
  result = ast.jsonb_set(result, '{CreateFunctionStmt, returnType}', v_returnType);
  result = ast.jsonb_set(result, '{CreateFunctionStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.function_parameter (
  v_type text DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_argType jsonb DEFAULT NULL, 
  v_mode text DEFAULT NULL, 
  v_defexpr jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"FunctionParameter":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{FunctionParameter, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{FunctionParameter, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{FunctionParameter, argType}', v_argType);
  result = ast.jsonb_set(result, '{FunctionParameter, mode}', to_jsonb (v_mode));
  result = ast.jsonb_set(result, '{FunctionParameter, defexpr}', v_defexpr);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_function_stmt (
  v_type text DEFAULT NULL, 
  v_objtype text DEFAULT NULL, 
  v_func jsonb DEFAULT NULL, 
  v_actions jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterFunctionStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterFunctionStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterFunctionStmt, objtype}', to_jsonb (v_objtype));
  result = ast.jsonb_set(result, '{AlterFunctionStmt, func}', v_func);
  result = ast.jsonb_set(result, '{AlterFunctionStmt, actions}', v_actions);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.do_stmt (
  v_type text DEFAULT NULL, 
  v_args jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"DoStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{DoStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{DoStmt, args}', v_args);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.inline_code_block (
  v_type text DEFAULT NULL, 
  v_source_text text DEFAULT NULL, 
  v_langOid jsonb DEFAULT NULL, 
  v_langIsTrusted boolean DEFAULT NULL, 
  v_atomic boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"InlineCodeBlock":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{InlineCodeBlock, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{InlineCodeBlock, source_text}', to_jsonb (v_source_text));
  result = ast.jsonb_set(result, '{InlineCodeBlock, langOid}', v_langOid);
  result = ast.jsonb_set(result, '{InlineCodeBlock, langIsTrusted}', to_jsonb (v_langIsTrusted));
  result = ast.jsonb_set(result, '{InlineCodeBlock, atomic}', to_jsonb (v_atomic));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.call_stmt (
  v_type text DEFAULT NULL, 
  v_funccall jsonb DEFAULT NULL, 
  v_funcexpr jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CallStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CallStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CallStmt, funccall}', v_funccall);
  result = ast.jsonb_set(result, '{CallStmt, funcexpr}', v_funcexpr);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.call_context (
  v_type text DEFAULT NULL, 
  v_atomic boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CallContext":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CallContext, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CallContext, atomic}', to_jsonb (v_atomic));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.rename_stmt (
  v_type text DEFAULT NULL, 
  v_renameType text DEFAULT NULL, 
  v_relationType text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_object jsonb DEFAULT NULL, 
  v_subname text DEFAULT NULL, 
  v_newname text DEFAULT NULL, 
  v_behavior text DEFAULT NULL, 
  v_missing_ok boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RenameStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RenameStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RenameStmt, renameType}', to_jsonb (v_renameType));
  result = ast.jsonb_set(result, '{RenameStmt, relationType}', to_jsonb (v_relationType));
  result = ast.jsonb_set(result, '{RenameStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{RenameStmt, object}', v_object);
  result = ast.jsonb_set(result, '{RenameStmt, subname}', to_jsonb (v_subname));
  result = ast.jsonb_set(result, '{RenameStmt, newname}', to_jsonb (v_newname));
  result = ast.jsonb_set(result, '{RenameStmt, behavior}', to_jsonb (v_behavior));
  result = ast.jsonb_set(result, '{RenameStmt, missing_ok}', to_jsonb (v_missing_ok));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_object_depends_stmt (
  v_type text DEFAULT NULL, 
  v_objectType text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_object jsonb DEFAULT NULL, 
  v_extname jsonb DEFAULT NULL, 
  v_remove boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterObjectDependsStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterObjectDependsStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterObjectDependsStmt, objectType}', to_jsonb (v_objectType));
  result = ast.jsonb_set(result, '{AlterObjectDependsStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{AlterObjectDependsStmt, object}', v_object);
  result = ast.jsonb_set(result, '{AlterObjectDependsStmt, extname}', v_extname);
  result = ast.jsonb_set(result, '{AlterObjectDependsStmt, remove}', to_jsonb (v_remove));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_object_schema_stmt (
  v_type text DEFAULT NULL, 
  v_objectType text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_object jsonb DEFAULT NULL, 
  v_newschema text DEFAULT NULL, 
  v_missing_ok boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterObjectSchemaStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, objectType}', to_jsonb (v_objectType));
  result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, object}', v_object);
  result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, newschema}', to_jsonb (v_newschema));
  result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, missing_ok}', to_jsonb (v_missing_ok));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_owner_stmt (
  v_type text DEFAULT NULL, 
  v_objectType text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_object jsonb DEFAULT NULL, 
  v_newowner jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterOwnerStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterOwnerStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterOwnerStmt, objectType}', to_jsonb (v_objectType));
  result = ast.jsonb_set(result, '{AlterOwnerStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{AlterOwnerStmt, object}', v_object);
  result = ast.jsonb_set(result, '{AlterOwnerStmt, newowner}', v_newowner);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_operator_stmt (
  v_type text DEFAULT NULL, 
  v_opername jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterOperatorStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterOperatorStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterOperatorStmt, opername}', v_opername);
  result = ast.jsonb_set(result, '{AlterOperatorStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_type_stmt (
  v_type text DEFAULT NULL, 
  v_typeName jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterTypeStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterTypeStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterTypeStmt, typeName}', v_typeName);
  result = ast.jsonb_set(result, '{AlterTypeStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.rule_stmt (
  v_type text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_rulename text DEFAULT NULL, 
  v_whereClause jsonb DEFAULT NULL, 
  v_event text DEFAULT NULL, 
  v_instead boolean DEFAULT NULL, 
  v_actions jsonb DEFAULT NULL, 
  v_replace boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RuleStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RuleStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RuleStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{RuleStmt, rulename}', to_jsonb (v_rulename));
  result = ast.jsonb_set(result, '{RuleStmt, whereClause}', v_whereClause);
  result = ast.jsonb_set(result, '{RuleStmt, event}', to_jsonb (v_event));
  result = ast.jsonb_set(result, '{RuleStmt, instead}', to_jsonb (v_instead));
  result = ast.jsonb_set(result, '{RuleStmt, actions}', v_actions);
  result = ast.jsonb_set(result, '{RuleStmt, replace}', to_jsonb (v_replace));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.notify_stmt (
  v_type text DEFAULT NULL, 
  v_conditionname text DEFAULT NULL, 
  v_payload text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"NotifyStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{NotifyStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{NotifyStmt, conditionname}', to_jsonb (v_conditionname));
  result = ast.jsonb_set(result, '{NotifyStmt, payload}', to_jsonb (v_payload));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.listen_stmt (
  v_type text DEFAULT NULL, 
  v_conditionname text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ListenStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ListenStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ListenStmt, conditionname}', to_jsonb (v_conditionname));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.unlisten_stmt (
  v_type text DEFAULT NULL, 
  v_conditionname text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"UnlistenStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{UnlistenStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{UnlistenStmt, conditionname}', to_jsonb (v_conditionname));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.transaction_stmt (
  v_type text DEFAULT NULL, 
  v_kind text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_savepoint_name text DEFAULT NULL, 
  v_gid text DEFAULT NULL, 
  v_chain boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"TransactionStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{TransactionStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{TransactionStmt, kind}', to_jsonb (v_kind));
  result = ast.jsonb_set(result, '{TransactionStmt, options}', v_options);
  result = ast.jsonb_set(result, '{TransactionStmt, savepoint_name}', to_jsonb (v_savepoint_name));
  result = ast.jsonb_set(result, '{TransactionStmt, gid}', to_jsonb (v_gid));
  result = ast.jsonb_set(result, '{TransactionStmt, chain}', to_jsonb (v_chain));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.composite_type_stmt (
  v_type text DEFAULT NULL, 
  v_typevar jsonb DEFAULT NULL, 
  v_coldeflist jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CompositeTypeStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CompositeTypeStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CompositeTypeStmt, typevar}', v_typevar);
  result = ast.jsonb_set(result, '{CompositeTypeStmt, coldeflist}', v_coldeflist);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_enum_stmt (
  v_type text DEFAULT NULL, 
  v_typeName jsonb DEFAULT NULL, 
  v_vals jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateEnumStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateEnumStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateEnumStmt, typeName}', v_typeName);
  result = ast.jsonb_set(result, '{CreateEnumStmt, vals}', v_vals);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_range_stmt (
  v_type text DEFAULT NULL, 
  v_typeName jsonb DEFAULT NULL, 
  v_params jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateRangeStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateRangeStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateRangeStmt, typeName}', v_typeName);
  result = ast.jsonb_set(result, '{CreateRangeStmt, params}', v_params);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_enum_stmt (
  v_type text DEFAULT NULL, 
  v_typeName jsonb DEFAULT NULL, 
  v_oldVal text DEFAULT NULL, 
  v_newVal text DEFAULT NULL, 
  v_newValNeighbor text DEFAULT NULL, 
  v_newValIsAfter boolean DEFAULT NULL, 
  v_skipIfNewValExists boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterEnumStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterEnumStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterEnumStmt, typeName}', v_typeName);
  result = ast.jsonb_set(result, '{AlterEnumStmt, oldVal}', to_jsonb (v_oldVal));
  result = ast.jsonb_set(result, '{AlterEnumStmt, newVal}', to_jsonb (v_newVal));
  result = ast.jsonb_set(result, '{AlterEnumStmt, newValNeighbor}', to_jsonb (v_newValNeighbor));
  result = ast.jsonb_set(result, '{AlterEnumStmt, newValIsAfter}', to_jsonb (v_newValIsAfter));
  result = ast.jsonb_set(result, '{AlterEnumStmt, skipIfNewValExists}', to_jsonb (v_skipIfNewValExists));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.view_stmt (
  v_type text DEFAULT NULL, 
  v_view jsonb DEFAULT NULL, 
  v_aliases jsonb DEFAULT NULL, 
  v_query jsonb DEFAULT NULL, 
  v_replace boolean DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_withCheckOption text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ViewStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ViewStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ViewStmt, view}', v_view);
  result = ast.jsonb_set(result, '{ViewStmt, aliases}', v_aliases);
  result = ast.jsonb_set(result, '{ViewStmt, query}', v_query);
  result = ast.jsonb_set(result, '{ViewStmt, replace}', to_jsonb (v_replace));
  result = ast.jsonb_set(result, '{ViewStmt, options}', v_options);
  result = ast.jsonb_set(result, '{ViewStmt, withCheckOption}', to_jsonb (v_withCheckOption));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.load_stmt (
  v_type text DEFAULT NULL, 
  v_filename text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"LoadStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{LoadStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{LoadStmt, filename}', to_jsonb (v_filename));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.createdb_stmt (
  v_type text DEFAULT NULL, 
  v_dbname text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreatedbStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreatedbStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreatedbStmt, dbname}', to_jsonb (v_dbname));
  result = ast.jsonb_set(result, '{CreatedbStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_database_stmt (
  v_type text DEFAULT NULL, 
  v_dbname text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterDatabaseStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterDatabaseStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterDatabaseStmt, dbname}', to_jsonb (v_dbname));
  result = ast.jsonb_set(result, '{AlterDatabaseStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_database_set_stmt (
  v_type text DEFAULT NULL, 
  v_dbname text DEFAULT NULL, 
  v_setstmt jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterDatabaseSetStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterDatabaseSetStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterDatabaseSetStmt, dbname}', to_jsonb (v_dbname));
  result = ast.jsonb_set(result, '{AlterDatabaseSetStmt, setstmt}', v_setstmt);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.dropdb_stmt (
  v_type text DEFAULT NULL, 
  v_dbname text DEFAULT NULL, 
  v_missing_ok boolean DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"DropdbStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{DropdbStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{DropdbStmt, dbname}', to_jsonb (v_dbname));
  result = ast.jsonb_set(result, '{DropdbStmt, missing_ok}', to_jsonb (v_missing_ok));
  result = ast.jsonb_set(result, '{DropdbStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_system_stmt (
  v_type text DEFAULT NULL, 
  v_setstmt jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterSystemStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterSystemStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterSystemStmt, setstmt}', v_setstmt);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.cluster_stmt (
  v_type text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_indexname text DEFAULT NULL, 
  v_options int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ClusterStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ClusterStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ClusterStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{ClusterStmt, indexname}', to_jsonb (v_indexname));
  result = ast.jsonb_set(result, '{ClusterStmt, options}', to_jsonb (v_options));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.vacuum_stmt (
  v_type text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_rels jsonb DEFAULT NULL, 
  v_is_vacuumcmd boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"VacuumStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{VacuumStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{VacuumStmt, options}', v_options);
  result = ast.jsonb_set(result, '{VacuumStmt, rels}', v_rels);
  result = ast.jsonb_set(result, '{VacuumStmt, is_vacuumcmd}', to_jsonb (v_is_vacuumcmd));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.vacuum_relation (
  v_type text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_oid jsonb DEFAULT NULL, 
  v_va_cols jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"VacuumRelation":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{VacuumRelation, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{VacuumRelation, relation}', v_relation);
  result = ast.jsonb_set(result, '{VacuumRelation, oid}', v_oid);
  result = ast.jsonb_set(result, '{VacuumRelation, va_cols}', v_va_cols);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.explain_stmt (
  v_type text DEFAULT NULL, 
  v_query jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ExplainStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ExplainStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ExplainStmt, query}', v_query);
  result = ast.jsonb_set(result, '{ExplainStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_table_as_stmt (
  v_type text DEFAULT NULL, 
  v_query jsonb DEFAULT NULL, 
  v_into jsonb DEFAULT NULL, 
  v_relkind text DEFAULT NULL, 
  v_is_select_into boolean DEFAULT NULL, 
  v_if_not_exists boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateTableAsStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateTableAsStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateTableAsStmt, query}', v_query);
  result = ast.jsonb_set(result, '{CreateTableAsStmt, into}', v_into);
  result = ast.jsonb_set(result, '{CreateTableAsStmt, relkind}', to_jsonb (v_relkind));
  result = ast.jsonb_set(result, '{CreateTableAsStmt, is_select_into}', to_jsonb (v_is_select_into));
  result = ast.jsonb_set(result, '{CreateTableAsStmt, if_not_exists}', to_jsonb (v_if_not_exists));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.refresh_mat_view_stmt (
  v_type text DEFAULT NULL, 
  v_concurrent boolean DEFAULT NULL, 
  v_skipData boolean DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"RefreshMatViewStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{RefreshMatViewStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{RefreshMatViewStmt, concurrent}', to_jsonb (v_concurrent));
  result = ast.jsonb_set(result, '{RefreshMatViewStmt, skipData}', to_jsonb (v_skipData));
  result = ast.jsonb_set(result, '{RefreshMatViewStmt, relation}', v_relation);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.check_point_stmt (
  v_type text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CheckPointStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CheckPointStmt, type}', to_jsonb (v_type));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.discard_stmt (
  v_type text DEFAULT NULL, 
  v_target text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"DiscardStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{DiscardStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{DiscardStmt, target}', to_jsonb (v_target));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.lock_stmt (
  v_type text DEFAULT NULL, 
  v_relations jsonb DEFAULT NULL, 
  v_mode int DEFAULT NULL, 
  v_nowait boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"LockStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{LockStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{LockStmt, relations}', v_relations);
  result = ast.jsonb_set(result, '{LockStmt, mode}', to_jsonb (v_mode));
  result = ast.jsonb_set(result, '{LockStmt, nowait}', to_jsonb (v_nowait));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.constraints_set_stmt (
  v_type text DEFAULT NULL, 
  v_constraints jsonb DEFAULT NULL, 
  v_deferred boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ConstraintsSetStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ConstraintsSetStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ConstraintsSetStmt, constraints}', v_constraints);
  result = ast.jsonb_set(result, '{ConstraintsSetStmt, deferred}', to_jsonb (v_deferred));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.reindex_stmt (
  v_type text DEFAULT NULL, 
  v_kind text DEFAULT NULL, 
  v_relation jsonb DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_options int DEFAULT NULL, 
  v_concurrent boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ReindexStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ReindexStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ReindexStmt, kind}', to_jsonb (v_kind));
  result = ast.jsonb_set(result, '{ReindexStmt, relation}', v_relation);
  result = ast.jsonb_set(result, '{ReindexStmt, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{ReindexStmt, options}', to_jsonb (v_options));
  result = ast.jsonb_set(result, '{ReindexStmt, concurrent}', to_jsonb (v_concurrent));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_conversion_stmt (
  v_type text DEFAULT NULL, 
  v_conversion_name jsonb DEFAULT NULL, 
  v_for_encoding_name text DEFAULT NULL, 
  v_to_encoding_name text DEFAULT NULL, 
  v_func_name jsonb DEFAULT NULL, 
  v_def boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateConversionStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateConversionStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateConversionStmt, conversion_name}', v_conversion_name);
  result = ast.jsonb_set(result, '{CreateConversionStmt, for_encoding_name}', to_jsonb (v_for_encoding_name));
  result = ast.jsonb_set(result, '{CreateConversionStmt, to_encoding_name}', to_jsonb (v_to_encoding_name));
  result = ast.jsonb_set(result, '{CreateConversionStmt, func_name}', v_func_name);
  result = ast.jsonb_set(result, '{CreateConversionStmt, def}', to_jsonb (v_def));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_cast_stmt (
  v_type text DEFAULT NULL, 
  v_sourcetype jsonb DEFAULT NULL, 
  v_targettype jsonb DEFAULT NULL, 
  v_func jsonb DEFAULT NULL, 
  v_context text DEFAULT NULL, 
  v_inout boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateCastStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateCastStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateCastStmt, sourcetype}', v_sourcetype);
  result = ast.jsonb_set(result, '{CreateCastStmt, targettype}', v_targettype);
  result = ast.jsonb_set(result, '{CreateCastStmt, func}', v_func);
  result = ast.jsonb_set(result, '{CreateCastStmt, context}', to_jsonb (v_context));
  result = ast.jsonb_set(result, '{CreateCastStmt, inout}', to_jsonb (v_inout));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_transform_stmt (
  v_type text DEFAULT NULL, 
  v_replace boolean DEFAULT NULL, 
  v_type_name jsonb DEFAULT NULL, 
  v_lang text DEFAULT NULL, 
  v_fromsql jsonb DEFAULT NULL, 
  v_tosql jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateTransformStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateTransformStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateTransformStmt, replace}', to_jsonb (v_replace));
  result = ast.jsonb_set(result, '{CreateTransformStmt, type_name}', v_type_name);
  result = ast.jsonb_set(result, '{CreateTransformStmt, lang}', to_jsonb (v_lang));
  result = ast.jsonb_set(result, '{CreateTransformStmt, fromsql}', v_fromsql);
  result = ast.jsonb_set(result, '{CreateTransformStmt, tosql}', v_tosql);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.prepare_stmt (
  v_type text DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_argtypes jsonb DEFAULT NULL, 
  v_query jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"PrepareStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{PrepareStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{PrepareStmt, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{PrepareStmt, argtypes}', v_argtypes);
  result = ast.jsonb_set(result, '{PrepareStmt, query}', v_query);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.execute_stmt (
  v_type text DEFAULT NULL, 
  v_name text DEFAULT NULL, 
  v_params jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ExecuteStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ExecuteStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ExecuteStmt, name}', to_jsonb (v_name));
  result = ast.jsonb_set(result, '{ExecuteStmt, params}', v_params);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.deallocate_stmt (
  v_type text DEFAULT NULL, 
  v_name text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"DeallocateStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{DeallocateStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{DeallocateStmt, name}', to_jsonb (v_name));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.drop_owned_stmt (
  v_type text DEFAULT NULL, 
  v_roles jsonb DEFAULT NULL, 
  v_behavior text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"DropOwnedStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{DropOwnedStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{DropOwnedStmt, roles}', v_roles);
  result = ast.jsonb_set(result, '{DropOwnedStmt, behavior}', to_jsonb (v_behavior));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.reassign_owned_stmt (
  v_type text DEFAULT NULL, 
  v_roles jsonb DEFAULT NULL, 
  v_newrole jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"ReassignOwnedStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{ReassignOwnedStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{ReassignOwnedStmt, roles}', v_roles);
  result = ast.jsonb_set(result, '{ReassignOwnedStmt, newrole}', v_newrole);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_ts_dictionary_stmt (
  v_type text DEFAULT NULL, 
  v_dictname jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterTSDictionaryStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterTSDictionaryStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterTSDictionaryStmt, dictname}', v_dictname);
  result = ast.jsonb_set(result, '{AlterTSDictionaryStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_ts_configuration_stmt (
  v_type text DEFAULT NULL, 
  v_kind text DEFAULT NULL, 
  v_cfgname jsonb DEFAULT NULL, 
  v_tokentype jsonb DEFAULT NULL, 
  v_dicts jsonb DEFAULT NULL, 
  v_override boolean DEFAULT NULL, 
  v_replace boolean DEFAULT NULL, 
  v_missing_ok boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterTSConfigurationStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, kind}', to_jsonb (v_kind));
  result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, cfgname}', v_cfgname);
  result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, tokentype}', v_tokentype);
  result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, dicts}', v_dicts);
  result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, override}', to_jsonb (v_override));
  result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, replace}', to_jsonb (v_replace));
  result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, missing_ok}', to_jsonb (v_missing_ok));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_publication_stmt (
  v_type text DEFAULT NULL, 
  v_pubname text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_tables jsonb DEFAULT NULL, 
  v_for_all_tables boolean DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreatePublicationStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreatePublicationStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreatePublicationStmt, pubname}', to_jsonb (v_pubname));
  result = ast.jsonb_set(result, '{CreatePublicationStmt, options}', v_options);
  result = ast.jsonb_set(result, '{CreatePublicationStmt, tables}', v_tables);
  result = ast.jsonb_set(result, '{CreatePublicationStmt, for_all_tables}', to_jsonb (v_for_all_tables));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_publication_stmt (
  v_type text DEFAULT NULL, 
  v_pubname text DEFAULT NULL, 
  v_options jsonb DEFAULT NULL, 
  v_tables jsonb DEFAULT NULL, 
  v_for_all_tables boolean DEFAULT NULL, 
  v_tableAction text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterPublicationStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterPublicationStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterPublicationStmt, pubname}', to_jsonb (v_pubname));
  result = ast.jsonb_set(result, '{AlterPublicationStmt, options}', v_options);
  result = ast.jsonb_set(result, '{AlterPublicationStmt, tables}', v_tables);
  result = ast.jsonb_set(result, '{AlterPublicationStmt, for_all_tables}', to_jsonb (v_for_all_tables));
  result = ast.jsonb_set(result, '{AlterPublicationStmt, tableAction}', to_jsonb (v_tableAction));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.create_subscription_stmt (
  v_type text DEFAULT NULL, 
  v_subname text DEFAULT NULL, 
  v_conninfo text DEFAULT NULL, 
  v_publication jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"CreateSubscriptionStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{CreateSubscriptionStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{CreateSubscriptionStmt, subname}', to_jsonb (v_subname));
  result = ast.jsonb_set(result, '{CreateSubscriptionStmt, conninfo}', to_jsonb (v_conninfo));
  result = ast.jsonb_set(result, '{CreateSubscriptionStmt, publication}', v_publication);
  result = ast.jsonb_set(result, '{CreateSubscriptionStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.alter_subscription_stmt (
  v_type text DEFAULT NULL, 
  v_kind text DEFAULT NULL, 
  v_subname text DEFAULT NULL, 
  v_conninfo text DEFAULT NULL, 
  v_publication jsonb DEFAULT NULL, 
  v_options jsonb DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"AlterSubscriptionStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{AlterSubscriptionStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{AlterSubscriptionStmt, kind}', to_jsonb (v_kind));
  result = ast.jsonb_set(result, '{AlterSubscriptionStmt, subname}', to_jsonb (v_subname));
  result = ast.jsonb_set(result, '{AlterSubscriptionStmt, conninfo}', to_jsonb (v_conninfo));
  result = ast.jsonb_set(result, '{AlterSubscriptionStmt, publication}', v_publication);
  result = ast.jsonb_set(result, '{AlterSubscriptionStmt, options}', v_options);
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.drop_subscription_stmt (
  v_type text DEFAULT NULL, 
  v_subname text DEFAULT NULL, 
  v_missing_ok boolean DEFAULT NULL, 
  v_behavior text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"DropSubscriptionStmt":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{DropSubscriptionStmt, type}', to_jsonb (v_type));
  result = ast.jsonb_set(result, '{DropSubscriptionStmt, subname}', to_jsonb (v_subname));
  result = ast.jsonb_set(result, '{DropSubscriptionStmt, missing_ok}', to_jsonb (v_missing_ok));
  result = ast.jsonb_set(result, '{DropSubscriptionStmt, behavior}', to_jsonb (v_behavior));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.vac_attr_stats (
  v_attr jsonb DEFAULT NULL, 
  v_attrtypid jsonb DEFAULT NULL, 
  v_attrtypmod int DEFAULT NULL, 
  v_attrtype jsonb DEFAULT NULL, 
  v_attrcollid jsonb DEFAULT NULL, 
  v_anl_context jsonb DEFAULT NULL, 
  v_compute_stats jsonb DEFAULT NULL, 
  v_minrows int DEFAULT NULL, 
  v_extra_data jsonb DEFAULT NULL, 
  v_stats_valid boolean DEFAULT NULL, 
  v_stanullfrac float DEFAULT NULL, 
  v_stawidth int DEFAULT NULL, 
  v_stadistinct float DEFAULT NULL, 
  v_tupattnum int DEFAULT NULL, 
  v_rows jsonb DEFAULT NULL, 
  v_tupDesc jsonb DEFAULT NULL, 
  v_exprvals jsonb DEFAULT NULL, 
  v_exprnulls boolean DEFAULT NULL, 
  v_rowstride int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"VacAttrStats":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{VacAttrStats, attr}', v_attr);
  result = ast.jsonb_set(result, '{VacAttrStats, attrtypid}', v_attrtypid);
  result = ast.jsonb_set(result, '{VacAttrStats, attrtypmod}', to_jsonb (v_attrtypmod));
  result = ast.jsonb_set(result, '{VacAttrStats, attrtype}', v_attrtype);
  result = ast.jsonb_set(result, '{VacAttrStats, attrcollid}', v_attrcollid);
  result = ast.jsonb_set(result, '{VacAttrStats, anl_context}', v_anl_context);
  result = ast.jsonb_set(result, '{VacAttrStats, compute_stats}', v_compute_stats);
  result = ast.jsonb_set(result, '{VacAttrStats, minrows}', to_jsonb (v_minrows));
  result = ast.jsonb_set(result, '{VacAttrStats, extra_data}', v_extra_data);
  result = ast.jsonb_set(result, '{VacAttrStats, stats_valid}', to_jsonb (v_stats_valid));
  result = ast.jsonb_set(result, '{VacAttrStats, stanullfrac}', to_jsonb (v_stanullfrac));
  result = ast.jsonb_set(result, '{VacAttrStats, stawidth}', to_jsonb (v_stawidth));
  result = ast.jsonb_set(result, '{VacAttrStats, stadistinct}', to_jsonb (v_stadistinct));
  result = ast.jsonb_set(result, '{VacAttrStats, tupattnum}', to_jsonb (v_tupattnum));
  result = ast.jsonb_set(result, '{VacAttrStats, rows}', v_rows);
  result = ast.jsonb_set(result, '{VacAttrStats, tupDesc}', v_tupDesc);
  result = ast.jsonb_set(result, '{VacAttrStats, exprvals}', v_exprvals);
  result = ast.jsonb_set(result, '{VacAttrStats, exprnulls}', to_jsonb (v_exprnulls));
  result = ast.jsonb_set(result, '{VacAttrStats, rowstride}', to_jsonb (v_rowstride));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.vacuum_params (
  v_options int DEFAULT NULL, 
  v_freeze_min_age int DEFAULT NULL, 
  v_freeze_table_age int DEFAULT NULL, 
  v_multixact_freeze_min_age int DEFAULT NULL, 
  v_multixact_freeze_table_age int DEFAULT NULL, 
  v_is_wraparound boolean DEFAULT NULL, 
  v_log_min_duration int DEFAULT NULL, 
  v_index_cleanup text DEFAULT NULL, 
  v_truncate text DEFAULT NULL, 
  v_nworkers int DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"VacuumParams":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{VacuumParams, options}', to_jsonb (v_options));
  result = ast.jsonb_set(result, '{VacuumParams, freeze_min_age}', to_jsonb (v_freeze_min_age));
  result = ast.jsonb_set(result, '{VacuumParams, freeze_table_age}', to_jsonb (v_freeze_table_age));
  result = ast.jsonb_set(result, '{VacuumParams, multixact_freeze_min_age}', to_jsonb (v_multixact_freeze_min_age));
  result = ast.jsonb_set(result, '{VacuumParams, multixact_freeze_table_age}', to_jsonb (v_multixact_freeze_table_age));
  result = ast.jsonb_set(result, '{VacuumParams, is_wraparound}', to_jsonb (v_is_wraparound));
  result = ast.jsonb_set(result, '{VacuumParams, log_min_duration}', to_jsonb (v_log_min_duration));
  result = ast.jsonb_set(result, '{VacuumParams, index_cleanup}', to_jsonb (v_index_cleanup));
  result = ast.jsonb_set(result, '{VacuumParams, truncate}', to_jsonb (v_truncate));
  result = ast.jsonb_set(result, '{VacuumParams, nworkers}', to_jsonb (v_nworkers));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.integer (
  v_ival bigint DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"Integer":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{Integer, ival}', to_jsonb (v_ival));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.float (
  v_str text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"Float":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{Float, str}', to_jsonb (v_str));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.string (
  v_str text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"String":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{String, str}', to_jsonb (v_str));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.bit_string (
  v_str text DEFAULT NULL
)
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"BitString":{}}'::jsonb;
BEGIN
  result = ast.jsonb_set(result, '{BitString, str}', to_jsonb (v_str));
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

CREATE FUNCTION ast.null ()
  RETURNS jsonb
  AS $EOFCODE$
DECLARE
  result jsonb = '{"Null":{}}'::jsonb;
BEGIN
  RETURN result;
END;
$EOFCODE$
LANGUAGE plpgsql
IMMUTABLE;

COMMIT;
