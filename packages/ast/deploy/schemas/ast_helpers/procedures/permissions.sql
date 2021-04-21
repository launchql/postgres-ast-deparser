-- Deploy schemas/ast_helpers/procedures/permissions to pg

-- requires: schemas/ast_helpers/schema
-- requires: schemas/ast_helpers/procedures/helpers
-- requires: schemas/ast_constants/procedures/constants 

BEGIN;

-- ALTER TABLE v_schema_name.v_table_name
--   ALTER COLUMN v_field_name TYPE bit(123)
--   USING utils.bitmask_pad (v_field_name, 123, '0')::bit(123)

CREATE FUNCTION ast_helpers.alter_table_perm_bitlen (
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
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

-- ALTER TABLE v_schema_name.v_table_name
--   ALTER COLUMN v_field_name SET DEFAULT lpad('', 123, '0')::bit(123)

CREATE FUNCTION ast_helpers.alter_table_perm_bitlen_default (
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
$$
LANGUAGE 'plpgsql'
IMMUTABLE;


COMMIT;
