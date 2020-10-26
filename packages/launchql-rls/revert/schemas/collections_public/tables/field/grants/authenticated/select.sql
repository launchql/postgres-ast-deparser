-- Revert: schemas/collections_public/tables/field/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE launchql_rls_collections_public.field FROM authenticated;
COMMIT;  

