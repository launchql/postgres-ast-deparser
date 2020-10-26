-- Revert: schemas/collections_public/tables/trigger/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE launchql_rls_collections_public.trigger FROM authenticated;
COMMIT;  

