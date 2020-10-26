-- Revert: schemas/collections_public/tables/schema/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE launchql_rls_collections_public.schema FROM authenticated;
COMMIT;  

