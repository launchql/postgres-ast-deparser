-- Revert: schemas/collections_public/tables/policy/policies/authenticated_can_select_on_policy from pg

BEGIN;
DROP POLICY authenticated_can_select_on_policy ON launchql_rls_collections_public.policy;
COMMIT;  

