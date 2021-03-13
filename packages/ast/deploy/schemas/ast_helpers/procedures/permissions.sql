-- Deploy schemas/ast_helpers/procedures/permissions to pg

-- requires: schemas/ast_helpers/schema
-- requires: schemas/ast_helpers/procedures/helpers
-- requires: schemas/ast_constants/procedures/constants 

BEGIN;

CREATE FUNCTION ast_helpers.alter_perm_table_bitlen (
  v_schema_name text,
  v_table_name text,
  v_field_name text,
  v_bitlen int
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.alter_table_stmt(
    v_relkind := ast_constants.object_type('OBJECT_TABLE'),
    v_relation := ast_helpers.range_var(
      v_schemaname := v_schema_name,
      v_relname := v_table_name
    ),
    v_cmds := to_jsonb(ARRAY[
      ast.alter_table_cmd(
        v_subtype := ast_constants.alter_table_type('AT_AlterColumnType'),
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
                ast.string('lpad')
              ]),
              v_args := to_jsonb(ARRAY[
                ast.type_cast(
                  v_arg := ast_helpers.col(v_field_name),
                  v_typeName := ast.type_name(
                    v_names := ast_helpers.array_of_strings('text'),
                    v_typemod := -1
                  )
                ),
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
        v_behavior := 0
      )
    ])
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;


CREATE FUNCTION ast_helpers.alter_perm_table_bitlen_default (
  v_schema_name text,
  v_table_name text,
  v_field_name text,
  v_bitlen int
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN
  ast_expr = ast.alter_table_stmt(
    v_relkind := ast_constants.object_type('OBJECT_TABLE'),
    v_relation := ast_helpers.range_var(
      v_schemaname := v_schema_name,
      v_relname := v_table_name
    ),
    v_cmds := to_jsonb(ARRAY[
      ast.alter_table_cmd(
        v_subtype := ast_constants.alter_table_type('AT_ColumnDefault'),
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
        v_behavior := 0
      )
    ])
  );
  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;


COMMIT;
