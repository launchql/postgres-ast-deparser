-- Revert schemas/collections_public/tables/constraint/policies/project_constraint_policy from pg

BEGIN;


REVOKE INSERT ON TABLE collections_public.constraint FROM authenticated;
REVOKE SELECT ON TABLE collections_public.constraint FROM authenticated;
REVOKE UPDATE ON TABLE collections_public.constraint FROM authenticated;
REVOKE DELETE ON TABLE collections_public.constraint FROM authenticated;


DROP POLICY can_select_constraint ON collections_public.constraint;
DROP POLICY can_insert_constraint ON collections_public.constraint;
DROP POLICY can_update_constraint ON collections_public.constraint;
DROP POLICY can_delete_constraint ON collections_public.constraint;

DROP FUNCTION collections_private.constraint_policy_fn;

COMMIT;
