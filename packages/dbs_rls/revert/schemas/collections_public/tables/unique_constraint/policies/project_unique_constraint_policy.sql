-- Revert schemas/collections_public/tables/unique_constraint/policies/project_unique_constraint_policy from pg

BEGIN;

REVOKE INSERT ON TABLE collections_public.unique_constraint FROM authenticated;
REVOKE SELECT ON TABLE collections_public.unique_constraint FROM authenticated;
REVOKE UPDATE ON TABLE collections_public.unique_constraint FROM authenticated;
REVOKE DELETE ON TABLE collections_public.unique_constraint FROM authenticated;

DROP POLICY can_select_unique_constraint ON collections_public.unique_constraint;
DROP POLICY can_insert_unique_constraint ON collections_public.unique_constraint;
DROP POLICY can_update_unique_constraint ON collections_public.unique_constraint;
DROP POLICY can_delete_unique_constraint ON collections_public.unique_constraint;

COMMIT;
