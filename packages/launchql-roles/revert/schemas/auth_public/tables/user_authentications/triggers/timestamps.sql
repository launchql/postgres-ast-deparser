-- Revert schemas/auth_public/tables/user_authentications/triggers/timestamps from pg

BEGIN;

ALTER TABLE auth_public.user_authentications DROP COLUMN created_at;
ALTER TABLE auth_public.user_authentications DROP COLUMN updated_at;
DROP TRIGGER update_auth_public_user_authentications_modtime ON auth_public.user_authentications;

COMMIT;
