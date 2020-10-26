-- Revert: schemas/collections_public/tables/policy/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE launchql_rls_collections_public.policy FROM authenticated;
COMMIT;  

