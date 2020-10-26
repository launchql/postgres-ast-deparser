-- Revert: schemas/launchql_private/tables/user_secrets/alterations/alt0000000011 from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_secrets
    ENABLE ROW LEVEL SECURITY;

COMMIT;  

