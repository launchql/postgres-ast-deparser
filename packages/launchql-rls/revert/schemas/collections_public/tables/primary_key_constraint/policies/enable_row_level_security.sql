-- Revert: schemas/collections_public/tables/primary_key_constraint/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE launchql_rls_collections_public.primary_key_constraint
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

