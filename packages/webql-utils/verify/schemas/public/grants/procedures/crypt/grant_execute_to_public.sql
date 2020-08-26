-- Verify schemas/public/grants/procedures/crypt/grant_execute_to_public on pg

BEGIN;

SELECT verify_function ('public.crypt', 'public');

ROLLBACK;
