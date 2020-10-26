-- Revert: schemas/collections_public/tables/trigger_function/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE launchql_rls_collections_public.trigger_function FROM authenticated;
COMMIT;  

