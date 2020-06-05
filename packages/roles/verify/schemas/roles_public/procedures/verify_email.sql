-- Verify schemas/roles_public/procedures/verify_email  on pg

BEGIN;

SELECT verify_function ('roles_public.verify_email');

ROLLBACK;
