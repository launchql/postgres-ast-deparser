-- Verify schemas/roles_private/procedures/create_email_verification_job  on pg

BEGIN;

SELECT verify_function ('roles_private.create_email_verification_job');

ROLLBACK;
