-- Deploy schemas/ast_helpers/procedures/rls to pg

-- requires: schemas/ast_helpers/schema
-- requires: schemas/ast_helpers/procedures/helpers
-- requires: schemas/ast_constants/procedures/constants 

BEGIN;

-- SELECT mt.id FROM v_schema_name.v_table_name AS mt
-- WHERE mt.name = 'Organization'

CREATE FUNCTION ast_helpers.rls_membership_type_select_field (
  v_schema_name text,
  v_table_name text,
  v_field text,
  v_membership_type int
)
    RETURNS jsonb
    AS $$
DECLARE
  ast_expr jsonb;
BEGIN

  ast_expr = ast.select_stmt(
    v_op := 'SETOP_NONE',
    v_targetList := to_jsonb(ARRAY[
        ast.res_target(
            v_val := ast_helpers.col('mt', v_field)
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
        v_lexpr := ast_helpers.col('mt', 'id'),
        v_rexpr := ast.a_const(
            v_val := ast.integer(v_membership_type)
        )
    )
  );

  RETURN ast_expr;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

-- SELECT mt.id FROM v_schema_name.v_table_name AS mt
-- WHERE mt.name = 'Organization'

CREATE FUNCTION ast_helpers.rls_membership_type_select (
  v_schema_name text,
  v_table_name text,
  v_membership_type_name text
)
    RETURNS jsonb
    AS $$
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
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

-- SELECT v_schema_name.v_function_name(ARRAY['Can I do this?']::citext[])

CREATE FUNCTION ast_helpers.rls_policy_permission_mask_select (
  v_schema_name text,
  v_function_name text,
  v_permission text
)
    RETURNS jsonb
    AS $$
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
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

-- SELECT v_schema_name.v_function_name(ARRAY['Can I do this?', 'Can I also do this']::citext[])

CREATE FUNCTION ast_helpers.rls_policy_permission_mask_select (
  v_schema_name text,
  v_function_name text,
  v_permissions text[]
)
    RETURNS jsonb
    AS $$
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
$$
LANGUAGE 'plpgsql'
IMMUTABLE;


COMMIT;
