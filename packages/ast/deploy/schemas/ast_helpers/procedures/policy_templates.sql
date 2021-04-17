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

  -- SELECT db_migrate.text('policy_expression_current_roles', 
    node = ast_helpers.eq(
      v_lexpr := ast_helpers.col(data->>'role_key'),
      v_rexpr := data->'current_user_ast'
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

CREATE FUNCTION ast_helpers.cpt_acl_field(
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
              v_val := ast_helpers.col('acl', coalesce(data->>'sel_field', 'entity_id'))
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

CREATE FUNCTION ast_helpers.cpt_acl_field_join(
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
              v_val := ast_helpers.col( (CASE (data->>'sel_obj')::bool WHEN TRUE THEN 'obj' ELSE 'acl' END), coalesce(data->>'sel_field', 'entity_id'))
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
              ast_helpers.col('acl', coalesce(data->>'acl_join_field', 'entity_id')),
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
DECLARE
  stmts jsonb[];
  acl_filter jsonb[];
BEGIN

  stmts = array_append(stmts, ast_helpers.eq(
      v_lexpr := ast_helpers.col('acl', 'actor_id'),
      v_rexpr := data->'current_user_ast'
  ));

  IF (data->'mask' IS NOT NULL) THEN 
    stmts = array_append(stmts, ast_helpers.eq(
        v_lexpr := ast.a_expr(
          v_kind := 'AEXPR_OP',
          v_name := to_jsonb(ARRAY[ast.string('&')]),
          v_lexpr := ast_helpers.col('acl', 'permissions'),
          v_rexpr := ast.a_const(v_val := ast.string(data->>'mask'))
        ),
        v_rexpr := ast.a_const(v_val := ast.string(data->>'mask'))
    ));
  END IF;

  -- NOTE: is_admin/is_owner ARE NOT included in index
  -- these should really only be used sparingly on CHECKs not quals

  IF ((data->'is_admin')::bool IS TRUE) THEN 
    acl_filter = array_append(acl_filter, 
      ast_helpers.is_true(ast_helpers.col('acl', 'is_admin'))
    );
  END IF;
 
  IF ((data->'is_owner')::bool IS TRUE) THEN 
    acl_filter = array_append(acl_filter, 
      ast_helpers.is_true(ast_helpers.col('acl', 'is_owner'))
    );
  END IF;

  IF (cardinality(acl_filter) = 1) THEN 
    stmts = array_append(stmts, acl_filter[1]);
  ELSIF (cardinality(acl_filter) = 2) THEN 
    stmts = array_append(stmts, 
      ast_helpers.or(
          acl_filter[1],
          acl_filter[2]
      )
    );
  END IF;

  IF (cardinality(stmts) = 1) THEN 
    RETURN stmts[1];
  END IF;

  RETURN ast.bool_expr(
    v_boolop := 'AND_EXPR',
    v_args := to_jsonb(stmts)
  );

END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE FUNCTION ast_helpers.cpt_acl_exists(
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
  ELSEIF (name = 'owned_object_records_group_array') THEN
      policy_ast = ast_helpers.cpt_owned_object_records_group_array(
          data
      );
  ELSEIF (name = 'acl_field_join') THEN
      policy_ast = ast_helpers.cpt_acl_field_join(
          data
      );
  ELSEIF (name = 'acl_field') THEN
      policy_ast = ast_helpers.cpt_acl_field(
          data
      );
  ELSEIF (name = 'acl_exists') THEN
      policy_ast = ast_helpers.cpt_acl_exists(
          data
      );
  ELSEIF (name = 'open') THEN
      policy_ast = ast.string('TRUE');
  ELSEIF (name = 'closed') THEN
      policy_ast = ast.string('FALSE');
  ELSE 
      RAISE EXCEPTION 'UNSUPPORTED POLICY (%)', name;
  END IF;

  RETURN policy_ast;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;



COMMIT;
