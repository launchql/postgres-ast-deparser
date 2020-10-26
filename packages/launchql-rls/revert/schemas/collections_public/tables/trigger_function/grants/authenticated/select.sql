-- Revert: schemas/collections_public/tables/trigger_function/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE launchql_rls_collections_public.trigger_function FROM authenticated;
COMMIT;  

