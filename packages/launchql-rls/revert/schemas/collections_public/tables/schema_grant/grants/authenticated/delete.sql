-- Revert: schemas/collections_public/tables/schema_grant/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE launchql_rls_collections_public.schema_grant FROM authenticated;
COMMIT;  

