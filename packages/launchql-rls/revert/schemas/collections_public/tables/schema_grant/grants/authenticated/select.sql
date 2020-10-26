-- Revert: schemas/collections_public/tables/schema_grant/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE launchql_rls_collections_public.schema_grant FROM authenticated;
COMMIT;  

