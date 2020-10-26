-- Revert: schemas/launchql_private/tables/user_secrets/constraints/user_secrets_user_id_name_key from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_secrets 
    DROP CONSTRAINT user_secrets_user_id_name_key;

COMMIT;  

