-- Revert: schemas/collections_public/tables/trigger/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE launchql_rls_collections_public.trigger FROM authenticated;
COMMIT;  

