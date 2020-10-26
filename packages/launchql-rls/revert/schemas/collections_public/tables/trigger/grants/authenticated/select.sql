-- Revert: schemas/collections_public/tables/trigger/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE launchql_rls_collections_public.trigger FROM authenticated;
COMMIT;  

