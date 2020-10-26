-- Revert: schemas/collections_public/tables/procedure/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE launchql_rls_collections_public.procedure
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

