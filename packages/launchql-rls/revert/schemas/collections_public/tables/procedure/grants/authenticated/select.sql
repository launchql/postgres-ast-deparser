-- Revert: schemas/collections_public/tables/procedure/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE launchql_rls_collections_public.procedure FROM authenticated;
COMMIT;  

