-- Revert: schemas/launchql_private/tables/user_secrets/constraints/user_secrets_pkey from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_secrets 
    DROP CONSTRAINT user_secrets_pkey;

COMMIT;  

