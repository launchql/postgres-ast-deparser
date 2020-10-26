-- Revert: schemas/launchql_private/procedures/user_encrypted_secrets_select/procedure from pg

BEGIN;


DROP FUNCTION "launchql_rls_private".user_encrypted_secrets_select;
COMMIT;  

