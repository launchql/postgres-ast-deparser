-- Revert schemas/auth_private/types/token_type from pg

BEGIN;

DROP TYPE auth_private.token_type;

COMMIT;
