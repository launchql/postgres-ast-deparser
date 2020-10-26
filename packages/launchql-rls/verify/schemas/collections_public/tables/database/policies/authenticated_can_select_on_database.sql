-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/database/policies/authenticated_can_select_on_database on pg

BEGIN;
SELECT verify_policy('authenticated_can_select_on_database', 'launchql_rls_launchql_rls_collections_public.database');
COMMIT;  

