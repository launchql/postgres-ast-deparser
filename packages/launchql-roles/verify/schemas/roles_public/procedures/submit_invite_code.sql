-- Verify schemas/roles_public/procedures/submit_invite_code  on pg

BEGIN;

SELECT verify_function ('roles_public.submit_invite_code');

ROLLBACK;
