-- Verify: schemas/launchql_public/tables/organization_profiles/grants/authenticated/select on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_public.organization_profiles', 'select', 'authenticated');
COMMIT;  

