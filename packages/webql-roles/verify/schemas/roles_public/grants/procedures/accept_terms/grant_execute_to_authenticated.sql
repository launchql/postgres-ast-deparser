-- Verify schemas/roles_public/grants/procedures/accept_terms/grant_execute_to_authenticated on pg

BEGIN;

SELECT verify_function ('roles_public.accept_terms', 'authenticated');

ROLLBACK;
