-- Revert: schemas/collections_public/tables/procedure/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE launchql_rls_collections_public.procedure FROM authenticated;
COMMIT;  

