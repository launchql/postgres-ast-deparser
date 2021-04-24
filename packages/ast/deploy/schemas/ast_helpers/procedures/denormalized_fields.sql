-- Deploy schemas/ast_helpers/procedures/denormalized_fields to pg

-- requires: schemas/ast_helpers/schema
-- requires: schemas/deparser/procedures/deparse
-- requires: schemas/ast_helpers/procedures/helpers

BEGIN;

CREATE FUNCTION ast_helpers.denormalized_fields_trigger_body(
  v_schema_name text,
  v_table_name text,
  v_table_field text,
  v_set_fields text[],

  v_ref_field text,
  v_ref_fields text[]
)
    RETURNS text
    AS $$
DECLARE
  ast_expr jsonb;
  body text;
  ref_fields jsonb[];
  set_fields jsonb[];
BEGIN

  FOR i IN 1 .. cardinality(v_set_fields) LOOP
    set_fields = array_append(set_fields, 
      ast_helpers.col('new', v_set_fields[i])
    );
  END LOOP;

  FOR i IN 1 .. cardinality(v_ref_fields) LOOP
    ref_fields = array_append(ref_fields, ast.res_target(
      v_val := ast_helpers.col('ref', v_ref_fields[i])
    ));
  END LOOP;

  ast_expr = ast.select_stmt(
      v_targetList := to_jsonb(ref_fields),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := v_schema_name,
              v_relname := v_table_name,
              v_alias := ast.alias(
                  v_aliasname := 'ref'
              )
          )
      ]),
      v_whereClause := ast_helpers.eq(
          ast_helpers.col('ref', v_ref_field),
          ast_helpers.col('new', v_table_field)
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
  deparser.list(to_jsonb(set_fields), E',\n')
  ));

  RETURN body;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

COMMIT;
