-- Verify schemas/roles_public/procedures/send_verification_email  on pg

BEGIN;

SELECT verify_function ('roles_public.send_verification_email');

ROLLBACK;
