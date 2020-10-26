-- Revert: schemas/launchql_public/tables/organization_profiles/indexes/organization_profiles_organization_id_idx from pg

BEGIN;


DROP INDEX "launchql_rls_public".organization_profiles_organization_id_idx;

COMMIT;  

