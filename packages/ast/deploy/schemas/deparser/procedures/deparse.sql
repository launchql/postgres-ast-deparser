-- Deploy schemas/deparser/procedures/deparse to pg

-- requires: schemas/deparser/schema

BEGIN;

CREATE FUNCTION deparser.reserved (
  str text
) returns boolean as $$
	select exists( select 1 from pg_get_keywords() where catcode = 'R' AND word=str  );
$$  
LANGUAGE 'sql' SECURITY DEFINER;

CREATE FUNCTION deparser.type_name (
  node jsonb,
  context text default null
) returns text as $$
DECLARE
  txa text[] = ARRAY[]::text[];
  -- args text[] = ARRAY[]::text[];
BEGIN
    IF (node->'TypeName') IS NULL THEN  
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'TypeName';
    END IF;

    node = node->'TypeName';

    IF (node->'names') IS NULL THEN  
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'TypeName';
    END IF;

    -- TODO look deeper in pgsql-parser
    -- I greatly simplified this at risk of losing function

    -- IF (node->'setof') IS NOT NULL 
    --   txa = array_append(txa, 'SETOF');
    -- END IF;
    -- IF (node->'typmods') IS NOT NULL 
    --   args = deparser.expressions_array(node->'typmods');
    -- END IF;

    IF (node->'arrayBounds') IS NOT NULL THEN
      RETURN deparser.expression(node->'names'->0, context) || '[]';
    END IF;

    RETURN deparser.expression(node->'names'->0, context);

END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.type_cast (
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.range_var (
  node jsonb,
  context text default null
) returns text as $$
DECLARE
  output text[];
    
BEGIN
    IF (node->'RangeVar') IS NULL THEN  
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'RangeVar';
    END IF;

    node = node->'RangeVar';

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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.a_expr_between(
  expr jsonb,
  context text default null
) returns text as $$
DECLARE
  left_expr text;
  right_expr text;
  right_expr2 text;
BEGIN

  -- lexpr
  SELECT deparser.expression(expr->'lexpr', context) INTO left_expr;

  -- rexpr
  SELECT deparser.expression(expr->'rexpr'->0, context) INTO right_expr;
  SELECT deparser.expression(expr->'rexpr'->1, context) INTO right_expr2;

  IF ((expr->>'kind')::int = 11) THEN
    RETURN format('%s BETWEEN %s AND %s', left_expr, right_expr, right_expr2);
  ELSEIF ((expr->>'kind')::int = 12) THEN
    RETURN format('%s NOT BETWEEN %s AND %s', left_expr, right_expr, right_expr2);
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.a_expr_func(
  expr jsonb,
  context text default null
) returns text as $$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
  right_expr2 text;
BEGIN

  -- lexpr
  SELECT deparser.expression(expr->'lexpr', context) INTO left_expr;

  IF (expr->'name') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
  END IF;
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
        RETURN format('%s SIMILARYY TO %s', left_expr, right_expr);
      ELSE 
        SELECT deparser.expression(expr->'rexpr'->'FuncCall'->'args'->0, context) INTO right_expr;
        SELECT deparser.expression(expr->'rexpr'->'FuncCall'->'args'->1, context) INTO right_expr2;
        RETURN format('%s SIMILAR TO %s ESCAPE %s', left_expr, right_expr, right_expr2);
      END IF;
    END IF;
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
END;
$$
LANGUAGE 'plpgsql';


CREATE FUNCTION deparser.a_expr_rlist(
  expr jsonb,
  context text default null
) returns text as $$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN

  -- lexpr
  SELECT deparser.expression(expr->'lexpr', context)
    INTO left_expr;

  -- rexpr
  SELECT array_to_string(deparser.expressions_array(expr->'rexpr', context), ', ')
    INTO right_expr;

  IF (expr->'name') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
  END IF;
  operator = deparser.expression(expr->'name'->0, context);

  IF ((expr->>'kind')::int = 5) THEN
    -- AEXPR_OF
    IF (operator = '=') THEN
      RETURN format('%s %s ( %s )', left_expr, 'IS OF', right_expr);
    ELSE
      RETURN format('%s %s ( %s )', left_expr, 'IS NOT OF', right_expr);
    END IF;
  ELSEIF ((expr->>'kind')::int = 6) THEN
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

  RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
END;
$$
LANGUAGE 'plpgsql';


CREATE FUNCTION deparser.a_expr_normal(
  expr jsonb,
  context text default null
) returns text as $$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  -- lexpr
  SELECT deparser.expression(expr->'lexpr', context) INTO left_expr;

  -- rexpr
  SELECT deparser.expression(expr->'rexpr', context) INTO right_expr;

  IF ((expr->>'kind')::int = 3) THEN
    -- AEXPR_DISTINCT
    RETURN format('%s IS DISTINCT FROM %s', left_expr, right_expr);
  ELSEIF ((expr->>'kind')::int = 4) THEN
    -- AEXPR_NULLIF
    RETURN format('NULLIF(%s, %s)', left_expr, right_expr);
  END IF;

  IF (expr->'name') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
  END IF;
  operator = deparser.expression(expr->'name'->0);

  IF ((expr->>'kind')::int = 0) THEN
    -- AEXPR_OP
    RETURN array_to_string(ARRAY[left_expr, operator, right_expr], ' ');
  ELSEIF ((expr->>'kind')::int = 1) THEN
    -- AEXPR_OP_ANY
    RETURN format('%s %s ANY( %s )', left_expr, operator, right_expr);
  ELSEIF ((expr->>'kind')::int = 2) THEN
    -- AEXPR_OP_ALL
    RETURN format('%s %s ALL( %s )', left_expr, operator, right_expr);
  ELSEIF ((expr->>'kind')::int = 8) THEN
    -- AEXPR_ILIKE
    IF (operator = '!~~') THEN
      RETURN format('%s %s ( %s )', left_expr, 'NOT LIKE', right_expr);
    ELSE
      RETURN format('%s %s ( %s )', left_expr, 'LIKE', right_expr);
    END IF;
  ELSEIF ((expr->>'kind')::int = 9) THEN
    -- AEXPR_OP_ALL
    IF (operator = '!~~*') THEN
      RETURN format('%s %s ( %s )', left_expr, 'NOT ILIKE', right_expr);
    ELSE
      RETURN format('%s %s ( %s )', left_expr, 'ILIKE', right_expr);
    END IF;
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.a_expr(
  expr jsonb,
  context text default null
) returns text as $$
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

  IF ((expr->>'kind')::int = 0) THEN
    -- AEXPR_OP
    RETURN deparser.a_expr_normal(expr, context);
  ELSEIF ((expr->>'kind')::int = 1) THEN
    -- AEXPR_OP_ANY
    RETURN deparser.a_expr_normal(expr, context);
  ELSEIF ((expr->>'kind')::int = 2) THEN
    -- AEXPR_OP_ALL
    RETURN deparser.a_expr_normal(expr, context);
  ELSEIF ((expr->>'kind')::int = 3) THEN
    -- AEXPR_DISTINCT
    RETURN deparser.a_expr_normal(expr, context);
  ELSEIF ((expr->>'kind')::int = 4) THEN
    -- AEXPR_OP_ALL
    RETURN deparser.a_expr_normal(expr, context);
  ELSEIF ((expr->>'kind')::int = 5) THEN
    -- AEXPR_OF
    RETURN deparser.a_expr_rlist(expr, context);
  ELSEIF ((expr->>'kind')::int = 6) THEN
    -- AEXPR_IN
    RETURN deparser.a_expr_rlist(expr, context);
  ELSEIF ((expr->>'kind')::int = 7) THEN
    -- AEXPR_IN
    RETURN deparser.a_expr_rlist(expr, context);
  ELSEIF ((expr->>'kind')::int = 8) THEN
    -- AEXPR_LIKE
    RETURN deparser.a_expr_normal(expr, context);
  ELSEIF ((expr->>'kind')::int = 9) THEN
    -- AEXPR_ILIKE
    RETURN deparser.a_expr_normal(expr, context);
  ELSEIF ((expr->>'kind')::int = 10) THEN
    -- AEXPR_SIMILAR
    RETURN deparser.a_expr_func(expr, context);
  ELSEIF ((expr->>'kind')::int = 11) THEN
    -- AEXPR_BETWEEN
    RETURN deparser.a_expr_between(expr, context);
  ELSEIF ((expr->>'kind')::int = 12) THEN
    -- AEXPR_NOT_BETWEEN
    RETURN deparser.a_expr_between(expr, context);
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Expr';
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.bool_expr(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.column_ref(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.a_const(
  node jsonb,
  context text default null
) returns text as $$
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
    txt = REPLACE(txt, '''', '''''' );
    return format('''%s''', txt);
  END IF;

  RETURN txt;

END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.create_trigger_stmt(
  node jsonb,
  context text default null
) returns text as $$
DECLARE
  txt text;
  output text[];
  events text[];
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

  -- TODO handle transitionRels
  -- TODO handle deferrable
  -- https://github.com/pyramation/pgsql-parser/blob/master/src/deparser.js

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
      output = array_append(output, '(');
      output = array_append(output, deparser.expression(node->'whenClause', 'trigger'));
      output = array_append(output, ')');
      output = array_append(output, chr(10));
  END IF;

  -- exec
  output = array_append(output, 'EXECUTE PROCEDURE');
  output = array_append(output, deparser.list(node->'funcname', '.', 'identifiers'));

  output = array_append(output, '(');
  -- TODO add args
  output = array_append(output, ')');

  RETURN array_to_string(output, ' ');
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.str(
  expr jsonb,
  context text default null
) returns text as $$
DECLARE
  txt text = expr->'String'->>'str';
BEGIN
  IF (context = 'trigger') THEN
    IF (lower(txt) = 'new') THEN
      RETURN 'NEW';
    ELSIF (lower(txt) = 'old') THEN
      RETURN 'OLD';
    ELSE 
      RETURN quote_ident(txt);
    END IF;
  ELSIF (context = 'column') THEN
    RETURN quote_ident(txt);
  ELSIF (context = 'identifiers') THEN
    RETURN quote_ident(txt);
  END IF;
  RETURN txt;
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.list(
  node jsonb,
  delimiter text default ', ',
  context text default null
) returns text as $$
DECLARE
  txt text;
BEGIN
  RETURN array_to_string(deparser.expressions_array(node, context), delimiter);
END;
$$
LANGUAGE 'plpgsql';

-- CREATE FUNCTION deparser.rls_column_ref(
--   node jsonb,
--   context text default null
-- ) returns text as $$
-- DECLARE
--   txt text;
-- BEGIN
--   SELECT name FROM collections_public.field 
--     WHERE id = (node->'RlsColumnRef'->>'ref')::uuid
--     INTO txt;
--   RETURN txt;
-- END;
-- $$
-- LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.create_policy_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
      output = array_append(output, upper(node->>'cmd_name')); -- TODO needs quote?
    END IF;

    output = array_append(output, 'TO');
    output = array_append(output, deparser.list(node->'roles'));

    IF (node->'with_check') IS NOT NULL THEN
      output = array_append(output, 'WITH CHECK');
      output = array_append(output, '(');
      output = array_append(output, deparser.expression(node->'with_check')); -- TODO needs quote?
      output = array_append(output, ')');
    ELSE 
      output = array_append(output, 'USING');
      output = array_append(output, '(');
      output = array_append(output, deparser.expression(node->'qual'));
      output = array_append(output, ')');
    END IF;

    RETURN array_to_string(output, ' ');

END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.role_spec(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.func_call(
  node jsonb,
  context text default null
) returns text as $$
DECLARE
  fn_name text;
  fn_args text = '';
BEGIN
    IF (node->'FuncCall') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'FuncCall';
    END IF;

    IF (node->'FuncCall'->'funcname') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'FuncCall';
    END IF;

    fn_name = array_to_string(deparser.expressions_array(node->'FuncCall'->'funcname', context), '.');
    IF (node->'FuncCall'->'args') IS NOT NULL THEN
      IF (node->'FuncCall'->'args'->0) IS NOT NULL THEN
        fn_args = array_to_string(deparser.expressions_array(node->'FuncCall'->'args', context), ', ');
      END IF;
    END IF;

    RETURN array_to_string(ARRAY[fn_name, format( '(%s)', fn_args )], ' ');
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.create_function_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.function_parameter(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

-- CREATE FUNCTION deparser.rls_func_ref(
--   node jsonb,
--   context text default null
-- ) returns text as $$
-- DECLARE
--   txt text;
--   rls_func collections_public.rls_function;
--   rls_schema text;
--   fn_name text;
-- BEGIN
--     IF (node->'RlsFuncRef') IS NULL THEN
--       RAISE EXCEPTION 'BAD_EXPRESSION %', 'RlsFuncRef';
--     END IF;

--     IF (node->'RlsFuncRef'->>'ref') IS NULL THEN
--       RAISE EXCEPTION 'BAD_EXPRESSION %', 'RlsFuncRef';
--     END IF;

--     SELECT * FROM collections_public.rls_function 
--       WHERE id = (node->'RlsFuncRef'->>'ref')::uuid
--       INTO rls_func;
    
--     IF (NOT FOUND) THEN
--       RAISE EXCEPTION 'BAD_EXPRESSION %', 'RlsFuncRef';
--     END IF;

--     -- currently hard-coding these to PUBLIC since they are RLS funcs
--     rls_schema = deparser.get_schema_name_by_database_id_and_name
--       (rls_func.database_id, 'public');

--     fn_name = format('%I.%I', rls_schema, rls_func.name);

--     return fn_name;

--   RETURN txt;
-- END;
-- $$
-- LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.expression(
  expr jsonb,
  context text default null
) returns text as $$
BEGIN

  IF (expr->>'A_Expr') IS NOT NULL THEN
    RETURN deparser.a_expr(expr, context);
  ELSEIF (expr->>'BoolExpr') IS NOT NULL THEN
    RETURN deparser.bool_expr(expr, context);
  ELSEIF (expr->>'A_Const') IS NOT NULL THEN
    RETURN deparser.a_const(expr, context);
  ELSEIF (expr->>'FuncCall') IS NOT NULL THEN
    RETURN deparser.func_call(expr, context);
  ELSEIF (expr->>'ColumnRef') IS NOT NULL THEN      
    RETURN deparser.column_ref(expr, context);
  ELSEIF (expr->>'RangeVar') IS NOT NULL THEN      
    RETURN deparser.range_var(expr, context);
  ELSEIF (expr->>'FunctionParameter') IS NOT NULL THEN      
    RETURN deparser.function_parameter(expr, context);
  ELSEIF (expr->>'CreatePolicyStmt') IS NOT NULL THEN      
    RETURN deparser.create_policy_stmt(expr, context);
  ELSEIF (expr->>'RoleSpec') IS NOT NULL THEN      
    RETURN deparser.role_spec(expr, context);
  ELSEIF (expr->>'CreateFunctionStmt') IS NOT NULL THEN      
    RETURN deparser.create_function_stmt(expr, context);
  ELSEIF (expr->>'CreateTrigStmt') IS NOT NULL THEN      
    RETURN deparser.create_trigger_stmt(expr, context);
  ELSEIF (expr->>'TypeCast') IS NOT NULL THEN      
    RETURN deparser.type_cast(expr, context);
  ELSEIF (expr->>'TypeName') IS NOT NULL THEN      
    RETURN deparser.type_name(expr, context);
  -- ELSEIF (expr->>'RlsColumnRef') IS NOT NULL THEN      
  --   RETURN deparser.rls_column_ref(expr, context);
  -- ELSEIF (expr->>'RlsFuncRef') IS NOT NULL THEN      
  --   RETURN deparser.rls_func_ref(expr, context);
  ELSEIF (expr->>'String') IS NOT NULL THEN      
    RETURN deparser.str(expr, context);
  ELSEIF (expr->>'RawStmt') IS NOT NULL THEN      
    RETURN deparser.expression(expr->'RawStmt'->'stmt');
  ELSEIF (expr->>'Null') IS NOT NULL THEN      
    RETURN 'NULL';
  ELSE
    RAISE EXCEPTION 'UNSUPPORTED_EXPRESSION %', expr::text;
  END IF;

END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.expressions_array(
  node jsonb,
  context text default null
) returns text[] as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.deparse (ast jsonb)
    RETURNS text
    AS $$
BEGIN
	RETURN deparser.expression(ast);
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE STRICT;

COMMIT;
