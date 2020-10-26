-- Revert: schemas/collections_public/tables/table_grant/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE launchql_rls_collections_public.table_grant FROM authenticated;
COMMIT;  

