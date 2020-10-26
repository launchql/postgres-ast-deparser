-- Verify: schemas/launchql_public/tables/organization_profiles/grants/authenticated/delete on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_public.organization_profiles', 'delete', 'authenticated');
COMMIT;  

