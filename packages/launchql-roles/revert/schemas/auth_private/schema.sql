-- Revert schemas/auth_private/schema from pg

BEGIN;

DROP SCHEMA auth_private;

COMMIT;
