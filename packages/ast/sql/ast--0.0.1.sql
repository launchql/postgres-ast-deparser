\echo Use "CREATE EXTENSION ast" to load this file. \quit
CREATE SCHEMA ast_constants;

GRANT USAGE ON SCHEMA ast_constants TO PUBLIC;

ALTER DEFAULT PRIVILEGES IN SCHEMA ast_constants 
 GRANT EXECUTE ON FUNCTIONS  TO PUBLIC;

CREATE SCHEMA ast_helpers;

GRANT USAGE ON SCHEMA ast_helpers TO PUBLIC;

ALTER DEFAULT PRIVILEGES IN SCHEMA ast_helpers 
 GRANT EXECUTE ON FUNCTIONS  TO PUBLIC;

CREATE SCHEMA ast;

GRANT USAGE ON SCHEMA ast TO PUBLIC;

ALTER DEFAULT PRIVILEGES IN SCHEMA ast 
 GRANT EXECUTE ON FUNCTIONS  TO PUBLIC;

CREATE FUNCTION ast.jsonb_set ( result jsonb, path text[], new_value jsonb ) RETURNS jsonb AS $EOFCODE$
BEGIN
IF (new_value IS NOT NULL) THEN
  RETURN jsonb_set(result, path, new_value);
END IF;
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

CREATE FUNCTION ast.range_var ( v_catalogname text DEFAULT NULL, v_schemaname text DEFAULT NULL, v_relname text DEFAULT NULL, v_inh boolean DEFAULT NULL, v_relpersistence text DEFAULT NULL, v_alias jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RangeVar":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RangeVar, catalogname}', to_jsonb(v_catalogname));
      result = ast.jsonb_set(result, '{RangeVar, schemaname}', to_jsonb(v_schemaname));
      result = ast.jsonb_set(result, '{RangeVar, relname}', to_jsonb(v_relname));
      result = ast.jsonb_set(result, '{RangeVar, inh}', to_jsonb(v_inh));
      result = ast.jsonb_set(result, '{RangeVar, relpersistence}', to_jsonb(v_relpersistence));
      result = ast.jsonb_set(result, '{RangeVar, alias}', v_alias);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.table_func ( v_ns_uris jsonb DEFAULT NULL, v_ns_names jsonb DEFAULT NULL, v_docexpr jsonb DEFAULT NULL, v_rowexpr jsonb DEFAULT NULL, v_colnames jsonb DEFAULT NULL, v_coltypes jsonb DEFAULT NULL, v_coltypmods jsonb DEFAULT NULL, v_colcollations jsonb DEFAULT NULL, v_colexprs jsonb DEFAULT NULL, v_coldefexprs jsonb DEFAULT NULL, v_notnulls jsonb DEFAULT NULL, v_ordinalitycol int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"TableFunc":{}}'::jsonb;
  BEGIN
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
      result = ast.jsonb_set(result, '{TableFunc, ordinalitycol}', to_jsonb(v_ordinalitycol));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.into_clause ( v_rel jsonb DEFAULT NULL, v_colnames jsonb DEFAULT NULL, v_accessmethod text DEFAULT NULL, v_options jsonb DEFAULT NULL, v_oncommit text DEFAULT NULL, v_tablespacename text DEFAULT NULL, v_viewquery jsonb DEFAULT NULL, v_skipdata boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"IntoClause":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{IntoClause, rel}', v_rel);
      result = ast.jsonb_set(result, '{IntoClause, colNames}', v_colNames);
      result = ast.jsonb_set(result, '{IntoClause, accessMethod}', to_jsonb(v_accessMethod));
      result = ast.jsonb_set(result, '{IntoClause, options}', v_options);
      result = ast.jsonb_set(result, '{IntoClause, onCommit}', to_jsonb(v_onCommit));
      result = ast.jsonb_set(result, '{IntoClause, tableSpaceName}', to_jsonb(v_tableSpaceName));
      result = ast.jsonb_set(result, '{IntoClause, viewQuery}', v_viewQuery);
      result = ast.jsonb_set(result, '{IntoClause, skipData}', to_jsonb(v_skipData));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.expr (  ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"Expr":{}}'::jsonb;
  BEGIN
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.var ( v_xpr jsonb DEFAULT NULL, v_varno jsonb DEFAULT NULL, v_varattno int DEFAULT NULL, v_vartype jsonb DEFAULT NULL, v_vartypmod int DEFAULT NULL, v_varcollid jsonb DEFAULT NULL, v_varlevelsup jsonb DEFAULT NULL, v_varnosyn jsonb DEFAULT NULL, v_varattnosyn int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"Var":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{Var, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{Var, varno}', v_varno);
      result = ast.jsonb_set(result, '{Var, varattno}', to_jsonb(v_varattno));
      result = ast.jsonb_set(result, '{Var, vartype}', v_vartype);
      result = ast.jsonb_set(result, '{Var, vartypmod}', to_jsonb(v_vartypmod));
      result = ast.jsonb_set(result, '{Var, varcollid}', v_varcollid);
      result = ast.jsonb_set(result, '{Var, varlevelsup}', v_varlevelsup);
      result = ast.jsonb_set(result, '{Var, varnosyn}', v_varnosyn);
      result = ast.jsonb_set(result, '{Var, varattnosyn}', to_jsonb(v_varattnosyn));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.const ( v_xpr jsonb DEFAULT NULL, v_consttype jsonb DEFAULT NULL, v_consttypmod int DEFAULT NULL, v_constcollid jsonb DEFAULT NULL, v_constlen int DEFAULT NULL, v_constvalue jsonb DEFAULT NULL, v_constisnull boolean DEFAULT NULL, v_constbyval boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"Const":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{Const, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{Const, consttype}', v_consttype);
      result = ast.jsonb_set(result, '{Const, consttypmod}', to_jsonb(v_consttypmod));
      result = ast.jsonb_set(result, '{Const, constcollid}', v_constcollid);
      result = ast.jsonb_set(result, '{Const, constlen}', to_jsonb(v_constlen));
      result = ast.jsonb_set(result, '{Const, constvalue}', v_constvalue);
      result = ast.jsonb_set(result, '{Const, constisnull}', to_jsonb(v_constisnull));
      result = ast.jsonb_set(result, '{Const, constbyval}', to_jsonb(v_constbyval));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.param ( v_xpr jsonb DEFAULT NULL, v_paramkind text DEFAULT NULL, v_paramid int DEFAULT NULL, v_paramtype jsonb DEFAULT NULL, v_paramtypmod int DEFAULT NULL, v_paramcollid jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"Param":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{Param, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{Param, paramkind}', to_jsonb(v_paramkind));
      result = ast.jsonb_set(result, '{Param, paramid}', to_jsonb(v_paramid));
      result = ast.jsonb_set(result, '{Param, paramtype}', v_paramtype);
      result = ast.jsonb_set(result, '{Param, paramtypmod}', to_jsonb(v_paramtypmod));
      result = ast.jsonb_set(result, '{Param, paramcollid}', v_paramcollid);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.aggref ( v_xpr jsonb DEFAULT NULL, v_aggfnoid jsonb DEFAULT NULL, v_aggtype jsonb DEFAULT NULL, v_aggcollid jsonb DEFAULT NULL, v_inputcollid jsonb DEFAULT NULL, v_aggtranstype jsonb DEFAULT NULL, v_aggargtypes jsonb DEFAULT NULL, v_aggdirectargs jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL, v_aggorder jsonb DEFAULT NULL, v_aggdistinct jsonb DEFAULT NULL, v_aggfilter jsonb DEFAULT NULL, v_aggstar boolean DEFAULT NULL, v_aggvariadic boolean DEFAULT NULL, v_aggkind text DEFAULT NULL, v_agglevelsup jsonb DEFAULT NULL, v_aggsplit text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
      result = ast.jsonb_set(result, '{Aggref, aggstar}', to_jsonb(v_aggstar));
      result = ast.jsonb_set(result, '{Aggref, aggvariadic}', to_jsonb(v_aggvariadic));
      result = ast.jsonb_set(result, '{Aggref, aggkind}', to_jsonb(v_aggkind));
      result = ast.jsonb_set(result, '{Aggref, agglevelsup}', v_agglevelsup);
      result = ast.jsonb_set(result, '{Aggref, aggsplit}', to_jsonb(v_aggsplit));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grouping_func ( v_xpr jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL, v_refs jsonb DEFAULT NULL, v_cols jsonb DEFAULT NULL, v_agglevelsup jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"GroupingFunc":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{GroupingFunc, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{GroupingFunc, args}', v_args);
      result = ast.jsonb_set(result, '{GroupingFunc, refs}', v_refs);
      result = ast.jsonb_set(result, '{GroupingFunc, cols}', v_cols);
      result = ast.jsonb_set(result, '{GroupingFunc, agglevelsup}', v_agglevelsup);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.window_func ( v_xpr jsonb DEFAULT NULL, v_winfnoid jsonb DEFAULT NULL, v_wintype jsonb DEFAULT NULL, v_wincollid jsonb DEFAULT NULL, v_inputcollid jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL, v_aggfilter jsonb DEFAULT NULL, v_winref jsonb DEFAULT NULL, v_winstar boolean DEFAULT NULL, v_winagg boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
      result = ast.jsonb_set(result, '{WindowFunc, winstar}', to_jsonb(v_winstar));
      result = ast.jsonb_set(result, '{WindowFunc, winagg}', to_jsonb(v_winagg));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.subscripting_ref ( v_xpr jsonb DEFAULT NULL, v_refcontainertype jsonb DEFAULT NULL, v_refelemtype jsonb DEFAULT NULL, v_reftypmod int DEFAULT NULL, v_refcollid jsonb DEFAULT NULL, v_refupperindexpr jsonb DEFAULT NULL, v_reflowerindexpr jsonb DEFAULT NULL, v_refexpr jsonb DEFAULT NULL, v_refassgnexpr jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"SubscriptingRef":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{SubscriptingRef, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{SubscriptingRef, refcontainertype}', v_refcontainertype);
      result = ast.jsonb_set(result, '{SubscriptingRef, refelemtype}', v_refelemtype);
      result = ast.jsonb_set(result, '{SubscriptingRef, reftypmod}', to_jsonb(v_reftypmod));
      result = ast.jsonb_set(result, '{SubscriptingRef, refcollid}', v_refcollid);
      result = ast.jsonb_set(result, '{SubscriptingRef, refupperindexpr}', v_refupperindexpr);
      result = ast.jsonb_set(result, '{SubscriptingRef, reflowerindexpr}', v_reflowerindexpr);
      result = ast.jsonb_set(result, '{SubscriptingRef, refexpr}', v_refexpr);
      result = ast.jsonb_set(result, '{SubscriptingRef, refassgnexpr}', v_refassgnexpr);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.func_expr ( v_xpr jsonb DEFAULT NULL, v_funcid jsonb DEFAULT NULL, v_funcresulttype jsonb DEFAULT NULL, v_funcretset boolean DEFAULT NULL, v_funcvariadic boolean DEFAULT NULL, v_funcformat text DEFAULT NULL, v_funccollid jsonb DEFAULT NULL, v_inputcollid jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"FuncExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{FuncExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{FuncExpr, funcid}', v_funcid);
      result = ast.jsonb_set(result, '{FuncExpr, funcresulttype}', v_funcresulttype);
      result = ast.jsonb_set(result, '{FuncExpr, funcretset}', to_jsonb(v_funcretset));
      result = ast.jsonb_set(result, '{FuncExpr, funcvariadic}', to_jsonb(v_funcvariadic));
      result = ast.jsonb_set(result, '{FuncExpr, funcformat}', to_jsonb(v_funcformat));
      result = ast.jsonb_set(result, '{FuncExpr, funccollid}', v_funccollid);
      result = ast.jsonb_set(result, '{FuncExpr, inputcollid}', v_inputcollid);
      result = ast.jsonb_set(result, '{FuncExpr, args}', v_args);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.named_arg_expr ( v_xpr jsonb DEFAULT NULL, v_arg jsonb DEFAULT NULL, v_name text DEFAULT NULL, v_argnumber int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"NamedArgExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{NamedArgExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{NamedArgExpr, arg}', v_arg);
      result = ast.jsonb_set(result, '{NamedArgExpr, name}', to_jsonb(v_name));
      result = ast.jsonb_set(result, '{NamedArgExpr, argnumber}', to_jsonb(v_argnumber));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.op_expr ( v_xpr jsonb DEFAULT NULL, v_opno jsonb DEFAULT NULL, v_opfuncid jsonb DEFAULT NULL, v_opresulttype jsonb DEFAULT NULL, v_opretset boolean DEFAULT NULL, v_opcollid jsonb DEFAULT NULL, v_inputcollid jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"OpExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{OpExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{OpExpr, opno}', v_opno);
      result = ast.jsonb_set(result, '{OpExpr, opfuncid}', v_opfuncid);
      result = ast.jsonb_set(result, '{OpExpr, opresulttype}', v_opresulttype);
      result = ast.jsonb_set(result, '{OpExpr, opretset}', to_jsonb(v_opretset));
      result = ast.jsonb_set(result, '{OpExpr, opcollid}', v_opcollid);
      result = ast.jsonb_set(result, '{OpExpr, inputcollid}', v_inputcollid);
      result = ast.jsonb_set(result, '{OpExpr, args}', v_args);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.scalar_array_op_expr ( v_xpr jsonb DEFAULT NULL, v_opno jsonb DEFAULT NULL, v_opfuncid jsonb DEFAULT NULL, v_useor boolean DEFAULT NULL, v_inputcollid jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"ScalarArrayOpExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{ScalarArrayOpExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{ScalarArrayOpExpr, opno}', v_opno);
      result = ast.jsonb_set(result, '{ScalarArrayOpExpr, opfuncid}', v_opfuncid);
      result = ast.jsonb_set(result, '{ScalarArrayOpExpr, useOr}', to_jsonb(v_useOr));
      result = ast.jsonb_set(result, '{ScalarArrayOpExpr, inputcollid}', v_inputcollid);
      result = ast.jsonb_set(result, '{ScalarArrayOpExpr, args}', v_args);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.bool_expr ( v_boolop text DEFAULT NULL, v_args jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"BoolExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{BoolExpr, boolop}', to_jsonb(v_boolop));
      result = ast.jsonb_set(result, '{BoolExpr, args}', v_args);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.sub_link ( v_xpr jsonb DEFAULT NULL, v_sublinktype text DEFAULT NULL, v_sublinkid int DEFAULT NULL, v_testexpr jsonb DEFAULT NULL, v_opername jsonb DEFAULT NULL, v_subselect jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"SubLink":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{SubLink, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{SubLink, subLinkType}', to_jsonb(v_subLinkType));
      result = ast.jsonb_set(result, '{SubLink, subLinkId}', to_jsonb(v_subLinkId));
      result = ast.jsonb_set(result, '{SubLink, testexpr}', v_testexpr);
      result = ast.jsonb_set(result, '{SubLink, operName}', v_operName);
      result = ast.jsonb_set(result, '{SubLink, subselect}', v_subselect);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.sub_plan ( v_xpr jsonb DEFAULT NULL, v_sublinktype text DEFAULT NULL, v_testexpr jsonb DEFAULT NULL, v_paramids jsonb DEFAULT NULL, v_plan_id int DEFAULT NULL, v_plan_name text DEFAULT NULL, v_firstcoltype jsonb DEFAULT NULL, v_firstcoltypmod int DEFAULT NULL, v_firstcolcollation jsonb DEFAULT NULL, v_usehashtable boolean DEFAULT NULL, v_unknowneqfalse boolean DEFAULT NULL, v_parallel_safe boolean DEFAULT NULL, v_setparam jsonb DEFAULT NULL, v_parparam jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL, v_startup_cost jsonb DEFAULT NULL, v_per_call_cost jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"SubPlan":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{SubPlan, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{SubPlan, subLinkType}', to_jsonb(v_subLinkType));
      result = ast.jsonb_set(result, '{SubPlan, testexpr}', v_testexpr);
      result = ast.jsonb_set(result, '{SubPlan, paramIds}', v_paramIds);
      result = ast.jsonb_set(result, '{SubPlan, plan_id}', to_jsonb(v_plan_id));
      result = ast.jsonb_set(result, '{SubPlan, plan_name}', to_jsonb(v_plan_name));
      result = ast.jsonb_set(result, '{SubPlan, firstColType}', v_firstColType);
      result = ast.jsonb_set(result, '{SubPlan, firstColTypmod}', to_jsonb(v_firstColTypmod));
      result = ast.jsonb_set(result, '{SubPlan, firstColCollation}', v_firstColCollation);
      result = ast.jsonb_set(result, '{SubPlan, useHashTable}', to_jsonb(v_useHashTable));
      result = ast.jsonb_set(result, '{SubPlan, unknownEqFalse}', to_jsonb(v_unknownEqFalse));
      result = ast.jsonb_set(result, '{SubPlan, parallel_safe}', to_jsonb(v_parallel_safe));
      result = ast.jsonb_set(result, '{SubPlan, setParam}', v_setParam);
      result = ast.jsonb_set(result, '{SubPlan, parParam}', v_parParam);
      result = ast.jsonb_set(result, '{SubPlan, args}', v_args);
      result = ast.jsonb_set(result, '{SubPlan, startup_cost}', v_startup_cost);
      result = ast.jsonb_set(result, '{SubPlan, per_call_cost}', v_per_call_cost);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alternative_sub_plan ( v_xpr jsonb DEFAULT NULL, v_subplans jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlternativeSubPlan":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlternativeSubPlan, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{AlternativeSubPlan, subplans}', v_subplans);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.field_select ( v_xpr jsonb DEFAULT NULL, v_arg jsonb DEFAULT NULL, v_fieldnum int DEFAULT NULL, v_resulttype jsonb DEFAULT NULL, v_resulttypmod int DEFAULT NULL, v_resultcollid jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"FieldSelect":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{FieldSelect, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{FieldSelect, arg}', v_arg);
      result = ast.jsonb_set(result, '{FieldSelect, fieldnum}', to_jsonb(v_fieldnum));
      result = ast.jsonb_set(result, '{FieldSelect, resulttype}', v_resulttype);
      result = ast.jsonb_set(result, '{FieldSelect, resulttypmod}', to_jsonb(v_resulttypmod));
      result = ast.jsonb_set(result, '{FieldSelect, resultcollid}', v_resultcollid);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.field_store ( v_xpr jsonb DEFAULT NULL, v_arg jsonb DEFAULT NULL, v_newvals jsonb DEFAULT NULL, v_fieldnums jsonb DEFAULT NULL, v_resulttype jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.relabel_type ( v_xpr jsonb DEFAULT NULL, v_arg jsonb DEFAULT NULL, v_resulttype jsonb DEFAULT NULL, v_resulttypmod int DEFAULT NULL, v_resultcollid jsonb DEFAULT NULL, v_relabelformat text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RelabelType":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RelabelType, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{RelabelType, arg}', v_arg);
      result = ast.jsonb_set(result, '{RelabelType, resulttype}', v_resulttype);
      result = ast.jsonb_set(result, '{RelabelType, resulttypmod}', to_jsonb(v_resulttypmod));
      result = ast.jsonb_set(result, '{RelabelType, resultcollid}', v_resultcollid);
      result = ast.jsonb_set(result, '{RelabelType, relabelformat}', to_jsonb(v_relabelformat));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.coerce_via_io ( v_xpr jsonb DEFAULT NULL, v_arg jsonb DEFAULT NULL, v_resulttype jsonb DEFAULT NULL, v_resultcollid jsonb DEFAULT NULL, v_coerceformat text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CoerceViaIO":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CoerceViaIO, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{CoerceViaIO, arg}', v_arg);
      result = ast.jsonb_set(result, '{CoerceViaIO, resulttype}', v_resulttype);
      result = ast.jsonb_set(result, '{CoerceViaIO, resultcollid}', v_resultcollid);
      result = ast.jsonb_set(result, '{CoerceViaIO, coerceformat}', to_jsonb(v_coerceformat));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.array_coerce_expr ( v_xpr jsonb DEFAULT NULL, v_arg jsonb DEFAULT NULL, v_elemexpr jsonb DEFAULT NULL, v_resulttype jsonb DEFAULT NULL, v_resulttypmod int DEFAULT NULL, v_resultcollid jsonb DEFAULT NULL, v_coerceformat text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"ArrayCoerceExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{ArrayCoerceExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{ArrayCoerceExpr, arg}', v_arg);
      result = ast.jsonb_set(result, '{ArrayCoerceExpr, elemexpr}', v_elemexpr);
      result = ast.jsonb_set(result, '{ArrayCoerceExpr, resulttype}', v_resulttype);
      result = ast.jsonb_set(result, '{ArrayCoerceExpr, resulttypmod}', to_jsonb(v_resulttypmod));
      result = ast.jsonb_set(result, '{ArrayCoerceExpr, resultcollid}', v_resultcollid);
      result = ast.jsonb_set(result, '{ArrayCoerceExpr, coerceformat}', to_jsonb(v_coerceformat));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.convert_rowtype_expr ( v_xpr jsonb DEFAULT NULL, v_arg jsonb DEFAULT NULL, v_resulttype jsonb DEFAULT NULL, v_convertformat text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"ConvertRowtypeExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{ConvertRowtypeExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{ConvertRowtypeExpr, arg}', v_arg);
      result = ast.jsonb_set(result, '{ConvertRowtypeExpr, resulttype}', v_resulttype);
      result = ast.jsonb_set(result, '{ConvertRowtypeExpr, convertformat}', to_jsonb(v_convertformat));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.collate_expr ( v_xpr jsonb DEFAULT NULL, v_arg jsonb DEFAULT NULL, v_colloid jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CollateExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CollateExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{CollateExpr, arg}', v_arg);
      result = ast.jsonb_set(result, '{CollateExpr, collOid}', v_collOid);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.case_expr ( v_xpr jsonb DEFAULT NULL, v_casetype jsonb DEFAULT NULL, v_casecollid jsonb DEFAULT NULL, v_arg jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL, v_defresult jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CaseExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CaseExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{CaseExpr, casetype}', v_casetype);
      result = ast.jsonb_set(result, '{CaseExpr, casecollid}', v_casecollid);
      result = ast.jsonb_set(result, '{CaseExpr, arg}', v_arg);
      result = ast.jsonb_set(result, '{CaseExpr, args}', v_args);
      result = ast.jsonb_set(result, '{CaseExpr, defresult}', v_defresult);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.case_when ( v_xpr jsonb DEFAULT NULL, v_expr jsonb DEFAULT NULL, v_result jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CaseWhen":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CaseWhen, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{CaseWhen, expr}', v_expr);
      result = ast.jsonb_set(result, '{CaseWhen, result}', v_result);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.case_test_expr ( v_xpr jsonb DEFAULT NULL, v_typeid jsonb DEFAULT NULL, v_typemod int DEFAULT NULL, v_collation jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CaseTestExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CaseTestExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{CaseTestExpr, typeId}', v_typeId);
      result = ast.jsonb_set(result, '{CaseTestExpr, typeMod}', to_jsonb(v_typeMod));
      result = ast.jsonb_set(result, '{CaseTestExpr, collation}', v_collation);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.array_expr ( v_xpr jsonb DEFAULT NULL, v_array_typeid jsonb DEFAULT NULL, v_array_collid jsonb DEFAULT NULL, v_element_typeid jsonb DEFAULT NULL, v_elements jsonb DEFAULT NULL, v_multidims boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"ArrayExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{ArrayExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{ArrayExpr, array_typeid}', v_array_typeid);
      result = ast.jsonb_set(result, '{ArrayExpr, array_collid}', v_array_collid);
      result = ast.jsonb_set(result, '{ArrayExpr, element_typeid}', v_element_typeid);
      result = ast.jsonb_set(result, '{ArrayExpr, elements}', v_elements);
      result = ast.jsonb_set(result, '{ArrayExpr, multidims}', to_jsonb(v_multidims));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.row_expr ( v_xpr jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL, v_row_typeid jsonb DEFAULT NULL, v_row_format text DEFAULT NULL, v_colnames jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RowExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RowExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{RowExpr, args}', v_args);
      result = ast.jsonb_set(result, '{RowExpr, row_typeid}', v_row_typeid);
      result = ast.jsonb_set(result, '{RowExpr, row_format}', to_jsonb(v_row_format));
      result = ast.jsonb_set(result, '{RowExpr, colnames}', v_colnames);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.row_compare_expr ( v_xpr jsonb DEFAULT NULL, v_rctype text DEFAULT NULL, v_opnos jsonb DEFAULT NULL, v_opfamilies jsonb DEFAULT NULL, v_inputcollids jsonb DEFAULT NULL, v_largs jsonb DEFAULT NULL, v_rargs jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RowCompareExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RowCompareExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{RowCompareExpr, rctype}', to_jsonb(v_rctype));
      result = ast.jsonb_set(result, '{RowCompareExpr, opnos}', v_opnos);
      result = ast.jsonb_set(result, '{RowCompareExpr, opfamilies}', v_opfamilies);
      result = ast.jsonb_set(result, '{RowCompareExpr, inputcollids}', v_inputcollids);
      result = ast.jsonb_set(result, '{RowCompareExpr, largs}', v_largs);
      result = ast.jsonb_set(result, '{RowCompareExpr, rargs}', v_rargs);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.coalesce_expr ( v_xpr jsonb DEFAULT NULL, v_coalescetype jsonb DEFAULT NULL, v_coalescecollid jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CoalesceExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CoalesceExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{CoalesceExpr, coalescetype}', v_coalescetype);
      result = ast.jsonb_set(result, '{CoalesceExpr, coalescecollid}', v_coalescecollid);
      result = ast.jsonb_set(result, '{CoalesceExpr, args}', v_args);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.min_max_expr ( v_xpr jsonb DEFAULT NULL, v_minmaxtype jsonb DEFAULT NULL, v_minmaxcollid jsonb DEFAULT NULL, v_inputcollid jsonb DEFAULT NULL, v_op text DEFAULT NULL, v_args jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"MinMaxExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{MinMaxExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{MinMaxExpr, minmaxtype}', v_minmaxtype);
      result = ast.jsonb_set(result, '{MinMaxExpr, minmaxcollid}', v_minmaxcollid);
      result = ast.jsonb_set(result, '{MinMaxExpr, inputcollid}', v_inputcollid);
      result = ast.jsonb_set(result, '{MinMaxExpr, op}', to_jsonb(v_op));
      result = ast.jsonb_set(result, '{MinMaxExpr, args}', v_args);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.sql_value_function ( v_xpr jsonb DEFAULT NULL, v_op text DEFAULT NULL, v_typmod int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"SQLValueFunction":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{SQLValueFunction, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{SQLValueFunction, op}', to_jsonb(v_op));
      result = ast.jsonb_set(result, '{SQLValueFunction, typmod}', to_jsonb(v_typmod));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.xml_expr ( v_xpr jsonb DEFAULT NULL, v_op text DEFAULT NULL, v_name text DEFAULT NULL, v_named_args jsonb DEFAULT NULL, v_arg_names jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL, v_xmloption text DEFAULT NULL, v_typmod int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"XmlExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{XmlExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{XmlExpr, op}', to_jsonb(v_op));
      result = ast.jsonb_set(result, '{XmlExpr, name}', to_jsonb(v_name));
      result = ast.jsonb_set(result, '{XmlExpr, named_args}', v_named_args);
      result = ast.jsonb_set(result, '{XmlExpr, arg_names}', v_arg_names);
      result = ast.jsonb_set(result, '{XmlExpr, args}', v_args);
      result = ast.jsonb_set(result, '{XmlExpr, xmloption}', to_jsonb(v_xmloption));
      result = ast.jsonb_set(result, '{XmlExpr, typmod}', to_jsonb(v_typmod));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.null_test ( v_xpr jsonb DEFAULT NULL, v_arg jsonb DEFAULT NULL, v_nulltesttype text DEFAULT NULL, v_argisrow boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"NullTest":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{NullTest, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{NullTest, arg}', v_arg);
      result = ast.jsonb_set(result, '{NullTest, nulltesttype}', to_jsonb(v_nulltesttype));
      result = ast.jsonb_set(result, '{NullTest, argisrow}', to_jsonb(v_argisrow));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.boolean_test ( v_xpr jsonb DEFAULT NULL, v_arg jsonb DEFAULT NULL, v_booltesttype text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"BooleanTest":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{BooleanTest, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{BooleanTest, arg}', v_arg);
      result = ast.jsonb_set(result, '{BooleanTest, booltesttype}', to_jsonb(v_booltesttype));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.coerce_to_domain ( v_xpr jsonb DEFAULT NULL, v_arg jsonb DEFAULT NULL, v_resulttype jsonb DEFAULT NULL, v_resulttypmod int DEFAULT NULL, v_resultcollid jsonb DEFAULT NULL, v_coercionformat text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CoerceToDomain":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CoerceToDomain, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{CoerceToDomain, arg}', v_arg);
      result = ast.jsonb_set(result, '{CoerceToDomain, resulttype}', v_resulttype);
      result = ast.jsonb_set(result, '{CoerceToDomain, resulttypmod}', to_jsonb(v_resulttypmod));
      result = ast.jsonb_set(result, '{CoerceToDomain, resultcollid}', v_resultcollid);
      result = ast.jsonb_set(result, '{CoerceToDomain, coercionformat}', to_jsonb(v_coercionformat));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.coerce_to_domain_value ( v_xpr jsonb DEFAULT NULL, v_typeid jsonb DEFAULT NULL, v_typemod int DEFAULT NULL, v_collation jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CoerceToDomainValue":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CoerceToDomainValue, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{CoerceToDomainValue, typeId}', v_typeId);
      result = ast.jsonb_set(result, '{CoerceToDomainValue, typeMod}', to_jsonb(v_typeMod));
      result = ast.jsonb_set(result, '{CoerceToDomainValue, collation}', v_collation);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.set_to_default ( v_xpr jsonb DEFAULT NULL, v_typeid jsonb DEFAULT NULL, v_typemod int DEFAULT NULL, v_collation jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"SetToDefault":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{SetToDefault, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{SetToDefault, typeId}', v_typeId);
      result = ast.jsonb_set(result, '{SetToDefault, typeMod}', to_jsonb(v_typeMod));
      result = ast.jsonb_set(result, '{SetToDefault, collation}', v_collation);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.current_of_expr ( v_xpr jsonb DEFAULT NULL, v_cvarno jsonb DEFAULT NULL, v_cursor_name text DEFAULT NULL, v_cursor_param int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CurrentOfExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CurrentOfExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{CurrentOfExpr, cvarno}', v_cvarno);
      result = ast.jsonb_set(result, '{CurrentOfExpr, cursor_name}', to_jsonb(v_cursor_name));
      result = ast.jsonb_set(result, '{CurrentOfExpr, cursor_param}', to_jsonb(v_cursor_param));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.next_value_expr ( v_xpr jsonb DEFAULT NULL, v_seqid jsonb DEFAULT NULL, v_typeid jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"NextValueExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{NextValueExpr, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{NextValueExpr, seqid}', v_seqid);
      result = ast.jsonb_set(result, '{NextValueExpr, typeId}', v_typeId);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.inference_elem ( v_xpr jsonb DEFAULT NULL, v_expr jsonb DEFAULT NULL, v_infercollid jsonb DEFAULT NULL, v_inferopclass jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"InferenceElem":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{InferenceElem, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{InferenceElem, expr}', v_expr);
      result = ast.jsonb_set(result, '{InferenceElem, infercollid}', v_infercollid);
      result = ast.jsonb_set(result, '{InferenceElem, inferopclass}', v_inferopclass);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.target_entry ( v_xpr jsonb DEFAULT NULL, v_expr jsonb DEFAULT NULL, v_resno int DEFAULT NULL, v_resname text DEFAULT NULL, v_ressortgroupref jsonb DEFAULT NULL, v_resorigtbl jsonb DEFAULT NULL, v_resorigcol int DEFAULT NULL, v_resjunk boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"TargetEntry":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{TargetEntry, xpr}', v_xpr);
      result = ast.jsonb_set(result, '{TargetEntry, expr}', v_expr);
      result = ast.jsonb_set(result, '{TargetEntry, resno}', to_jsonb(v_resno));
      result = ast.jsonb_set(result, '{TargetEntry, resname}', to_jsonb(v_resname));
      result = ast.jsonb_set(result, '{TargetEntry, ressortgroupref}', v_ressortgroupref);
      result = ast.jsonb_set(result, '{TargetEntry, resorigtbl}', v_resorigtbl);
      result = ast.jsonb_set(result, '{TargetEntry, resorigcol}', to_jsonb(v_resorigcol));
      result = ast.jsonb_set(result, '{TargetEntry, resjunk}', to_jsonb(v_resjunk));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_tbl_ref ( v_rtindex int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RangeTblRef":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RangeTblRef, rtindex}', to_jsonb(v_rtindex));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.join_expr ( v_jointype text DEFAULT NULL, v_isnatural boolean DEFAULT NULL, v_larg jsonb DEFAULT NULL, v_rarg jsonb DEFAULT NULL, v_usingclause jsonb DEFAULT NULL, v_quals jsonb DEFAULT NULL, v_alias jsonb DEFAULT NULL, v_rtindex int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"JoinExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{JoinExpr, jointype}', to_jsonb(v_jointype));
      result = ast.jsonb_set(result, '{JoinExpr, isNatural}', to_jsonb(v_isNatural));
      result = ast.jsonb_set(result, '{JoinExpr, larg}', v_larg);
      result = ast.jsonb_set(result, '{JoinExpr, rarg}', v_rarg);
      result = ast.jsonb_set(result, '{JoinExpr, usingClause}', v_usingClause);
      result = ast.jsonb_set(result, '{JoinExpr, quals}', v_quals);
      result = ast.jsonb_set(result, '{JoinExpr, alias}', v_alias);
      result = ast.jsonb_set(result, '{JoinExpr, rtindex}', to_jsonb(v_rtindex));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.from_expr ( v_fromlist jsonb DEFAULT NULL, v_quals jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"FromExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{FromExpr, fromlist}', v_fromlist);
      result = ast.jsonb_set(result, '{FromExpr, quals}', v_quals);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.on_conflict_expr ( v_action text DEFAULT NULL, v_arbiterelems jsonb DEFAULT NULL, v_arbiterwhere jsonb DEFAULT NULL, v_constraint jsonb DEFAULT NULL, v_onconflictset jsonb DEFAULT NULL, v_onconflictwhere jsonb DEFAULT NULL, v_exclrelindex int DEFAULT NULL, v_exclreltlist jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"OnConflictExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{OnConflictExpr, action}', to_jsonb(v_action));
      result = ast.jsonb_set(result, '{OnConflictExpr, arbiterElems}', v_arbiterElems);
      result = ast.jsonb_set(result, '{OnConflictExpr, arbiterWhere}', v_arbiterWhere);
      result = ast.jsonb_set(result, '{OnConflictExpr, constraint}', v_constraint);
      result = ast.jsonb_set(result, '{OnConflictExpr, onConflictSet}', v_onConflictSet);
      result = ast.jsonb_set(result, '{OnConflictExpr, onConflictWhere}', v_onConflictWhere);
      result = ast.jsonb_set(result, '{OnConflictExpr, exclRelIndex}', to_jsonb(v_exclRelIndex));
      result = ast.jsonb_set(result, '{OnConflictExpr, exclRelTlist}', v_exclRelTlist);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.query ( v_commandtype text DEFAULT NULL, v_querysource text DEFAULT NULL, v_queryid int DEFAULT NULL, v_cansettag boolean DEFAULT NULL, v_utilitystmt jsonb DEFAULT NULL, v_resultrelation int DEFAULT NULL, v_hasaggs boolean DEFAULT NULL, v_haswindowfuncs boolean DEFAULT NULL, v_hastargetsrfs boolean DEFAULT NULL, v_hassublinks boolean DEFAULT NULL, v_hasdistincton boolean DEFAULT NULL, v_hasrecursive boolean DEFAULT NULL, v_hasmodifyingcte boolean DEFAULT NULL, v_hasforupdate boolean DEFAULT NULL, v_hasrowsecurity boolean DEFAULT NULL, v_ctelist jsonb DEFAULT NULL, v_rtable jsonb DEFAULT NULL, v_jointree jsonb DEFAULT NULL, v_targetlist jsonb DEFAULT NULL, v_override text DEFAULT NULL, v_onconflict jsonb DEFAULT NULL, v_returninglist jsonb DEFAULT NULL, v_groupclause jsonb DEFAULT NULL, v_groupingsets jsonb DEFAULT NULL, v_havingqual jsonb DEFAULT NULL, v_windowclause jsonb DEFAULT NULL, v_distinctclause jsonb DEFAULT NULL, v_sortclause jsonb DEFAULT NULL, v_limitoffset jsonb DEFAULT NULL, v_limitcount jsonb DEFAULT NULL, v_limitoption text DEFAULT NULL, v_rowmarks jsonb DEFAULT NULL, v_setoperations jsonb DEFAULT NULL, v_constraintdeps jsonb DEFAULT NULL, v_withcheckoptions jsonb DEFAULT NULL, v_stmt_location int DEFAULT NULL, v_stmt_len int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"Query":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{Query, commandType}', to_jsonb(v_commandType));
      result = ast.jsonb_set(result, '{Query, querySource}', to_jsonb(v_querySource));
      result = ast.jsonb_set(result, '{Query, queryId}', to_jsonb(v_queryId));
      result = ast.jsonb_set(result, '{Query, canSetTag}', to_jsonb(v_canSetTag));
      result = ast.jsonb_set(result, '{Query, utilityStmt}', v_utilityStmt);
      result = ast.jsonb_set(result, '{Query, resultRelation}', to_jsonb(v_resultRelation));
      result = ast.jsonb_set(result, '{Query, hasAggs}', to_jsonb(v_hasAggs));
      result = ast.jsonb_set(result, '{Query, hasWindowFuncs}', to_jsonb(v_hasWindowFuncs));
      result = ast.jsonb_set(result, '{Query, hasTargetSRFs}', to_jsonb(v_hasTargetSRFs));
      result = ast.jsonb_set(result, '{Query, hasSubLinks}', to_jsonb(v_hasSubLinks));
      result = ast.jsonb_set(result, '{Query, hasDistinctOn}', to_jsonb(v_hasDistinctOn));
      result = ast.jsonb_set(result, '{Query, hasRecursive}', to_jsonb(v_hasRecursive));
      result = ast.jsonb_set(result, '{Query, hasModifyingCTE}', to_jsonb(v_hasModifyingCTE));
      result = ast.jsonb_set(result, '{Query, hasForUpdate}', to_jsonb(v_hasForUpdate));
      result = ast.jsonb_set(result, '{Query, hasRowSecurity}', to_jsonb(v_hasRowSecurity));
      result = ast.jsonb_set(result, '{Query, cteList}', v_cteList);
      result = ast.jsonb_set(result, '{Query, rtable}', v_rtable);
      result = ast.jsonb_set(result, '{Query, jointree}', v_jointree);
      result = ast.jsonb_set(result, '{Query, targetList}', v_targetList);
      result = ast.jsonb_set(result, '{Query, override}', to_jsonb(v_override));
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
      result = ast.jsonb_set(result, '{Query, limitOption}', to_jsonb(v_limitOption));
      result = ast.jsonb_set(result, '{Query, rowMarks}', v_rowMarks);
      result = ast.jsonb_set(result, '{Query, setOperations}', v_setOperations);
      result = ast.jsonb_set(result, '{Query, constraintDeps}', v_constraintDeps);
      result = ast.jsonb_set(result, '{Query, withCheckOptions}', v_withCheckOptions);
      result = ast.jsonb_set(result, '{Query, stmt_location}', to_jsonb(v_stmt_location));
      result = ast.jsonb_set(result, '{Query, stmt_len}', to_jsonb(v_stmt_len));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.type_name ( v_names jsonb DEFAULT NULL, v_typeoid jsonb DEFAULT NULL, v_setof boolean DEFAULT NULL, v_pct_type boolean DEFAULT NULL, v_typmods jsonb DEFAULT NULL, v_typemod int DEFAULT NULL, v_arraybounds jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"TypeName":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{TypeName, names}', v_names);
      result = ast.jsonb_set(result, '{TypeName, typeOid}', v_typeOid);
      result = ast.jsonb_set(result, '{TypeName, setof}', to_jsonb(v_setof));
      result = ast.jsonb_set(result, '{TypeName, pct_type}', to_jsonb(v_pct_type));
      result = ast.jsonb_set(result, '{TypeName, typmods}', v_typmods);
      result = ast.jsonb_set(result, '{TypeName, typemod}', to_jsonb(v_typemod));
      result = ast.jsonb_set(result, '{TypeName, arrayBounds}', v_arrayBounds);
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

CREATE FUNCTION ast.param_ref ( v_number int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"ParamRef":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{ParamRef, number}', to_jsonb(v_number));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.a_expr ( v_kind text DEFAULT NULL, v_name jsonb DEFAULT NULL, v_lexpr jsonb DEFAULT NULL, v_rexpr jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.a_const ( v_val jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"A_Const":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{A_Const, val}', v_val);
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

CREATE FUNCTION ast.collate_clause ( v_arg jsonb DEFAULT NULL, v_collname jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CollateClause":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CollateClause, arg}', v_arg);
      result = ast.jsonb_set(result, '{CollateClause, collname}', v_collname);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.role_spec ( v_roletype text DEFAULT NULL, v_rolename text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RoleSpec":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RoleSpec, roletype}', to_jsonb(v_roletype));
      result = ast.jsonb_set(result, '{RoleSpec, rolename}', to_jsonb(v_rolename));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.func_call ( v_funcname jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL, v_agg_order jsonb DEFAULT NULL, v_agg_filter jsonb DEFAULT NULL, v_agg_within_group boolean DEFAULT NULL, v_agg_star boolean DEFAULT NULL, v_agg_distinct boolean DEFAULT NULL, v_func_variadic boolean DEFAULT NULL, v_over jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"FuncCall":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{FuncCall, funcname}', v_funcname);
      result = ast.jsonb_set(result, '{FuncCall, args}', v_args);
      result = ast.jsonb_set(result, '{FuncCall, agg_order}', v_agg_order);
      result = ast.jsonb_set(result, '{FuncCall, agg_filter}', v_agg_filter);
      result = ast.jsonb_set(result, '{FuncCall, agg_within_group}', to_jsonb(v_agg_within_group));
      result = ast.jsonb_set(result, '{FuncCall, agg_star}', to_jsonb(v_agg_star));
      result = ast.jsonb_set(result, '{FuncCall, agg_distinct}', to_jsonb(v_agg_distinct));
      result = ast.jsonb_set(result, '{FuncCall, func_variadic}', to_jsonb(v_func_variadic));
      result = ast.jsonb_set(result, '{FuncCall, over}', v_over);
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

CREATE FUNCTION ast.a_indirection ( v_arg jsonb DEFAULT NULL, v_indirection jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"A_Indirection":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{A_Indirection, arg}', v_arg);
      result = ast.jsonb_set(result, '{A_Indirection, indirection}', v_indirection);
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

CREATE FUNCTION ast.res_target ( v_name text DEFAULT NULL, v_indirection jsonb DEFAULT NULL, v_val jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"ResTarget":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{ResTarget, name}', to_jsonb(v_name));
      result = ast.jsonb_set(result, '{ResTarget, indirection}', v_indirection);
      result = ast.jsonb_set(result, '{ResTarget, val}', v_val);
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

CREATE FUNCTION ast.sort_by ( v_node jsonb DEFAULT NULL, v_sortby_dir text DEFAULT NULL, v_sortby_nulls text DEFAULT NULL, v_useop jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.window_def ( v_name text DEFAULT NULL, v_refname text DEFAULT NULL, v_partitionclause jsonb DEFAULT NULL, v_orderclause jsonb DEFAULT NULL, v_frameoptions int DEFAULT NULL, v_startoffset jsonb DEFAULT NULL, v_endoffset jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"WindowDef":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{WindowDef, name}', to_jsonb(v_name));
      result = ast.jsonb_set(result, '{WindowDef, refname}', to_jsonb(v_refname));
      result = ast.jsonb_set(result, '{WindowDef, partitionClause}', v_partitionClause);
      result = ast.jsonb_set(result, '{WindowDef, orderClause}', v_orderClause);
      result = ast.jsonb_set(result, '{WindowDef, frameOptions}', to_jsonb(v_frameOptions));
      result = ast.jsonb_set(result, '{WindowDef, startOffset}', v_startOffset);
      result = ast.jsonb_set(result, '{WindowDef, endOffset}', v_endOffset);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_subselect ( v_lateral boolean DEFAULT NULL, v_subquery jsonb DEFAULT NULL, v_alias jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RangeSubselect":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RangeSubselect, lateral}', to_jsonb(v_lateral));
      result = ast.jsonb_set(result, '{RangeSubselect, subquery}', v_subquery);
      result = ast.jsonb_set(result, '{RangeSubselect, alias}', v_alias);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_function ( v_lateral boolean DEFAULT NULL, v_ordinality boolean DEFAULT NULL, v_is_rowsfrom boolean DEFAULT NULL, v_functions jsonb DEFAULT NULL, v_alias jsonb DEFAULT NULL, v_coldeflist jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RangeFunction":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RangeFunction, lateral}', to_jsonb(v_lateral));
      result = ast.jsonb_set(result, '{RangeFunction, ordinality}', to_jsonb(v_ordinality));
      result = ast.jsonb_set(result, '{RangeFunction, is_rowsfrom}', to_jsonb(v_is_rowsfrom));
      result = ast.jsonb_set(result, '{RangeFunction, functions}', v_functions);
      result = ast.jsonb_set(result, '{RangeFunction, alias}', v_alias);
      result = ast.jsonb_set(result, '{RangeFunction, coldeflist}', v_coldeflist);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_table_func ( v_lateral boolean DEFAULT NULL, v_docexpr jsonb DEFAULT NULL, v_rowexpr jsonb DEFAULT NULL, v_namespaces jsonb DEFAULT NULL, v_columns jsonb DEFAULT NULL, v_alias jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RangeTableFunc":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RangeTableFunc, lateral}', to_jsonb(v_lateral));
      result = ast.jsonb_set(result, '{RangeTableFunc, docexpr}', v_docexpr);
      result = ast.jsonb_set(result, '{RangeTableFunc, rowexpr}', v_rowexpr);
      result = ast.jsonb_set(result, '{RangeTableFunc, namespaces}', v_namespaces);
      result = ast.jsonb_set(result, '{RangeTableFunc, columns}', v_columns);
      result = ast.jsonb_set(result, '{RangeTableFunc, alias}', v_alias);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_table_func_col ( v_colname text DEFAULT NULL, v_typename jsonb DEFAULT NULL, v_for_ordinality boolean DEFAULT NULL, v_is_not_null boolean DEFAULT NULL, v_colexpr jsonb DEFAULT NULL, v_coldefexpr jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RangeTableFuncCol":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RangeTableFuncCol, colname}', to_jsonb(v_colname));
      result = ast.jsonb_set(result, '{RangeTableFuncCol, typeName}', v_typeName);
      result = ast.jsonb_set(result, '{RangeTableFuncCol, for_ordinality}', to_jsonb(v_for_ordinality));
      result = ast.jsonb_set(result, '{RangeTableFuncCol, is_not_null}', to_jsonb(v_is_not_null));
      result = ast.jsonb_set(result, '{RangeTableFuncCol, colexpr}', v_colexpr);
      result = ast.jsonb_set(result, '{RangeTableFuncCol, coldefexpr}', v_coldefexpr);
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

CREATE FUNCTION ast.column_def ( v_colname text DEFAULT NULL, v_typename jsonb DEFAULT NULL, v_inhcount int DEFAULT NULL, v_is_local boolean DEFAULT NULL, v_is_not_null boolean DEFAULT NULL, v_is_from_type boolean DEFAULT NULL, v_storage text DEFAULT NULL, v_raw_default jsonb DEFAULT NULL, v_cooked_default jsonb DEFAULT NULL, v_identity text DEFAULT NULL, v_identitysequence jsonb DEFAULT NULL, v_generated text DEFAULT NULL, v_collclause jsonb DEFAULT NULL, v_colloid jsonb DEFAULT NULL, v_constraints jsonb DEFAULT NULL, v_fdwoptions jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"ColumnDef":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{ColumnDef, colname}', to_jsonb(v_colname));
      result = ast.jsonb_set(result, '{ColumnDef, typeName}', v_typeName);
      result = ast.jsonb_set(result, '{ColumnDef, inhcount}', to_jsonb(v_inhcount));
      result = ast.jsonb_set(result, '{ColumnDef, is_local}', to_jsonb(v_is_local));
      result = ast.jsonb_set(result, '{ColumnDef, is_not_null}', to_jsonb(v_is_not_null));
      result = ast.jsonb_set(result, '{ColumnDef, is_from_type}', to_jsonb(v_is_from_type));
      result = ast.jsonb_set(result, '{ColumnDef, storage}', to_jsonb(v_storage));
      result = ast.jsonb_set(result, '{ColumnDef, raw_default}', v_raw_default);
      result = ast.jsonb_set(result, '{ColumnDef, cooked_default}', v_cooked_default);
      result = ast.jsonb_set(result, '{ColumnDef, identity}', to_jsonb(v_identity));
      result = ast.jsonb_set(result, '{ColumnDef, identitySequence}', v_identitySequence);
      result = ast.jsonb_set(result, '{ColumnDef, generated}', to_jsonb(v_generated));
      result = ast.jsonb_set(result, '{ColumnDef, collClause}', v_collClause);
      result = ast.jsonb_set(result, '{ColumnDef, collOid}', v_collOid);
      result = ast.jsonb_set(result, '{ColumnDef, constraints}', v_constraints);
      result = ast.jsonb_set(result, '{ColumnDef, fdwoptions}', v_fdwoptions);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.table_like_clause ( v_relation jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"TableLikeClause":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{TableLikeClause, relation}', v_relation);
      result = ast.jsonb_set(result, '{TableLikeClause, options}', v_options);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.index_elem ( v_name text DEFAULT NULL, v_expr jsonb DEFAULT NULL, v_indexcolname text DEFAULT NULL, v_collation jsonb DEFAULT NULL, v_opclass jsonb DEFAULT NULL, v_opclassopts jsonb DEFAULT NULL, v_ordering text DEFAULT NULL, v_nulls_ordering text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"IndexElem":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{IndexElem, name}', to_jsonb(v_name));
      result = ast.jsonb_set(result, '{IndexElem, expr}', v_expr);
      result = ast.jsonb_set(result, '{IndexElem, indexcolname}', to_jsonb(v_indexcolname));
      result = ast.jsonb_set(result, '{IndexElem, collation}', v_collation);
      result = ast.jsonb_set(result, '{IndexElem, opclass}', v_opclass);
      result = ast.jsonb_set(result, '{IndexElem, opclassopts}', v_opclassopts);
      result = ast.jsonb_set(result, '{IndexElem, ordering}', to_jsonb(v_ordering));
      result = ast.jsonb_set(result, '{IndexElem, nulls_ordering}', to_jsonb(v_nulls_ordering));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.def_elem ( v_defnamespace text DEFAULT NULL, v_defname text DEFAULT NULL, v_arg jsonb DEFAULT NULL, v_defaction text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"DefElem":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{DefElem, defnamespace}', to_jsonb(v_defnamespace));
      result = ast.jsonb_set(result, '{DefElem, defname}', to_jsonb(v_defname));
      result = ast.jsonb_set(result, '{DefElem, arg}', v_arg);
      result = ast.jsonb_set(result, '{DefElem, defaction}', to_jsonb(v_defaction));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.locking_clause ( v_lockedrels jsonb DEFAULT NULL, v_strength text DEFAULT NULL, v_waitpolicy text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"LockingClause":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{LockingClause, lockedRels}', v_lockedRels);
      result = ast.jsonb_set(result, '{LockingClause, strength}', to_jsonb(v_strength));
      result = ast.jsonb_set(result, '{LockingClause, waitPolicy}', to_jsonb(v_waitPolicy));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.xml_serialize ( v_xmloption text DEFAULT NULL, v_expr jsonb DEFAULT NULL, v_typename jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"XmlSerialize":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{XmlSerialize, xmloption}', to_jsonb(v_xmloption));
      result = ast.jsonb_set(result, '{XmlSerialize, expr}', v_expr);
      result = ast.jsonb_set(result, '{XmlSerialize, typeName}', v_typeName);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.partition_elem ( v_name text DEFAULT NULL, v_expr jsonb DEFAULT NULL, v_collation jsonb DEFAULT NULL, v_opclass jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"PartitionElem":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{PartitionElem, name}', to_jsonb(v_name));
      result = ast.jsonb_set(result, '{PartitionElem, expr}', v_expr);
      result = ast.jsonb_set(result, '{PartitionElem, collation}', v_collation);
      result = ast.jsonb_set(result, '{PartitionElem, opclass}', v_opclass);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.partition_spec ( v_strategy text DEFAULT NULL, v_partparams jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"PartitionSpec":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{PartitionSpec, strategy}', to_jsonb(v_strategy));
      result = ast.jsonb_set(result, '{PartitionSpec, partParams}', v_partParams);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.partition_bound_spec ( v_strategy text DEFAULT NULL, v_is_default boolean DEFAULT NULL, v_modulus int DEFAULT NULL, v_remainder int DEFAULT NULL, v_listdatums jsonb DEFAULT NULL, v_lowerdatums jsonb DEFAULT NULL, v_upperdatums jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"PartitionBoundSpec":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{PartitionBoundSpec, strategy}', to_jsonb(v_strategy));
      result = ast.jsonb_set(result, '{PartitionBoundSpec, is_default}', to_jsonb(v_is_default));
      result = ast.jsonb_set(result, '{PartitionBoundSpec, modulus}', to_jsonb(v_modulus));
      result = ast.jsonb_set(result, '{PartitionBoundSpec, remainder}', to_jsonb(v_remainder));
      result = ast.jsonb_set(result, '{PartitionBoundSpec, listdatums}', v_listdatums);
      result = ast.jsonb_set(result, '{PartitionBoundSpec, lowerdatums}', v_lowerdatums);
      result = ast.jsonb_set(result, '{PartitionBoundSpec, upperdatums}', v_upperdatums);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.partition_range_datum ( v_kind text DEFAULT NULL, v_value jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"PartitionRangeDatum":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{PartitionRangeDatum, kind}', to_jsonb(v_kind));
      result = ast.jsonb_set(result, '{PartitionRangeDatum, value}', v_value);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.partition_cmd ( v_name jsonb DEFAULT NULL, v_bound jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"PartitionCmd":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{PartitionCmd, name}', v_name);
      result = ast.jsonb_set(result, '{PartitionCmd, bound}', v_bound);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_tbl_entry ( v_rtekind text DEFAULT NULL, v_relid jsonb DEFAULT NULL, v_relkind text DEFAULT NULL, v_rellockmode int DEFAULT NULL, v_tablesample jsonb DEFAULT NULL, v_subquery jsonb DEFAULT NULL, v_security_barrier boolean DEFAULT NULL, v_jointype text DEFAULT NULL, v_joinmergedcols int DEFAULT NULL, v_joinaliasvars jsonb DEFAULT NULL, v_joinleftcols jsonb DEFAULT NULL, v_joinrightcols jsonb DEFAULT NULL, v_functions jsonb DEFAULT NULL, v_funcordinality boolean DEFAULT NULL, v_tablefunc jsonb DEFAULT NULL, v_values_lists jsonb DEFAULT NULL, v_ctename text DEFAULT NULL, v_ctelevelsup jsonb DEFAULT NULL, v_self_reference boolean DEFAULT NULL, v_coltypes jsonb DEFAULT NULL, v_coltypmods jsonb DEFAULT NULL, v_colcollations jsonb DEFAULT NULL, v_enrname text DEFAULT NULL, v_enrtuples pg_catalog.float8 DEFAULT NULL, v_alias jsonb DEFAULT NULL, v_eref jsonb DEFAULT NULL, v_lateral boolean DEFAULT NULL, v_inh boolean DEFAULT NULL, v_infromcl boolean DEFAULT NULL, v_requiredperms jsonb DEFAULT NULL, v_checkasuser jsonb DEFAULT NULL, v_selectedcols jsonb DEFAULT NULL, v_insertedcols jsonb DEFAULT NULL, v_updatedcols jsonb DEFAULT NULL, v_extraupdatedcols jsonb DEFAULT NULL, v_securityquals jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RangeTblEntry":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RangeTblEntry, rtekind}', to_jsonb(v_rtekind));
      result = ast.jsonb_set(result, '{RangeTblEntry, relid}', v_relid);
      result = ast.jsonb_set(result, '{RangeTblEntry, relkind}', to_jsonb(v_relkind));
      result = ast.jsonb_set(result, '{RangeTblEntry, rellockmode}', to_jsonb(v_rellockmode));
      result = ast.jsonb_set(result, '{RangeTblEntry, tablesample}', v_tablesample);
      result = ast.jsonb_set(result, '{RangeTblEntry, subquery}', v_subquery);
      result = ast.jsonb_set(result, '{RangeTblEntry, security_barrier}', to_jsonb(v_security_barrier));
      result = ast.jsonb_set(result, '{RangeTblEntry, jointype}', to_jsonb(v_jointype));
      result = ast.jsonb_set(result, '{RangeTblEntry, joinmergedcols}', to_jsonb(v_joinmergedcols));
      result = ast.jsonb_set(result, '{RangeTblEntry, joinaliasvars}', v_joinaliasvars);
      result = ast.jsonb_set(result, '{RangeTblEntry, joinleftcols}', v_joinleftcols);
      result = ast.jsonb_set(result, '{RangeTblEntry, joinrightcols}', v_joinrightcols);
      result = ast.jsonb_set(result, '{RangeTblEntry, functions}', v_functions);
      result = ast.jsonb_set(result, '{RangeTblEntry, funcordinality}', to_jsonb(v_funcordinality));
      result = ast.jsonb_set(result, '{RangeTblEntry, tablefunc}', v_tablefunc);
      result = ast.jsonb_set(result, '{RangeTblEntry, values_lists}', v_values_lists);
      result = ast.jsonb_set(result, '{RangeTblEntry, ctename}', to_jsonb(v_ctename));
      result = ast.jsonb_set(result, '{RangeTblEntry, ctelevelsup}', v_ctelevelsup);
      result = ast.jsonb_set(result, '{RangeTblEntry, self_reference}', to_jsonb(v_self_reference));
      result = ast.jsonb_set(result, '{RangeTblEntry, coltypes}', v_coltypes);
      result = ast.jsonb_set(result, '{RangeTblEntry, coltypmods}', v_coltypmods);
      result = ast.jsonb_set(result, '{RangeTblEntry, colcollations}', v_colcollations);
      result = ast.jsonb_set(result, '{RangeTblEntry, enrname}', to_jsonb(v_enrname));
      result = ast.jsonb_set(result, '{RangeTblEntry, enrtuples}', to_jsonb(v_enrtuples));
      result = ast.jsonb_set(result, '{RangeTblEntry, alias}', v_alias);
      result = ast.jsonb_set(result, '{RangeTblEntry, eref}', v_eref);
      result = ast.jsonb_set(result, '{RangeTblEntry, lateral}', to_jsonb(v_lateral));
      result = ast.jsonb_set(result, '{RangeTblEntry, inh}', to_jsonb(v_inh));
      result = ast.jsonb_set(result, '{RangeTblEntry, inFromCl}', to_jsonb(v_inFromCl));
      result = ast.jsonb_set(result, '{RangeTblEntry, requiredPerms}', v_requiredPerms);
      result = ast.jsonb_set(result, '{RangeTblEntry, checkAsUser}', v_checkAsUser);
      result = ast.jsonb_set(result, '{RangeTblEntry, selectedCols}', v_selectedCols);
      result = ast.jsonb_set(result, '{RangeTblEntry, insertedCols}', v_insertedCols);
      result = ast.jsonb_set(result, '{RangeTblEntry, updatedCols}', v_updatedCols);
      result = ast.jsonb_set(result, '{RangeTblEntry, extraUpdatedCols}', v_extraUpdatedCols);
      result = ast.jsonb_set(result, '{RangeTblEntry, securityQuals}', v_securityQuals);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.range_tbl_function ( v_funcexpr jsonb DEFAULT NULL, v_funccolcount int DEFAULT NULL, v_funccolnames jsonb DEFAULT NULL, v_funccoltypes jsonb DEFAULT NULL, v_funccoltypmods jsonb DEFAULT NULL, v_funccolcollations jsonb DEFAULT NULL, v_funcparams jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RangeTblFunction":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RangeTblFunction, funcexpr}', v_funcexpr);
      result = ast.jsonb_set(result, '{RangeTblFunction, funccolcount}', to_jsonb(v_funccolcount));
      result = ast.jsonb_set(result, '{RangeTblFunction, funccolnames}', v_funccolnames);
      result = ast.jsonb_set(result, '{RangeTblFunction, funccoltypes}', v_funccoltypes);
      result = ast.jsonb_set(result, '{RangeTblFunction, funccoltypmods}', v_funccoltypmods);
      result = ast.jsonb_set(result, '{RangeTblFunction, funccolcollations}', v_funccolcollations);
      result = ast.jsonb_set(result, '{RangeTblFunction, funcparams}', v_funcparams);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.table_sample_clause ( v_tsmhandler jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL, v_repeatable jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"TableSampleClause":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{TableSampleClause, tsmhandler}', v_tsmhandler);
      result = ast.jsonb_set(result, '{TableSampleClause, args}', v_args);
      result = ast.jsonb_set(result, '{TableSampleClause, repeatable}', v_repeatable);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.with_check_option ( v_kind text DEFAULT NULL, v_relname text DEFAULT NULL, v_polname text DEFAULT NULL, v_qual jsonb DEFAULT NULL, v_cascaded boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"WithCheckOption":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{WithCheckOption, kind}', to_jsonb(v_kind));
      result = ast.jsonb_set(result, '{WithCheckOption, relname}', to_jsonb(v_relname));
      result = ast.jsonb_set(result, '{WithCheckOption, polname}', to_jsonb(v_polname));
      result = ast.jsonb_set(result, '{WithCheckOption, qual}', v_qual);
      result = ast.jsonb_set(result, '{WithCheckOption, cascaded}', to_jsonb(v_cascaded));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.sort_group_clause ( v_tlesortgroupref jsonb DEFAULT NULL, v_eqop jsonb DEFAULT NULL, v_sortop jsonb DEFAULT NULL, v_nulls_first boolean DEFAULT NULL, v_hashable boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"SortGroupClause":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{SortGroupClause, tleSortGroupRef}', v_tleSortGroupRef);
      result = ast.jsonb_set(result, '{SortGroupClause, eqop}', v_eqop);
      result = ast.jsonb_set(result, '{SortGroupClause, sortop}', v_sortop);
      result = ast.jsonb_set(result, '{SortGroupClause, nulls_first}', to_jsonb(v_nulls_first));
      result = ast.jsonb_set(result, '{SortGroupClause, hashable}', to_jsonb(v_hashable));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grouping_set ( v_kind text DEFAULT NULL, v_content jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"GroupingSet":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{GroupingSet, kind}', to_jsonb(v_kind));
      result = ast.jsonb_set(result, '{GroupingSet, content}', v_content);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.window_clause ( v_name text DEFAULT NULL, v_refname text DEFAULT NULL, v_partitionclause jsonb DEFAULT NULL, v_orderclause jsonb DEFAULT NULL, v_frameoptions int DEFAULT NULL, v_startoffset jsonb DEFAULT NULL, v_endoffset jsonb DEFAULT NULL, v_startinrangefunc jsonb DEFAULT NULL, v_endinrangefunc jsonb DEFAULT NULL, v_inrangecoll jsonb DEFAULT NULL, v_inrangeasc boolean DEFAULT NULL, v_inrangenullsfirst boolean DEFAULT NULL, v_winref jsonb DEFAULT NULL, v_copiedorder boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"WindowClause":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{WindowClause, name}', to_jsonb(v_name));
      result = ast.jsonb_set(result, '{WindowClause, refname}', to_jsonb(v_refname));
      result = ast.jsonb_set(result, '{WindowClause, partitionClause}', v_partitionClause);
      result = ast.jsonb_set(result, '{WindowClause, orderClause}', v_orderClause);
      result = ast.jsonb_set(result, '{WindowClause, frameOptions}', to_jsonb(v_frameOptions));
      result = ast.jsonb_set(result, '{WindowClause, startOffset}', v_startOffset);
      result = ast.jsonb_set(result, '{WindowClause, endOffset}', v_endOffset);
      result = ast.jsonb_set(result, '{WindowClause, startInRangeFunc}', v_startInRangeFunc);
      result = ast.jsonb_set(result, '{WindowClause, endInRangeFunc}', v_endInRangeFunc);
      result = ast.jsonb_set(result, '{WindowClause, inRangeColl}', v_inRangeColl);
      result = ast.jsonb_set(result, '{WindowClause, inRangeAsc}', to_jsonb(v_inRangeAsc));
      result = ast.jsonb_set(result, '{WindowClause, inRangeNullsFirst}', to_jsonb(v_inRangeNullsFirst));
      result = ast.jsonb_set(result, '{WindowClause, winref}', v_winref);
      result = ast.jsonb_set(result, '{WindowClause, copiedOrder}', to_jsonb(v_copiedOrder));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.row_mark_clause ( v_rti jsonb DEFAULT NULL, v_strength text DEFAULT NULL, v_waitpolicy text DEFAULT NULL, v_pusheddown boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RowMarkClause":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RowMarkClause, rti}', v_rti);
      result = ast.jsonb_set(result, '{RowMarkClause, strength}', to_jsonb(v_strength));
      result = ast.jsonb_set(result, '{RowMarkClause, waitPolicy}', to_jsonb(v_waitPolicy));
      result = ast.jsonb_set(result, '{RowMarkClause, pushedDown}', to_jsonb(v_pushedDown));
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

CREATE FUNCTION ast.infer_clause ( v_indexelems jsonb DEFAULT NULL, v_whereclause jsonb DEFAULT NULL, v_conname text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"InferClause":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{InferClause, indexElems}', v_indexElems);
      result = ast.jsonb_set(result, '{InferClause, whereClause}', v_whereClause);
      result = ast.jsonb_set(result, '{InferClause, conname}', to_jsonb(v_conname));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.on_conflict_clause ( v_action text DEFAULT NULL, v_infer jsonb DEFAULT NULL, v_targetlist jsonb DEFAULT NULL, v_whereclause jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.common_table_expr ( v_ctename text DEFAULT NULL, v_aliascolnames jsonb DEFAULT NULL, v_ctematerialized text DEFAULT NULL, v_ctequery jsonb DEFAULT NULL, v_cterecursive boolean DEFAULT NULL, v_cterefcount int DEFAULT NULL, v_ctecolnames jsonb DEFAULT NULL, v_ctecoltypes jsonb DEFAULT NULL, v_ctecoltypmods jsonb DEFAULT NULL, v_ctecolcollations jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CommonTableExpr":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CommonTableExpr, ctename}', to_jsonb(v_ctename));
      result = ast.jsonb_set(result, '{CommonTableExpr, aliascolnames}', v_aliascolnames);
      result = ast.jsonb_set(result, '{CommonTableExpr, ctematerialized}', to_jsonb(v_ctematerialized));
      result = ast.jsonb_set(result, '{CommonTableExpr, ctequery}', v_ctequery);
      result = ast.jsonb_set(result, '{CommonTableExpr, cterecursive}', to_jsonb(v_cterecursive));
      result = ast.jsonb_set(result, '{CommonTableExpr, cterefcount}', to_jsonb(v_cterefcount));
      result = ast.jsonb_set(result, '{CommonTableExpr, ctecolnames}', v_ctecolnames);
      result = ast.jsonb_set(result, '{CommonTableExpr, ctecoltypes}', v_ctecoltypes);
      result = ast.jsonb_set(result, '{CommonTableExpr, ctecoltypmods}', v_ctecoltypmods);
      result = ast.jsonb_set(result, '{CommonTableExpr, ctecolcollations}', v_ctecolcollations);
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

CREATE FUNCTION ast.raw_stmt ( v_stmt jsonb DEFAULT NULL, v_stmt_len int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RawStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RawStmt, stmt}', v_stmt);
      result = ast.jsonb_set(result, '{RawStmt, stmt_len}', to_jsonb(v_stmt_len));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.insert_stmt ( v_relation jsonb DEFAULT NULL, v_cols jsonb DEFAULT NULL, v_selectstmt jsonb DEFAULT NULL, v_onconflictclause jsonb DEFAULT NULL, v_returninglist jsonb DEFAULT NULL, v_withclause jsonb DEFAULT NULL, v_override text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"InsertStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{InsertStmt, relation}', v_relation);
      result = ast.jsonb_set(result, '{InsertStmt, cols}', v_cols);
      result = ast.jsonb_set(result, '{InsertStmt, selectStmt}', v_selectStmt);
      result = ast.jsonb_set(result, '{InsertStmt, onConflictClause}', v_onConflictClause);
      result = ast.jsonb_set(result, '{InsertStmt, returningList}', v_returningList);
      result = ast.jsonb_set(result, '{InsertStmt, withClause}', v_withClause);
      result = ast.jsonb_set(result, '{InsertStmt, override}', to_jsonb(v_override));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.delete_stmt ( v_relation jsonb DEFAULT NULL, v_usingclause jsonb DEFAULT NULL, v_whereclause jsonb DEFAULT NULL, v_returninglist jsonb DEFAULT NULL, v_withclause jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"DeleteStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{DeleteStmt, relation}', v_relation);
      result = ast.jsonb_set(result, '{DeleteStmt, usingClause}', v_usingClause);
      result = ast.jsonb_set(result, '{DeleteStmt, whereClause}', v_whereClause);
      result = ast.jsonb_set(result, '{DeleteStmt, returningList}', v_returningList);
      result = ast.jsonb_set(result, '{DeleteStmt, withClause}', v_withClause);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.update_stmt ( v_relation jsonb DEFAULT NULL, v_targetlist jsonb DEFAULT NULL, v_whereclause jsonb DEFAULT NULL, v_fromclause jsonb DEFAULT NULL, v_returninglist jsonb DEFAULT NULL, v_withclause jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"UpdateStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{UpdateStmt, relation}', v_relation);
      result = ast.jsonb_set(result, '{UpdateStmt, targetList}', v_targetList);
      result = ast.jsonb_set(result, '{UpdateStmt, whereClause}', v_whereClause);
      result = ast.jsonb_set(result, '{UpdateStmt, fromClause}', v_fromClause);
      result = ast.jsonb_set(result, '{UpdateStmt, returningList}', v_returningList);
      result = ast.jsonb_set(result, '{UpdateStmt, withClause}', v_withClause);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.select_stmt ( v_distinctclause jsonb DEFAULT NULL, v_intoclause jsonb DEFAULT NULL, v_targetlist jsonb DEFAULT NULL, v_fromclause jsonb DEFAULT NULL, v_whereclause jsonb DEFAULT NULL, v_groupclause jsonb DEFAULT NULL, v_havingclause jsonb DEFAULT NULL, v_windowclause jsonb DEFAULT NULL, v_valueslists jsonb DEFAULT NULL, v_sortclause jsonb DEFAULT NULL, v_limitoffset jsonb DEFAULT NULL, v_limitcount jsonb DEFAULT NULL, v_limitoption text DEFAULT NULL, v_lockingclause jsonb DEFAULT NULL, v_withclause jsonb DEFAULT NULL, v_op text DEFAULT NULL, v_all boolean DEFAULT NULL, v_larg jsonb DEFAULT NULL, v_rarg jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"SelectStmt":{}}'::jsonb;
  BEGIN
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
      result = ast.jsonb_set(result, '{SelectStmt, limitOption}', to_jsonb(v_limitOption));
      result = ast.jsonb_set(result, '{SelectStmt, lockingClause}', v_lockingClause);
      result = ast.jsonb_set(result, '{SelectStmt, withClause}', v_withClause);
      result = ast.jsonb_set(result, '{SelectStmt, op}', to_jsonb(v_op));
      result = ast.jsonb_set(result, '{SelectStmt, all}', to_jsonb(v_all));
      result = ast.jsonb_set(result, '{SelectStmt, larg}', v_larg);
      result = ast.jsonb_set(result, '{SelectStmt, rarg}', v_rarg);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.set_operation_stmt ( v_op text DEFAULT NULL, v_all boolean DEFAULT NULL, v_larg jsonb DEFAULT NULL, v_rarg jsonb DEFAULT NULL, v_coltypes jsonb DEFAULT NULL, v_coltypmods jsonb DEFAULT NULL, v_colcollations jsonb DEFAULT NULL, v_groupclauses jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"SetOperationStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{SetOperationStmt, op}', to_jsonb(v_op));
      result = ast.jsonb_set(result, '{SetOperationStmt, all}', to_jsonb(v_all));
      result = ast.jsonb_set(result, '{SetOperationStmt, larg}', v_larg);
      result = ast.jsonb_set(result, '{SetOperationStmt, rarg}', v_rarg);
      result = ast.jsonb_set(result, '{SetOperationStmt, colTypes}', v_colTypes);
      result = ast.jsonb_set(result, '{SetOperationStmt, colTypmods}', v_colTypmods);
      result = ast.jsonb_set(result, '{SetOperationStmt, colCollations}', v_colCollations);
      result = ast.jsonb_set(result, '{SetOperationStmt, groupClauses}', v_groupClauses);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_schema_stmt ( v_schemaname text DEFAULT NULL, v_authrole jsonb DEFAULT NULL, v_schemaelts jsonb DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateSchemaStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateSchemaStmt, schemaname}', to_jsonb(v_schemaname));
      result = ast.jsonb_set(result, '{CreateSchemaStmt, authrole}', v_authrole);
      result = ast.jsonb_set(result, '{CreateSchemaStmt, schemaElts}', v_schemaElts);
      result = ast.jsonb_set(result, '{CreateSchemaStmt, if_not_exists}', to_jsonb(v_if_not_exists));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_table_stmt ( v_relation jsonb DEFAULT NULL, v_cmds jsonb DEFAULT NULL, v_relkind text DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.replica_identity_stmt ( v_identity_type text DEFAULT NULL, v_name text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"ReplicaIdentityStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{ReplicaIdentityStmt, identity_type}', to_jsonb(v_identity_type));
      result = ast.jsonb_set(result, '{ReplicaIdentityStmt, name}', to_jsonb(v_name));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_table_cmd ( v_subtype text DEFAULT NULL, v_name text DEFAULT NULL, v_num int DEFAULT NULL, v_newowner jsonb DEFAULT NULL, v_def jsonb DEFAULT NULL, v_behavior text DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterTableCmd":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterTableCmd, subtype}', to_jsonb(v_subtype));
      result = ast.jsonb_set(result, '{AlterTableCmd, name}', to_jsonb(v_name));
      result = ast.jsonb_set(result, '{AlterTableCmd, num}', to_jsonb(v_num));
      result = ast.jsonb_set(result, '{AlterTableCmd, newowner}', v_newowner);
      result = ast.jsonb_set(result, '{AlterTableCmd, def}', v_def);
      result = ast.jsonb_set(result, '{AlterTableCmd, behavior}', to_jsonb(v_behavior));
      result = ast.jsonb_set(result, '{AlterTableCmd, missing_ok}', to_jsonb(v_missing_ok));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_collation_stmt ( v_collname jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterCollationStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterCollationStmt, collname}', v_collname);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_domain_stmt ( v_subtype text DEFAULT NULL, v_typename jsonb DEFAULT NULL, v_name text DEFAULT NULL, v_def jsonb DEFAULT NULL, v_behavior text DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterDomainStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterDomainStmt, subtype}', to_jsonb(v_subtype));
      result = ast.jsonb_set(result, '{AlterDomainStmt, typeName}', v_typeName);
      result = ast.jsonb_set(result, '{AlterDomainStmt, name}', to_jsonb(v_name));
      result = ast.jsonb_set(result, '{AlterDomainStmt, def}', v_def);
      result = ast.jsonb_set(result, '{AlterDomainStmt, behavior}', to_jsonb(v_behavior));
      result = ast.jsonb_set(result, '{AlterDomainStmt, missing_ok}', to_jsonb(v_missing_ok));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grant_stmt ( v_is_grant boolean DEFAULT NULL, v_targtype text DEFAULT NULL, v_objtype text DEFAULT NULL, v_objects jsonb DEFAULT NULL, v_privileges jsonb DEFAULT NULL, v_grantees jsonb DEFAULT NULL, v_grant_option boolean DEFAULT NULL, v_behavior text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"GrantStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{GrantStmt, is_grant}', to_jsonb(v_is_grant));
      result = ast.jsonb_set(result, '{GrantStmt, targtype}', to_jsonb(v_targtype));
      result = ast.jsonb_set(result, '{GrantStmt, objtype}', to_jsonb(v_objtype));
      result = ast.jsonb_set(result, '{GrantStmt, objects}', v_objects);
      result = ast.jsonb_set(result, '{GrantStmt, privileges}', v_privileges);
      result = ast.jsonb_set(result, '{GrantStmt, grantees}', v_grantees);
      result = ast.jsonb_set(result, '{GrantStmt, grant_option}', to_jsonb(v_grant_option));
      result = ast.jsonb_set(result, '{GrantStmt, behavior}', to_jsonb(v_behavior));
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

CREATE FUNCTION ast.access_priv ( v_priv_name text DEFAULT NULL, v_cols jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AccessPriv":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AccessPriv, priv_name}', to_jsonb(v_priv_name));
      result = ast.jsonb_set(result, '{AccessPriv, cols}', v_cols);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.grant_role_stmt ( v_granted_roles jsonb DEFAULT NULL, v_grantee_roles jsonb DEFAULT NULL, v_is_grant boolean DEFAULT NULL, v_admin_opt boolean DEFAULT NULL, v_grantor jsonb DEFAULT NULL, v_behavior text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"GrantRoleStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{GrantRoleStmt, granted_roles}', v_granted_roles);
      result = ast.jsonb_set(result, '{GrantRoleStmt, grantee_roles}', v_grantee_roles);
      result = ast.jsonb_set(result, '{GrantRoleStmt, is_grant}', to_jsonb(v_is_grant));
      result = ast.jsonb_set(result, '{GrantRoleStmt, admin_opt}', to_jsonb(v_admin_opt));
      result = ast.jsonb_set(result, '{GrantRoleStmt, grantor}', v_grantor);
      result = ast.jsonb_set(result, '{GrantRoleStmt, behavior}', to_jsonb(v_behavior));
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

CREATE FUNCTION ast.copy_stmt ( v_relation jsonb DEFAULT NULL, v_query jsonb DEFAULT NULL, v_attlist jsonb DEFAULT NULL, v_is_from boolean DEFAULT NULL, v_is_program boolean DEFAULT NULL, v_filename text DEFAULT NULL, v_options jsonb DEFAULT NULL, v_whereclause jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CopyStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CopyStmt, relation}', v_relation);
      result = ast.jsonb_set(result, '{CopyStmt, query}', v_query);
      result = ast.jsonb_set(result, '{CopyStmt, attlist}', v_attlist);
      result = ast.jsonb_set(result, '{CopyStmt, is_from}', to_jsonb(v_is_from));
      result = ast.jsonb_set(result, '{CopyStmt, is_program}', to_jsonb(v_is_program));
      result = ast.jsonb_set(result, '{CopyStmt, filename}', to_jsonb(v_filename));
      result = ast.jsonb_set(result, '{CopyStmt, options}', v_options);
      result = ast.jsonb_set(result, '{CopyStmt, whereClause}', v_whereClause);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.variable_set_stmt ( v_kind text DEFAULT NULL, v_name text DEFAULT NULL, v_args jsonb DEFAULT NULL, v_is_local boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.create_stmt ( v_relation jsonb DEFAULT NULL, v_tableelts jsonb DEFAULT NULL, v_inhrelations jsonb DEFAULT NULL, v_partbound jsonb DEFAULT NULL, v_partspec jsonb DEFAULT NULL, v_oftypename jsonb DEFAULT NULL, v_constraints jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL, v_oncommit text DEFAULT NULL, v_tablespacename text DEFAULT NULL, v_accessmethod text DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateStmt, relation}', v_relation);
      result = ast.jsonb_set(result, '{CreateStmt, tableElts}', v_tableElts);
      result = ast.jsonb_set(result, '{CreateStmt, inhRelations}', v_inhRelations);
      result = ast.jsonb_set(result, '{CreateStmt, partbound}', v_partbound);
      result = ast.jsonb_set(result, '{CreateStmt, partspec}', v_partspec);
      result = ast.jsonb_set(result, '{CreateStmt, ofTypename}', v_ofTypename);
      result = ast.jsonb_set(result, '{CreateStmt, constraints}', v_constraints);
      result = ast.jsonb_set(result, '{CreateStmt, options}', v_options);
      result = ast.jsonb_set(result, '{CreateStmt, oncommit}', to_jsonb(v_oncommit));
      result = ast.jsonb_set(result, '{CreateStmt, tablespacename}', to_jsonb(v_tablespacename));
      result = ast.jsonb_set(result, '{CreateStmt, accessMethod}', to_jsonb(v_accessMethod));
      result = ast.jsonb_set(result, '{CreateStmt, if_not_exists}', to_jsonb(v_if_not_exists));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.constraint ( v_contype text DEFAULT NULL, v_conname text DEFAULT NULL, v_deferrable boolean DEFAULT NULL, v_initdeferred boolean DEFAULT NULL, v_is_no_inherit boolean DEFAULT NULL, v_raw_expr jsonb DEFAULT NULL, v_cooked_expr text DEFAULT NULL, v_generated_when text DEFAULT NULL, v_keys jsonb DEFAULT NULL, v_including jsonb DEFAULT NULL, v_exclusions jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL, v_indexname text DEFAULT NULL, v_indexspace text DEFAULT NULL, v_reset_default_tblspc boolean DEFAULT NULL, v_access_method text DEFAULT NULL, v_where_clause jsonb DEFAULT NULL, v_pktable jsonb DEFAULT NULL, v_fk_attrs jsonb DEFAULT NULL, v_pk_attrs jsonb DEFAULT NULL, v_fk_matchtype text DEFAULT NULL, v_fk_upd_action text DEFAULT NULL, v_fk_del_action text DEFAULT NULL, v_old_conpfeqop jsonb DEFAULT NULL, v_old_pktable_oid jsonb DEFAULT NULL, v_skip_validation boolean DEFAULT NULL, v_initially_valid boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"Constraint":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{Constraint, contype}', to_jsonb(v_contype));
      result = ast.jsonb_set(result, '{Constraint, conname}', to_jsonb(v_conname));
      result = ast.jsonb_set(result, '{Constraint, deferrable}', to_jsonb(v_deferrable));
      result = ast.jsonb_set(result, '{Constraint, initdeferred}', to_jsonb(v_initdeferred));
      result = ast.jsonb_set(result, '{Constraint, is_no_inherit}', to_jsonb(v_is_no_inherit));
      result = ast.jsonb_set(result, '{Constraint, raw_expr}', v_raw_expr);
      result = ast.jsonb_set(result, '{Constraint, cooked_expr}', to_jsonb(v_cooked_expr));
      result = ast.jsonb_set(result, '{Constraint, generated_when}', to_jsonb(v_generated_when));
      result = ast.jsonb_set(result, '{Constraint, keys}', v_keys);
      result = ast.jsonb_set(result, '{Constraint, including}', v_including);
      result = ast.jsonb_set(result, '{Constraint, exclusions}', v_exclusions);
      result = ast.jsonb_set(result, '{Constraint, options}', v_options);
      result = ast.jsonb_set(result, '{Constraint, indexname}', to_jsonb(v_indexname));
      result = ast.jsonb_set(result, '{Constraint, indexspace}', to_jsonb(v_indexspace));
      result = ast.jsonb_set(result, '{Constraint, reset_default_tblspc}', to_jsonb(v_reset_default_tblspc));
      result = ast.jsonb_set(result, '{Constraint, access_method}', to_jsonb(v_access_method));
      result = ast.jsonb_set(result, '{Constraint, where_clause}', v_where_clause);
      result = ast.jsonb_set(result, '{Constraint, pktable}', v_pktable);
      result = ast.jsonb_set(result, '{Constraint, fk_attrs}', v_fk_attrs);
      result = ast.jsonb_set(result, '{Constraint, pk_attrs}', v_pk_attrs);
      result = ast.jsonb_set(result, '{Constraint, fk_matchtype}', to_jsonb(v_fk_matchtype));
      result = ast.jsonb_set(result, '{Constraint, fk_upd_action}', to_jsonb(v_fk_upd_action));
      result = ast.jsonb_set(result, '{Constraint, fk_del_action}', to_jsonb(v_fk_del_action));
      result = ast.jsonb_set(result, '{Constraint, old_conpfeqop}', v_old_conpfeqop);
      result = ast.jsonb_set(result, '{Constraint, old_pktable_oid}', v_old_pktable_oid);
      result = ast.jsonb_set(result, '{Constraint, skip_validation}', to_jsonb(v_skip_validation));
      result = ast.jsonb_set(result, '{Constraint, initially_valid}', to_jsonb(v_initially_valid));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_table_space_stmt ( v_tablespacename text DEFAULT NULL, v_owner jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateTableSpaceStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateTableSpaceStmt, tablespacename}', to_jsonb(v_tablespacename));
      result = ast.jsonb_set(result, '{CreateTableSpaceStmt, owner}', v_owner);
      result = ast.jsonb_set(result, '{CreateTableSpaceStmt, options}', v_options);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.drop_table_space_stmt ( v_tablespacename text DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"DropTableSpaceStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{DropTableSpaceStmt, tablespacename}', to_jsonb(v_tablespacename));
      result = ast.jsonb_set(result, '{DropTableSpaceStmt, missing_ok}', to_jsonb(v_missing_ok));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_table_space_options_stmt ( v_tablespacename text DEFAULT NULL, v_options jsonb DEFAULT NULL, v_isreset boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterTableSpaceOptionsStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterTableSpaceOptionsStmt, tablespacename}', to_jsonb(v_tablespacename));
      result = ast.jsonb_set(result, '{AlterTableSpaceOptionsStmt, options}', v_options);
      result = ast.jsonb_set(result, '{AlterTableSpaceOptionsStmt, isReset}', to_jsonb(v_isReset));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_table_move_all_stmt ( v_orig_tablespacename text DEFAULT NULL, v_objtype text DEFAULT NULL, v_roles jsonb DEFAULT NULL, v_new_tablespacename text DEFAULT NULL, v_nowait boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterTableMoveAllStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterTableMoveAllStmt, orig_tablespacename}', to_jsonb(v_orig_tablespacename));
      result = ast.jsonb_set(result, '{AlterTableMoveAllStmt, objtype}', to_jsonb(v_objtype));
      result = ast.jsonb_set(result, '{AlterTableMoveAllStmt, roles}', v_roles);
      result = ast.jsonb_set(result, '{AlterTableMoveAllStmt, new_tablespacename}', to_jsonb(v_new_tablespacename));
      result = ast.jsonb_set(result, '{AlterTableMoveAllStmt, nowait}', to_jsonb(v_nowait));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_extension_stmt ( v_extname text DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateExtensionStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateExtensionStmt, extname}', to_jsonb(v_extname));
      result = ast.jsonb_set(result, '{CreateExtensionStmt, if_not_exists}', to_jsonb(v_if_not_exists));
      result = ast.jsonb_set(result, '{CreateExtensionStmt, options}', v_options);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_extension_stmt ( v_extname text DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterExtensionStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterExtensionStmt, extname}', to_jsonb(v_extname));
      result = ast.jsonb_set(result, '{AlterExtensionStmt, options}', v_options);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_extension_contents_stmt ( v_extname text DEFAULT NULL, v_action int DEFAULT NULL, v_objtype text DEFAULT NULL, v_object jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterExtensionContentsStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterExtensionContentsStmt, extname}', to_jsonb(v_extname));
      result = ast.jsonb_set(result, '{AlterExtensionContentsStmt, action}', to_jsonb(v_action));
      result = ast.jsonb_set(result, '{AlterExtensionContentsStmt, objtype}', to_jsonb(v_objtype));
      result = ast.jsonb_set(result, '{AlterExtensionContentsStmt, object}', v_object);
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

CREATE FUNCTION ast.create_foreign_server_stmt ( v_servername text DEFAULT NULL, v_servertype text DEFAULT NULL, v_version text DEFAULT NULL, v_fdwname text DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateForeignServerStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateForeignServerStmt, servername}', to_jsonb(v_servername));
      result = ast.jsonb_set(result, '{CreateForeignServerStmt, servertype}', to_jsonb(v_servertype));
      result = ast.jsonb_set(result, '{CreateForeignServerStmt, version}', to_jsonb(v_version));
      result = ast.jsonb_set(result, '{CreateForeignServerStmt, fdwname}', to_jsonb(v_fdwname));
      result = ast.jsonb_set(result, '{CreateForeignServerStmt, if_not_exists}', to_jsonb(v_if_not_exists));
      result = ast.jsonb_set(result, '{CreateForeignServerStmt, options}', v_options);
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

CREATE FUNCTION ast.create_user_mapping_stmt ( v_user jsonb DEFAULT NULL, v_servername text DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateUserMappingStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateUserMappingStmt, user}', v_user);
      result = ast.jsonb_set(result, '{CreateUserMappingStmt, servername}', to_jsonb(v_servername));
      result = ast.jsonb_set(result, '{CreateUserMappingStmt, if_not_exists}', to_jsonb(v_if_not_exists));
      result = ast.jsonb_set(result, '{CreateUserMappingStmt, options}', v_options);
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

CREATE FUNCTION ast.import_foreign_schema_stmt ( v_server_name text DEFAULT NULL, v_remote_schema text DEFAULT NULL, v_local_schema text DEFAULT NULL, v_list_type text DEFAULT NULL, v_table_list jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.alter_policy_stmt ( v_policy_name text DEFAULT NULL, v_table jsonb DEFAULT NULL, v_roles jsonb DEFAULT NULL, v_qual jsonb DEFAULT NULL, v_with_check jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterPolicyStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterPolicyStmt, policy_name}', to_jsonb(v_policy_name));
      result = ast.jsonb_set(result, '{AlterPolicyStmt, table}', v_table);
      result = ast.jsonb_set(result, '{AlterPolicyStmt, roles}', v_roles);
      result = ast.jsonb_set(result, '{AlterPolicyStmt, qual}', v_qual);
      result = ast.jsonb_set(result, '{AlterPolicyStmt, with_check}', v_with_check);
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

CREATE FUNCTION ast.create_trig_stmt ( v_trigname text DEFAULT NULL, v_relation jsonb DEFAULT NULL, v_funcname jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL, v_row boolean DEFAULT NULL, v_timing int DEFAULT NULL, v_events int DEFAULT NULL, v_columns jsonb DEFAULT NULL, v_whenclause jsonb DEFAULT NULL, v_isconstraint boolean DEFAULT NULL, v_transitionrels jsonb DEFAULT NULL, v_deferrable boolean DEFAULT NULL, v_initdeferred boolean DEFAULT NULL, v_constrrel jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateTrigStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateTrigStmt, trigname}', to_jsonb(v_trigname));
      result = ast.jsonb_set(result, '{CreateTrigStmt, relation}', v_relation);
      result = ast.jsonb_set(result, '{CreateTrigStmt, funcname}', v_funcname);
      result = ast.jsonb_set(result, '{CreateTrigStmt, args}', v_args);
      result = ast.jsonb_set(result, '{CreateTrigStmt, row}', to_jsonb(v_row));
      result = ast.jsonb_set(result, '{CreateTrigStmt, timing}', to_jsonb(v_timing));
      result = ast.jsonb_set(result, '{CreateTrigStmt, events}', to_jsonb(v_events));
      result = ast.jsonb_set(result, '{CreateTrigStmt, columns}', v_columns);
      result = ast.jsonb_set(result, '{CreateTrigStmt, whenClause}', v_whenClause);
      result = ast.jsonb_set(result, '{CreateTrigStmt, isconstraint}', to_jsonb(v_isconstraint));
      result = ast.jsonb_set(result, '{CreateTrigStmt, transitionRels}', v_transitionRels);
      result = ast.jsonb_set(result, '{CreateTrigStmt, deferrable}', to_jsonb(v_deferrable));
      result = ast.jsonb_set(result, '{CreateTrigStmt, initdeferred}', to_jsonb(v_initdeferred));
      result = ast.jsonb_set(result, '{CreateTrigStmt, constrrel}', v_constrrel);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_event_trig_stmt ( v_trigname text DEFAULT NULL, v_eventname text DEFAULT NULL, v_whenclause jsonb DEFAULT NULL, v_funcname jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateEventTrigStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateEventTrigStmt, trigname}', to_jsonb(v_trigname));
      result = ast.jsonb_set(result, '{CreateEventTrigStmt, eventname}', to_jsonb(v_eventname));
      result = ast.jsonb_set(result, '{CreateEventTrigStmt, whenclause}', v_whenclause);
      result = ast.jsonb_set(result, '{CreateEventTrigStmt, funcname}', v_funcname);
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

CREATE FUNCTION ast.create_p_lang_stmt ( v_replace boolean DEFAULT NULL, v_plname text DEFAULT NULL, v_plhandler jsonb DEFAULT NULL, v_plinline jsonb DEFAULT NULL, v_plvalidator jsonb DEFAULT NULL, v_pltrusted boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreatePLangStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreatePLangStmt, replace}', to_jsonb(v_replace));
      result = ast.jsonb_set(result, '{CreatePLangStmt, plname}', to_jsonb(v_plname));
      result = ast.jsonb_set(result, '{CreatePLangStmt, plhandler}', v_plhandler);
      result = ast.jsonb_set(result, '{CreatePLangStmt, plinline}', v_plinline);
      result = ast.jsonb_set(result, '{CreatePLangStmt, plvalidator}', v_plvalidator);
      result = ast.jsonb_set(result, '{CreatePLangStmt, pltrusted}', to_jsonb(v_pltrusted));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_role_stmt ( v_stmt_type text DEFAULT NULL, v_role text DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateRoleStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateRoleStmt, stmt_type}', to_jsonb(v_stmt_type));
      result = ast.jsonb_set(result, '{CreateRoleStmt, role}', to_jsonb(v_role));
      result = ast.jsonb_set(result, '{CreateRoleStmt, options}', v_options);
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

CREATE FUNCTION ast.alter_role_set_stmt ( v_role jsonb DEFAULT NULL, v_database text DEFAULT NULL, v_setstmt jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterRoleSetStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterRoleSetStmt, role}', v_role);
      result = ast.jsonb_set(result, '{AlterRoleSetStmt, database}', to_jsonb(v_database));
      result = ast.jsonb_set(result, '{AlterRoleSetStmt, setstmt}', v_setstmt);
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

CREATE FUNCTION ast.create_seq_stmt ( v_sequence jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL, v_ownerid jsonb DEFAULT NULL, v_for_identity boolean DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateSeqStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateSeqStmt, sequence}', v_sequence);
      result = ast.jsonb_set(result, '{CreateSeqStmt, options}', v_options);
      result = ast.jsonb_set(result, '{CreateSeqStmt, ownerId}', v_ownerId);
      result = ast.jsonb_set(result, '{CreateSeqStmt, for_identity}', to_jsonb(v_for_identity));
      result = ast.jsonb_set(result, '{CreateSeqStmt, if_not_exists}', to_jsonb(v_if_not_exists));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_seq_stmt ( v_sequence jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL, v_for_identity boolean DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterSeqStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterSeqStmt, sequence}', v_sequence);
      result = ast.jsonb_set(result, '{AlterSeqStmt, options}', v_options);
      result = ast.jsonb_set(result, '{AlterSeqStmt, for_identity}', to_jsonb(v_for_identity));
      result = ast.jsonb_set(result, '{AlterSeqStmt, missing_ok}', to_jsonb(v_missing_ok));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.define_stmt ( v_kind text DEFAULT NULL, v_oldstyle boolean DEFAULT NULL, v_defnames jsonb DEFAULT NULL, v_args jsonb DEFAULT NULL, v_definition jsonb DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL, v_replace boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"DefineStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{DefineStmt, kind}', to_jsonb(v_kind));
      result = ast.jsonb_set(result, '{DefineStmt, oldstyle}', to_jsonb(v_oldstyle));
      result = ast.jsonb_set(result, '{DefineStmt, defnames}', v_defnames);
      result = ast.jsonb_set(result, '{DefineStmt, args}', v_args);
      result = ast.jsonb_set(result, '{DefineStmt, definition}', v_definition);
      result = ast.jsonb_set(result, '{DefineStmt, if_not_exists}', to_jsonb(v_if_not_exists));
      result = ast.jsonb_set(result, '{DefineStmt, replace}', to_jsonb(v_replace));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_domain_stmt ( v_domainname jsonb DEFAULT NULL, v_typename jsonb DEFAULT NULL, v_collclause jsonb DEFAULT NULL, v_constraints jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateDomainStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateDomainStmt, domainname}', v_domainname);
      result = ast.jsonb_set(result, '{CreateDomainStmt, typeName}', v_typeName);
      result = ast.jsonb_set(result, '{CreateDomainStmt, collClause}', v_collClause);
      result = ast.jsonb_set(result, '{CreateDomainStmt, constraints}', v_constraints);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_op_class_stmt ( v_opclassname jsonb DEFAULT NULL, v_opfamilyname jsonb DEFAULT NULL, v_amname text DEFAULT NULL, v_datatype jsonb DEFAULT NULL, v_items jsonb DEFAULT NULL, v_isdefault boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateOpClassStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateOpClassStmt, opclassname}', v_opclassname);
      result = ast.jsonb_set(result, '{CreateOpClassStmt, opfamilyname}', v_opfamilyname);
      result = ast.jsonb_set(result, '{CreateOpClassStmt, amname}', to_jsonb(v_amname));
      result = ast.jsonb_set(result, '{CreateOpClassStmt, datatype}', v_datatype);
      result = ast.jsonb_set(result, '{CreateOpClassStmt, items}', v_items);
      result = ast.jsonb_set(result, '{CreateOpClassStmt, isDefault}', to_jsonb(v_isDefault));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_op_class_item ( v_itemtype int DEFAULT NULL, v_name jsonb DEFAULT NULL, v_number int DEFAULT NULL, v_order_family jsonb DEFAULT NULL, v_class_args jsonb DEFAULT NULL, v_storedtype jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateOpClassItem":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateOpClassItem, itemtype}', to_jsonb(v_itemtype));
      result = ast.jsonb_set(result, '{CreateOpClassItem, name}', v_name);
      result = ast.jsonb_set(result, '{CreateOpClassItem, number}', to_jsonb(v_number));
      result = ast.jsonb_set(result, '{CreateOpClassItem, order_family}', v_order_family);
      result = ast.jsonb_set(result, '{CreateOpClassItem, class_args}', v_class_args);
      result = ast.jsonb_set(result, '{CreateOpClassItem, storedtype}', v_storedtype);
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

CREATE FUNCTION ast.alter_op_family_stmt ( v_opfamilyname jsonb DEFAULT NULL, v_amname text DEFAULT NULL, v_isdrop boolean DEFAULT NULL, v_items jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterOpFamilyStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterOpFamilyStmt, opfamilyname}', v_opfamilyname);
      result = ast.jsonb_set(result, '{AlterOpFamilyStmt, amname}', to_jsonb(v_amname));
      result = ast.jsonb_set(result, '{AlterOpFamilyStmt, isDrop}', to_jsonb(v_isDrop));
      result = ast.jsonb_set(result, '{AlterOpFamilyStmt, items}', v_items);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.drop_stmt ( v_objects jsonb DEFAULT NULL, v_removetype text DEFAULT NULL, v_behavior text DEFAULT NULL, v_missing_ok boolean DEFAULT NULL, v_concurrent boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.truncate_stmt ( v_relations jsonb DEFAULT NULL, v_restart_seqs boolean DEFAULT NULL, v_behavior text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"TruncateStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{TruncateStmt, relations}', v_relations);
      result = ast.jsonb_set(result, '{TruncateStmt, restart_seqs}', to_jsonb(v_restart_seqs));
      result = ast.jsonb_set(result, '{TruncateStmt, behavior}', to_jsonb(v_behavior));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.comment_stmt ( v_objtype text DEFAULT NULL, v_object jsonb DEFAULT NULL, v_comment text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CommentStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CommentStmt, objtype}', to_jsonb(v_objtype));
      result = ast.jsonb_set(result, '{CommentStmt, object}', v_object);
      result = ast.jsonb_set(result, '{CommentStmt, comment}', to_jsonb(v_comment));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.sec_label_stmt ( v_objtype text DEFAULT NULL, v_object jsonb DEFAULT NULL, v_provider text DEFAULT NULL, v_label text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"SecLabelStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{SecLabelStmt, objtype}', to_jsonb(v_objtype));
      result = ast.jsonb_set(result, '{SecLabelStmt, object}', v_object);
      result = ast.jsonb_set(result, '{SecLabelStmt, provider}', to_jsonb(v_provider));
      result = ast.jsonb_set(result, '{SecLabelStmt, label}', to_jsonb(v_label));
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

CREATE FUNCTION ast.close_portal_stmt ( v_portalname text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"ClosePortalStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{ClosePortalStmt, portalname}', to_jsonb(v_portalname));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.fetch_stmt ( v_direction text DEFAULT NULL, v_howmany bigint DEFAULT NULL, v_portalname text DEFAULT NULL, v_ismove boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.index_stmt ( v_idxname text DEFAULT NULL, v_relation jsonb DEFAULT NULL, v_accessmethod text DEFAULT NULL, v_tablespace text DEFAULT NULL, v_indexparams jsonb DEFAULT NULL, v_indexincludingparams jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL, v_whereclause jsonb DEFAULT NULL, v_excludeopnames jsonb DEFAULT NULL, v_idxcomment text DEFAULT NULL, v_indexoid jsonb DEFAULT NULL, v_oldnode jsonb DEFAULT NULL, v_oldcreatesubid jsonb DEFAULT NULL, v_oldfirstrelfilenodesubid jsonb DEFAULT NULL, v_unique boolean DEFAULT NULL, v_primary boolean DEFAULT NULL, v_isconstraint boolean DEFAULT NULL, v_deferrable boolean DEFAULT NULL, v_initdeferred boolean DEFAULT NULL, v_transformed boolean DEFAULT NULL, v_concurrent boolean DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL, v_reset_default_tblspc boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"IndexStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{IndexStmt, idxname}', to_jsonb(v_idxname));
      result = ast.jsonb_set(result, '{IndexStmt, relation}', v_relation);
      result = ast.jsonb_set(result, '{IndexStmt, accessMethod}', to_jsonb(v_accessMethod));
      result = ast.jsonb_set(result, '{IndexStmt, tableSpace}', to_jsonb(v_tableSpace));
      result = ast.jsonb_set(result, '{IndexStmt, indexParams}', v_indexParams);
      result = ast.jsonb_set(result, '{IndexStmt, indexIncludingParams}', v_indexIncludingParams);
      result = ast.jsonb_set(result, '{IndexStmt, options}', v_options);
      result = ast.jsonb_set(result, '{IndexStmt, whereClause}', v_whereClause);
      result = ast.jsonb_set(result, '{IndexStmt, excludeOpNames}', v_excludeOpNames);
      result = ast.jsonb_set(result, '{IndexStmt, idxcomment}', to_jsonb(v_idxcomment));
      result = ast.jsonb_set(result, '{IndexStmt, indexOid}', v_indexOid);
      result = ast.jsonb_set(result, '{IndexStmt, oldNode}', v_oldNode);
      result = ast.jsonb_set(result, '{IndexStmt, oldCreateSubid}', v_oldCreateSubid);
      result = ast.jsonb_set(result, '{IndexStmt, oldFirstRelfilenodeSubid}', v_oldFirstRelfilenodeSubid);
      result = ast.jsonb_set(result, '{IndexStmt, unique}', to_jsonb(v_unique));
      result = ast.jsonb_set(result, '{IndexStmt, primary}', to_jsonb(v_primary));
      result = ast.jsonb_set(result, '{IndexStmt, isconstraint}', to_jsonb(v_isconstraint));
      result = ast.jsonb_set(result, '{IndexStmt, deferrable}', to_jsonb(v_deferrable));
      result = ast.jsonb_set(result, '{IndexStmt, initdeferred}', to_jsonb(v_initdeferred));
      result = ast.jsonb_set(result, '{IndexStmt, transformed}', to_jsonb(v_transformed));
      result = ast.jsonb_set(result, '{IndexStmt, concurrent}', to_jsonb(v_concurrent));
      result = ast.jsonb_set(result, '{IndexStmt, if_not_exists}', to_jsonb(v_if_not_exists));
      result = ast.jsonb_set(result, '{IndexStmt, reset_default_tblspc}', to_jsonb(v_reset_default_tblspc));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_stats_stmt ( v_defnames jsonb DEFAULT NULL, v_stat_types jsonb DEFAULT NULL, v_exprs jsonb DEFAULT NULL, v_relations jsonb DEFAULT NULL, v_stxcomment text DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateStatsStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateStatsStmt, defnames}', v_defnames);
      result = ast.jsonb_set(result, '{CreateStatsStmt, stat_types}', v_stat_types);
      result = ast.jsonb_set(result, '{CreateStatsStmt, exprs}', v_exprs);
      result = ast.jsonb_set(result, '{CreateStatsStmt, relations}', v_relations);
      result = ast.jsonb_set(result, '{CreateStatsStmt, stxcomment}', to_jsonb(v_stxcomment));
      result = ast.jsonb_set(result, '{CreateStatsStmt, if_not_exists}', to_jsonb(v_if_not_exists));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_stats_stmt ( v_defnames jsonb DEFAULT NULL, v_stxstattarget int DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterStatsStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterStatsStmt, defnames}', v_defnames);
      result = ast.jsonb_set(result, '{AlterStatsStmt, stxstattarget}', to_jsonb(v_stxstattarget));
      result = ast.jsonb_set(result, '{AlterStatsStmt, missing_ok}', to_jsonb(v_missing_ok));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_function_stmt ( v_is_procedure boolean DEFAULT NULL, v_replace boolean DEFAULT NULL, v_funcname jsonb DEFAULT NULL, v_parameters jsonb DEFAULT NULL, v_returntype jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateFunctionStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateFunctionStmt, is_procedure}', to_jsonb(v_is_procedure));
      result = ast.jsonb_set(result, '{CreateFunctionStmt, replace}', to_jsonb(v_replace));
      result = ast.jsonb_set(result, '{CreateFunctionStmt, funcname}', v_funcname);
      result = ast.jsonb_set(result, '{CreateFunctionStmt, parameters}', v_parameters);
      result = ast.jsonb_set(result, '{CreateFunctionStmt, returnType}', v_returnType);
      result = ast.jsonb_set(result, '{CreateFunctionStmt, options}', v_options);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.function_parameter ( v_name text DEFAULT NULL, v_argtype jsonb DEFAULT NULL, v_mode text DEFAULT NULL, v_defexpr jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.alter_function_stmt ( v_objtype text DEFAULT NULL, v_func jsonb DEFAULT NULL, v_actions jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterFunctionStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterFunctionStmt, objtype}', to_jsonb(v_objtype));
      result = ast.jsonb_set(result, '{AlterFunctionStmt, func}', v_func);
      result = ast.jsonb_set(result, '{AlterFunctionStmt, actions}', v_actions);
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

CREATE FUNCTION ast.inline_code_block ( v_source_text text DEFAULT NULL, v_langoid jsonb DEFAULT NULL, v_langistrusted boolean DEFAULT NULL, v_atomic boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"InlineCodeBlock":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{InlineCodeBlock, source_text}', to_jsonb(v_source_text));
      result = ast.jsonb_set(result, '{InlineCodeBlock, langOid}', v_langOid);
      result = ast.jsonb_set(result, '{InlineCodeBlock, langIsTrusted}', to_jsonb(v_langIsTrusted));
      result = ast.jsonb_set(result, '{InlineCodeBlock, atomic}', to_jsonb(v_atomic));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.call_stmt ( v_funccall jsonb DEFAULT NULL, v_funcexpr jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CallStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CallStmt, funccall}', v_funccall);
      result = ast.jsonb_set(result, '{CallStmt, funcexpr}', v_funcexpr);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.call_context ( v_atomic boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CallContext":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CallContext, atomic}', to_jsonb(v_atomic));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.rename_stmt ( v_renametype text DEFAULT NULL, v_relationtype text DEFAULT NULL, v_relation jsonb DEFAULT NULL, v_object jsonb DEFAULT NULL, v_subname text DEFAULT NULL, v_newname text DEFAULT NULL, v_behavior text DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RenameStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RenameStmt, renameType}', to_jsonb(v_renameType));
      result = ast.jsonb_set(result, '{RenameStmt, relationType}', to_jsonb(v_relationType));
      result = ast.jsonb_set(result, '{RenameStmt, relation}', v_relation);
      result = ast.jsonb_set(result, '{RenameStmt, object}', v_object);
      result = ast.jsonb_set(result, '{RenameStmt, subname}', to_jsonb(v_subname));
      result = ast.jsonb_set(result, '{RenameStmt, newname}', to_jsonb(v_newname));
      result = ast.jsonb_set(result, '{RenameStmt, behavior}', to_jsonb(v_behavior));
      result = ast.jsonb_set(result, '{RenameStmt, missing_ok}', to_jsonb(v_missing_ok));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_object_depends_stmt ( v_objecttype text DEFAULT NULL, v_relation jsonb DEFAULT NULL, v_object jsonb DEFAULT NULL, v_extname jsonb DEFAULT NULL, v_remove boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterObjectDependsStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterObjectDependsStmt, objectType}', to_jsonb(v_objectType));
      result = ast.jsonb_set(result, '{AlterObjectDependsStmt, relation}', v_relation);
      result = ast.jsonb_set(result, '{AlterObjectDependsStmt, object}', v_object);
      result = ast.jsonb_set(result, '{AlterObjectDependsStmt, extname}', v_extname);
      result = ast.jsonb_set(result, '{AlterObjectDependsStmt, remove}', to_jsonb(v_remove));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_object_schema_stmt ( v_objecttype text DEFAULT NULL, v_relation jsonb DEFAULT NULL, v_object jsonb DEFAULT NULL, v_newschema text DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterObjectSchemaStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, objectType}', to_jsonb(v_objectType));
      result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, relation}', v_relation);
      result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, object}', v_object);
      result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, newschema}', to_jsonb(v_newschema));
      result = ast.jsonb_set(result, '{AlterObjectSchemaStmt, missing_ok}', to_jsonb(v_missing_ok));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_owner_stmt ( v_objecttype text DEFAULT NULL, v_relation jsonb DEFAULT NULL, v_object jsonb DEFAULT NULL, v_newowner jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterOwnerStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterOwnerStmt, objectType}', to_jsonb(v_objectType));
      result = ast.jsonb_set(result, '{AlterOwnerStmt, relation}', v_relation);
      result = ast.jsonb_set(result, '{AlterOwnerStmt, object}', v_object);
      result = ast.jsonb_set(result, '{AlterOwnerStmt, newowner}', v_newowner);
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

CREATE FUNCTION ast.alter_type_stmt ( v_typename jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterTypeStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterTypeStmt, typeName}', v_typeName);
      result = ast.jsonb_set(result, '{AlterTypeStmt, options}', v_options);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.rule_stmt ( v_relation jsonb DEFAULT NULL, v_rulename text DEFAULT NULL, v_whereclause jsonb DEFAULT NULL, v_event text DEFAULT NULL, v_instead boolean DEFAULT NULL, v_actions jsonb DEFAULT NULL, v_replace boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RuleStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RuleStmt, relation}', v_relation);
      result = ast.jsonb_set(result, '{RuleStmt, rulename}', to_jsonb(v_rulename));
      result = ast.jsonb_set(result, '{RuleStmt, whereClause}', v_whereClause);
      result = ast.jsonb_set(result, '{RuleStmt, event}', to_jsonb(v_event));
      result = ast.jsonb_set(result, '{RuleStmt, instead}', to_jsonb(v_instead));
      result = ast.jsonb_set(result, '{RuleStmt, actions}', v_actions);
      result = ast.jsonb_set(result, '{RuleStmt, replace}', to_jsonb(v_replace));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.notify_stmt ( v_conditionname text DEFAULT NULL, v_payload text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"NotifyStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{NotifyStmt, conditionname}', to_jsonb(v_conditionname));
      result = ast.jsonb_set(result, '{NotifyStmt, payload}', to_jsonb(v_payload));
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

CREATE FUNCTION ast.transaction_stmt ( v_kind text DEFAULT NULL, v_options jsonb DEFAULT NULL, v_savepoint_name text DEFAULT NULL, v_gid text DEFAULT NULL, v_chain boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"TransactionStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{TransactionStmt, kind}', to_jsonb(v_kind));
      result = ast.jsonb_set(result, '{TransactionStmt, options}', v_options);
      result = ast.jsonb_set(result, '{TransactionStmt, savepoint_name}', to_jsonb(v_savepoint_name));
      result = ast.jsonb_set(result, '{TransactionStmt, gid}', to_jsonb(v_gid));
      result = ast.jsonb_set(result, '{TransactionStmt, chain}', to_jsonb(v_chain));
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

CREATE FUNCTION ast.create_enum_stmt ( v_typename jsonb DEFAULT NULL, v_vals jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateEnumStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateEnumStmt, typeName}', v_typeName);
      result = ast.jsonb_set(result, '{CreateEnumStmt, vals}', v_vals);
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

CREATE FUNCTION ast.alter_enum_stmt ( v_typename jsonb DEFAULT NULL, v_oldval text DEFAULT NULL, v_newval text DEFAULT NULL, v_newvalneighbor text DEFAULT NULL, v_newvalisafter boolean DEFAULT NULL, v_skipifnewvalexists boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterEnumStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterEnumStmt, typeName}', v_typeName);
      result = ast.jsonb_set(result, '{AlterEnumStmt, oldVal}', to_jsonb(v_oldVal));
      result = ast.jsonb_set(result, '{AlterEnumStmt, newVal}', to_jsonb(v_newVal));
      result = ast.jsonb_set(result, '{AlterEnumStmt, newValNeighbor}', to_jsonb(v_newValNeighbor));
      result = ast.jsonb_set(result, '{AlterEnumStmt, newValIsAfter}', to_jsonb(v_newValIsAfter));
      result = ast.jsonb_set(result, '{AlterEnumStmt, skipIfNewValExists}', to_jsonb(v_skipIfNewValExists));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.view_stmt ( v_view jsonb DEFAULT NULL, v_aliases jsonb DEFAULT NULL, v_query jsonb DEFAULT NULL, v_replace boolean DEFAULT NULL, v_options jsonb DEFAULT NULL, v_withcheckoption text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"ViewStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{ViewStmt, view}', v_view);
      result = ast.jsonb_set(result, '{ViewStmt, aliases}', v_aliases);
      result = ast.jsonb_set(result, '{ViewStmt, query}', v_query);
      result = ast.jsonb_set(result, '{ViewStmt, replace}', to_jsonb(v_replace));
      result = ast.jsonb_set(result, '{ViewStmt, options}', v_options);
      result = ast.jsonb_set(result, '{ViewStmt, withCheckOption}', to_jsonb(v_withCheckOption));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.load_stmt ( v_filename text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"LoadStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{LoadStmt, filename}', to_jsonb(v_filename));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.createdb_stmt ( v_dbname text DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreatedbStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreatedbStmt, dbname}', to_jsonb(v_dbname));
      result = ast.jsonb_set(result, '{CreatedbStmt, options}', v_options);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_database_stmt ( v_dbname text DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterDatabaseStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterDatabaseStmt, dbname}', to_jsonb(v_dbname));
      result = ast.jsonb_set(result, '{AlterDatabaseStmt, options}', v_options);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_database_set_stmt ( v_dbname text DEFAULT NULL, v_setstmt jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterDatabaseSetStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterDatabaseSetStmt, dbname}', to_jsonb(v_dbname));
      result = ast.jsonb_set(result, '{AlterDatabaseSetStmt, setstmt}', v_setstmt);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.dropdb_stmt ( v_dbname text DEFAULT NULL, v_missing_ok boolean DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"DropdbStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{DropdbStmt, dbname}', to_jsonb(v_dbname));
      result = ast.jsonb_set(result, '{DropdbStmt, missing_ok}', to_jsonb(v_missing_ok));
      result = ast.jsonb_set(result, '{DropdbStmt, options}', v_options);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_system_stmt ( v_setstmt jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterSystemStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterSystemStmt, setstmt}', v_setstmt);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.cluster_stmt ( v_relation jsonb DEFAULT NULL, v_indexname text DEFAULT NULL, v_options int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"ClusterStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{ClusterStmt, relation}', v_relation);
      result = ast.jsonb_set(result, '{ClusterStmt, indexname}', to_jsonb(v_indexname));
      result = ast.jsonb_set(result, '{ClusterStmt, options}', to_jsonb(v_options));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.vacuum_stmt ( v_options jsonb DEFAULT NULL, v_rels jsonb DEFAULT NULL, v_is_vacuumcmd boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"VacuumStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{VacuumStmt, options}', v_options);
      result = ast.jsonb_set(result, '{VacuumStmt, rels}', v_rels);
      result = ast.jsonb_set(result, '{VacuumStmt, is_vacuumcmd}', to_jsonb(v_is_vacuumcmd));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.vacuum_relation ( v_relation jsonb DEFAULT NULL, v_oid jsonb DEFAULT NULL, v_va_cols jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"VacuumRelation":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{VacuumRelation, relation}', v_relation);
      result = ast.jsonb_set(result, '{VacuumRelation, oid}', v_oid);
      result = ast.jsonb_set(result, '{VacuumRelation, va_cols}', v_va_cols);
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

CREATE FUNCTION ast.create_table_as_stmt ( v_query jsonb DEFAULT NULL, v_into jsonb DEFAULT NULL, v_relkind text DEFAULT NULL, v_is_select_into boolean DEFAULT NULL, v_if_not_exists boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateTableAsStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateTableAsStmt, query}', v_query);
      result = ast.jsonb_set(result, '{CreateTableAsStmt, into}', v_into);
      result = ast.jsonb_set(result, '{CreateTableAsStmt, relkind}', to_jsonb(v_relkind));
      result = ast.jsonb_set(result, '{CreateTableAsStmt, is_select_into}', to_jsonb(v_is_select_into));
      result = ast.jsonb_set(result, '{CreateTableAsStmt, if_not_exists}', to_jsonb(v_if_not_exists));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.refresh_mat_view_stmt ( v_concurrent boolean DEFAULT NULL, v_skipdata boolean DEFAULT NULL, v_relation jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"RefreshMatViewStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{RefreshMatViewStmt, concurrent}', to_jsonb(v_concurrent));
      result = ast.jsonb_set(result, '{RefreshMatViewStmt, skipData}', to_jsonb(v_skipData));
      result = ast.jsonb_set(result, '{RefreshMatViewStmt, relation}', v_relation);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.check_point_stmt (  ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CheckPointStmt":{}}'::jsonb;
  BEGIN
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.discard_stmt ( v_target text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.constraints_set_stmt ( v_constraints jsonb DEFAULT NULL, v_deferred boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"ConstraintsSetStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{ConstraintsSetStmt, constraints}', v_constraints);
      result = ast.jsonb_set(result, '{ConstraintsSetStmt, deferred}', to_jsonb(v_deferred));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.reindex_stmt ( v_kind text DEFAULT NULL, v_relation jsonb DEFAULT NULL, v_name text DEFAULT NULL, v_options int DEFAULT NULL, v_concurrent boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"ReindexStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{ReindexStmt, kind}', to_jsonb(v_kind));
      result = ast.jsonb_set(result, '{ReindexStmt, relation}', v_relation);
      result = ast.jsonb_set(result, '{ReindexStmt, name}', to_jsonb(v_name));
      result = ast.jsonb_set(result, '{ReindexStmt, options}', to_jsonb(v_options));
      result = ast.jsonb_set(result, '{ReindexStmt, concurrent}', to_jsonb(v_concurrent));
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

CREATE FUNCTION ast.create_cast_stmt ( v_sourcetype jsonb DEFAULT NULL, v_targettype jsonb DEFAULT NULL, v_func jsonb DEFAULT NULL, v_context text DEFAULT NULL, v_inout boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateCastStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateCastStmt, sourcetype}', v_sourcetype);
      result = ast.jsonb_set(result, '{CreateCastStmt, targettype}', v_targettype);
      result = ast.jsonb_set(result, '{CreateCastStmt, func}', v_func);
      result = ast.jsonb_set(result, '{CreateCastStmt, context}', to_jsonb(v_context));
      result = ast.jsonb_set(result, '{CreateCastStmt, inout}', to_jsonb(v_inout));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_transform_stmt ( v_replace boolean DEFAULT NULL, v_type_name jsonb DEFAULT NULL, v_lang text DEFAULT NULL, v_fromsql jsonb DEFAULT NULL, v_tosql jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateTransformStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateTransformStmt, replace}', to_jsonb(v_replace));
      result = ast.jsonb_set(result, '{CreateTransformStmt, type_name}', v_type_name);
      result = ast.jsonb_set(result, '{CreateTransformStmt, lang}', to_jsonb(v_lang));
      result = ast.jsonb_set(result, '{CreateTransformStmt, fromsql}', v_fromsql);
      result = ast.jsonb_set(result, '{CreateTransformStmt, tosql}', v_tosql);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.prepare_stmt ( v_name text DEFAULT NULL, v_argtypes jsonb DEFAULT NULL, v_query jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"PrepareStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{PrepareStmt, name}', to_jsonb(v_name));
      result = ast.jsonb_set(result, '{PrepareStmt, argtypes}', v_argtypes);
      result = ast.jsonb_set(result, '{PrepareStmt, query}', v_query);
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

CREATE FUNCTION ast.deallocate_stmt ( v_name text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"DeallocateStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{DeallocateStmt, name}', to_jsonb(v_name));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.drop_owned_stmt ( v_roles jsonb DEFAULT NULL, v_behavior text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast.alter_ts_dictionary_stmt ( v_dictname jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterTSDictionaryStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterTSDictionaryStmt, dictname}', v_dictname);
      result = ast.jsonb_set(result, '{AlterTSDictionaryStmt, options}', v_options);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_ts_configuration_stmt ( v_kind text DEFAULT NULL, v_cfgname jsonb DEFAULT NULL, v_tokentype jsonb DEFAULT NULL, v_dicts jsonb DEFAULT NULL, v_override boolean DEFAULT NULL, v_replace boolean DEFAULT NULL, v_missing_ok boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterTSConfigurationStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, kind}', to_jsonb(v_kind));
      result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, cfgname}', v_cfgname);
      result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, tokentype}', v_tokentype);
      result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, dicts}', v_dicts);
      result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, override}', to_jsonb(v_override));
      result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, replace}', to_jsonb(v_replace));
      result = ast.jsonb_set(result, '{AlterTSConfigurationStmt, missing_ok}', to_jsonb(v_missing_ok));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_publication_stmt ( v_pubname text DEFAULT NULL, v_options jsonb DEFAULT NULL, v_tables jsonb DEFAULT NULL, v_for_all_tables boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreatePublicationStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreatePublicationStmt, pubname}', to_jsonb(v_pubname));
      result = ast.jsonb_set(result, '{CreatePublicationStmt, options}', v_options);
      result = ast.jsonb_set(result, '{CreatePublicationStmt, tables}', v_tables);
      result = ast.jsonb_set(result, '{CreatePublicationStmt, for_all_tables}', to_jsonb(v_for_all_tables));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_publication_stmt ( v_pubname text DEFAULT NULL, v_options jsonb DEFAULT NULL, v_tables jsonb DEFAULT NULL, v_for_all_tables boolean DEFAULT NULL, v_tableaction text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterPublicationStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterPublicationStmt, pubname}', to_jsonb(v_pubname));
      result = ast.jsonb_set(result, '{AlterPublicationStmt, options}', v_options);
      result = ast.jsonb_set(result, '{AlterPublicationStmt, tables}', v_tables);
      result = ast.jsonb_set(result, '{AlterPublicationStmt, for_all_tables}', to_jsonb(v_for_all_tables));
      result = ast.jsonb_set(result, '{AlterPublicationStmt, tableAction}', to_jsonb(v_tableAction));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.create_subscription_stmt ( v_subname text DEFAULT NULL, v_conninfo text DEFAULT NULL, v_publication jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"CreateSubscriptionStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{CreateSubscriptionStmt, subname}', to_jsonb(v_subname));
      result = ast.jsonb_set(result, '{CreateSubscriptionStmt, conninfo}', to_jsonb(v_conninfo));
      result = ast.jsonb_set(result, '{CreateSubscriptionStmt, publication}', v_publication);
      result = ast.jsonb_set(result, '{CreateSubscriptionStmt, options}', v_options);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.alter_subscription_stmt ( v_kind text DEFAULT NULL, v_subname text DEFAULT NULL, v_conninfo text DEFAULT NULL, v_publication jsonb DEFAULT NULL, v_options jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"AlterSubscriptionStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{AlterSubscriptionStmt, kind}', to_jsonb(v_kind));
      result = ast.jsonb_set(result, '{AlterSubscriptionStmt, subname}', to_jsonb(v_subname));
      result = ast.jsonb_set(result, '{AlterSubscriptionStmt, conninfo}', to_jsonb(v_conninfo));
      result = ast.jsonb_set(result, '{AlterSubscriptionStmt, publication}', v_publication);
      result = ast.jsonb_set(result, '{AlterSubscriptionStmt, options}', v_options);
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.drop_subscription_stmt ( v_subname text DEFAULT NULL, v_missing_ok boolean DEFAULT NULL, v_behavior text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"DropSubscriptionStmt":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{DropSubscriptionStmt, subname}', to_jsonb(v_subname));
      result = ast.jsonb_set(result, '{DropSubscriptionStmt, missing_ok}', to_jsonb(v_missing_ok));
      result = ast.jsonb_set(result, '{DropSubscriptionStmt, behavior}', to_jsonb(v_behavior));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.vac_attr_stats ( v_attr jsonb DEFAULT NULL, v_attrtypid jsonb DEFAULT NULL, v_attrtypmod int DEFAULT NULL, v_attrtype jsonb DEFAULT NULL, v_attrcollid jsonb DEFAULT NULL, v_anl_context jsonb DEFAULT NULL, v_compute_stats jsonb DEFAULT NULL, v_minrows int DEFAULT NULL, v_extra_data jsonb DEFAULT NULL, v_stats_valid boolean DEFAULT NULL, v_stanullfrac pg_catalog.float8 DEFAULT NULL, v_stawidth int DEFAULT NULL, v_stadistinct pg_catalog.float8 DEFAULT NULL, v_tupattnum int DEFAULT NULL, v_rows jsonb DEFAULT NULL, v_tupdesc jsonb DEFAULT NULL, v_exprvals jsonb DEFAULT NULL, v_exprnulls boolean DEFAULT NULL, v_rowstride int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"VacAttrStats":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{VacAttrStats, attr}', v_attr);
      result = ast.jsonb_set(result, '{VacAttrStats, attrtypid}', v_attrtypid);
      result = ast.jsonb_set(result, '{VacAttrStats, attrtypmod}', to_jsonb(v_attrtypmod));
      result = ast.jsonb_set(result, '{VacAttrStats, attrtype}', v_attrtype);
      result = ast.jsonb_set(result, '{VacAttrStats, attrcollid}', v_attrcollid);
      result = ast.jsonb_set(result, '{VacAttrStats, anl_context}', v_anl_context);
      result = ast.jsonb_set(result, '{VacAttrStats, compute_stats}', v_compute_stats);
      result = ast.jsonb_set(result, '{VacAttrStats, minrows}', to_jsonb(v_minrows));
      result = ast.jsonb_set(result, '{VacAttrStats, extra_data}', v_extra_data);
      result = ast.jsonb_set(result, '{VacAttrStats, stats_valid}', to_jsonb(v_stats_valid));
      result = ast.jsonb_set(result, '{VacAttrStats, stanullfrac}', to_jsonb(v_stanullfrac));
      result = ast.jsonb_set(result, '{VacAttrStats, stawidth}', to_jsonb(v_stawidth));
      result = ast.jsonb_set(result, '{VacAttrStats, stadistinct}', to_jsonb(v_stadistinct));
      result = ast.jsonb_set(result, '{VacAttrStats, tupattnum}', to_jsonb(v_tupattnum));
      result = ast.jsonb_set(result, '{VacAttrStats, rows}', v_rows);
      result = ast.jsonb_set(result, '{VacAttrStats, tupDesc}', v_tupDesc);
      result = ast.jsonb_set(result, '{VacAttrStats, exprvals}', v_exprvals);
      result = ast.jsonb_set(result, '{VacAttrStats, exprnulls}', to_jsonb(v_exprnulls));
      result = ast.jsonb_set(result, '{VacAttrStats, rowstride}', to_jsonb(v_rowstride));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.vacuum_params ( v_options int DEFAULT NULL, v_freeze_min_age int DEFAULT NULL, v_freeze_table_age int DEFAULT NULL, v_multixact_freeze_min_age int DEFAULT NULL, v_multixact_freeze_table_age int DEFAULT NULL, v_is_wraparound boolean DEFAULT NULL, v_log_min_duration int DEFAULT NULL, v_index_cleanup text DEFAULT NULL, v_truncate text DEFAULT NULL, v_nworkers int DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"VacuumParams":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{VacuumParams, options}', to_jsonb(v_options));
      result = ast.jsonb_set(result, '{VacuumParams, freeze_min_age}', to_jsonb(v_freeze_min_age));
      result = ast.jsonb_set(result, '{VacuumParams, freeze_table_age}', to_jsonb(v_freeze_table_age));
      result = ast.jsonb_set(result, '{VacuumParams, multixact_freeze_min_age}', to_jsonb(v_multixact_freeze_min_age));
      result = ast.jsonb_set(result, '{VacuumParams, multixact_freeze_table_age}', to_jsonb(v_multixact_freeze_table_age));
      result = ast.jsonb_set(result, '{VacuumParams, is_wraparound}', to_jsonb(v_is_wraparound));
      result = ast.jsonb_set(result, '{VacuumParams, log_min_duration}', to_jsonb(v_log_min_duration));
      result = ast.jsonb_set(result, '{VacuumParams, index_cleanup}', to_jsonb(v_index_cleanup));
      result = ast.jsonb_set(result, '{VacuumParams, truncate}', to_jsonb(v_truncate));
      result = ast.jsonb_set(result, '{VacuumParams, nworkers}', to_jsonb(v_nworkers));
      RETURN result;
  END;
  $EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast.integer ( v_ival bigint DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"Integer":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{Integer, ival}', to_jsonb(v_ival));
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

CREATE FUNCTION ast.string ( v_str text DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"String":{}}'::jsonb;
  BEGIN
      result = ast.jsonb_set(result, '{String, str}', to_jsonb(v_str));
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

CREATE FUNCTION ast.null (  ) RETURNS jsonb AS $EOFCODE$
  DECLARE
      result jsonb = '{"Null":{}}'::jsonb;
  BEGIN
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

CREATE FUNCTION ast_helpers.eq ( v_lexpr jsonb, v_rexpr jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 'AEXPR_OP',
      v_name := to_jsonb(ARRAY[
          ast.string('=')
      ]),
      v_lexpr := v_lexpr,
      v_rexpr := v_rexpr
  );
  RETURN ast_expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.neq ( v_lexpr jsonb, v_rexpr jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.a_expr(
      v_kind := 'AEXPR_OP',
      v_name := to_jsonb(ARRAY[
          ast.string('<>')
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
      v_kind := 'AEXPR_OP',
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
      v_kind := 'AEXPR_OP',
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
      v_kind := 'AEXPR_OP',
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
      v_kind := 'AEXPR_OP',
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
      v_kind := 'AEXPR_OP_ANY',
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
      v_boolop := 'AND_EXPR',
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
      v_boolop := 'OR_EXPR',
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
      v_kind := 'AEXPR_OP',
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
      v_mode := 'FUNC_PARAM_IN'
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
      v_mode := 'FUNC_PARAM_IN',
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
      v_mode := 'FUNC_PARAM_IN',
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
	RETURN ast.a_expr(v_kind := 'AEXPR_DISTINCT', 
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
          v_kind := 'AEXPR_OP',
          v_lexpr := results[i], 
          v_name := to_jsonb(ARRAY[ast.string('||')]),
          v_rexpr := result );
      END IF;
    END LOOP;

	RETURN result;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.create_trigger ( v_trigger_name text, v_schema_name text, v_table_name text, v_trigger_fn_schema text, v_trigger_fn_name text, v_whenclause jsonb DEFAULT NULL, v_params text[] DEFAULT ARRAY[]::text[], v_timing int DEFAULT 2, v_events int DEFAULT 4 | 16 ) RETURNS jsonb AS $EOFCODE$
DECLARE
  result jsonb;
BEGIN
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
    v_whenClause := v_whenClause
  );
	RETURN ast.raw_stmt(
    v_stmt := result,
    v_stmt_len := 1
  );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.create_trigger_distinct_fields ( v_trigger_name text, v_schema_name text, v_table_name text, v_trigger_fn_schema text, v_trigger_fn_name text, v_fields text[] DEFAULT ARRAY[]::text[], v_params text[] DEFAULT ARRAY[]::text[], v_timing int DEFAULT 2, v_events int DEFAULT 4 | 16 ) RETURNS jsonb AS $EOFCODE$
DECLARE
  whenClause jsonb;
	i int;
  nodes jsonb[];
BEGIN

  FOR i IN SELECT * FROM generate_subscripts(v_fields, 1) g(i)
  LOOP
    -- OLD.field <> NEW.field
    nodes = array_append(nodes, ast_helpers.a_expr_distinct_tg_field(v_fields[i]));
  END LOOP;
 
  IF (cardinality(nodes) > 1) THEN
    whenClause = ast_helpers.or( variadic nodes := nodes );
  ELSEIF (cardinality(nodes) = 1) THEN
    whenClause = nodes[1];
  END IF;

  RETURN ast_helpers.create_trigger(
    v_trigger_name := v_trigger_name,
    
    v_schema_name := v_schema_name,
    v_table_name := v_table_name,

    v_trigger_fn_schema := v_trigger_fn_schema,
    v_trigger_fn_name := v_trigger_fn_name,

    v_whenClause := whenClause,
    v_params := v_params,
    v_timing := v_timing,
    v_events := v_events
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
      v_removeType := 'OBJECT_TRIGGER',
      v_behavior:= (CASE when v_cascade IS TRUE then 'DROP_CASCADE' else 'DROP_RESTRICT' END)
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
    v_defname := 'as',
    v_arg := to_jsonb(ARRAY[ast.string(v_body)])
  ));
  
  options = array_append(options, ast.def_elem(
    v_defname := 'language',
    v_arg := ast.string(v_language)
  ));

  IF (v_volatility IS NOT NULL) THEN 
    options = array_append(options, ast.def_elem(
      v_defname := 'volatility',
      v_arg := ast.string(v_volatility)
    ));
  END IF;

  IF (v_security IS NOT NULL) THEN 
    options = array_append(options, ast.def_elem(
      v_defname := 'security',
      v_arg := ast.integer(v_security)
    ));
  END IF;

  ast = ast.create_function_stmt(
    v_funcname := ast_helpers.array_of_strings(v_schema_name, v_function_name),
    v_parameters := v_parameters,
    v_returnType := ast.type_name( 
        v_names := ast_helpers.array_of_strings(v_type)
    ),
    v_options := to_jsonb(options)
  );

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
      v_removeType := 'OBJECT_FUNCTION'
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
        v_roletype := 'ROLESPEC_PUBLIC'
      ));
  ELSE
    FOR i IN 
    SELECT * FROM generate_series(1, cardinality(v_roles))
    LOOP
      roles = array_append(roles, ast.role_spec(
        v_roletype := 'ROLESPEC_CSTRING',
        v_rolename := v_roles[i]
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

CREATE FUNCTION ast_helpers.alter_policy ( v_policy_name text DEFAULT NULL, v_schema_name text DEFAULT NULL, v_table_name text DEFAULT NULL, v_roles text[] DEFAULT NULL, v_qual jsonb DEFAULT NULL, v_with_check jsonb DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast jsonb;
  roles jsonb[];
  i int;
BEGIN

  -- if there are no roles then use PUBLIC
  IF (v_roles IS NOT NULL OR cardinality(v_roles) > 0) THEN 
    FOR i IN 
    SELECT * FROM generate_series(1, cardinality(v_roles))
    LOOP
      roles = array_append(roles, ast.role_spec(
        v_roletype := 'ROLESPEC_CSTRING',
        v_rolename := v_roles[i]
      ));
    END LOOP;
  END IF;

  select * FROM ast.alter_policy_stmt(
    v_policy_name := v_policy_name,
    v_table := ast_helpers.range_var(
      v_schemaname := v_schema_name,
      v_relname := v_table_name
    ),
    v_roles := to_jsonb(roles),
    v_qual := v_qual,
    v_with_check := v_with_check
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
      v_removeType := 'OBJECT_POLICY'
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
      v_oncommit := 'ONCOMMIT_NOOP'
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
      v_removeType := 'OBJECT_TABLE',
      v_behavior:= (CASE when v_cascade IS TRUE then 'DROP_CASCADE' else 'DROP_RESTRICT' END)
    ),
    v_stmt_len := 1
  );
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_helpers.create_index ( v_index_name text, v_schema_name text, v_table_name text, v_fields text[], v_include_fields text[] DEFAULT ARRAY[]::text[], v_accessmethod text DEFAULT NULL, v_unique boolean DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
DECLARE
  parameters jsonb[] = ARRAY[]::jsonb[];
  includingParameters jsonb[] = ARRAY[]::jsonb[];

  item text;
  i int;

  ast jsonb;
BEGIN
  FOR i IN
    SELECT * FROM generate_series(1, cardinality(v_fields)) g (i)
  LOOP
    parameters = array_append(parameters, ast.index_elem(
      v_name := v_fields[i],
      v_ordering := 'SORTBY_DEFAULT',
      v_nulls_ordering := 'SORTBY_NULLS_DEFAULT'
    ));
  END LOOP;

  FOR i IN
    SELECT * FROM generate_series(1, cardinality(v_include_fields)) g (i)
  LOOP
    includingParameters = array_append(includingParameters, ast.index_elem(
      v_name := v_include_fields[i],
      v_ordering := 'SORTBY_DEFAULT',
      v_nulls_ordering := 'SORTBY_NULLS_DEFAULT'
    ));
  END LOOP;

  ast = ast.raw_stmt(
    v_stmt := ast.index_stmt(
      v_idxname := v_index_name,
      v_relation := ast_helpers.range_var(
        v_schemaname := v_schema_name,
        v_relname := v_table_name
      ),
      v_accessMethod := v_accessMethod,
      v_indexParams := to_jsonb(parameters),
      v_indexIncludingParams := to_jsonb(includingParameters),
      v_unique := v_unique
    ),
    v_stmt_len:= 1
  );

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
      v_removeType:= 'OBJECT_INDEX',
      v_behavior:= 'DROP_RESTRICT'
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
      v_targtype := 'ACL_TARGET_OBJECT',
      v_objtype := 'OBJECT_TABLE',
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
          v_roletype := 'ROLESPEC_CSTRING',
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
          v_subtype := 'AT_AddColumn',
          v_def := ast.column_def(
            v_colname := v_column_name,
            v_typeName := v_column_type,
            v_is_local := TRUE
          ),
          v_behavior := 'DROP_RESTRICT' 
        )
      ]),
      v_relkind := 'OBJECT_TABLE'
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
          v_subtype := 'AT_DropColumn',
          v_name := v_column_name,
          v_behavior := 'DROP_RESTRICT' 
        )
      ]),
      v_relkind := 'OBJECT_TABLE'
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
      v_renameType := 'OBJECT_COLUMN',
      v_relationType := 'OBJECT_TABLE',
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
          v_subtype := 'AT_AlterColumnType',
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
          v_behavior := 'DROP_RESTRICT'
        )
      ]),
      v_relkind := 'OBJECT_TABLE'
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
              v_subtype := 'AT_AddConstraint',
              v_def := ast.constraint(
                v_contype := 'CONSTR_CHECK',
                v_conname := v_constraint_name,
                v_raw_expr := v_constraint_expr,
                v_initially_valid := true
              ),
              v_behavior := 'DROP_RESTRICT'
            )
          ]),
          v_relkind := 'OBJECT_TABLE'
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
              v_subtype := 'AT_DropConstraint',
              v_name := v_constraint_name,
              v_behavior := 'DROP_RESTRICT'
            )
          ]),
          v_relkind := 'OBJECT_TABLE'
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
              v_subtype := 'AT_DropConstraint',
              v_name := v_constraint_name,
              v_behavior := 'DROP_RESTRICT',
              v_missing_ok := TRUE
            ),
            -- ADD IT BACK
            ast.alter_table_cmd(
              v_subtype := 'AT_AddConstraint',
              v_def := ast.constraint(
                v_contype := 'CONSTR_CHECK',
                v_conname := v_constraint_name,
                v_raw_expr := v_constraint_expr,
                v_initially_valid := true
              ),
              v_behavior := 'DROP_RESTRICT' 
            )
          ]),
          v_relkind := 'OBJECT_TABLE'
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
        v_objtype := 'OBJECT_FUNCTION',
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

CREATE FUNCTION ast_helpers.set_comment ( v_objtype text, v_comment text DEFAULT NULL, VARIADIC v_name text[] DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast_helpers.set_comment ( v_objtype text, v_tags jsonb DEFAULT NULL, v_description text DEFAULT NULL, VARIADIC v_name text[] DEFAULT NULL ) RETURNS jsonb AS $EOFCODE$
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

CREATE FUNCTION ast_helpers.cpt_own_records ( data jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  node jsonb;
BEGIN

  -- Function(id), Field(id)
  -- SELECT db_migrate.text('policy_expression_current_role', 

  node = ast_helpers.eq(
      v_lexpr := ast_helpers.col(data->>'role_key'),
      v_rexpr := data->'current_user_ast'
  );

  RETURN node;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_owned_records ( data jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  node jsonb;
BEGIN
  -- Function(id), Field(id)

  -- TODO get both role_fn and groups_fn!!!!

  -- SELECT db_migrate.text('policy_expression_current_roles', 
  node = ast_helpers.or(
    ast_helpers.eq(
      v_lexpr := ast_helpers.col(data->>'role_key'),
      v_rexpr := data->'current_user_ast'
    ),
    ast_helpers.any(
      v_lexpr := ast_helpers.col(data->>'role_key'),
      v_rexpr := data->'current_groups_ast'
    )
  );

  -- node = ast_helpers.any(
  --   v_lexpr := ast_helpers.col(data->>'role_key'),
  --   v_rexpr := data->'current_groups_ast'
  -- );

  RETURN node;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_multi_owners ( data jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  node jsonb;
  key_asts jsonb[];
  item jsonb;
BEGIN

  FOR item IN
    SELECT * FROM jsonb_array_elements(data->'role_keys')
    LOOP 
    key_asts = array_append(key_asts, ast_helpers.eq(
      -- NOTE if you have a string JSON element, item::text will keep " around it
      -- this just gets the root path unescaped.... a nice hack
      -- https://dba.stackexchange.com/questions/207984/unquoting-json-strings-print-json-strings-without-quotes
      v_lexpr := ast_helpers.col(item#>>'{}'),
      v_rexpr := data->'current_user_ast'
    ));
  END LOOP;

  node = ast_helpers.or( variadic nodes := key_asts );

  RETURN node;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_permission_name ( data jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  node jsonb;
BEGIN
  node = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', data->>'permission_role_key'),
                  v_rexpr := data->'current_groups_ast'
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := data->>'permission_schema',
              v_relname := data->>'permission_table',
              v_alias := ast.alias(
                  v_aliasname := 'p'
              )
          )
      ]),
      v_whereClause := ast_helpers.eq(
          v_lexpr := ast_helpers.col('p', data->>'permission_name_key'),
          v_rexpr := ast.a_const(
              v_val := ast.string(data->>'this_value')
          )
      )
  );

  node = ast.sub_link(
    v_subLinkType := 'EXPR_SUBLINK',
    v_subselect := node
  );

  RETURN node;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_owned_object_records ( data jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  node jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key', 

  node = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', data->>'owned_table_key'),
                  v_rexpr := data->'current_groups_ast'
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := data->>'owned_schema',
              v_relname := data->>'owned_table',
              v_alias := ast.alias(
                  v_aliasname := 'p'
              )
          )
      ]),
      v_whereClause := ast_helpers.eq(
          v_lexpr := ast_helpers.col('p', data->>'owned_table_ref_key'),
          v_rexpr := ast_helpers.col(data->>'this_object_key')
      )
  );

  node = ast.sub_link(
    v_subLinkType := 'EXPR_SUBLINK',
    v_subselect := node
  );

  RETURN node;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_administrator_records ( data jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  node jsonb;
BEGIN

  node = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('d', 'owner_id'),
                  v_rexpr := data->'current_groups_ast'
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast.join_expr(
              v_jointype := 'JOIN_INNER',
              v_larg := ast_helpers.range_var(
                  v_schemaname := 'collections_public',
                  v_relname := 'table',
                  v_alias := ast.alias(
                      v_aliasname := 't'
                  )
              ),
              v_rarg := ast_helpers.range_var(
                  v_schemaname := 'collections_public',
                  v_relname := 'database',
                  v_alias := ast.alias(
                      v_aliasname := 'd'
                  )
              ),
              v_quals := ast_helpers.eq(
                  v_lexpr := ast_helpers.col('t', 'database_id'),
                  v_rexpr := ast_helpers.col('d', 'id') 
              )
          )
      ]),
      v_whereClause := ast_helpers.and(
          ast_helpers.eq(
              v_lexpr := ast_helpers.col('t', 'database_id'),
              v_rexpr := ast.a_const( 
                v_val := ast.string( data->>'database_id' )
              )
          ),
          ast_helpers.eq(
              v_lexpr := ast_helpers.col('t', 'id'),
              v_rexpr := ast.a_const( 
                v_val := ast.string( data->>'table_id' )
              )
          )
      )
  );

  node = ast.sub_link(
    v_subLinkType := 'EXPR_SUBLINK',
    v_subselect := node
  );

  RETURN node;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_child_of_owned_object_records ( data jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  node jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed', 

  node = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', data->>'owned_table_key'),
                  v_rexpr := data->'current_groups_ast'
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast.join_expr(
              v_jointype := 'JOIN_INNER',
              v_larg := ast_helpers.range_var(
                  v_schemaname := data->>'object_schema',
                  v_relname := data->>'object_table',
                  v_alias := ast.alias(
                      v_aliasname := 'c'
                  )
              ),
              v_rarg := ast_helpers.range_var(
                  v_schemaname := data->>'owned_schema',
                  v_relname := data->>'owned_table',
                  v_alias := ast.alias(
                      v_aliasname := 'p'
                  )
              ),
              v_quals := ast_helpers.eq(
                  v_lexpr := ast_helpers.col('p',data->>'owned_table_ref_key'),
                  v_rexpr := ast_helpers.col('c',data->>'object_table_owned_key')
              )
          )
      ]),
      v_whereClause := ast_helpers.eq(
          v_lexpr := ast_helpers.col('c',data->>'object_table_ref_key'),
          v_rexpr := ast_helpers.col(data->>'this_object_key')
      )
  );

  node = ast.sub_link(
    v_subLinkType := 'EXPR_SUBLINK',
    v_subselect := node
  );

  RETURN node;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_child_of_owned_object_records_group_array ( data jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  node jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed', 

  node = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := data->'current_user_ast',
                  v_rexpr := ast_helpers.col('g', data->>'owned_table_key')
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast.join_expr(
              v_jointype := 'JOIN_INNER',
              v_larg := ast_helpers.range_var(
                  v_schemaname := data->>'object_schema',
                  v_relname := data->>'object_table',
                  v_alias := ast.alias(
                      v_aliasname := 'm'
                  )
              ),
              v_rarg := ast_helpers.range_var(
                  v_schemaname := data->>'owned_schema',
                  v_relname := data->>'owned_table',
                  v_alias := ast.alias(
                      v_aliasname := 'g'
                  )
              ),
              v_quals := ast_helpers.eq(
                  v_lexpr := ast_helpers.col('g',data->>'owned_table_ref_key'),
                  v_rexpr := ast_helpers.col('m',data->>'object_table_owned_key')
              )
          )
      ]),
      v_whereClause := ast_helpers.eq(
          v_lexpr := ast_helpers.col('m',data->>'object_table_ref_key'),
          v_rexpr := ast_helpers.col(data->>'this_object_key')
      )
  );

  node = ast.sub_link(
    v_subLinkType := 'EXPR_SUBLINK',
    v_subselect := node
  );

  RETURN node;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_child_of_owned_object_records_with_ownership ( data jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  node jsonb;
BEGIN

  -- MODIFY policy since they are the same, except we just WRAP the JoinExpr with an AND
  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed_with_ownership', 

  node = ast_helpers.cpt_child_of_owned_object_records(
    data
  );

  node = jsonb_set(node, '{SubLink, subselect, SelectStmt, fromClause, 0, JoinExpr, quals}', ast.bool_expr(
    v_boolop := 'AND_EXPR',
    v_args := to_jsonb(ARRAY[
        node->'SubLink'->'subselect'->'SelectStmt'->'fromClause'->0->'JoinExpr'->'quals',
        ast_helpers.eq(
            v_lexpr := ast_helpers.col('p', data->>'owned_table_ref_key'),
            v_rexpr := ast_helpers.col(data->>'this_owned_key')
        )
    ])
  ));

  RETURN node;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_owned_object_records_group_array ( data jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  node jsonb;
BEGIN

  node = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := data->'current_user_ast',
                  v_rexpr := ast_helpers.col('p', data->>'owned_table_key')
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := data->>'owned_schema',
              v_relname := data->>'owned_table',
              v_alias := ast.alias(
                  v_aliasname := 'p'
              )
          )
      ]),
      v_whereClause := ast_helpers.eq(
          v_lexpr := ast_helpers.col('p', data->>'owned_table_ref_key'),
          v_rexpr := ast_helpers.col(
            data->>'this_object_key'
          )
      )
  );

  node = ast.sub_link(
    v_subLinkType := 'EXPR_SUBLINK',
    v_subselect := node
  );

  RETURN node;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.entity_wrap_array ( node jsonb, data jsonb ) RETURNS jsonb AS $EOFCODE$
BEGIN

  IF ((data->'include_current_user_id')::bool IS TRUE) THEN 
    -- DO WE NEED TO CAST THE possible ARRAY(...)::uuid[] ?
    -- postgres=# select array_append(NULL, 'sdf');
    -- ERROR:  could not determine polymorphic type because input has type unknown
    node = ast_helpers.any(
      v_lexpr := ast_helpers.col(data->>'entity_field'),
      v_rexpr := ast.func_call(
        v_funcname := ast_helpers.array_of_strings('array_append'),
        v_args := to_jsonb(ARRAY[
          node,
          data->'current_user_ast'
        ])
      )
    );
  ELSE
    node = ast_helpers.any(
      v_lexpr := ast_helpers.col(data->>'entity_field'),
      v_rexpr := node
    );
  END IF;

  RETURN node;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_entity_acl ( data jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  node jsonb;
BEGIN

  node = ast.sub_link(
    v_subLinkType := 'ARRAY_SUBLINK',
    v_subselect := ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.col('acl', 'entity_id')
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := data->>'acl_schema',
              v_relname := data->>'acl_table',
              v_alias := ast.alias(
                  v_aliasname := 'acl'
              )
          )
      ]),
      v_whereClause := ast_helpers.acl_where_clause(data)
    )
  );

  RETURN ast_helpers.entity_wrap_array(
    node,
    data
  );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_entity_acl_join ( data jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  node jsonb;
BEGIN

  node = ast.sub_link(
    v_subLinkType := 'ARRAY_SUBLINK',
    v_subselect := ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_limitOption := 'LIMIT_OPTION_DEFAULT',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.col('acl', 'entity_id')
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast.join_expr(
            v_jointype := 'JOIN_INNER',
            v_larg := ast_helpers.range_var(
              v_schemaname := data->>'acl_schema',
              v_relname := data->>'acl_table',
              v_alias := ast.alias(
                v_aliasname := 'acl'
              )
            ),
            v_rarg := ast_helpers.range_var(
              v_schemaname := data->>'obj_schema',
              v_relname := data->>'obj_table',
              v_alias := ast.alias(
                v_aliasname := 'obj'
              )
            ),
            v_quals := ast_helpers.eq(
              ast_helpers.col('acl', 'entity_id'),
              ast_helpers.col('obj', data->>'obj_field')
            )
          )
      ]),
      v_whereClause := ast_helpers.acl_where_clause(data)
    )
  );

  RETURN ast_helpers.entity_wrap_array(
    node,
    data
  );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.acl_where_clause ( data jsonb ) RETURNS jsonb AS $EOFCODE$
BEGIN
  RETURN (CASE WHEN data->'mask' IS NULL THEN
      ast_helpers.eq(
          v_lexpr := ast_helpers.col('acl', 'actor_id'),
          v_rexpr := data->'current_user_ast'
      )
    ELSE
      ast.bool_expr(
        v_boolop := 'AND_EXPR',
        v_args := to_jsonb(ARRAY[
          ast_helpers.eq(
              v_lexpr := ast.a_expr(
                v_kind := 'AEXPR_OP',
                v_name := to_jsonb(ARRAY[ast.string('&')]),
                v_lexpr := ast_helpers.col('acl', 'permissions'),
                v_rexpr := ast.a_const(v_val := ast.string(data->>'mask'))
              ),
              v_rexpr := ast.a_const(v_val := ast.string(data->>'mask'))
          ),
          ast_helpers.eq(
              v_lexpr := ast_helpers.col('acl', 'actor_id'),
              v_rexpr := data->'current_user_ast'
          )
        ]) 
      )
    END);
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_acl ( data jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  node jsonb;
BEGIN

  node = ast.sub_link (
    v_subLinkType := 'EXISTS_SUBLINK',
    v_subselect := ast.select_stmt(
       v_op := 'SETOP_NONE',
       v_targetList := to_jsonb(ARRAY[
         ast.res_target(
            v_val := ast.a_const(ast.integer(1))
         )
       ]),
       v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := data->>'acl_schema',
              v_relname := data->>'acl_table',
              v_alias := ast.alias(
                  v_aliasname := 'acl'
              )
          )
      ]),
      v_whereClause := ast_helpers.acl_where_clause(
        data
      )
    )
  );

  RETURN node;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.create_policy_template ( name text, data jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  policy_ast jsonb;
BEGIN

  -- TODO for safety, keep defaults. However, group_ids() should only return array of current_user_id()

  IF (data->>'rls_role' IS NULL OR data->>'rls_role_schema' IS NULL) THEN 
    data = jsonb_set(data, '{rls_role_schema}', to_jsonb('jwt_public'::text));
    data = jsonb_set(data, '{rls_role}', to_jsonb('current_user_id'::text));
  END IF;

  IF (data->>'rls_groups' IS NULL OR data->>'rls_groups_schema' IS NULL) THEN 
    data = jsonb_set(data, '{rls_groups_schema}', to_jsonb('jwt_public'::text));
    data = jsonb_set(data, '{rls_groups}', to_jsonb('current_group_ids'::text));
  END IF;

  IF (data->'current_groups_ast' IS NULL) THEN 
      data = jsonb_set(data, '{current_groups_ast}', 
        ast_helpers.rls_fn(
          data->>'rls_groups_schema',
          data->>'rls_groups'
        )
      );
  END IF;

  IF (data->'current_user_ast' IS NULL) THEN 
      data = jsonb_set(data, '{current_user_ast}', 
        ast_helpers.rls_fn(
          data->>'rls_role_schema',
          data->>'rls_role')
      );
  END IF;


  -- Tag some functions, allow them to be "RLS functions"
  -- so they show up in the RLS UI

  IF (name = 'own_records') THEN
      policy_ast = ast_helpers.cpt_own_records(
          data
      );
  ELSEIF (name = 'owned_records') THEN
      policy_ast = ast_helpers.cpt_owned_records(
          data
      );
  ELSEIF (name = 'multi_owners') THEN
      policy_ast = ast_helpers.cpt_multi_owners(
          data
      );
  ELSEIF (name = 'permission_name') THEN
      policy_ast = ast_helpers.cpt_permission_name(
          data
      );
  ELSEIF (name = 'owned_object_records') THEN
      policy_ast = ast_helpers.cpt_owned_object_records(
          data
      );
  ELSEIF (name = 'child_of_owned_object_records') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records(
          data
      );
  ELSEIF (name = 'child_of_owned_object_records_with_ownership') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records_with_ownership(
          data
      );
  ELSEIF (name = 'child_of_owned_object_records_group_array') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records_group_array(
          data
      );
  ELSEIF (name = 'owned_object_records_group_array') THEN
      policy_ast = ast_helpers.cpt_owned_object_records_group_array(
          data
      );
  ELSEIF (name = 'administrator_records') THEN
      policy_ast = ast_helpers.cpt_administrator_records(
          data
      );
  ELSEIF (name = 'entity_acl_join') THEN
      policy_ast = ast_helpers.cpt_entity_acl_join(
          data
      );
  ELSEIF (name = 'entity_acl') THEN
      policy_ast = ast_helpers.cpt_entity_acl(
          data
      );
  ELSEIF (name = 'acl') THEN
      policy_ast = ast_helpers.cpt_acl(
          data
      );
  ELSEIF (name = 'open') THEN
      policy_ast = ast.string('TRUE');
  ELSEIF (name = 'closed') THEN
      policy_ast = ast.string('FALSE');
  ELSE 
      RAISE EXCEPTION 'UNSUPPORTED POLICY (%)', name;
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
      v_op := 'SETOP_NONE'
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

GRANT USAGE ON SCHEMA ast_utils TO PUBLIC;

ALTER DEFAULT PRIVILEGES IN SCHEMA ast_utils 
 GRANT EXECUTE ON FUNCTIONS  TO PUBLIC;

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

CREATE FUNCTION ast_utils.objtype_name ( objtype text ) RETURNS text AS $EOFCODE$
  select (CASE objtype
WHEN 'OBJECT_ACCESS_METHOD' THEN 'ACCESS METHOD'
WHEN 'OBJECT_AGGREGATE' THEN 'AGGREGATE'
WHEN 'OBJECT_AMOP' THEN NULL -- TODO  
WHEN 'OBJECT_AMPROC' THEN NULL -- TODO 
WHEN 'OBJECT_ATTRIBUTE' THEN 'ATTRIBUTE'
WHEN 'OBJECT_CAST' THEN 'CAST'
WHEN 'OBJECT_COLUMN' THEN 'COLUMN'
WHEN 'OBJECT_COLLATION' THEN 'COLLATION'
WHEN 'OBJECT_CONVERSION' THEN 'CONVERSION'
WHEN 'OBJECT_DATABASE' THEN 'DATABASE'
WHEN 'OBJECT_DEFAULT' THEN NULL -- TODO 
WHEN 'OBJECT_DEFACL' THEN NULL -- TODO 
WHEN 'OBJECT_DOMAIN' THEN 'DOMAIN'
WHEN 'OBJECT_DOMCONSTRAINT' THEN 'CONSTRAINT'
WHEN 'OBJECT_EVENT_TRIGGER' THEN 'EVENT TRIGGER'
WHEN 'OBJECT_EXTENSION' THEN 'EXTENSION'
WHEN 'OBJECT_FDW' THEN 'FOREIGN DATA WRAPPER'
WHEN 'OBJECT_FOREIGN_SERVER' THEN 'SERVER'
WHEN 'OBJECT_FOREIGN_TABLE' THEN 'FOREIGN TABLE'
WHEN 'OBJECT_FUNCTION' THEN 'FUNCTION'
WHEN 'OBJECT_INDEX' THEN 'INDEX'
WHEN 'OBJECT_LANGUAGE' THEN 'LANGUAGE'
WHEN 'OBJECT_LARGEOBJECT' THEN 'LARGE OBJECT'
WHEN 'OBJECT_MATVIEW' THEN 'MATERIALIZED VIEW'
WHEN 'OBJECT_OPCLASS' THEN 'OPERATOR CLASS'
WHEN 'OBJECT_OPERATOR' THEN 'OPERATOR'
WHEN 'OBJECT_OPFAMILY' THEN 'OPERATOR FAMILY'
WHEN 'OBJECT_POLICY' THEN 'POLICY'
WHEN 'OBJECT_PROCEDURE' THEN 'PROCEDURE'
WHEN 'OBJECT_PUBLICATION' THEN 'PUBLICATION'
WHEN 'OBJECT_PUBLICATION_REL' THEN NULL -- TODO 
WHEN 'OBJECT_ROLE' THEN 'ROLE'
WHEN 'OBJECT_ROUTINE' THEN 'ROUTINE'
WHEN 'OBJECT_RULE' THEN 'RULE'
WHEN 'OBJECT_SCHEMA' THEN 'SCHEMA'
WHEN 'OBJECT_SEQUENCE' THEN 'SEQUENCE'
WHEN 'OBJECT_SUBSCRIPTION' THEN 'SUBSCRIPTION'
WHEN 'OBJECT_STATISTIC_EXT' THEN 'STATISTICS'
WHEN 'OBJECT_TABCONSTRAINT' THEN 'CONSTRAINT'
WHEN 'OBJECT_TABLE' THEN 'TABLE'
WHEN 'OBJECT_TABLESPACE' THEN 'TABLESPACE'
WHEN 'OBJECT_TRANSFORM' THEN 'TRANSFORM'
WHEN 'OBJECT_TRIGGER' THEN 'TRIGGER'
WHEN 'OBJECT_TSCONFIGURATION' THEN 'TEXT SEARCH CONFIGURATION'
WHEN 'OBJECT_TSDICTIONARY' THEN 'TEXT SEARCH DICTIONARY'
WHEN 'OBJECT_TSPARSER' THEN 'TEXT SEARCH PARSER'
WHEN 'OBJECT_TSTEMPLATE' THEN 'TEXT SEARCH TEMPLATE'
WHEN 'OBJECT_TYPE' THEN 'TYPE'
WHEN 'OBJECT_USER_MAPPING' THEN 'USER MAPPING'
WHEN 'OBJECT_VIEW' THEN 'VIEW'
END);
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_utils.constrainttypes ( contype text ) RETURNS text AS $EOFCODE$
  select (CASE contype
WHEN 'CONSTR_NULL' THEN 'NULL'
WHEN 'CONSTR_NOTNULL' THEN 'NOT NULL'
WHEN 'CONSTR_DEFAULT' THEN 'DEFAULT'
WHEN 'CONSTR_CHECK' THEN 'CHECK'
WHEN 'CONSTR_PRIMARY' THEN 'PRIMARY KEY'
WHEN 'CONSTR_UNIQUE' THEN 'UNIQUE'
WHEN 'CONSTR_EXCLUSION' THEN 'EXCLUDE'
WHEN 'CONSTR_FOREIGN' THEN 'REFERENCES'
END);
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION ast_utils.getgrantobject ( node jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  objtype text;
  targtype text;
BEGIN 

  objtype = node->>'objtype';
  IF (node->'targtype') IS NOT NULL THEN
    targtype = node->>'targtype';
  END IF;

  IF (objtype = 'OBJECT_COLUMN') THEN
    RETURN 'COLUMN';
  ELSIF (objtype = 'OBJECT_TABLE') THEN
    IF (targtype = 'ACL_TARGET_ALL_IN_SCHEMA') THEN 
      RETURN 'ALL TABLES IN SCHEMA';
    ELSIF (targtype = 'ACL_TARGET_DEFAULTS') THEN 
      RETURN 'TABLES';
    END IF;
    RETURN 'TABLE';
  ELSIF (objtype = 'OBJECT_SEQUENCE') THEN
    IF (targtype = 'ACL_TARGET_ALL_IN_SCHEMA') THEN 
      RETURN 'ALL SEQUENCES IN SCHEMA';
    ELSIF (targtype = 'ACL_TARGET_DEFAULTS') THEN 
      RETURN 'SEQUENCES';
    END IF;
    RETURN 'SEQUENCE';
  ELSIF (objtype = 'OBJECT_DATABASE') THEN
    RETURN 'DATABASE';
  ELSIF (objtype = 'OBJECT_DOMAIN') THEN
    RETURN 'DOMAIN';
  ELSIF (objtype = 'OBJECT_FDW') THEN
    RETURN 'FOREIGN DATA WRAPPER';
  ELSIF (objtype = 'OBJECT_FOREIGN_SERVER') THEN
    RETURN 'FOREIGN SERVER';
  ELSIF (objtype = 'OBJECT_FUNCTION') THEN
    IF (targtype = 'ACL_TARGET_ALL_IN_SCHEMA') THEN 
      RETURN 'ALL FUNCTIONS IN SCHEMA';
    ELSIF (targtype = 'ACL_TARGET_DEFAULTS') THEN 
      RETURN 'FUNCTIONS';
    END IF;
    RETURN 'FUNCTION';
  ELSIF (objtype = 'OBJECT_LANGUAGE') THEN
    RETURN 'LANGUAGE';
  ELSIF (objtype = 'OBJECT_LARGEOBJECT') THEN
    RETURN 'LARGE OBJECT';
  ELSIF (objtype = 'OBJECT_SCHEMA') THEN
    RETURN 'SCHEMA';
  ELSIF (objtype = 'OBJECT_TABLESPACE') THEN
    RETURN 'TABLESPACE';
  ELSIF (objtype = 'OBJECT_TYPE') THEN
    RETURN 'TYPE';
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION %', 'GrantObjectType';

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE SCHEMA deparser;

GRANT USAGE ON SCHEMA deparser TO PUBLIC;

ALTER DEFAULT PRIVILEGES IN SCHEMA deparser 
 GRANT EXECUTE ON FUNCTIONS  TO PUBLIC;

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
    IF (node->'TypeName') IS NOT NULL THEN  
      node = node->'TypeName';
    END IF;

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
    IF (node->'TypeCast') IS NOT NULL THEN  
      node = node->'TypeCast';
    END IF;

    IF (node->'typeName') IS NULL THEN  
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'TypeCast';
    END IF;

    type = deparser.type_name(node->'typeName', context);

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
    IF (node->'RangeVar') IS NOT NULL THEN  
      node = node->'RangeVar';
    END IF;

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
      output = array_append(output, deparser.alias(node->'alias', context));
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

  IF (operator = '~') THEN
    IF ( jsonb_array_length( expr->'rexpr'->'FuncCall'->'args' ) > 1 ) THEN
      SELECT deparser.expression(expr->'rexpr'->'FuncCall'->'args'->0, context) INTO right_expr;
      SELECT deparser.expression(expr->'rexpr'->'FuncCall'->'args'->1, context) INTO right_expr2;
      RETURN format('%s SIMILAR TO %s ESCAPE %s', left_expr, right_expr, right_expr2);
    ELSE 
      SELECT deparser.expression(expr->'rexpr'->'FuncCall'->'args'->0, context) INTO right_expr;
      RETURN format('%s SIMILAR TO %s', left_expr, right_expr);
    END IF;
  ELSE
    IF ( jsonb_array_length( expr->'rexpr'->'FuncCall'->'args' ) > 1) THEN
      SELECT deparser.expression(expr->'rexpr'->'FuncCall'->'args'->0, context) INTO right_expr;
      SELECT deparser.expression(expr->'rexpr'->'FuncCall'->'args'->1, context) INTO right_expr2;
      RETURN format('%s NOT SIMILAR TO %s ESCAPE %s', left_expr, right_expr, right_expr2);
    ELSE 
      SELECT deparser.expression(expr->'rexpr'->'FuncCall'->'args'->0, context) INTO right_expr;
      RETURN format('%s NOT SIMILAR TO %s', left_expr, right_expr);
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
  kind text;
BEGIN

  IF (expr->>'A_Expr') IS NULL THEN  
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
  END IF;

  expr = expr->'A_Expr';

  IF (expr->'kind') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
  END IF;

  kind = expr->>'kind';

  IF (kind = 'AEXPR_OP') THEN
    RETURN deparser.a_expr_op(expr, context);
  ELSEIF (kind = 'AEXPR_OP_ANY') THEN
    RETURN deparser.a_expr_op_any(expr, context);
  ELSEIF (kind = 'AEXPR_OP_ALL') THEN
    RETURN deparser.a_expr_op_all(expr, context);
  ELSEIF (kind = 'AEXPR_DISTINCT') THEN
    RETURN deparser.a_expr_distinct(expr, context);
  ELSEIF (kind = 'AEXPR_NOT_DISTINCT') THEN
    RETURN deparser.a_expr_not_distinct(expr, context);
  ELSEIF (kind = 'AEXPR_NULLIF') THEN
    RETURN deparser.a_expr_nullif(expr, context);
  ELSEIF (kind = 'AEXPR_OF') THEN
    RETURN deparser.a_expr_of(expr, context);
  ELSEIF (kind = 'AEXPR_IN') THEN
    RETURN deparser.a_expr_in(expr, context);
  ELSEIF (kind = 'AEXPR_LIKE') THEN
    RETURN deparser.a_expr_like(expr, context);
  ELSEIF (kind = 'AEXPR_ILIKE') THEN
    RETURN deparser.a_expr_ilike(expr, context);
  ELSEIF (kind = 'AEXPR_SIMILAR') THEN
    RETURN deparser.a_expr_similar(expr, context);
  ELSEIF (kind = 'AEXPR_BETWEEN') THEN
    RETURN deparser.a_expr_between(expr, context);
  ELSEIF (kind = 'AEXPR_NOT_BETWEEN') THEN
    RETURN deparser.a_expr_not_between(expr, context);
  ELSEIF (kind = 'AEXPR_BETWEEN_SYM') THEN
    RETURN deparser.a_expr_between_sym(expr, context);
  ELSEIF (kind = 'AEXPR_NOT_BETWEEN_SYM') THEN
    RETURN deparser.a_expr_not_between_sym(expr, context);
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION % (%)', 'A_Expr', expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.bool_expr ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  boolop text;
  ctx jsonb;
  fmt_str text = '%s';
BEGIN

  IF (node->>'BoolExpr') IS NULL THEN  
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'BoolExpr (node)';
  END IF;

  node = node->'BoolExpr';

  IF (node->'boolop') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'BoolExpr (missing boolop)';
  END IF;
  IF (node->'args') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'BoolExpr (missing args)';
  END IF;

  boolop = node->>'boolop';

  IF ((context->'bool')::bool IS TRUE) THEN 
    fmt_str = '(%s)';
  END IF;
  ctx = jsonb_set(context, '{bool}', to_jsonb(TRUE));

  IF (boolop = 'AND_EXPR') THEN
    RETURN format(fmt_str, array_to_string(deparser.expressions_array(node->'args', ctx), ' AND '));
  ELSEIF (boolop = 'OR_EXPR') THEN
    RETURN format(fmt_str, array_to_string(deparser.expressions_array(node->'args', ctx), ' OR '));
  ELSEIF (boolop = 'NOT_EXPR') THEN -- purposely use original context for less parens
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
    RETURN format('ARRAY[]');
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

  output = array_append(output, deparser.type_name(node->'typeName', context));

  IF (node->'raw_default') IS NOT NULL THEN
    output = array_append(output, 'USING');
    output = array_append(output, deparser.expression(node->'raw_default', context));
  END IF;

  IF (node->'constraints') IS NOT NULL THEN
    output = array_append(output, deparser.list(node->'constraints', ' ', context));
  END IF;

  IF (node->'collClause') IS NOT NULL THEN
    output = array_append(output, 'COLLATE');
    output = array_append(output, quote_ident(node->'collClause'->'collname'->0->'String'->>'str'));
  END IF;

  RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.sql_value_function ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  op text;
  value text;
BEGIN

  IF (node->'SQLValueFunction') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'SQLValueFunction';
  END IF;

  IF (node->'SQLValueFunction'->'op') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION % (op)', 'SQLValueFunction';
  END IF;

  node = node->'SQLValueFunction';
  op = node->>'op';

  SELECT (CASE
  WHEN (op = 'SVFOP_CURRENT_DATE')
      THEN 'CURRENT_DATE' 
  WHEN (op = 'SVFOP_CURRENT_TIME')
      THEN 'CURRENT_TIME' 
  WHEN (op = 'SVFOP_CURRENT_TIME_N')
      THEN 'CURRENT_TIME_N' 
  WHEN (op = 'SVFOP_CURRENT_TIMESTAMP')
      THEN 'CURRENT_TIMESTAMP' 
  WHEN (op = 'SVFOP_CURRENT_TIMESTAMP_N')
      THEN 'CURRENT_TIMESTAMP_N' 
  WHEN (op = 'SVFOP_LOCALTIME')
      THEN 'LOCALTIME' 
  WHEN (op = 'SVFOP_LOCALTIME_N')
      THEN 'LOCALTIME_N' 
  WHEN (op = 'SVFOP_LOCALTIMESTAMP')
      THEN 'LOCALTIMESTAMP' 
  WHEN (op = 'SVFOP_LOCALTIMESTAMP_N')
      THEN 'LOCALTIMESTAMP_N' 
  WHEN (op = 'SVFOP_CURRENT_ROLE')
      THEN 'CURRENT_ROLE' 
  WHEN (op = 'SVFOP_CURRENT_USER')
      THEN 'CURRENT_USER'
  WHEN (op = 'SVFOP_USER')
      THEN 'USER' 
  WHEN (op = 'SVFOP_SESSION_USER')
      THEN 'SESSION_USER' 
  WHEN (op = 'SVFOP_CURRENT_CATALOG')
      THEN 'CURRENT_CATALOG' 
  WHEN (op = 'SVFOP_CURRENT_SCHEMA')
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
  booltesttype text;
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

  booltesttype = node->>'booltesttype';

  output = array_append(output, deparser.expression(node->'arg'));

  output = array_append(output, (CASE
      WHEN booltesttype = 'IS_TRUE' THEN 'IS TRUE'
      WHEN booltesttype = 'IS_NOT_TRUE' THEN 'IS NOT TRUE'
      WHEN booltesttype = 'IS_FALSE' THEN 'IS FALSE'
      WHEN booltesttype = 'IS_NOT_FALSE' THEN 'IS NOT FALSE'
      WHEN booltesttype = 'IS_UNKNOWN' THEN 'IS UNKNOWN'
      WHEN booltesttype = 'IS_NOT_UNKNOWN' THEN 'IS NOT UNKNOWN'
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
  output = array_append(output, deparser.range_var(node->'relation', context));
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
      output = array_append(output, deparser.range_var(node->'table'));
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

    IF (node->'qual') IS NOT NULL THEN
      output = array_append(output, 'USING');
      output = array_append(output, '(');
      output = array_append(output, deparser.expression(node->'qual'));
      output = array_append(output, ')');
    END IF;

    IF (node->'with_check') IS NOT NULL THEN
      output = array_append(output, 'WITH CHECK');
      output = array_append(output, '(');
      output = array_append(output, deparser.expression(node->'with_check'));
      output = array_append(output, ')');
    END IF;

    RETURN array_to_string(output, ' ');

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_policy_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  permissive bool;
BEGIN
    IF (node->'AlterPolicyStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterPolicyStmt';
    END IF;

    IF (node->'AlterPolicyStmt'->'policy_name') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterPolicyStmt';
    END IF;

    node = node->'AlterPolicyStmt';

    output = array_append(output, 'ALTER');
    output = array_append(output, 'POLICY');
    output = array_append(output, quote_ident(node->>'policy_name'));

    IF (node->'table') IS NOT NULL THEN
      output = array_append(output, 'ON');
      output = array_append(output, deparser.range_var(node->'table'));
    END IF;

    IF (node->'roles') IS NOT NULL THEN
      output = array_append(output, 'TO');
      output = array_append(output, deparser.list(node->'roles'));
    END IF;

   IF (node->'qual') IS NOT NULL THEN
      output = array_append(output, 'USING');
      output = array_append(output, '(');
      output = array_append(output, deparser.expression(node->'qual'));
      output = array_append(output, ')');
    END IF;

    IF (node->'with_check') IS NOT NULL THEN
      output = array_append(output, 'WITH CHECK');
      output = array_append(output, '(');
      output = array_append(output, deparser.expression(node->'with_check'));
      output = array_append(output, ')');
    END IF;

    RETURN array_to_string(output, ' ');

END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.role_spec ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  roletype text;
BEGIN
    IF (node->'RoleSpec') IS NOT NULL THEN
      node = node->'RoleSpec';
    END IF;

    IF (node->'roletype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RoleSpec';
    END IF;

    roletype = node->>'roletype';

    IF (roletype = 'ROLESPEC_CSTRING') THEN
      RETURN quote_ident(node->>'rolename');
    ELSIF (roletype = 'ROLESPEC_CURRENT_USER') THEN 
      RETURN 'CURRENT_USER';
    ELSIF (roletype = 'ROLESPEC_SESSION_USER') THEN 
      RETURN 'SESSION_USER';
    ELSIF (roletype = 'ROLESPEC_PUBLIC') THEN 
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
    output = array_append(output, deparser.range_var(node->'relation'));

    IF (node->'cols' IS NOT NULL AND jsonb_array_length(node->'cols') > 0) THEN 
      output = array_append(output, deparser.parens(deparser.list(node->'cols')));
    END IF;

    IF (node->'selectStmt') IS NOT NULL THEN
      output = array_append(output, deparser.expression(node->'selectStmt'));
    ELSE
      output = array_append(output, 'DEFAULT VALUES');
    END IF;

    IF (node->'onConflictClause') IS NOT NULL THEN
      output = array_append(output, deparser.on_conflict_clause(node->'onConflictClause'));
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
      output = array_append(output, deparser.range_var(node->'pktable'));
      output = array_append(output, deparser.parens(deparser.list_quotes(node->'pk_attrs')));
    ELSIF (has_pk_attrs) THEN 
      output = array_append(output, deparser.constraint_stmt(node));
      output = array_append(output, deparser.range_var(node->'pktable'));
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
      output = array_append(output, deparser.range_var(node->'pktable'));
    ELSE 
      output = array_append(output, deparser.constraint_stmt(node));
      output = array_append(output, deparser.range_var(node->'pktable'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.constraint_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  contype text;
  constrainttype text;
BEGIN
  contype = node->>'contype';

  IF (contype = 'CONSTR_IDENTITY') THEN
    output = array_append(output, 'GENERATED');
    IF (node->>'generated_when' = 'a') THEN 
      output = array_append(output, 'ALWAYS AS');
    ELSE
      output = array_append(output, 'BY DEFAULT AS');
    END IF;
    output = array_append(output, 'IDENTITY');
    IF (node->'options' IS NOT NULL) THEN 
      output = array_append(output, 
        deparser.parens(deparser.list(node->'options', ' ', 
          jsonb_set(context, '{generated}', to_jsonb(TRUE))
        ))
      );
    END IF;
    RETURN array_to_string(output, ' ');

  ELSIF (contype = 'CONSTR_GENERATED') THEN
    output = array_append(output, 'GENERATED');
    IF (node->>'generated_when' = 'a') THEN 
      output = array_append(output, 'ALWAYS AS');
    END IF;
    RETURN array_to_string(output, ' ');

  END IF;

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
    output = array_append(output, deparser.range_var(node->'sequence'));

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
    output = array_append(output, deparser.into_clause(node->'into'));
    output = array_append(output, 'AS');
    output = array_append(output, deparser.expression(node->'query'));

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.constraint ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  contype text;
BEGIN

    IF (node->'Constraint') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'Constraint';
    END IF;

    IF (node->'Constraint'->'contype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'Constraint';
    END IF;

    node = node->'Constraint';
    contype = node->>'contype';

    IF (contype = 'CONSTR_FOREIGN') THEN 
      output = array_append(output, deparser.reference_constraint(node));
    ELSE
      output = array_append(output, deparser.constraint_stmt(node));
    END IF;

    IF (node->'keys' IS NOT NULL AND jsonb_array_length(node->'keys') > 0) THEN 
      output = array_append(output, deparser.parens(deparser.list_quotes(node->'keys')));
    END IF;

    IF (node->'raw_expr' IS NOT NULL) THEN 
      output = array_append(output, deparser.parens(deparser.expression(node->'raw_expr')));
      IF (contype = 'CONSTR_GENERATED') THEN 
        output = array_append(output, 'STORED');
      END IF;
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

    IF (contype = 'CONSTR_EXCLUSION') THEN 
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

    IF ((context->'generated')::bool IS TRUE) THEN
      IF (defname = 'start') THEN 
        RETURN 'START WITH ' || deparser.expression(node->'arg');
      ELSIF (defname = 'increment') THEN 
        RETURN 'INCREMENT BY ' || deparser.expression(node->'arg');
      ELSE 
        RAISE EXCEPTION 'BAD_EXPRESSION %', 'DefElem (generated)';
      END IF;
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
  objtype text;

  cmt text;
BEGIN
    IF (node->'CommentStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CommentStmt';
    END IF;

    IF (node->'CommentStmt'->'objtype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'CommentStmt';
    END IF;

    node = node->'CommentStmt';
    objtype = node->>'objtype';
    output = array_append(output, 'COMMENT');
    output = array_append(output, 'ON');
    output = array_append(output, ast_utils.objtype_name(objtype));

    IF (objtype = 'OBJECT_CAST') THEN
      output = array_append(output, '(');
      output = array_append(output, deparser.expression(node->'object'->0));
      output = array_append(output, 'AS');
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, ')');
    ELSIF (objtype = 'OBJECT_DOMCONSTRAINT') THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'ON');
      output = array_append(output, 'DOMAIN');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = 'OBJECT_OPCLASS') THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'USING');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = 'OBJECT_OPFAMILY') THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'USING');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = 'OBJECT_OPERATOR') THEN
      -- TODO lookup noquotes context in pgsql-parser
      output = array_append(output, deparser.expression(node->'object', 'noquotes'));
    ELSIF (objtype = 'OBJECT_POLICY') THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'ON');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = 'OBJECT_ROLE') THEN
      output = array_append(output, deparser.expression(node->'object'));
    ELSIF (objtype = 'OBJECT_RULE') THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'ON');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = 'OBJECT_TABCONSTRAINT') THEN
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
    ELSIF (objtype = 'OBJECT_TRANSFORM') THEN
      output = array_append(output, 'FOR');
      output = array_append(output, deparser.expression(node->'object'->0));
      output = array_append(output, 'LANGUAGE');
      output = array_append(output, deparser.expression(node->'object'->1));
    ELSIF (objtype = 'OBJECT_TRIGGER') THEN
      output = array_append(output, deparser.expression(node->'object'->1));
      output = array_append(output, 'ON');
      output = array_append(output, deparser.expression(node->'object'->0));
    ELSIF (objtype = 'OBJECT_LARGEOBJECT') THEN
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

    output = array_append(output, deparser.grant_stmt(node->'action'));

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
    IF (node->'WithClause') IS NOT NULL THEN
      node = node->'WithClause';
    END IF;

    IF (node->'ctes') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'WithClause';
    END IF;

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
  kind text;
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

    kind = node->>'kind';
    IF (kind = 'VAR_SET_VALUE') THEN 
      IF (node->'is_local' IS NOT NULL AND (node->'is_local')::bool IS TRUE) THEN 
        local = 'LOCAL ';
      END IF;
      output = array_append(output, format('SET %s%s = %s', local, node->>'name', deparser.list(node->'args', ', ', jsonb_set(context, '{simple}', to_jsonb(TRUE)))));
    ELSIF (kind = 'VAR_SET_DEFAULT') THEN
      output = array_append(output, format('SET %s TO DEFAULT', node->>'name'));
    ELSIF (kind = 'VAR_SET_CURRENT') THEN
      output = array_append(output, format('SET %s FROM CURRENT', node->>'name'));
    ELSIF (kind = 'VAR_SET_MULTI') THEN
      IF (node->>'name' = 'TRANSACTION') THEN
        multi = 'TRANSACTION';
      ELSIF (node->>'name' = 'SESSION CHARACTERISTICS') THEN
        multi = 'SESSION CHARACTERISTICS AS TRANSACTION';
      END IF;
      output = array_append(output, format('SET %s %s', multi, deparser.list(node->'args', ', ', jsonb_set(context, '{simple}', to_jsonb(TRUE)))));
    ELSIF (kind = 'VAR_RESET') THEN
      output = array_append(output, format('RESET %s', node->>'name'));
    ELSIF (kind = 'VAR_RESET_ALL') THEN
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
    IF (node->'Alias') IS NOT NULL THEN
      node = node->'Alias';
    END IF;

    IF (node->'aliasname') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'Alias';
    END IF;

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
      output = array_append(output, deparser.alias(node->'alias'));
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
    output = array_append(output, deparser.range_var(node->'relation'));

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
    output = array_append(output, deparser.type_name(node->'typeName'));

    IF (node->'constraints' IS NOT NULL) THEN 
      output = array_append(output, deparser.list(node->'constraints'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.grant_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  objtype text;
BEGIN
    IF (node->'GrantStmt') IS NOT NULL THEN
      node = node->'GrantStmt';
    END IF;

    IF (node->'objtype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'GrantStmt';
    END IF;

    objtype = node->>'objtype';

    IF (objtype != 'OBJECT_ACCESS_METHOD') THEN 
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
        IF ( objtype = 'OBJECT_DOMAIN' ) THEN 
          output = array_append(output, deparser.list(node->'objects'->0));
        ELSIF (jsonb_typeof (node->'objects'->0) = 'array') THEN 
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
      
      IF (node->>'behavior' = 'DROP_CASCADE') THEN
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
    output = array_append(output, deparser.range_var(node->'typevar', context));
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
  subtype text;
  subtypeName text;
BEGIN
    IF (node->'AlterTableCmd') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterTableCmd';
    END IF;

    IF (node->'AlterTableCmd'->'subtype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterTableCmd';
    END IF;

    node = node->'AlterTableCmd';
    subtype = node->>'subtype';
    
    subtypeName = 'COLUMN';
    IF ( context->>'alterType' = 'OBJECT_TYPE' ) THEN 
      subtypeName = 'ATTRIBUTE';
    END IF;

    IF (subtype = 'AT_AddColumn') THEN 
      output = array_append(output, 'ADD');
      output = array_append(output, subtypeName);
      IF ( (node->'missing_ok')::bool IS TRUE ) THEN 
        output = array_append(output, 'IF NOT EXISTS');
      END IF;
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = 'AT_ColumnDefault') THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, subtypeName);
      output = array_append(output, quote_ident(node->>'name'));
      IF (node->'def' IS NOT NULL) THEN
        output = array_append(output, 'SET DEFAULT');
        output = array_append(output, deparser.expression(node->'def'));
      ELSE
        output = array_append(output, 'DROP DEFAULT');
      END IF;
    ELSIF (subtype = 'AT_DropNotNull') THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, subtypeName);
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'DROP NOT NULL');
    ELSIF (subtype = 'AT_SetNotNull') THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, subtypeName);
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'SET NOT NULL');
    ELSIF (subtype = 'AT_SetStatistics') THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'SET STATISTICS');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = 'AT_SetOptions') THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, subtypeName);
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'SET');
      output = array_append(output, deparser.parens(deparser.list(node->'def')));
    ELSIF (subtype = 'AT_SetStorage') THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'SET STORAGE');
      IF (node->'def' IS NOT NULL) THEN
        output = array_append(output, deparser.expression(node->'def'));
      ELSE
        output = array_append(output, 'PLAIN');
      END IF;
    ELSIF (subtype = 'AT_DropColumn') THEN
      output = array_append(output, 'DROP');
      output = array_append(output, subtypeName);
      IF ( (node->'missing_ok')::bool IS TRUE ) THEN
        output = array_append(output, 'IF EXISTS');
      END IF;
      output = array_append(output, quote_ident(node->>'name'));
    ELSIF (subtype = 'AT_AddConstraint') THEN
      output = array_append(output, 'ADD');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = 'AT_ValidateConstraint') THEN
      output = array_append(output, 'VALIDATE CONSTRAINT');
      output = array_append(output, quote_ident(node->>'name'));
    ELSIF (subtype = 'AT_DropConstraint') THEN
      output = array_append(output, 'DROP CONSTRAINT');
      IF ( (node->'missing_ok')::bool IS TRUE ) THEN
        output = array_append(output, 'IF EXISTS');
      END IF;
      output = array_append(output, quote_ident(node->>'name'));
    ELSIF (subtype = 'AT_AlterColumnType') THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, subtypeName);
      output = array_append(output, quote_ident(node->>'name'));
      output = array_append(output, 'TYPE');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = 'AT_ChangeOwner') THEN
      output = array_append(output, 'OWNER TO');
      output = array_append(output, deparser.role_spec(node->'newowner'));
    ELSIF (subtype = 'AT_ClusterOn') THEN
      output = array_append(output, 'CLUSTER ON');
      output = array_append(output, quote_ident(node->>'name'));
    ELSIF (subtype = 'AT_DropCluster') THEN
      output = array_append(output, 'SET WITHOUT CLUSTER');
    ELSIF (subtype = 'AT_AddOids') THEN
      output = array_append(output, 'SET WITH OIDS');
    ELSIF (subtype = 'AT_DropOids') THEN
      output = array_append(output, 'SET WITHOUT OIDS');
    ELSIF (subtype = 'AT_SetRelOptions') THEN
      output = array_append(output, 'SET');
      output = array_append(output, deparser.parens(deparser.list(node->'def')));
    ELSIF (subtype = 'AT_ResetRelOptions') THEN
      output = array_append(output, 'RESET');
      output = array_append(output, deparser.parens(deparser.list(node->'def')));
    ELSIF (subtype = 'AT_AddInherit') THEN
      output = array_append(output, 'INHERIT');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = 'AT_DropInherit') THEN
      output = array_append(output, 'NO INHERIT');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = 'AT_AddOf') THEN
      output = array_append(output, 'OF');
      output = array_append(output, deparser.expression(node->'def'));
    ELSIF (subtype = 'AT_DropOf') THEN
      output = array_append(output, 'NOT OF');
    ELSIF (subtype = 'AT_EnableRowSecurity') THEN
      output = array_append(output, 'ENABLE ROW LEVEL SECURITY');
    ELSIF (subtype = 'AT_DisableRowSecurity') THEN
      output = array_append(output, 'DISABLE ROW LEVEL SECURITY');
    ELSIF (subtype = 'AT_ForceRowSecurity') THEN
      output = array_append(output, 'FORCE ROW SECURITY');
    ELSIF (subtype = 'AT_NoForceRowSecurity') THEN
      output = array_append(output, 'NO FORCE ROW SECURITY');
    ELSE 
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterTableCmd may need to implement more alter_table_type(s)';
    END IF;

    IF ( node->>'behavior' = 'DROP_CASCADE') THEN
      output = array_append(output, 'CASCADE');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_table_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  relkind text;
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
    relkind = node->>'relkind';
    output = array_append(output, 'ALTER');

    IF (relkind = 'OBJECT_TABLE' ) THEN 
      output = array_append(output, 'TABLE');

      -- MARKED AS backwards compat (RangeVar/no RangeVar)
      IF (node->'relation'->'RangeVar' IS NOT NULL) THEN 
        ninh = (node->'relation'->'RangeVar'->'inh')::bool;
      ELSE
        ninh = (node->'relation'->'inh')::bool;
      END IF;
      IF ( ninh IS FALSE OR ninh IS NULL ) THEN 
        output = array_append(output, 'ONLY');
      END IF;

    ELSEIF (relkind = 'OBJECT_TYPE') THEN 
      output = array_append(output, 'TYPE');
    ELSE 
      RAISE EXCEPTION 'BAD_EXPRESSION % %', 'AlterTableStmt (relkind impl)', relkind;
    END IF;

    IF ( (node->'missing_ok')::bool IS TRUE ) THEN 
      output = array_append(output, 'IF EXISTS');
    END IF;

    context = jsonb_set(context, '{alterType}', to_jsonb(relkind));

    output = array_append(output, deparser.range_var(node->'relation', context));
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
      output = array_append(output, deparser.alias(node->'alias'));
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
    IF ((node->'unique')::bool IS TRUE) THEN 
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
    output = array_append(output, deparser.range_var(node->'relation'));

    -- BTREE is default, don't need to explicitly put it there
    IF (node->'accessMethod' IS NOT NULL AND upper(node->>'accessMethod') != 'BTREE') THEN
      output = array_append(output, 'USING');
      output = array_append(output, upper(node->>'accessMethod'));
    END IF;

    IF (node->'indexParams' IS NOT NULL AND jsonb_array_length(node->'indexParams') > 0) THEN 
      output = array_append(output, deparser.parens(deparser.list(node->'indexParams')));
    END IF; 

    IF (node->'indexIncludingParams' IS NOT NULL AND jsonb_array_length(node->'indexIncludingParams') > 0) THEN 
      output = array_append(output, 'INCLUDE');
      output = array_append(output, deparser.parens(deparser.list(node->'indexIncludingParams')));
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
      output = array_append(output, deparser.range_var(node->'relation'));
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
  jointype text;
  jointxt text;
  wrapped text;
  is_natural bool = false;
BEGIN
    IF (node->'JoinExpr') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'JoinExpr (node)';
    END IF;

    IF (node->'JoinExpr'->'larg') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'JoinExpr (larg)';
    END IF;

    IF (node->'JoinExpr'->'jointype') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'JoinExpr (jointype)';
    END IF;

    node = node->'JoinExpr';

    output = array_append(output, deparser.expression(node->'larg'));

    IF (node->'isNatural' IS NOT NULL AND (node->'isNatural')::bool IS TRUE) THEN 
      output = array_append(output, 'NATURAL');
      is_natural = TRUE;
    END IF;

    jointype = node->>'jointype';
    IF (jointype = 'JOIN_INNER') THEN 
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
    ELSIF (jointype = 'JOIN_LEFT') THEN
        jointxt = 'LEFT OUTER JOIN';
    ELSIF (jointype = 'JOIN_FULL') THEN
        jointxt = 'FULL OUTER JOIN';
    ELSIF (jointype = 'JOIN_RIGHT') THEN
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
      wrapped = wrapped || ' ' || deparser.alias(node->'alias');
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
  subLinkType text;
BEGIN
    IF (node->'SubLink') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'SubLink';
    END IF;

    node = node->'SubLink';
    subLinkType = node->>'subLinkType';
    IF (subLinkType = 'EXISTS_SUBLINK') THEN
      output = array_append(output, format(
        'EXISTS (%s)', 
        deparser.expression(node->'subselect')
      ));
    ELSIF (subLinkType = 'ALL_SUBLINK') THEN
      output = array_append(output, format(
        '%s %s ALL (%s)',
        deparser.expression(node->'testexpr'),
        deparser.expression(node->'operName'->0),
        deparser.expression(node->'subselect')
      ));
    ELSIF (subLinkType = 'ANY_SUBLINK') THEN
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
    ELSIF (subLinkType = 'ROWCOMPARE_SUBLINK') THEN
      output = array_append(output, format(
        '%s %s (%s)',
        deparser.expression(node->'testexpr'),
        deparser.expression(node->'operName'->0),
        deparser.expression(node->'subselect')
      ));
    ELSIF (subLinkType = 'EXPR_SUBLINK') THEN
      output = array_append(output, format(
        '(%s)',
        deparser.expression(node->'subselect')
      ));
    ELSIF (subLinkType = 'ARRAY_SUBLINK') THEN
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
  event text;
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
    event = node->>'event';
    IF (event = 'CMD_SELECT') THEN
      output = array_append(output, 'SELECT');
    ELSIF (event = 'CMD_UPDATE') THEN 
      output = array_append(output, 'UPDATE');
    ELSIF (event = 'CMD_INSERT') THEN 
      output = array_append(output, 'INSERT');
    ELSIF (event = 'CMD_DELETE') THEN 
      output = array_append(output, 'DELETE');
    ELSE
      RAISE EXCEPTION 'event type not yet implemented for RuleStmt';
    END IF;

    -- relation

    output = array_append(output, 'TO');
    output = array_append(output, deparser.range_var(node->'relation', context));

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
  stmt_type text;
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
    stmt_type = node->>'stmt_type';

    output = array_append(output, 'CREATE');
    
    IF (stmt_type = 'ROLESTMT_ROLE') THEN 
      output = array_append(output, 'ROLE');
    ELSEIF (stmt_type = 'ROLESTMT_USER') THEN 
      output = array_append(output, 'USER');
    ELSEIF (stmt_type = 'ROLESTMT_GROUP') THEN 
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
          output = array_append(output, '''' || deparser.expression(option->'DefElem'->'arg') || '''' );
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

    -- MARKED AS backwar
          -- MARKED AS backwards compat (RangeVar/no RangeVar)ds compat (RangeVar/no RangeVar)
    IF (node->'relation'->'RangeVar' IS NOT NULL) THEN 
      relpersistence = node#>>'{relation, RangeVar, relpersistence}';
    ELSE
      relpersistence = node#>>'{relation, relpersistence}';
    END IF;

    IF (relpersistence = 't') THEN 
      output = array_append(output, 'CREATE');
    ELSE
      output = array_append(output, 'CREATE TABLE');
    END IF;

    output = array_append(output, deparser.range_var(node->'relation', context));
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
  kind text;
BEGIN
    IF (node->'TransactionStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'TransactionStmt';
    END IF;

    IF (node->'TransactionStmt'->'kind') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'TransactionStmt';
    END IF;

    node = node->'TransactionStmt';
    kind = node->>'kind';

    IF (kind = 'TRANS_STMT_BEGIN') THEN
      -- TODO implement other options
      output = array_append(output, 'BEGIN');
    ELSIF (kind = 'TRANS_STMT_START') THEN
      -- TODO implement other options
      output = array_append(output, 'START TRANSACTION');
    ELSIF (kind = 'TRANS_STMT_COMMIT') THEN
      output = array_append(output, 'COMMIT');
    ELSIF (kind = 'TRANS_STMT_ROLLBACK') THEN
      output = array_append(output, 'ROLLBACK');
    ELSIF (kind = 'TRANS_STMT_SAVEPOINT') THEN
      output = array_append(output, 'SAVEPOINT');
      output = array_append(output, deparser.expression(node->'options'->0->'DefElem'->'arg'));
    ELSIF (kind = 'TRANS_STMT_RELEASE') THEN
      output = array_append(output, 'RELEASE SAVEPOINT');
      output = array_append(output, deparser.expression(node->'options'->0->'DefElem'->'arg'));
    ELSIF (kind = 'TRANS_STMT_ROLLBACK_TO') THEN
      output = array_append(output, 'ROLLBACK TO');
      output = array_append(output, deparser.expression(node->'options'->0->'DefElem'->'arg'));
    ELSIF (kind = 'TRANS_STMT_PREPARE') THEN
      output = array_append(output, 'PREPARE TRANSACTION');
      output = array_append(output, '''' || node->>'gid' || '''');
    ELSIF (kind = 'TRANS_STMT_COMMIT_PREPARED') THEN
      output = array_append(output, 'COMMIT PREPARED');
      output = array_append(output, '''' || node->>'gid' || '''');
    ELSIF (kind = 'TRANS_STMT_ROLLBACK_PREPARED') THEN
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
    output = array_append(output, deparser.range_var(node->'view', context));
    output = array_append(output, 'AS');
    output = array_append(output, deparser.expression(node->'query', context));
    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.sort_by ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  dir text;
  nulls text;
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

    dir = node->>'sortby_dir';
    IF (dir = 'SORTBY_DEFAULT') THEN 
      -- noop
    ELSIF (dir = 'SORTBY_ASC') THEN
      output = array_append(output, 'ASC');
    ELSIF (dir = 'SORTBY_DESC') THEN
      output = array_append(output, 'DESC');
    ELSIF (dir = 'SORTBY_USING') THEN
      output = array_append(output, 'USING');
      output = array_append(output, deparser.list(node->'useOp'));
    ELSE 
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'SortBy (enum)';
    END IF;

    IF (node->'sortby_nulls' IS NOT NULL) THEN
      nulls = node->>'sortby_nulls';
      IF (nulls = 'SORTBY_NULLS_DEFAULT') THEN 
        -- noop
      ELSIF (nulls = 'SORTBY_NULLS_FIRST') THEN
        output = array_append(output, 'NULLS FIRST');
      ELSIF (nulls = 'SORTBY_NULLS_LAST') THEN
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
        IF (item IS NULL OR item = '{}'::jsonb) THEN
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

    IF ( node->>'behavior' = 'DROP_CASCADE') THEN
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

    IF ( node->>'behavior' = 'DROP_CASCADE') THEN
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
  row_format text;
BEGIN
    IF (node->'RowExpr') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RowExpr';
    END IF;

    node = node->'RowExpr';
    row_format = node->>'row_format';
    IF (row_format = 'COERCE_IMPLICIT_CAST') THEN 
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
    IF (node->'IntoClause') IS NOT NULL THEN
      node = node->'IntoClause';
    END IF;
    RETURN deparser.range_var(node->'rel');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.rename_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  renameType text;
  relationType text;
  typObj jsonb;
BEGIN
    IF (node->'RenameStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RenameStmt';
    END IF;

    node = node->'RenameStmt';
    renameType = node->>'renameType';
    relationType = node->>'relationType';
    IF (
      renameType = 'OBJECT_FUNCTION' OR
      renameType = 'OBJECT_FOREIGN_TABLE' OR
      renameType = 'OBJECT_FDW' OR
      renameType = 'OBJECT_FOREIGN_SERVER'
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
    ELSEIF ( renameType = 'OBJECT_ATTRIBUTE' ) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, ast_utils.objtype_name(relationType) );
      IF ((node->'missing_ok')::bool is TRUE) THEN
        output = array_append(output, 'IF EXISTS');
      END IF;
      output = array_append(output, deparser.range_var(node->'relation'));
      output = array_append(output, 'RENAME');
      output = array_append(output, ast_utils.objtype_name(renameType) );
      output = array_append(output, quote_ident(node->>'subname'));
      output = array_append(output, 'TO');
      output = array_append(output, quote_ident(node->>'newname'));
    ELSEIF ( 
      renameType = 'OBJECT_DOMAIN' OR
      renameType = 'OBJECT_TYPE' 
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

    ELSEIF ( renameType = 'OBJECT_DOMCONSTRAINT' ) THEN

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
      output = array_append(output, deparser.range_var(node->'relation'));
      output = array_append(output, 'RENAME');
      IF (renameType = 'OBJECT_COLUMN') THEN 
        -- not necessary, but why not
        output = array_append(output, 'COLUMN');
      END IF;
      output = array_append(output, quote_ident(node->>'subname'));
      output = array_append(output, 'TO');
      output = array_append(output, quote_ident(node->>'newname'));

    END IF;

    IF ( node->>'behavior' = 'DROP_CASCADE') THEN
      output = array_append(output, 'CASCADE');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_owner_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  objectType text;
BEGIN
    IF (node->'AlterOwnerStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterOwnerStmt';
    END IF;

    node = node->'AlterOwnerStmt';
    objectType = node->>'objectType';

    output = array_append(output, 'ALTER');
    output = array_append(output, ast_utils.objtype_name(objectType) );
    IF (jsonb_typeof(node->'object') = 'array') THEN 
      output = array_append(output, deparser.list_quotes(node->'object', '.'));
    ELSE
      output = array_append(output, deparser.expression(node->'object'));
    END IF;
    output = array_append(output, 'OWNER');
    output = array_append(output, 'TO');
    output = array_append(output, deparser.role_spec(node->'newowner'));

    RETURN array_to_string(output, ' ');
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION deparser.alter_object_schema_stmt ( node jsonb, context jsonb DEFAULT '{}'::jsonb ) RETURNS text AS $EOFCODE$
DECLARE
  output text[];
  objectType text;
BEGIN
    IF (node->'AlterObjectSchemaStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'AlterObjectSchemaStmt';
    END IF;

    node = node->'AlterObjectSchemaStmt';
    objectType = node->>'objectType';
    IF ( objectType = 'OBJECT_TABLE' ) THEN
      output = array_append(output, 'ALTER');
      output = array_append(output, ast_utils.objtype_name(objectType) );
      IF ( (node->'missing_ok')::bool IS TRUE ) THEN 
        output = array_append(output, 'IF EXISTS');
      END IF;
      output = array_append(output, deparser.range_var(node->'relation'));
      output = array_append(output, 'SET SCHEMA');
      output = array_append(output, quote_ident(node->>'newschema'));
    ELSE
      output = array_append(output, 'ALTER');
      output = array_append(output, ast_utils.objtype_name(objectType) );
      IF ( (node->'missing_ok')::bool IS TRUE ) THEN 
        output = array_append(output, 'IF EXISTS');
      END IF;
      
      IF (jsonb_typeof(node->'object') = 'array') THEN 
        output = array_append(output, deparser.list_quotes(node->'object', '.'));
      ELSE 
        output = array_append(output, deparser.expression(node->'object'));
      END IF;

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
  values text[];
  pvalues text[];
  value text;
  op text;
  valueSet jsonb;
  valueArr text[];
BEGIN
    IF (node->'SelectStmt') IS NOT NULL THEN
      node = node->'SelectStmt';
    END IF;

    IF (node->'op') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'SelectStmt';
    END IF;

    IF (node->'withClause') IS NOT NULL THEN 
      output = array_append(output, deparser.with_clause(node->'withClause', context));
    END IF;

    op = node->>'op';

    IF (op = 'SETOP_NONE') THEN 
       IF (node->'valuesLists') IS NULL THEN 
        output = array_append(output, 'SELECT');
       END IF;
    ELSE 
        output = array_append(output, '(');
        output = array_append(output, deparser.select_stmt(node->'larg', context));
        output = array_append(output, ')');

        IF (op = 'SETOP_NONE') THEN 
          output = array_append(output, 'NONE');
        ELSEIF (op = 'SETOP_UNION') THEN 
          output = array_append(output, 'UNION');
        ELSEIF (op = 'SETOP_INTERSECT') THEN 
          output = array_append(output, 'INTERSECT');
        ELSEIF (op = 'SETOP_EXCEPT') THEN 
          output = array_append(output, 'EXCEPT');
        ELSE
          RAISE EXCEPTION 'BAD_EXPRESSION %', 'SelectStmt (op)';
        END IF;
        
        -- all
        IF (node->'all') IS NOT NULL THEN
          output = array_append(output, 'ALL');
        END IF;        

        -- rarg
        output = array_append(output, '(');
        output = array_append(output, deparser.select_stmt(node->'rarg', context));
        output = array_append(output, ')');
    END IF;

    -- distinct
    IF (node->'distinctClause') IS NOT NULL THEN 
      IF (node->'distinctClause'->0 IS NOT NULL) THEN 
        IF (
           jsonb_typeof(node->'distinctClause'->0) = 'null' 
           OR 
           node->'distinctClause'->0 = '{}'::jsonb
        ) THEN 
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
      output = array_append(output, deparser.into_clause(node->'intoClause', context));
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
  strength text;
BEGIN
    IF (node->'LockingClause') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'LockingClause';
    END IF;

    IF (node->'LockingClause'->'strength') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'LockingClause';
    END IF;

    node = node->'LockingClause';
    strength = node->>'strength';
    IF (strength = 'LCS_NONE') THEN 
      output = array_append(output, 'NONE');
    ELSIF (strength = 'LCS_FORKEYSHARE') THEN
      output = array_append(output, 'FOR KEY SHARE');
    ELSIF (strength = 'LCS_FORSHARE') THEN
      output = array_append(output, 'FOR SHARE');
    ELSIF (strength = 'LCS_FORNOKEYUPDATE') THEN
      output = array_append(output, 'FOR NO KEY UPDATE');
    ELSIF (strength = 'LCS_FORUPDATE') THEN
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
  op text;
  output text[];
BEGIN
    IF (node->'MinMaxExpr') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'MinMaxExpr';
    END IF;

    IF (node->'MinMaxExpr'->'op') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'MinMaxExpr';
    END IF;

    node = node->'MinMaxExpr';
    op = node->>'op';
    IF (op = 'IS_GREATEST') THEN 
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
  nulltesttype text;
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
    nulltesttype = node->>'nulltesttype';

    output = array_append(output, deparser.expression(node->'arg'));
    IF (nulltesttype = 'IS_NULL') THEN 
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
  objtype text;
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
    objtype = node->>'removeType';
    output = array_append(output, ast_utils.objtype_name(objtype));
    
    IF (node->'missing_ok' IS NOT NULL AND (node->'missing_ok')::bool IS TRUE) THEN 
      output = array_append(output, 'IF EXISTS');
    END IF;

    
    FOR obj IN SELECT * FROM jsonb_array_elements(node->'objects')
    LOOP
      IF ( 
        objtype = 'OBJECT_POLICY'
        OR objtype = 'OBJECT_RULE'
        OR objtype = 'OBJECT_TRIGGER'
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
      ELSEIF (objtype = 'OBJECT_CAST') THEN 
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
    IF (node->>'behavior' = 'DROP_CASCADE') THEN 
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
    IF (node->'InferClause') IS NOT NULL THEN
      node = node->'InferClause';
    END IF;


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
  action text;
BEGIN
    IF (node->'OnConflictClause') IS NOT NULL THEN
      node = node->'OnConflictClause';
    END IF;

    IF (node->'infer') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'OnConflictClause';
    END IF;


    output = array_append(output, 'ON CONFLICT');

    IF (node->'infer' IS NOT NULL) THEN
      output = array_append(output, deparser.infer_clause(node->'infer'));
    END IF;

    action = node->>'action';
    IF (action = 'ONCONFLICT_NOTHING') THEN 
      output = array_append(output, 'DO NOTHING');
    ELSIF (action = 'ONCONFLICT_UPDATE') THEN 
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
        IF (param->'FunctionParameter'->>'mode' = ANY(ARRAY['FUNC_PARAM_VARIADIC', 'FUNC_PARAM_OUT', 'FUNC_PARAM_INOUT', 'FUNC_PARAM_IN'])) THEN
          params = array_append(params, param);
        ELSEIF (param->'FunctionParameter'->>'mode' = 'FUNC_PARAM_TABLE') THEN
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
      output = array_append(output, deparser.type_name(node->'returnType'));
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

    IF (node->>'mode' = 'FUNC_PARAM_VARIADIC') THEN
      output = array_append(output, 'VARIADIC');
    END IF;

    IF (node->>'mode' = 'FUNC_PARAM_OUT') THEN
      output = array_append(output, 'OUT');
    END IF;

    IF (node->>'mode' = 'FUNC_PARAM_INOUT') THEN
      output = array_append(output, 'INOUT');
    END IF;

    output = array_append(output, quote_ident(node->>'name'));
    output = array_append(output, deparser.type_name(node->'argType'));

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
  ELSEIF (expr->>'AlterPolicyStmt') IS NOT NULL THEN
    RETURN deparser.alter_policy_stmt(expr, context);
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

CREATE FUNCTION ast_helpers.create_insert ( v_schema text, v_table text, v_cols text[], v_values jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
  i int;
  cols jsonb[] = ARRAY[]::jsonb[];
BEGIN

  -- cols
  FOR i IN 1 .. cardinality(v_cols) LOOP
    cols = array_append(cols, ast.res_target(
      v_name := v_cols[i]
    ));
  END LOOP;

  ast_expr = ast.insert_stmt(
    v_relation := ast_helpers.range_var(
      v_schemaname := v_schema,
      v_relname := v_table
    ),
    v_cols := to_jsonb(cols),
    v_selectStmt := ast.select_stmt(
      v_valuesLists := v_values,
      v_op := 'SETOP_NONE'
    ),
    v_override := 'OVERRIDING_NOT_SET'
  );

  RETURN ast.raw_stmt (
    v_stmt := ast_expr,
    v_stmt_len := 1
  );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.create_fixture ( v_schema text, v_table text, v_cols text[], v_values jsonb ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
  i int;
  j int;
  cols jsonb[];
  
  records jsonb;
  recordArray jsonb;
  node jsonb;

  col_typeof text;
  col_type text;
  col_val text;
BEGIN

  -- cols
  FOR i IN 1 .. cardinality(v_cols) LOOP
    cols = array_append(cols, ast.res_target(
      v_name := v_cols[i]
    ));
  END LOOP;

  records = '[]';
  FOR i IN 0 .. jsonb_array_length(v_values)-1 LOOP
    recordArray = '[]';
    FOR j IN 0 .. jsonb_array_length(v_values->i)-1 LOOP
      col_type = v_values->i->j->>'type';
      col_typeof = jsonb_typeof(v_values->i->j->'value');
      col_val = v_values->i->j->>'value';

      IF (col_typeof = 'null') THEN 
        node = ast.null();
      ELSIF (col_type = 'int') THEN 
        node = ast.a_const( v_val := ast.integer( (col_val)::int ) );
      ELSIF (col_type = 'float') THEN 
        node = ast.a_const( v_val := ast.float( col_val ) );
      ELSIF (col_type = 'text') THEN 
        node = ast.a_const( v_val := ast.string( col_val ) );
      ELSIF (col_type = 'uuid') THEN 
        node = ast.a_const( v_val := ast.string( col_val ) );
      ELSIF (col_type = 'bool') THEN 
        IF (col_val)::bool IS TRUE THEN 
          node = ast.string( 'TRUE' );
        ELSE 
          node = ast.string( 'FALSE' );
        END IF;
      ELSIF (col_type = 'jsonb' OR col_type = 'json') THEN 
        node = ast.type_cast(
          v_arg := ast.a_const(
             ast.string(
               col_val
             )
          ),
          v_typeName := ast.type_name(
            v_names := ast_helpers.array_of_strings(col_type),
            v_typemod := -1
          )
        );
      ELSE
        RAISE EXCEPTION 'MISSING_FIXTURE_TYPE';
      END IF;
      recordArray = recordArray || to_jsonb(ARRAY[ node ]);
    END LOOP;
    records = records || to_jsonb(ARRAY[recordArray]);
  END LOOP;

  ast_expr = ast.insert_stmt(
    v_relation := ast_helpers.range_var(
      v_schemaname := v_schema,
      v_relname := v_table
    ),
    v_cols := to_jsonb(cols),
    v_selectStmt := ast.select_stmt(
      v_valuesLists := records,
      v_op := 'SETOP_NONE'
    ),
    v_override := 'OVERRIDING_NOT_SET'
  );

  RETURN ast.raw_stmt (
    v_stmt := ast_expr,
    v_stmt_len := 1
  );
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.rls_membership_type_select ( v_schema_name text, v_table_name text, v_membership_type_name text ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN

  ast_expr = ast.select_stmt(
    v_op := 'SETOP_NONE',
    v_targetList := to_jsonb(ARRAY[
        ast.res_target(
            v_val := ast_helpers.col('mt', 'id')
        )
    ]),
    v_fromClause := to_jsonb(ARRAY[
        ast_helpers.range_var(
            v_schemaname := v_schema_name,
            v_relname := v_table_name,
            v_alias := ast.alias(
                v_aliasname := 'mt'
            )
        )
    ]),
    v_whereClause := ast_helpers.eq(
        v_lexpr := ast_helpers.col('mt', 'name'),
        v_rexpr := ast.a_const(
            v_val := ast.string(v_membership_type_name)
        )
    )
  );

  RETURN ast_expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.rls_policy_permission_mask_select ( v_schema_name text, v_function_name text, v_permission text ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN

  ast_expr = ast.select_stmt(
    v_op := 'SETOP_NONE',
    v_targetList := to_jsonb(ARRAY[
        ast.res_target(
            v_val := ast.func_call (
              v_funcname := ast_helpers.array_of_strings(v_schema_name, v_function_name),
              v_args := to_jsonb(ARRAY[
                ast.type_cast(
                  v_arg := ast.a_array_expr(
                    v_elements := to_jsonb(ARRAY[
                      -- each permission goes here... maybe make an array
                      ast.a_const(
                        ast.string(v_permission)
                      )
                    ])
                  ),
                  v_typeName := ast.type_name(
                    v_names := ast_helpers.array_of_strings('citext'),
                    v_typemod := -1,
                    v_arrayBounds := to_jsonb(ARRAY[
                      ast.integer(-1)
                    ])
                  )
                )
              ])
            )
        )
    ])
  );

  RETURN ast_expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.rls_policy_permission_mask_select ( v_schema_name text, v_function_name text, v_permissions text[] ) RETURNS jsonb AS $EOFCODE$
DECLARE
  nodes jsonb[];
  i int;

  ast_expr jsonb;
BEGIN

  FOR i IN SELECT * FROM generate_subscripts(v_permissions, 1) g(i)
  LOOP
    nodes = array_append(nodes, 
        ast.a_const(
          ast.string(v_permissions[i])
        )
     );
  END LOOP;


  ast_expr = ast.select_stmt(
    v_op := 'SETOP_NONE',
    v_targetList := to_jsonb(ARRAY[
        ast.res_target(
            v_val := ast.func_call (
              v_funcname := ast_helpers.array_of_strings(v_schema_name, v_function_name),
              v_args := to_jsonb(ARRAY[
                ast.type_cast(
                  v_arg := ast.a_array_expr(
                    v_elements := to_jsonb(nodes)
                  ),
                  v_typeName := ast.type_name(
                    v_names := ast_helpers.array_of_strings('citext'),
                    v_typemod := -1,
                    v_arrayBounds := to_jsonb(ARRAY[
                      ast.integer(-1)
                    ])
                  )
                )
              ])
            )
        )
    ])
  );

  RETURN ast_expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_perm_bitlen ( v_schema_name text, v_table_name text, v_field_name text, v_bitlen int ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.alter_table_stmt(
    v_relkind := 'OBJECT_TABLE',
    v_relation := ast_helpers.range_var(
      v_schemaname := v_schema_name,
      v_relname := v_table_name
    ),
    v_cmds := to_jsonb(ARRAY[
      ast.alter_table_cmd(
        v_subtype := 'AT_AlterColumnType',
        v_name := v_field_name,
        v_def := ast.column_def(
          v_typeName := ast.type_name(
            v_names := to_jsonb(ARRAY[
              ast.string('pg_catalog'),
              ast.string('bit')
            ]),
            v_typmods := to_jsonb(ARRAY[
              ast.a_const( v_val := ast.integer(v_bitlen))
            ]),
            v_typemod := -1
          ),
          v_raw_default := ast.type_cast (
            v_arg := ast.func_call(
              v_funcname := to_jsonb(ARRAY[
                ast.string('utils'),
                ast.string('bitmask_pad')
              ]),
              v_args := to_jsonb(ARRAY[
                ast_helpers.col(v_field_name),
                ast.a_const(
                  v_val := ast.integer( v_bitlen )
                ),
                ast.a_const(
                  v_val := ast.string( '0' )
                )
              ])
            ),
            v_typeName := ast.type_name(
              v_names := to_jsonb(ARRAY[
                ast.string('pg_catalog'),
                ast.string('bit')
              ]),
              v_typmods := to_jsonb(ARRAY[
                ast.a_const( v_val := ast.integer(v_bitlen))
              ]),
              v_typemod := -1
            )
          )
        ),
        v_behavior := 'DROP_RESTRICT'
      )
    ])
  );
  RETURN ast_expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION ast_helpers.alter_table_perm_bitlen_default ( v_schema_name text, v_table_name text, v_field_name text, v_bitlen int ) RETURNS jsonb AS $EOFCODE$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.alter_table_stmt(
    v_relkind := 'OBJECT_TABLE',
    v_relation := ast_helpers.range_var(
      v_schemaname := v_schema_name,
      v_relname := v_table_name
    ),
    v_cmds := to_jsonb(ARRAY[
      ast.alter_table_cmd(
        v_subtype := 'AT_ColumnDefault',
        v_name := v_field_name,
        v_def := ast.type_cast(
          v_arg := ast.func_call(
            v_funcname := ast_helpers.array_of_strings('lpad'),
            v_args := to_jsonb(ARRAY[
              ast.a_const(
                v_val := ast.string('')
              ),
              ast.a_const(
                v_val := ast.integer(v_bitlen)
              ),
              ast.a_const(
                v_val := ast.string('0')
              )
            ])
          ),
          v_typeName := ast.type_name(
            v_names := ast_helpers.array_of_strings('pg_catalog', 'bit'),
            v_typmods := to_jsonb(ARRAY[
              ast.a_const(ast.integer(v_bitlen))
            ]),
            v_typemod := -1
          )
        ),
        v_behavior := 'DROP_RESTRICT'
      )
    ])
  );
  RETURN ast_expr;
END;
$EOFCODE$ LANGUAGE plpgsql IMMUTABLE;