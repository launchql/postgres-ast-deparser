-- Deploy schemas/roles_public/grants/procedures/sign_up/grant_execute_to_anonymous to pg
-- requires: schemas/roles_public/procedures/sign_up

BEGIN;

GRANT EXECUTE ON FUNCTION roles_public.sign_up TO anonymous;

COMMIT;
