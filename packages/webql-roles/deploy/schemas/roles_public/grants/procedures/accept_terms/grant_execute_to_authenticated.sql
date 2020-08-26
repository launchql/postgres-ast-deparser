-- Deploy schemas/roles_public/grants/procedures/accept_terms/grant_execute_to_authenticated to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/procedures/accept_terms

BEGIN;

GRANT EXECUTE ON FUNCTION roles_public.accept_terms TO authenticated;

COMMIT;
