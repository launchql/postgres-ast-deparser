-- Revert: schemas/collections_public/tables/table_grant/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE launchql_rls_collections_public.table_grant FROM authenticated;
COMMIT;  

