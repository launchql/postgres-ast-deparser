-- Revert: schemas/collections_public/tables/policy/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE launchql_rls_collections_public.policy
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

