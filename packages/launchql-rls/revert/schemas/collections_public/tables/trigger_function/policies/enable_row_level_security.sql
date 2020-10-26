-- Revert: schemas/collections_public/tables/trigger_function/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE launchql_rls_collections_public.trigger_function
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

