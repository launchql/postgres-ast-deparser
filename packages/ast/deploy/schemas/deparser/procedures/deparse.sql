-- Deploy schemas/deparser/procedures/deparse to pg

-- requires: schemas/deparser/schema
-- requires: schemas/ast_utils/procedures/utils
-- requires: schemas/ast_constants/procedures/constants 

BEGIN;

CREATE FUNCTION deparser.parens (
  str text
) returns text as $$
	select '(' || str || ')';
$$  
LANGUAGE 'sql';

CREATE FUNCTION deparser.compact (
  vvalues text[],
  usetrim boolean default false
) returns text[] as $$
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
$$  
LANGUAGE 'plpgsql' IMMUTABLE;

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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.get_pg_catalog_type (
  typ text,
  typemods text
) returns text as $$
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
$$
LANGUAGE 'sql';

CREATE FUNCTION deparser.parse_type (
  names jsonb,
  typemods text
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.type_name (
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.type_cast (
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.returning_list (
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.range_var (
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.create_extension_stmt (
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.raw_stmt (
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr_between(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr_between_sym(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr_not_between(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr_not_between_sym(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr_similar(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr_ilike(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr_like(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr_of(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr_in(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;


CREATE FUNCTION deparser.a_expr_nullif(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
DECLARE
  left_expr text;
  right_expr text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);

  RETURN format('NULLIF(%s, %s)', left_expr, right_expr);
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr_op(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr_op_any(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr_op_all(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr_distinct(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);
  RETURN format('%s IS DISTINCT FROM %s', left_expr, right_expr);
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr_not_distinct(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
DECLARE
  left_expr text;
  operator text;
  right_expr text;
BEGIN
  left_expr = deparser.expression(expr->'lexpr', context);
  right_expr = deparser.expression(expr->'rexpr', context);
  RETURN format('%s IS NOT DISTINCT FROM %s', left_expr, right_expr);
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_expr(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.bool_expr(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.column_ref(
  node jsonb,
  context jsonb default '{}'::jsonb
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

  RETURN deparser.list(node->'ColumnRef'->'fields', '.', jsonb_set(context, '{ColumnRef}', to_jsonb(TRUE)));
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.explain_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
BEGIN

  IF (node->'ExplainStmt') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'ExplainStmt';
  END IF;

  IF (node->'ExplainStmt'->'query') IS NULL THEN
    RAISE EXCEPTION 'BAD_EXPRESSION %', 'ExplainStmt';
  END IF;

  RETURN 'EXPLAIN' || ' ' || deparser.expression(node->'ExplainStmt'->'query');
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.collate_clause(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_array_expr(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.column_def(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.sql_value_function(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.common_table_expr(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.escape(
  txt text
) returns text as $$
BEGIN
  -- TODO isn't there a native function for this?
  txt = REPLACE(txt, '''', '''''' );
  return format('''%s''', txt);
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.bit_string(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_const(
  node jsonb,
  context jsonb default '{}'::jsonb
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
    RETURN deparser.escape(txt);
  END IF;

  RETURN txt;

END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.boolean_test(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.create_trigger_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.string(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.float(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
BEGIN
  IF (LEFT(node->'Float'->>'str', 1) = '-') THEN 
    RETURN deparser.parens(node->'Float'->>'str');
  END IF;
  RETURN node->'Float'->>'str';
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.list(
  node jsonb,
  delimiter text default ', ',
  context jsonb default '{}'::jsonb
) returns text as $$
DECLARE
  txt text;
BEGIN
  RETURN array_to_string(deparser.expressions_array(node, context), delimiter);
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.list_quotes(
  node jsonb,
  delimiter text default ', ',
  context jsonb default '{}'::jsonb
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
LANGUAGE 'plpgsql' IMMUTABLE;

-- CREATE FUNCTION deparser.rls_column_ref(
--   node jsonb,
--   context jsonb default '{}'::jsonb
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
-- LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.create_policy_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.alter_policy_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;


CREATE FUNCTION deparser.role_spec(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.insert_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.create_schema_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
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
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.exclusion_constraint(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.reference_constraint(
  node jsonb,
  context jsonb default '{}'::jsonb
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.constraint_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.create_seq_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
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
    output = array_append(output, deparser.range_var(node->'sequence'));

    IF (node->'options' IS NOT NULL AND jsonb_array_length(node->'options') > 0) THEN 
      output = array_append(output, deparser.list(node->'options', ' ', jsonb_set(context, '{sequence}', to_jsonb(TRUE))));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.do_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.create_table_as_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.constraint(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.def_elem(
  node jsonb,
  context jsonb default '{}'::jsonb
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.comment_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.alter_default_privileges_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.case_expr(
  node jsonb,
  context jsonb default '{}'::jsonb
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
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.case_when(
  node jsonb,
  context jsonb default '{}'::jsonb
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
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.with_clause(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.variable_set_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.variable_show_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.alias(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.range_subselect(
  node jsonb,
  context jsonb default '{}'::jsonb
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
      output = array_append(output, deparser.alias(node->'alias'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.delete_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
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
    output = array_append(output, deparser.range_var(node->'relation'));

    IF (node->'whereClause' IS NOT NULL) THEN 
      output = array_append(output, 'WHERE');
      output = array_append(output, deparser.expression(node->'whereClause'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.quoted_name(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.create_domain_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
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
    output = array_append(output, deparser.type_name(node->'typeName'));

    IF (node->'constraints' IS NOT NULL) THEN 
      output = array_append(output, deparser.list(node->'constraints'));
    END IF;

    RETURN array_to_string(output, ' ');
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.grant_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.composite_type_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
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
    output = array_append(output, deparser.range_var(node->'typevar', context));
    output = array_append(output, 'AS');
    output = array_append(output, deparser.parens(
      deparser.list(node->'coldeflist', E',')
    ));

    RETURN array_to_string(output, ' ');
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.index_elem(
  node jsonb,
  context jsonb default '{}'::jsonb
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
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.create_enum_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
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
    output = array_append(output, deparser.list(node->'vals', E',\n', jsonb_set(context, '{enum}', to_jsonb(TRUE))));
    output = array_append(output, E'\n)');

    RETURN array_to_string(output, ' ');
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.alter_table_cmd(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.alter_table_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.range_function(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.index_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.update_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.param_ref(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.set_to_default(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
BEGIN
    IF (node->'SetToDefault') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'SetToDefault';
    END IF;

    RETURN 'DEFAULT';
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.multi_assign_ref(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.join_expr(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_indirection(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.sub_link(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_star(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
BEGIN
    IF (node->'A_Star') IS NULL THEN
      RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Star';
    END IF;
    RETURN '*';
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.integer(
  node jsonb,
  context jsonb default '{}'::jsonb
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

    IF (ival < 0 AND context->'simple' IS NULL) THEN
      RETURN deparser.parens(node->>'ival');
    END IF;
    
    RETURN node->>'ival';
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.access_priv(
  node jsonb,
  context jsonb default '{}'::jsonb
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
      output = array_append(output, deparser.list_quotes(node->'cols', ', ', context));
      output = array_append(output, ')');
    END IF;

    RETURN array_to_string(output, ' ');

END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.grouping_func(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.grouping_set(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.func_call(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.rule_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.create_role_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.create_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.transaction_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.view_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
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
    output = array_append(output, deparser.range_var(node->'view', context));
    output = array_append(output, 'AS');
    output = array_append(output, deparser.expression(node->'query', context));
    RETURN array_to_string(output, ' ');
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.sort_by(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.res_target(
  node jsonb,
  context jsonb default '{}'::jsonb
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.object_with_args(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.alter_domain_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.alter_enum_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

-- TODO never FULLY TESTED
CREATE FUNCTION deparser.execute_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
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
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.row_expr(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.a_indices(
  node jsonb,
  context jsonb default '{}'::jsonb
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
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.into_clause(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
BEGIN
    IF (node->'IntoClause') IS NOT NULL THEN
      node = node->'IntoClause';
    END IF;
    RETURN deparser.range_var(node->'rel');
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.rename_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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

    ELSEIF ( renameType = 'OBJECT_SCHEMA' ) THEN

      output = array_append(output, 'ALTER');
      output = array_append(output, 'SCHEMA');
      IF ((node->'missing_ok')::bool is TRUE) THEN
        output = array_append(output, 'IF EXISTS');
      END IF;
      output = array_append(output, quote_ident(node->>'subname'));
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.alter_owner_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.alter_object_schema_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

-- TODO never FULLY IMPLEMENTED
CREATE FUNCTION deparser.vacuum_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.select_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.grant_role_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
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
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.locking_clause(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.coalesce_expr(
  node jsonb,
  context jsonb default '{}'::jsonb
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
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.min_max_expr(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.null_test(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.named_arg_expr(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.drop_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.infer_clause(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.on_conflict_clause(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.create_function_stmt(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.function_parameter(
  node jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

-- CREATE FUNCTION deparser.rls_func_ref(
--   node jsonb,
--   context jsonb default '{}'::jsonb
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
-- LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.expression(
  expr jsonb,
  context jsonb default '{}'::jsonb
) returns text as $$
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
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.expressions_array(
  node jsonb,
  context jsonb default '{}'::jsonb
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
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION deparser.deparse (ast jsonb)
    RETURNS text
    AS $$
BEGIN
	RETURN deparser.expression(ast);
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

COMMIT;
