-- Revert schemas/collections_public/tables/primary_key_constraint/policies/project_primary_key_policy from pg

BEGIN;

REVOKE INSERT ON TABLE collections_public.primary_key_constraint FROM authenticated;
REVOKE SELECT ON TABLE collections_public.primary_key_constraint FROM authenticated;
REVOKE UPDATE ON TABLE collections_public.primary_key_constraint FROM authenticated;
REVOKE DELETE ON TABLE collections_public.primary_key_constraint FROM authenticated;

DROP POLICY can_select_primary_key_constraint ON collections_public.primary_key_constraint;
DROP POLICY can_insert_primary_key_constraint ON collections_public.primary_key_constraint;
DROP POLICY can_update_primary_key_constraint ON collections_public.primary_key_constraint;
DROP POLICY can_delete_primary_key_constraint ON collections_public.primary_key_constraint;

COMMIT;
