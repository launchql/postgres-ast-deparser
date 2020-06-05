-- Revert schemas/auth_private/tables/token/triggers/timestamps from pg

BEGIN;

ALTER TABLE auth_private.token DROP COLUMN created_at;
ALTER TABLE auth_private.token DROP COLUMN updated_at;
DROP TRIGGER update_auth_private_token_modtime ON auth_private.token;

COMMIT;
