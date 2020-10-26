-- Revert: schemas/collections_public/tables/field/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE launchql_rls_collections_public.field
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

