-- Deploy schemas/roles_public/grants/procedures/current_role/grant_execute_to_anonymous_authenticated to pg
-- requires: schemas/roles_public/procedures/current_role

BEGIN;

GRANT EXECUTE ON FUNCTION roles_public.current_role TO authenticated;
GRANT EXECUTE ON FUNCTION roles_public.current_role TO anonymous;

COMMIT;
