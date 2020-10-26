-- Revert: schemas/collections_public/tables/field/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE launchql_rls_collections_public.field FROM authenticated;
COMMIT;  

