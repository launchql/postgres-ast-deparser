-- Deploy schemas/ast_helpers/procedures/policy_templates to pg

-- requires: schemas/ast_helpers/schema
-- requires: schemas/ast_helpers/procedures/helpers

BEGIN;

CREATE FUNCTION ast_helpers.cpt_own_records(
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  -- Function(id), Field(id)
  -- SELECT db_migrate.text('policy_expression_current_role', 

  policy_ast = ast_helpers.eq(
      v_lexpr := ast_helpers.col(policy_template_vars->>'role_key'),
      v_rexpr := policy_template_vars->'current_user_ast'
  );

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_owned_records(
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN
  -- Function(id), Field(id)

  -- TODO get both role_fn and groups_fn!!!!

  -- SELECT db_migrate.text('policy_expression_current_roles', 
  policy_ast = ast_helpers.or(
    ast_helpers.eq(
      v_lexpr := ast_helpers.col(policy_template_vars->>'role_key'),
      v_rexpr := policy_template_vars->'current_user_ast'
    ),
    ast_helpers.any(
      v_lexpr := ast_helpers.col(policy_template_vars->>'role_key'),
      v_rexpr := policy_template_vars->'current_groups_ast'
    )
  );

  -- policy_ast = ast_helpers.any(
  --   v_lexpr := ast_helpers.col(policy_template_vars->>'role_key'),
  --   v_rexpr := policy_template_vars->'current_groups_ast'
  -- );

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_multi_owners(
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
    key_asts = array_append(key_asts, ast_helpers.eq(
      -- NOTE if you have a string JSON element, item::text will keep " around it
      -- this just gets the root path unescaped.... a nice hack
      -- https://dba.stackexchange.com/questions/207984/unquoting-json-strings-print-json-strings-without-quotes
      v_lexpr := ast_helpers.col(item#>>'{}'),
      v_rexpr := policy_template_vars->'current_user_ast'
    ));
  END LOOP;

  policy_ast = ast_helpers.or( variadic nodes := key_asts );

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_permission_name(
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN
  policy_ast = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', policy_template_vars->>'permission_role_key'),
                  v_rexpr := policy_template_vars->'current_groups_ast'
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
      v_whereClause := ast_helpers.eq(
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
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key', 

  policy_ast = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', policy_template_vars->>'owned_table_key'),
                  v_rexpr := policy_template_vars->'current_groups_ast'
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
      v_whereClause := ast_helpers.eq(
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

CREATE FUNCTION ast_helpers.cpt_administrator_records(
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  policy_ast = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('d', 'owner_id'),
                  v_rexpr := policy_template_vars->'current_groups_ast'
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast.join_expr(
              v_jointype := 0,
              v_larg := ast_helpers.range_var(
                  v_schemaname := 'collections_public',
                  v_relname := 'table',
                  v_alias := ast.alias(
                      v_aliasname := 't'
                  )
              ),
              v_rarg := ast_helpers.range_var(
                  v_schemaname := 'collections_public',
                  v_relname := 'database',
                  v_alias := ast.alias(
                      v_aliasname := 'd'
                  )
              ),
              v_quals := ast_helpers.eq(
                  v_lexpr := ast_helpers.col('t', 'database_id'),
                  v_rexpr := ast_helpers.col('d', 'id') 
              )
          )
      ]),
      v_whereClause := ast_helpers.and(
          ast_helpers.eq(
              v_lexpr := ast_helpers.col('t', 'database_id'),
              v_rexpr := ast.a_const( 
                v_val := ast.string( policy_template_vars->>'database_id' )
              )
          ),
          ast_helpers.eq(
              v_lexpr := ast_helpers.col('t', 'id'),
              v_rexpr := ast.a_const( 
                v_val := ast.string( policy_template_vars->>'table_id' )
              )
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

CREATE FUNCTION ast_helpers.cpt_child_of_owned_object_records(
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed', 

  policy_ast = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', policy_template_vars->>'owned_table_key'),
                  v_rexpr := policy_template_vars->'current_groups_ast'
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
              v_quals := ast_helpers.eq(
                  v_lexpr := ast_helpers.col('p',policy_template_vars->>'owned_table_ref_key'),
                  v_rexpr := ast_helpers.col('c',policy_template_vars->>'object_table_owned_key')
              )
          )
      ]),
      v_whereClause := ast_helpers.eq(
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
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed', 

  policy_ast = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := policy_template_vars->'current_user_ast',
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
              v_quals := ast_helpers.eq(
                  v_lexpr := ast_helpers.col('g',policy_template_vars->>'owned_table_ref_key'),
                  v_rexpr := ast_helpers.col('m',policy_template_vars->>'object_table_owned_key')
              )
          )
      ]),
      v_whereClause := ast_helpers.eq(
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
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  -- MODIFY policy since they are the same, except we just WRAP the JoinExpr with an AND
  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed_with_ownership', 

  policy_ast = ast_helpers.cpt_child_of_owned_object_records(
    policy_template_vars
  );

  policy_ast = jsonb_set(policy_ast, '{SubLink, subselect, SelectStmt, fromClause, 0, JoinExpr, quals}', ast.bool_expr(
    v_boolop := 'AND_EXPR',
    v_args := to_jsonb(ARRAY[
        policy_ast->'SubLink'->'subselect'->'SelectStmt'->'fromClause'->0->'JoinExpr'->'quals',
        ast_helpers.eq(
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
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  policy_ast = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := policy_template_vars->'current_user_ast',
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
      v_whereClause := ast_helpers.eq(
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


CREATE FUNCTION ast_helpers.cpt_entity_acl(
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
  array_ast jsonb;
BEGIN

  array_ast = ast.sub_link(
    v_subLinkType := 'ARRAY_SUBLINK',
    v_subselect := ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.col('acl', 'entity_id')
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := policy_template_vars->>'acl_schema',
              v_relname := policy_template_vars->>'acl_table',
              v_alias := ast.alias(
                  v_aliasname := 'acl'
              )
          )
      ]),
      v_whereClause := ast_helpers.acl_where_clause(policy_template_vars)
    )
  );

  IF ((policy_template_vars->'include_current_user_id')::bool IS TRUE) THEN 
    -- DO WE NEED TO CAST THE possible ARRAY(...)::uuid[] ?
    -- postgres=# select array_append(NULL, 'sdf');
    -- ERROR:  could not determine polymorphic type because input has type unknown
    policy_ast = ast_helpers.any(
      v_lexpr := ast_helpers.col(policy_template_vars->>'entity_field'),
      v_rexpr := ast.func_call(
        v_funcname := ast_helpers.array_of_strings('array_append'),
        v_args := to_jsonb(ARRAY[
          array_ast,
          policy_template_vars->'current_user_ast'
        ])
      )
    );
  ELSE
    policy_ast = ast_helpers.any(
      v_lexpr := ast_helpers.col(policy_template_vars->>'entity_field'),
      v_rexpr := array_ast
    );
  END IF;

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.acl_where_clause(
  policy_template_vars jsonb
) returns jsonb as $$
BEGIN
  RETURN (CASE WHEN policy_template_vars->'mask' IS NULL THEN
      ast_helpers.eq(
          v_lexpr := ast_helpers.col('acl', 'actor_id'),
          v_rexpr := policy_template_vars->'current_user_ast'
      )
    ELSE
      ast.bool_expr(
        v_boolop := 'AND_EXPR',
        v_args := to_jsonb(ARRAY[
          ast_helpers.eq(
              v_lexpr := ast.a_expr(
                v_kind := 'AEXPR_OP',
                v_name := to_jsonb(ARRAY[ast.string('&')]),
                v_lexpr := ast_helpers.col('acl', 'permissions'),
                v_rexpr := ast.a_const(v_val := ast.string(policy_template_vars->>'mask'))
              ),
              v_rexpr := ast.a_const(v_val := ast.string(policy_template_vars->>'mask'))
          ),
          ast_helpers.eq(
              v_lexpr := ast_helpers.col('acl', 'actor_id'),
              v_rexpr := policy_template_vars->'current_user_ast'
          )
        ]) 
      )
    END);
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_acl(
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  policy_ast = ast.sub_link (
    v_subLinkType := 'EXISTS_SUBLINK',
    v_subselect := ast.select_stmt(
       v_op := 'SETOP_NONE',
       v_targetList := to_jsonb(ARRAY[
         ast.res_target(
            v_val := ast.a_const(ast.integer(1))
         )
       ]),
       v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := policy_template_vars->>'acl_schema',
              v_relname := policy_template_vars->>'acl_table',
              v_alias := ast.alias(
                  v_aliasname := 'acl'
              )
          )
      ]),
      v_whereClause := ast_helpers.acl_where_clause(
        policy_template_vars
      )
    )
  );

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.create_policy_template(
  policy_template_name text,
  policy_template_vars jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  -- TODO for safety, keep defaults. However, group_ids() should only return array of current_user_id()

  IF (policy_template_vars->>'rls_role' IS NULL OR policy_template_vars->>'rls_role_schema' IS NULL) THEN 
    policy_template_vars = jsonb_set(policy_template_vars, '{rls_role_schema}', to_jsonb('jwt_public'::text));
    policy_template_vars = jsonb_set(policy_template_vars, '{rls_role}', to_jsonb('current_user_id'::text));
  END IF;

  IF (policy_template_vars->>'rls_groups' IS NULL OR policy_template_vars->>'rls_groups_schema' IS NULL) THEN 
    policy_template_vars = jsonb_set(policy_template_vars, '{rls_groups_schema}', to_jsonb('jwt_public'::text));
    policy_template_vars = jsonb_set(policy_template_vars, '{rls_groups}', to_jsonb('current_group_ids'::text));
  END IF;

  IF (policy_template_vars->'current_groups_ast' IS NULL) THEN 
      policy_template_vars = jsonb_set(policy_template_vars, '{current_groups_ast}', 
        ast_helpers.rls_fn(
          policy_template_vars->>'rls_groups_schema',
          policy_template_vars->>'rls_groups'
        )
      );
  END IF;

  IF (policy_template_vars->'current_user_ast' IS NULL) THEN 
      policy_template_vars = jsonb_set(policy_template_vars, '{current_user_ast}', 
        ast_helpers.rls_fn(
          policy_template_vars->>'rls_role_schema',
          policy_template_vars->>'rls_role')
      );
  END IF;


  -- Tag some functions, allow them to be "RLS functions"
  -- so they show up in the RLS UI

  IF (policy_template_name = 'own_records') THEN
      policy_ast = ast_helpers.cpt_own_records(
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'owned_records') THEN
      policy_ast = ast_helpers.cpt_owned_records(
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'multi_owners') THEN
      policy_ast = ast_helpers.cpt_multi_owners(
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'permission_name') THEN
      policy_ast = ast_helpers.cpt_permission_name(
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'owned_object_records') THEN
      policy_ast = ast_helpers.cpt_owned_object_records(
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'child_of_owned_object_records') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records(
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'child_of_owned_object_records_with_ownership') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records_with_ownership(
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'child_of_owned_object_records_group_array') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records_group_array(
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'owned_object_records_group_array') THEN
      policy_ast = ast_helpers.cpt_owned_object_records_group_array(
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'administrator_records') THEN
      policy_ast = ast_helpers.cpt_administrator_records(
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'entity_acl') THEN
      policy_ast = ast_helpers.cpt_entity_acl(
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'acl') THEN
      policy_ast = ast_helpers.cpt_acl(
          policy_template_vars
      );
  ELSEIF (policy_template_name = 'open') THEN
      policy_ast = ast.string('TRUE');
  ELSEIF (policy_template_name = 'closed') THEN
      policy_ast = ast.string('FALSE');
  ELSE 
      RAISE EXCEPTION 'UNSUPPORTED POLICY';
  END IF;

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;



COMMIT;
