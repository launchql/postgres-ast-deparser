-- Revert schemas/roles_private/procedures/create_email_verification_job from pg

BEGIN;

DROP FUNCTION roles_private.create_email_verification_job;

COMMIT;
