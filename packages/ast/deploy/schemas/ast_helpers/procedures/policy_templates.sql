-- Deploy schemas/ast_helpers/procedures/policy_templates to pg

-- requires: schemas/ast_helpers/schema
-- requires: schemas/ast_helpers/procedures/helpers

BEGIN;

CREATE FUNCTION ast_helpers.cpt_own_records(
  rls_schema text,
  role_fn text,
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  -- Function(id), Field(id)
  -- SELECT db_migrate.text('policy_expression_current_role', 

  policy_ast = ast_helpers.equals(
      v_lexpr := ast_helpers.col(policy_template_vars->>'role_key'),
      v_rexpr := ast_helpers.rls_fn(rls_schema, role_fn)
  );

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_owned_records(
  rls_schema text,
  role_fn text,
  groups_fn text,
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN
  -- Function(id), Field(id)

  -- TODO get both role_fn and groups_fn!!!!

  -- SELECT db_migrate.text('policy_expression_current_roles', 
  policy_ast = ast_helpers.or(
    ast_helpers.equals(
      v_lexpr := ast_helpers.col(policy_template_vars->>'role_key'),
      v_rexpr := ast_helpers.rls_fn(rls_schema, role_fn)
    ),
    ast_helpers.any(
      v_lexpr := ast_helpers.col(policy_template_vars->>'role_key'),
      v_rexpr := ast_helpers.rls_fn(rls_schema, groups_fn)
    )
  );

  -- policy_ast = ast_helpers.any(
  --   v_lexpr := ast_helpers.col(policy_template_vars->>'role_key'),
  --   v_rexpr := ast_helpers.rls_fn(rls_schema, groups_fn)
  -- );

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_multi_owners(
  rls_schema text,
  role_fn text,
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
  key_asts jsonb[];
  item jsonb;
BEGIN

  FOR item IN
    SELECT * FROM jsonb_array_elements(policy_template_vars->'role_keys')
    LOOP 
    key_asts = array_append(key_asts, ast_helpers.equals(
      -- NOTE if you have a string JSON element, item::text will keep " around it
      -- this just gets the root path unescaped.... a nice hack
      -- https://dba.stackexchange.com/questions/207984/unquoting-json-strings-print-json-strings-without-quotes
      v_lexpr := ast_helpers.col(item#>>'{}'),
      v_rexpr := ast_helpers.rls_fn(rls_schema, role_fn)
    ));
  END LOOP;

  policy_ast = ast_helpers.or( variadic nodes := key_asts );

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_permission_name(
  rls_schema text,
  groups_fn text,
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN
  policy_ast = ast.select_stmt(
      v_op := 0,
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', policy_template_vars->>'permission_role_key'),
                  v_rexpr := ast_helpers.rls_fn(rls_schema, groups_fn)
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := policy_template_vars->>'permission_schema',
              v_relname := policy_template_vars->>'permission_table',
              v_alias := ast.alias(
                  v_aliasname := 'p'
              )
          )
      ]),
      v_whereClause := ast_helpers.equals(
          v_lexpr := ast_helpers.col('p', policy_template_vars->>'permission_name_key'),
          v_rexpr := ast.a_const(
              v_val := ast.string(policy_template_vars->>'this_value')
          )
      )
  );

  policy_ast = ast.sub_link(
    v_subLinkType := 4,
    v_subselect := policy_ast
  );

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_owned_object_records(
  rls_schema text,
  groups_fn text,
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key', 

  policy_ast = ast.select_stmt(
      v_op := 0,
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', policy_template_vars->>'owned_table_key'),
                  v_rexpr := ast_helpers.rls_fn(rls_schema, groups_fn)
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := policy_template_vars->>'owned_schema',
              v_relname := policy_template_vars->>'owned_table',
              v_alias := ast.alias(
                  v_aliasname := 'p'
              )
          )
      ]),
      v_whereClause := ast_helpers.equals(
          v_lexpr := ast_helpers.col('p', policy_template_vars->>'owned_table_ref_key'),
          v_rexpr := ast_helpers.col(policy_template_vars->>'this_object_key')
      )
  );

  policy_ast = ast.sub_link(
    v_subLinkType := 4,
    v_subselect := policy_ast
  );

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_child_of_owned_object_records(
  rls_schema text,
  groups_fn text,
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed', 

  policy_ast = ast.select_stmt(
      v_op := 0,
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', policy_template_vars->>'owned_table_key'),
                  v_rexpr := ast_helpers.rls_fn(rls_schema, groups_fn)
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast.join_expr(
              v_jointype := 0,
              v_larg := ast_helpers.range_var(
                  v_schemaname := policy_template_vars->>'object_schema',
                  v_relname := policy_template_vars->>'object_table',
                  v_alias := ast.alias(
                      v_aliasname := 'c'
                  )
              ),
              v_rarg := ast_helpers.range_var(
                  v_schemaname := policy_template_vars->>'owned_schema',
                  v_relname := policy_template_vars->>'owned_table',
                  v_alias := ast.alias(
                      v_aliasname := 'p'
                  )
              ),
              v_quals := ast_helpers.equals(
                  v_lexpr := ast_helpers.col('p',policy_template_vars->>'owned_table_ref_key'),
                  v_rexpr := ast_helpers.col('c',policy_template_vars->>'object_table_owned_key')
              )
          )
      ]),
      v_whereClause := ast_helpers.equals(
          v_lexpr := ast_helpers.col('c',policy_template_vars->>'object_table_ref_key'),
          v_rexpr := ast_helpers.col(policy_template_vars->>'this_object_key')
      )
  );

  policy_ast = ast.sub_link(
    v_subLinkType := 4,
    v_subselect := policy_ast
  );

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_child_of_owned_object_records_group_array(
  rls_schema text,
  role_fn text,
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed', 

  policy_ast = ast.select_stmt(
      v_op := 0,
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.rls_fn(rls_schema, role_fn),
                  v_rexpr := ast_helpers.col('g', policy_template_vars->>'owned_table_key')
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast.join_expr(
              v_jointype := 0,
              v_larg := ast_helpers.range_var(
                  v_schemaname := policy_template_vars->>'object_schema',
                  v_relname := policy_template_vars->>'object_table',
                  v_alias := ast.alias(
                      v_aliasname := 'm'
                  )
              ),
              v_rarg := ast_helpers.range_var(
                  v_schemaname := policy_template_vars->>'owned_schema',
                  v_relname := policy_template_vars->>'owned_table',
                  v_alias := ast.alias(
                      v_aliasname := 'g'
                  )
              ),
              v_quals := ast_helpers.equals(
                  v_lexpr := ast_helpers.col('g',policy_template_vars->>'owned_table_ref_key'),
                  v_rexpr := ast_helpers.col('m',policy_template_vars->>'object_table_owned_key')
              )
          )
      ]),
      v_whereClause := ast_helpers.equals(
          v_lexpr := ast_helpers.col('m',policy_template_vars->>'object_table_ref_key'),
          v_rexpr := ast_helpers.col(policy_template_vars->>'this_object_key')
      )
  );

  policy_ast = ast.sub_link(
    v_subLinkType := 4,
    v_subselect := policy_ast
  );

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_child_of_owned_object_records_with_ownership(
  rls_schema text,
  groups_fn text,
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  -- MODIFY policy since they are the same, except we just WRAP the JoinExpr with an AND
  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed_with_ownership', 

  policy_ast = ast_helpers.cpt_child_of_owned_object_records(
    rls_schema,
    groups_fn,
    policy_template_vars
  );

  policy_ast = jsonb_set(policy_ast, '{SubLink, subselect, SelectStmt, fromClause, 0, JoinExpr, quals}', ast.bool_expr(
    v_boolop := 0,
    v_args := to_jsonb(ARRAY[
        policy_ast->'SubLink'->'subselect'->'SelectStmt'->'fromClause'->0->'JoinExpr'->'quals',
        ast_helpers.equals(
            v_lexpr := ast_helpers.col('p', policy_template_vars->>'owned_table_ref_key'),
            v_rexpr := ast_helpers.col(policy_template_vars->>'this_owned_key')
        )
    ])
  ));

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_owned_object_records_group_array(
  rls_schema text,
  role_fn text,
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  policy_ast = ast.select_stmt(
      v_op := 0,
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.rls_fn(rls_schema, role_fn),
                  v_rexpr := ast_helpers.col('p', policy_template_vars->>'owned_table_key')
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := policy_template_vars->>'owned_schema',
              v_relname := policy_template_vars->>'owned_table',
              v_alias := ast.alias(
                  v_aliasname := 'p'
              )
          )
      ]),
      v_whereClause := ast_helpers.equals(
          v_lexpr := ast_helpers.col('p', policy_template_vars->>'owned_table_ref_key'),
          v_rexpr := ast_helpers.col(
            policy_template_vars->>'this_object_key'
          )
      )
  );

  policy_ast = ast.sub_link(
    v_subLinkType := 4,
    v_subselect := policy_ast
  );

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;


CREATE FUNCTION ast_helpers.create_policy_template(
  rls_schema text,
  role_fn text,
  groups_fn text,
  policy_template_name text,
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  -- Tag some functions, allow them to be "RLS functions"
  -- so they show up in the RLS UI

  IF (policy_template_name = 'own_records') THEN
      policy_ast = ast_helpers.cpt_own_records(
          rls_schema,
          role_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'owned_records') THEN
      policy_ast = ast_helpers.cpt_owned_records(
          rls_schema,
          role_fn,
          groups_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'multi_owners') THEN
      policy_ast = ast_helpers.cpt_multi_owners(
          rls_schema,
          role_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'permission_name') THEN
      policy_ast = ast_helpers.cpt_permission_name(
          rls_schema,
          groups_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'owned_object_records') THEN
      policy_ast = ast_helpers.cpt_owned_object_records(
          rls_schema,
          groups_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'child_of_owned_object_records') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records(
          rls_schema,
          groups_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'child_of_owned_object_records_with_ownership') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records_with_ownership(
          rls_schema,
          groups_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'child_of_owned_object_records_group_array') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records_group_array(
          rls_schema,
          role_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'owned_object_records_group_array') THEN
      policy_ast = ast_helpers.cpt_owned_object_records_group_array(
          rls_schema,
          role_fn,
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'open') THEN
      policy_ast = ast.string('TRUE');
  ELSE 
      RAISE EXCEPTION 'UNSUPPORTED POLICY';
  END IF;

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;



COMMIT;
