-- Revert: schemas/collections_public/tables/schema_grant/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE launchql_rls_collections_public.schema_grant FROM authenticated;
COMMIT;  

