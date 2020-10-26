-- Revert: schemas/collections_public/tables/table_grant/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE launchql_rls_collections_public.table_grant FROM authenticated;
COMMIT;  

