-- Verify schemas/roles_public/procedures/accept_terms  on pg

BEGIN;

SELECT verify_function ('roles_public.accept_terms');

ROLLBACK;
