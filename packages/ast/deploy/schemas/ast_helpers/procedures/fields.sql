-- Deploy schemas/ast_helpers/procedures/fields to pg

-- requires: schemas/ast_helpers/schema
-- requires: schemas/ast_helpers/procedures/helpers
-- requires: schemas/ast_constants/procedures/constants 

-- requires: schemas/deparser/procedures/deparse 


BEGIN;

CREATE FUNCTION ast_helpers.owned_field_func_body (
  v_role_key text,
  v_func_schema text DEFAULT 'jwt_public',
  v_func text DEFAULT 'current_user_id'
)
    RETURNS text
    AS $$
DECLARE
  ast_expr jsonb;
  body text;
BEGIN

  ast_expr = ast_helpers.neq(
    ast_helpers.col('new', v_role_key),
    ast.func_call(
      v_funcname := ast_helpers.array_of_strings(
        v_func_schema, v_func
      )
    )
  );

  body = trim(format('
  BEGIN
    IF (%1s) THEN
      RAISE EXCEPTION ''OWNED_PROPS'';
    END IF;
  RETURN NEW;
  END;
  ', deparser.deparse(ast_expr)));

  RETURN body;
END;
$$
LANGUAGE 'plpgsql'
IMMUTABLE;

COMMIT;
