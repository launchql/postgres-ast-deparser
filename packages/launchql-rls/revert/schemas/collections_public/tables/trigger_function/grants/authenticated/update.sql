-- Revert: schemas/collections_public/tables/trigger_function/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE launchql_rls_collections_public.trigger_function FROM authenticated;
COMMIT;  

