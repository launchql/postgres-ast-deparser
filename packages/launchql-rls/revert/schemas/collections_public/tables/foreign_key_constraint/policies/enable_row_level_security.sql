-- Revert: schemas/collections_public/tables/foreign_key_constraint/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE launchql_rls_collections_public.foreign_key_constraint
    DISABLE ROW LEVEL SECURITY;

COMMIT;  
