-- Revert schemas/auth_public/tables/user_authentications/table from pg

BEGIN;

DROP TABLE auth_public.user_authentications;

COMMIT;
