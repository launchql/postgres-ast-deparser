-- Revert schemas/auth_public/schema from pg

BEGIN;

DROP SCHEMA auth_public;

COMMIT;
