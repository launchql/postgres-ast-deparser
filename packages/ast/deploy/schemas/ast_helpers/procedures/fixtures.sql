-- Deploy schemas/ast_helpers/procedures/fixtures to pg

-- requires: schemas/ast_helpers/schema
-- requires: schemas/ast_helpers/procedures/helpers

BEGIN;

CREATE FUNCTION ast_helpers.create_insert(
  v_schema text,
  v_table text,
  v_cols text[],
  v_values jsonb
)
    RETURNS jsonb
    AS $$
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
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

-- this one takes a simple [ {type,value}, ... ]

CREATE FUNCTION ast_helpers.create_fixture(
  v_schema text,
  v_table text,
  v_cols text[],
  v_values jsonb
)
    RETURNS jsonb
    AS $$
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
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

COMMIT;
