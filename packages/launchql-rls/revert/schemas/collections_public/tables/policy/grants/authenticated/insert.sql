-- Revert: schemas/collections_public/tables/policy/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE launchql_rls_collections_public.policy FROM authenticated;
COMMIT;  

