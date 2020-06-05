-- Revert schemas/roles_private/procedures/prepare_secrets_for_email_validation from pg

BEGIN;

DROP FUNCTION roles_private.prepare_secrets_for_email_validation;

COMMIT;
