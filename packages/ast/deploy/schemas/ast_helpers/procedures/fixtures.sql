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
  cols jsonb[];
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
      v_op := 0
    ),
    v_override := 0
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
