-- Revert schemas/roles_public/procedures/accept_terms from pg

BEGIN;

DROP FUNCTION roles_public.accept_terms;

COMMIT;
