-- Revert: schemas/collections_public/tables/database/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE launchql_rls_collections_public.database FROM authenticated;
COMMIT;  

