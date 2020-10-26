-- Revert: schemas/collections_public/tables/policy/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE launchql_rls_collections_public.policy FROM authenticated;
COMMIT;  

