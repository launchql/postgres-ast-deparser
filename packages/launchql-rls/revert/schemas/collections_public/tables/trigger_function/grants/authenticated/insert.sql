-- Revert: schemas/collections_public/tables/trigger_function/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE launchql_rls_collections_public.trigger_function FROM authenticated;
COMMIT;  

