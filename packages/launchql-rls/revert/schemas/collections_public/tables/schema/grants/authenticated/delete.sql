-- Revert: schemas/collections_public/tables/schema/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE launchql_rls_collections_public.schema FROM authenticated;
COMMIT;  

