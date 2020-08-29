-- Revert schemas/roles_public/grants/procedures/accept_terms/grant_execute_to_authenticated from pg

BEGIN;

REVOKE EXECUTE ON roles_public.accept_terms FROM authenticated;

COMMIT;
