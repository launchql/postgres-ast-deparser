-- Revert: schemas/collections_public/tables/procedure/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE launchql_rls_collections_public.procedure FROM authenticated;
COMMIT;  

