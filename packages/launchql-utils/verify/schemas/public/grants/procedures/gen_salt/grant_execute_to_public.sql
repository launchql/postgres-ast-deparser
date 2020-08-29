-- Verify schemas/public/grants/procedures/gen_salt/grant_execute_to_public on pg

BEGIN;

SELECT verify_function ('public.gen_salt', 'public');

ROLLBACK;
