-- Revert: schemas/collections_public/tables/unique_constraint/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE launchql_rls_collections_public.unique_constraint
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

