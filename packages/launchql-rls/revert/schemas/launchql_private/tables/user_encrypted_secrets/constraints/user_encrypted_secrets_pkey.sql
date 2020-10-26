-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/constraints/user_encrypted_secrets_pkey from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_encrypted_secrets 
    DROP CONSTRAINT user_encrypted_secrets_pkey;

COMMIT;  

