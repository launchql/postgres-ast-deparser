-- Verify schemas/auth_private/tables/token/triggers/on_create_token  on pg

BEGIN;

SELECT verify_function ('auth_private.tg_on_create_token', current_user); 
SELECT verify_trigger ('auth_private.on_create_token');

ROLLBACK;
