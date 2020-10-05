-- Deploy schemas/deparser/procedures/deparse to pg

-- requires: schemas/deparser/schema
-- requires: schemas/ast_utils/procedures/utils

BEGIN;

CREATE FUNCTION deparser.parens (
  str text
) returns text as $$
	select '(' || str || ')';
$$  
LANGUAGE 'sql';

CREATE FUNCTION deparser.compact (
  vvalues text[]
) returns text[] as $$
DECLARE
  value text;
  filtered text[];
BEGIN
  FOREACH value IN array vvalues
    LOOP
        IF (value IS NOT NULL AND character_length (trim(value)) > 0) THEN 
          filtered = array_append(filtered, value);
        END IF;
    END LOOP;
  RETURN filtered;
END;
$$  
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.deparse_interval (
  node jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

-- TODO improve this
CREATE FUNCTION deparser.get_pgtype (
  typ text,
  typemods text
) returns text as $$
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
$$
LANGUAGE 'sql';

CREATE FUNCTION deparser.parse_type (
  names jsonb,
  typemods text
) returns text as $$
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
      RETURN deparser.quoted_name(names) || deparser.parens(typemods);
    ELSE
      RETURN deparser.quoted_name(names);
    END IF;
  END IF;

  typ = deparser.get_pgtype(typ, typemods);
  IF (typemods IS NOT NULL AND character_length(typemods) > 0) THEN 
    RETURN typ || deparser.parens(typemods);
  ELSE
    RETURN typ;
  END IF;

END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.type_name (
  node jsonb,
  context text default null
) returns text as $$
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

CREATE FUNCTION deparser.column_def(
  node jsonb,
  context text default null
) returns text as $$
DECLARE
  output text[];
BEGIN

  IF (node->'ColumnDef') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'ColumnDef';
  END IF;

  IF (node->'ColumnDef'->'colname') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'ColumnDef';
  END IF;

  IF (node->'ColumnDef'->'typeName') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'ColumnDef';
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
      IF (arg->'String' IS NOT NULL) THEN
        str = '''' || deparser.expression(arg) || '''';
      ELSE
        str = deparser.expression(arg);
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
  ELSIF (context = 'enum') THEN
    RETURN '''' || txt || '''';
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

CREATE FUNCTION deparser.list_quotes(
  node jsonb,
  delimiter text default ', ',
  context text default null
) returns text as $$
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

CREATE FUNCTION deparser.insert_stmt(
  node jsonb,
  context text default null
) returns text as $$
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

    RETURN array_to_string(output, ' ');

END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.create_schema_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.exclusion_constraint(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.reference_constraint(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.constraint_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.create_seq_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.constraint(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.def_elem(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.comment_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.alter_default_privileges_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.case_expr(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.case_when(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.variable_set_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.alias(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.range_subselect(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.delete_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.quoted_name(
  node jsonb,
  context text default null
) returns text as $$
DECLARE
  output text[];
  item text;
BEGIN
    -- NOTE: assumes array of names passed in 
    FOREACH item IN array deparser.expressions_array(node)
    LOOP
      output = array_append(output, quote_ident(item));
    END LOOP;
    RETURN array_to_string(output, '.');
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.create_domain_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.grant_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.composite_type_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
      deparser.list(node->'coldeflist', E',\n')
    ));

    RETURN array_to_string(output, ' ');
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.index_elem(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.create_enum_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.alter_table_cmd(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.alter_table_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.range_function(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.index_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.update_stmt(
  node jsonb,
  context text default null
) returns text as $$
DECLARE
  output text[];
  targets text[];
  rets text[];
  name text;
  item jsonb;
BEGIN
    IF (node->'UpdateStmt') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'UpdateStmt';
    END IF;

    IF (node->'UpdateStmt'->'relation') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'UpdateStmt';
    END IF;

    node = node->'UpdateStmt';
  
    output = array_append(output, 'UPDATE');
    output = array_append(output, deparser.expression(node->'relation'));
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
        output = array_append(output, deparser.expression(node->'targetList'->0->'val'));
      ELSE
        output = array_append(output, deparser.list(node->'targetList'));
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

      output = array_append(output, array_to_string(rets, ', '));

    END IF;

    RETURN array_to_string(output, ' ');
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.param_ref(
  node jsonb,
  context text default null
) returns text as $$
BEGIN
    IF (node->'ParamRef') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'ParamRef';
    END IF;

    node = node->'ParamRef';

    IF (node->'number' IS NOT NULL AND (node->'number')::int > 0) THEN 
      RETURN '$' || node->>'number';
    END IF;

    RETURN '?';
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.join_expr(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.a_indirection(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.sub_link(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.a_star(
  node jsonb,
  context text default null
) returns text as $$
BEGIN
    IF (node->'A_Star') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Star';
    END IF;
    RETURN '*';
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.integer(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.access_priv(
  node jsonb,
  context text default null
) returns text as $$
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

CREATE FUNCTION deparser.rule_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
    IF (node->'rulename' = '_RETURN') THEN
      -- special rules
      output = array_append(output, '"_RETURN"');
    ELSE
      output = array_append(output, e.rulename);
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
    output = array_append(output, deparse.expression(node->'relation', context));

    IF (node->'instead') IS NOT NULL THEN 
      output = array_append(output, 'DO');
      output = array_append(output, 'INSTEAD');
    END IF;

    IF (node->'whereClause') IS NOT NULL THEN 
      output = array_append(output, 'WHERE');
      output = array_append(output, deparse.expression(node->'whereClause', context));
      output = array_append(output, 'DO');
    END IF;

    IF (node->'actions' IS NOT NULL AND jsonb_array_length(node->'actions') > 0) THEN 
      output = array_append(output, deparse.expression(node->'actions'->0, context));
    ELSE
      output = array_append(output, 'NOTHING');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.create_role_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.create_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.transaction_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.view_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.sort_by(
  node jsonb,
  context text default null
) returns text as $$
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

    -- NOTE uses ENUMS
    dir = (node->'sortby_dir')::int;
    IF (dir = 0) THEN 
      output = array_append(output, 'ASC');
    ELSIF (dir = 1) THEN
      output = array_append(output, 'DESC');
    ELSIF (dir = 2) THEN
      output = array_append(output, 'USING');
      output = array_append(output, deparser.list(node->'useOp'));
    ELSIF (dir = 3) THEN
      -- noop
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.res_target(
  node jsonb,
  context text default null
) returns text as $$
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
        deparser.expression(node->'val'),
        quote_ident(node->>'name')
      ]), ' AS '));
    ELSIF (context = 'update') THEN 
      output = array_append(output, array_to_string(deparser.compact(ARRAY[
        quote_ident(node->>'name'),
        deparser.expression(node->'val')
      ]), ' = '));
    ELSE
      output = array_append(output, quote_ident(node->>'name'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$$
LANGUAGE 'plpgsql';

-- TODO never FULLY IMPLEMENTED
CREATE FUNCTION deparser.alter_domain_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

-- TODO never FULLY IMPLEMENTED
CREATE FUNCTION deparser.alter_enum_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

-- TODO never FULLY TESTED
CREATE FUNCTION deparser.execute_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.row_expr(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.a_indices(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

-- TODO never FULLY IMPLEMENTED
CREATE FUNCTION deparser.rename_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
      output = array_append(output, node->'subname');
      output = array_append(output, 'TO');
      output = array_append(output, node->'newname');
    ELSE
      RAISE EXCEPTION 'BAD_EXPRESSION % type(%)', 'RenameStmt', node->>'renameType';
    END IF;

END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.select_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.grant_role_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.coalesce_expr(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.drop_stmt(
  node jsonb,
  context text default null
) returns text as $$
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
        quoted = array_append(quoted, deparser.quoted_name(obj));
      ELSE
        quoted = array_append(quoted, quote_ident(deparser.expression(obj)));
      END IF;
    END LOOP;

    output = array_append(output, array_to_string(quoted, ', '));

    -- behavior
    IF (node->'behavior' IS NOT NULL) THEN 
      -- TODO this is an integer, what does 1 vs 0 mean?
      output = array_append(output, 'CASCADE');
    END IF;

    RETURN array_to_string(output, ' ');
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.infer_clause(
  node jsonb,
  context text default null
) returns text as $$
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
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION deparser.on_conflict_clause(
  node jsonb,
  context text default null
) returns text as $$
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

  IF (expr->>'A_Const') IS NOT NULL THEN
    RETURN deparser.a_const(expr, context);
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
  ELSEIF (expr->>'BoolExpr') IS NOT NULL THEN
    RETURN deparser.bool_expr(expr, context);
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
  ELSEIF (expr->>'CommentStmt') IS NOT NULL THEN
    RETURN deparser.comment_stmt(expr, context);
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
  ELSEIF (expr->>'DefElem') IS NOT NULL THEN
    RETURN deparser.def_elem(expr, context);
  ELSEIF (expr->>'DeleteStmt') IS NOT NULL THEN
    RETURN deparser.delete_stmt(expr, context);
  ELSEIF (expr->>'DropStmt') IS NOT NULL THEN
    RETURN deparser.drop_stmt(expr, context);
  ELSEIF (expr->>'ExecuteStmt') IS NOT NULL THEN
    RETURN deparser.execute_stmt(expr, context);
  ELSEIF (expr->>'FuncCall') IS NOT NULL THEN
    RETURN deparser.func_call(expr, context);
  ELSEIF (expr->>'FunctionParameter') IS NOT NULL THEN
    RETURN deparser.function_parameter(expr, context);
  ELSEIF (expr->>'GrantRoleStmt') IS NOT NULL THEN
    RETURN deparser.grant_role_stmt(expr, context);
  ELSEIF (expr->>'GrantStmt') IS NOT NULL THEN
    RETURN deparser.grant_stmt(expr, context);
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
  ELSEIF (expr->>'JoinExpr') IS NOT NULL THEN
    RETURN deparser.jointype(expr, context);
  ELSEIF (expr->>'Null') IS NOT NULL THEN
    RETURN 'NULL';
  ELSEIF (expr->>'OnConflictClause') IS NOT NULL THEN
    RETURN deparser.on_conflict_clause(expr, context);
  ELSEIF (expr->>'ParamRef') IS NOT NULL THEN
    RETURN deparser.param_ref(expr, context);
  ELSEIF (expr->>'RangeFunction') IS NOT NULL THEN
    RETURN deparser.range_function(expr, context);
  ELSEIF (expr->>'RangeSubselect') IS NOT NULL THEN
    RETURN deparser.range_subselect(expr->'RawStmt'->'stmt');
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
  ELSEIF (expr->>'SelectStmt') IS NOT NULL THEN
    RETURN deparser.select_stmt(expr, context);
  ELSEIF (expr->>'SortBy') IS NOT NULL THEN
    RETURN deparser.sort_by(expr, context);
  ELSEIF (expr->>'String') IS NOT NULL THEN
    RETURN deparser.str(expr, context);
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
  ELSEIF (expr->>'VariableSetStmt') IS NOT NULL THEN
    RETURN deparser.variable_set_stmt(expr, context);
  ELSEIF (expr->>'ViewStmt') IS NOT NULL THEN
    RETURN deparser.view_stmt(expr, context);
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

CREATE FUNCTION deparser.deparse_query (ast jsonb)
    RETURNS text
    AS $$
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
$$
LANGUAGE 'plpgsql'
IMMUTABLE STRICT;

COMMIT;
