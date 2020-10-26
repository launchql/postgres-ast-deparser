-- Revert: schemas/launchql_public/tables/organization_profiles/alterations/alt0000000070 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".organization_profiles
    ENABLE ROW LEVEL SECURITY;

COMMIT;  

