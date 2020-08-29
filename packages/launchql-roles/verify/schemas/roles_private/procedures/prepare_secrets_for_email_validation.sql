-- Verify schemas/roles_private/procedures/prepare_secrets_for_email_validation  on pg

BEGIN;

SELECT verify_function ('roles_private.prepare_secrets_for_email_validation');

ROLLBACK;
