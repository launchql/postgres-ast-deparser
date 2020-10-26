-- Revert: schemas/collections_public/tables/table_grant/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE launchql_rls_collections_public.table_grant
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

