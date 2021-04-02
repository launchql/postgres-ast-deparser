-- Deploy schemas/ast_helpers/procedures/policy_templates to pg

-- requires: schemas/ast_helpers/schema
-- requires: schemas/ast_helpers/procedures/helpers

BEGIN;

CREATE FUNCTION ast_helpers.cpt_own_records(
  data jsonb
) returns jsonb as $$
DECLARE
  node jsonb;
BEGIN

  -- Function(id), Field(id)
  -- SELECT db_migrate.text('policy_expression_current_role', 

  node = ast_helpers.eq(
      v_lexpr := ast_helpers.col(data->>'role_key'),
      v_rexpr := data->'current_user_ast'
  );

  RETURN node;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_owned_records(
  data jsonb
) returns jsonb as $$
DECLARE
  node jsonb;
BEGIN
  -- Function(id), Field(id)

  -- TODO get both role_fn and groups_fn!!!!

  -- SELECT db_migrate.text('policy_expression_current_roles', 
  node = ast_helpers.or(
    ast_helpers.eq(
      v_lexpr := ast_helpers.col(data->>'role_key'),
      v_rexpr := data->'current_user_ast'
    ),
    ast_helpers.any(
      v_lexpr := ast_helpers.col(data->>'role_key'),
      v_rexpr := data->'current_groups_ast'
    )
  );

  -- node = ast_helpers.any(
  --   v_lexpr := ast_helpers.col(data->>'role_key'),
  --   v_rexpr := data->'current_groups_ast'
  -- );

  RETURN node;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_multi_owners(
  data jsonb
) returns jsonb as $$
DECLARE
  node jsonb;
  key_asts jsonb[];
  item jsonb;
BEGIN

  FOR item IN
    SELECT * FROM jsonb_array_elements(data->'role_keys')
    LOOP 
    key_asts = array_append(key_asts, ast_helpers.eq(
      -- NOTE if you have a string JSON element, item::text will keep " around it
      -- this just gets the root path unescaped.... a nice hack
      -- https://dba.stackexchange.com/questions/207984/unquoting-json-strings-print-json-strings-without-quotes
      v_lexpr := ast_helpers.col(item#>>'{}'),
      v_rexpr := data->'current_user_ast'
    ));
  END LOOP;

  node = ast_helpers.or( variadic nodes := key_asts );

  RETURN node;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_permission_name(
  data jsonb
) returns jsonb as $$
DECLARE
  node jsonb;
BEGIN
  node = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', data->>'permission_role_key'),
                  v_rexpr := data->'current_groups_ast'
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := data->>'permission_schema',
              v_relname := data->>'permission_table',
              v_alias := ast.alias(
                  v_aliasname := 'p'
              )
          )
      ]),
      v_whereClause := ast_helpers.eq(
          v_lexpr := ast_helpers.col('p', data->>'permission_name_key'),
          v_rexpr := ast.a_const(
              v_val := ast.string(data->>'this_value')
          )
      )
  );

  node = ast.sub_link(
    v_subLinkType := 'EXPR_SUBLINK',
    v_subselect := node
  );

  RETURN node;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_owned_object_records(
  data jsonb
) returns jsonb as $$
DECLARE
  node jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key', 

  node = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', data->>'owned_table_key'),
                  v_rexpr := data->'current_groups_ast'
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := data->>'owned_schema',
              v_relname := data->>'owned_table',
              v_alias := ast.alias(
                  v_aliasname := 'p'
              )
          )
      ]),
      v_whereClause := ast_helpers.eq(
          v_lexpr := ast_helpers.col('p', data->>'owned_table_ref_key'),
          v_rexpr := ast_helpers.col(data->>'this_object_key')
      )
  );

  node = ast.sub_link(
    v_subLinkType := 'EXPR_SUBLINK',
    v_subselect := node
  );

  RETURN node;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_administrator_records(
  data jsonb
) returns jsonb as $$
DECLARE
  node jsonb;
BEGIN

  node = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('d', 'owner_id'),
                  v_rexpr := data->'current_groups_ast'
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast.join_expr(
              v_jointype := 'JOIN_INNER',
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
                v_val := ast.string( data->>'database_id' )
              )
          ),
          ast_helpers.eq(
              v_lexpr := ast_helpers.col('t', 'id'),
              v_rexpr := ast.a_const( 
                v_val := ast.string( data->>'table_id' )
              )
          )
      )
  );

  node = ast.sub_link(
    v_subLinkType := 'EXPR_SUBLINK',
    v_subselect := node
  );

  RETURN node;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_child_of_owned_object_records(
  data jsonb
) returns jsonb as $$
DECLARE
  node jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed', 

  node = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := ast_helpers.col('p', data->>'owned_table_key'),
                  v_rexpr := data->'current_groups_ast'
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast.join_expr(
              v_jointype := 'JOIN_INNER',
              v_larg := ast_helpers.range_var(
                  v_schemaname := data->>'object_schema',
                  v_relname := data->>'object_table',
                  v_alias := ast.alias(
                      v_aliasname := 'c'
                  )
              ),
              v_rarg := ast_helpers.range_var(
                  v_schemaname := data->>'owned_schema',
                  v_relname := data->>'owned_table',
                  v_alias := ast.alias(
                      v_aliasname := 'p'
                  )
              ),
              v_quals := ast_helpers.eq(
                  v_lexpr := ast_helpers.col('p',data->>'owned_table_ref_key'),
                  v_rexpr := ast_helpers.col('c',data->>'object_table_owned_key')
              )
          )
      ]),
      v_whereClause := ast_helpers.eq(
          v_lexpr := ast_helpers.col('c',data->>'object_table_ref_key'),
          v_rexpr := ast_helpers.col(data->>'this_object_key')
      )
  );

  node = ast.sub_link(
    v_subLinkType := 'EXPR_SUBLINK',
    v_subselect := node
  );

  RETURN node;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_child_of_owned_object_records_group_array(
  data jsonb
) returns jsonb as $$
DECLARE
  node jsonb;
BEGIN

  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed', 

  node = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := data->'current_user_ast',
                  v_rexpr := ast_helpers.col('g', data->>'owned_table_key')
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast.join_expr(
              v_jointype := 'JOIN_INNER',
              v_larg := ast_helpers.range_var(
                  v_schemaname := data->>'object_schema',
                  v_relname := data->>'object_table',
                  v_alias := ast.alias(
                      v_aliasname := 'm'
                  )
              ),
              v_rarg := ast_helpers.range_var(
                  v_schemaname := data->>'owned_schema',
                  v_relname := data->>'owned_table',
                  v_alias := ast.alias(
                      v_aliasname := 'g'
                  )
              ),
              v_quals := ast_helpers.eq(
                  v_lexpr := ast_helpers.col('g',data->>'owned_table_ref_key'),
                  v_rexpr := ast_helpers.col('m',data->>'object_table_owned_key')
              )
          )
      ]),
      v_whereClause := ast_helpers.eq(
          v_lexpr := ast_helpers.col('m',data->>'object_table_ref_key'),
          v_rexpr := ast_helpers.col(data->>'this_object_key')
      )
  );

  node = ast.sub_link(
    v_subLinkType := 'EXPR_SUBLINK',
    v_subselect := node
  );

  RETURN node;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_child_of_owned_object_records_with_ownership(
  data jsonb
) returns jsonb as $$
DECLARE
  node jsonb;
BEGIN

  -- MODIFY policy since they are the same, except we just WRAP the JoinExpr with an AND
  -- Function(id), Table(id), Field(id), RefField(id), Field2(id)
  -- SELECT db_migrate.text('policy_expression_owned_object_key_once_removed_with_ownership', 

  node = ast_helpers.cpt_child_of_owned_object_records(
    data
  );

  node = jsonb_set(node, '{SubLink, subselect, SelectStmt, fromClause, 0, JoinExpr, quals}', ast.bool_expr(
    v_boolop := 'AND_EXPR',
    v_args := to_jsonb(ARRAY[
        node->'SubLink'->'subselect'->'SelectStmt'->'fromClause'->0->'JoinExpr'->'quals',
        ast_helpers.eq(
            v_lexpr := ast_helpers.col('p', data->>'owned_table_ref_key'),
            v_rexpr := ast_helpers.col(data->>'this_owned_key')
        )
    ])
  ));

  RETURN node;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_owned_object_records_group_array(
  data jsonb
) returns jsonb as $$
DECLARE
  node jsonb;
BEGIN

  node = ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.any(
                  v_lexpr := data->'current_user_ast',
                  v_rexpr := ast_helpers.col('p', data->>'owned_table_key')
              )
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast_helpers.range_var(
              v_schemaname := data->>'owned_schema',
              v_relname := data->>'owned_table',
              v_alias := ast.alias(
                  v_aliasname := 'p'
              )
          )
      ]),
      v_whereClause := ast_helpers.eq(
          v_lexpr := ast_helpers.col('p', data->>'owned_table_ref_key'),
          v_rexpr := ast_helpers.col(
            data->>'this_object_key'
          )
      )
  );

  node = ast.sub_link(
    v_subLinkType := 'EXPR_SUBLINK',
    v_subselect := node
  );

  RETURN node;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;


CREATE FUNCTION ast_helpers.entity_wrap_array(
  node jsonb,
  data jsonb
) returns jsonb as $$
BEGIN

  IF ((data->'include_current_user_id')::bool IS TRUE) THEN 
    -- DO WE NEED TO CAST THE possible ARRAY(...)::uuid[] ?
    -- postgres=# select array_append(NULL, 'sdf');
    -- ERROR:  could not determine polymorphic type because input has type unknown
    node = ast_helpers.any(
      v_lexpr := ast_helpers.col(data->>'entity_field'),
      v_rexpr := ast.func_call(
        v_funcname := ast_helpers.array_of_strings('array_append'),
        v_args := to_jsonb(ARRAY[
          node,
          data->'current_user_ast'
        ])
      )
    );
  ELSE
    node = ast_helpers.any(
      v_lexpr := ast_helpers.col(data->>'entity_field'),
      v_rexpr := node
    );
  END IF;

  RETURN node;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_entity_acl(
  data jsonb
) returns jsonb as $$
DECLARE
  node jsonb;
BEGIN

  node = ast.sub_link(
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
              v_schemaname := data->>'acl_schema',
              v_relname := data->>'acl_table',
              v_alias := ast.alias(
                  v_aliasname := 'acl'
              )
          )
      ]),
      v_whereClause := ast_helpers.acl_where_clause(data)
    )
  );

  RETURN ast_helpers.entity_wrap_array(
    node,
    data
  );
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_entity_acl_join(
  data jsonb
) returns jsonb as $$
DECLARE
  node jsonb;
BEGIN

  node = ast.sub_link(
    v_subLinkType := 'ARRAY_SUBLINK',
    v_subselect := ast.select_stmt(
      v_op := 'SETOP_NONE',
      v_limitOption := 'LIMIT_OPTION_DEFAULT',
      v_targetList := to_jsonb(ARRAY[
          ast.res_target(
              v_val := ast_helpers.col('acl', 'entity_id')
          )
      ]),
      v_fromClause := to_jsonb(ARRAY[
          ast.join_expr(
            v_jointype := 'JOIN_INNER',
            v_larg := ast_helpers.range_var(
              v_schemaname := data->>'acl_schema',
              v_relname := data->>'acl_table',
              v_alias := ast.alias(
                v_aliasname := 'acl'
              )
            ),
            v_rarg := ast_helpers.range_var(
              v_schemaname := data->>'obj_schema',
              v_relname := data->>'obj_table',
              v_alias := ast.alias(
                v_aliasname := 'obj'
              )
            ),
            v_quals := ast_helpers.eq(
              ast_helpers.col('acl', 'entity_id'),
              ast_helpers.col('obj', data->>'obj_field')
            )
          )
      ]),
      v_whereClause := ast_helpers.acl_where_clause(data)
    )
  );

  RETURN ast_helpers.entity_wrap_array(
    node,
    data
  );
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.acl_where_clause(
  data jsonb
) returns jsonb as $$
BEGIN
  RETURN (CASE WHEN data->'mask' IS NULL THEN
      ast_helpers.eq(
          v_lexpr := ast_helpers.col('acl', 'actor_id'),
          v_rexpr := data->'current_user_ast'
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
                v_rexpr := ast.a_const(v_val := ast.string(data->>'mask'))
              ),
              v_rexpr := ast.a_const(v_val := ast.string(data->>'mask'))
          ),
          ast_helpers.eq(
              v_lexpr := ast_helpers.col('acl', 'actor_id'),
              v_rexpr := data->'current_user_ast'
          )
        ]) 
      )
    END);
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_acl(
  data jsonb
) returns jsonb as $$
DECLARE
  node jsonb;
BEGIN

  node = ast.sub_link (
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
              v_schemaname := data->>'acl_schema',
              v_relname := data->>'acl_table',
              v_alias := ast.alias(
                  v_aliasname := 'acl'
              )
          )
      ]),
      v_whereClause := ast_helpers.acl_where_clause(
        data
      )
    )
  );

  RETURN node;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.create_policy_template(
  name text,
  data jsonb
) returns jsonb as $$
DECLARE
  policy_ast jsonb;
BEGIN

  -- TODO for safety, keep defaults. However, group_ids() should only return array of current_user_id()

  IF (data->>'rls_role' IS NULL OR data->>'rls_role_schema' IS NULL) THEN 
    data = jsonb_set(data, '{rls_role_schema}', to_jsonb('jwt_public'::text));
    data = jsonb_set(data, '{rls_role}', to_jsonb('current_user_id'::text));
  END IF;

  IF (data->>'rls_groups' IS NULL OR data->>'rls_groups_schema' IS NULL) THEN 
    data = jsonb_set(data, '{rls_groups_schema}', to_jsonb('jwt_public'::text));
    data = jsonb_set(data, '{rls_groups}', to_jsonb('current_group_ids'::text));
  END IF;

  IF (data->'current_groups_ast' IS NULL) THEN 
      data = jsonb_set(data, '{current_groups_ast}', 
        ast_helpers.rls_fn(
          data->>'rls_groups_schema',
          data->>'rls_groups'
        )
      );
  END IF;

  IF (data->'current_user_ast' IS NULL) THEN 
      data = jsonb_set(data, '{current_user_ast}', 
        ast_helpers.rls_fn(
          data->>'rls_role_schema',
          data->>'rls_role')
      );
  END IF;


  -- Tag some functions, allow them to be "RLS functions"
  -- so they show up in the RLS UI

  IF (name = 'own_records') THEN
      policy_ast = ast_helpers.cpt_own_records(
          data
      );
  ELSEIF (name = 'owned_records') THEN
      policy_ast = ast_helpers.cpt_owned_records(
          data
      );
  ELSEIF (name = 'multi_owners') THEN
      policy_ast = ast_helpers.cpt_multi_owners(
          data
      );
  ELSEIF (name = 'permission_name') THEN
      policy_ast = ast_helpers.cpt_permission_name(
          data
      );
  ELSEIF (name = 'owned_object_records') THEN
      policy_ast = ast_helpers.cpt_owned_object_records(
          data
      );
  ELSEIF (name = 'child_of_owned_object_records') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records(
          data
      );
  ELSEIF (name = 'child_of_owned_object_records_with_ownership') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records_with_ownership(
          data
      );
  ELSEIF (name = 'child_of_owned_object_records_group_array') THEN
      policy_ast = ast_helpers.cpt_child_of_owned_object_records_group_array(
          data
      );
  ELSEIF (name = 'owned_object_records_group_array') THEN
      policy_ast = ast_helpers.cpt_owned_object_records_group_array(
          data
      );
  ELSEIF (name = 'administrator_records') THEN
      policy_ast = ast_helpers.cpt_administrator_records(
          data
      );
  ELSEIF (name = 'entity_acl_join') THEN
      policy_ast = ast_helpers.cpt_entity_acl_join(
          data
      );
  ELSEIF (name = 'entity_acl') THEN
      policy_ast = ast_helpers.cpt_entity_acl(
          data
      );
  ELSEIF (name = 'acl') THEN
      policy_ast = ast_helpers.cpt_acl(
          data
      );
  ELSEIF (name = 'open') THEN
      policy_ast = ast.string('TRUE');
  ELSEIF (name = 'closed') THEN
      policy_ast = ast.string('FALSE');
  ELSE 
      RAISE EXCEPTION 'UNSUPPORTED POLICY';
  END IF;

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;



COMMIT;
