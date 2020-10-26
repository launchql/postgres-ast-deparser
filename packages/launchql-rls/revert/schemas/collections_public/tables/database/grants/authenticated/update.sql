-- Revert: schemas/collections_public/tables/database/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE launchql_rls_collections_public.database FROM authenticated;
COMMIT;  

