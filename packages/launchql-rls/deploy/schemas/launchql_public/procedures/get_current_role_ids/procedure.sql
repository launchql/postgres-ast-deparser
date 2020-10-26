-- Deploy: schemas/launchql_public/procedures/get_current_role_ids/procedure to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/procedures/get_current_user_id/grants/authenticated

BEGIN;

CREATE FUNCTION "launchql_public".get_current_role_ids ()
  RETURNS uuid[]
AS $$
DECLARE
  v_identifier_ids uuid[];
BEGIN
  IF current_setting('jwt.claims.user_ids', TRUE)
    IS NOT NULL THEN
    BEGIN
      v_identifier_ids = current_setting('jwt.claims.user_ids', TRUE)::uuid[];
    EXCEPTION
      WHEN OTHERS THEN
      RAISE NOTICE 'Invalid UUID value';
    RETURN ARRAY[]::uuid[];
    END;
    RETURN v_identifier_ids;
  ELSE
    RETURN ARRAY[]::uuid[];
  END IF;
END;
$$
LANGUAGE 'plpgsql' STABLE;
COMMIT;
