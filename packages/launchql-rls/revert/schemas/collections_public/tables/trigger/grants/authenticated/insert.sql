-- Revert: schemas/collections_public/tables/trigger/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE launchql_rls_collections_public.trigger FROM authenticated;
COMMIT;  

