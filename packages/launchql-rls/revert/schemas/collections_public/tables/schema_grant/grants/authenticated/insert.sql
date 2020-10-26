-- Revert: schemas/collections_public/tables/schema_grant/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE launchql_rls_collections_public.schema_grant FROM authenticated;
COMMIT;  

