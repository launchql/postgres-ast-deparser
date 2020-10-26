-- Revert: schemas/collections_public/tables/database/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE launchql_rls_collections_public.database FROM authenticated;
COMMIT;  

