-- Revert schemas/auth_public/procedures/refresh_token from pg

BEGIN;

DROP FUNCTION auth_public.refresh_token;

COMMIT;
