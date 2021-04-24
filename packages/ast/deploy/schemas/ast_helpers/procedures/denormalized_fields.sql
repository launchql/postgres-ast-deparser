-- Deploy schemas/ast_helpers/procedures/denormalized_fields to pg

-- requires: schemas/ast_helpers/schema
-- requires: schemas/deparser/procedures/deparse
-- requires: schemas/ast_helpers/procedures/helpers

BEGIN;

CREATE FUNCTION ast_helpers.denormalized_fields_trigger_body(
  v_schema_name text,
  v_table_name text,
  v_parent_key text,
  v_ref_key text,

  v_sel_fields text[],
  v_into_fields text[]
)
    RETURNS text
    AS $$
DECLARE
  ast_expr jsonb;
  body text;
  sel_fields jsonb[];
  into_fields jsonb[];
BEGIN

  FOR i IN 1 .. cardinality(v_into_fields) LOOP
    into_fields = array_append(into_fields, 
      ast_helpers.col('new', v_into_fields[i])
    );
  END LOOP;

  FOR i IN 1 .. cardinality(v_sel_fields) LOOP
    sel_fields = array_append(sel_fields, ast.res_target(
      v_val := ast_helpers.col('parent', v_sel_fields[i])
    ));
  END LOOP;

  ast_expr = ast.select_stmt(
      v_targetList := to_jsonb(sel_fields),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := v_schema_name,
              v_relname := v_table_name,
              v_alias := ast.alias(
                  v_aliasname := 'parent'
              )
          )
      ]),
      v_whereClause := ast_helpers.eq(
          ast_helpers.col('new', v_ref_key),
          ast_helpers.col('parent', v_parent_key)
      ), 
      v_op := 'SETOP_NONE'
  );

  body = trim(format('
  BEGIN
  %1s
  INTO %2s;
  RETURN NEW;
  END;
  ', 
  deparser.deparse(ast_expr),
  deparser.list(to_jsonb(into_fields), E',\n')
  ));

  RETURN body;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

COMMIT;
