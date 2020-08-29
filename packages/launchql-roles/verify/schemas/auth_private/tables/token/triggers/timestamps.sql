-- Verify schemas/auth_private/tables/token/triggers/timestamps  on pg

BEGIN;

SELECT created_at FROM auth_private.token LIMIT 1;
SELECT updated_at FROM auth_private.token LIMIT 1;
SELECT verify_trigger ('auth_private.update_auth_private_token_modtime');

ROLLBACK;
