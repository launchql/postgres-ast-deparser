-- Revert: schemas/collections_public/tables/schema/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE launchql_rls_collections_public.schema FROM authenticated;
COMMIT;  

