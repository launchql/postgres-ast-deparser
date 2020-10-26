-- Verify: schemas/launchql_public/tables/organization_profiles/table on pg

BEGIN;
SELECT verify_table('launchql_rls_public.organization_profiles');
COMMIT;  

