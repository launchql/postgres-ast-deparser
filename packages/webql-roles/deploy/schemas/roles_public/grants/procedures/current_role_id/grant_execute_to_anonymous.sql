-- Deploy schemas/roles_public/grants/procedures/current_role_id/grant_execute_to_anonymous to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/procedures/current_role_id

BEGIN;

GRANT EXECUTE ON FUNCTION roles_public.current_role_id TO anonymous;

COMMIT;
