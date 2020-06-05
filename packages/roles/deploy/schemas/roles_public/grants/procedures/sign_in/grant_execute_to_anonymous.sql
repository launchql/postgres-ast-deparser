-- Deploy schemas/roles_public/grants/procedures/sign_in/grant_execute_to_anonymous to pg


-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/procedures/sign_in

BEGIN;

GRANT EXECUTE ON FUNCTION roles_public.sign_in TO anonymous;

COMMIT;
