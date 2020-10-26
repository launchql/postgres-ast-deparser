-- Deploy: schemas/launchql_public/procedures/get_current_user/procedure to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/procedures/get_current_role_ids/grants/authenticated

BEGIN;

CREATE FUNCTION "launchql_public".get_current_user()
    RETURNS "launchql_public".users
AS $$
DECLARE
  v_user "launchql_public".users;
BEGIN
  IF "launchql_public".get_current_user_id() IS NOT NULL THEN
     SELECT * FROM "launchql_public".users WHERE id = "launchql_public".get_current_user_id() INTO v_user;
     RETURN v_user;
  ELSE
     RETURN NULL;
  END IF;
END;
$$
LANGUAGE 'plpgsql' STABLE;
COMMIT;
