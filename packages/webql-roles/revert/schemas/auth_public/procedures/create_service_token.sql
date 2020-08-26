-- Revert schemas/auth_public/procedures/create_service_token from pg

BEGIN;

DROP FUNCTION auth_public.create_service_token;

COMMIT;
