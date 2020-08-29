-- Deploy schemas/auth_public/tables/user_authentications/triggers/timestamps to pg

-- requires: schemas/auth_public/schema
-- requires: schemas/auth_public/tables/user_authentications/table

BEGIN;

ALTER TABLE auth_public.user_authentications ADD COLUMN created_at TIMESTAMPTZ;
ALTER TABLE auth_public.user_authentications ALTER COLUMN created_at SET DEFAULT NOW();

ALTER TABLE auth_public.user_authentications ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE auth_public.user_authentications ALTER COLUMN updated_at SET DEFAULT NOW();

CREATE TRIGGER update_auth_public_user_authentications_modtime
BEFORE UPDATE OR INSERT ON auth_public.user_authentications
FOR EACH ROW
EXECUTE PROCEDURE tg_update_timestamps();

COMMIT;
