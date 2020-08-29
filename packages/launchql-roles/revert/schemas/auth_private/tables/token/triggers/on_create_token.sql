-- Revert schemas/auth_private/tables/token/triggers/on_create_token from pg

BEGIN;

DROP TRIGGER on_create_token ON auth_private.token;
DROP FUNCTION auth_private.tg_on_create_token; 

COMMIT;
