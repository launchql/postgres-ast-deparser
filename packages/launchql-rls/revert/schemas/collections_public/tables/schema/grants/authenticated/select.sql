-- Revert: schemas/collections_public/tables/schema/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE launchql_rls_collections_public.schema FROM authenticated;
COMMIT;  

