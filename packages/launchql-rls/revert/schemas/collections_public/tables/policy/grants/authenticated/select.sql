-- Revert: schemas/collections_public/tables/policy/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE launchql_rls_collections_public.policy FROM authenticated;
COMMIT;  

