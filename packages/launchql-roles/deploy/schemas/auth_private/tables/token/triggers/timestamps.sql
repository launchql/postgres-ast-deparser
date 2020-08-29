-- Deploy schemas/auth_private/tables/token/triggers/timestamps to pg

-- requires: schemas/auth_private/schema
-- requires: schemas/auth_private/tables/token/table

BEGIN;

ALTER TABLE auth_private.token ADD COLUMN created_at TIMESTAMPTZ;
ALTER TABLE auth_private.token ALTER COLUMN created_at SET DEFAULT NOW();

ALTER TABLE auth_private.token ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE auth_private.token ALTER COLUMN updated_at SET DEFAULT NOW();

CREATE TRIGGER update_auth_private_token_modtime
BEFORE UPDATE OR INSERT ON auth_private.token
FOR EACH ROW
EXECUTE PROCEDURE tg_update_timestamps();

COMMIT;
