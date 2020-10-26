-- Revert: schemas/collections_public/tables/procedure/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE launchql_rls_collections_public.procedure FROM authenticated;
COMMIT;  

