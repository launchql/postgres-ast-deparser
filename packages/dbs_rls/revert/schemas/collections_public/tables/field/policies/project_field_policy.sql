-- Revert schemas/collections_public/tables/field/policies/project_field_policy from pg

BEGIN;


REVOKE INSERT ON TABLE collections_public.field FROM authenticated;
REVOKE SELECT ON TABLE collections_public.field FROM authenticated;
REVOKE UPDATE ON TABLE collections_public.field FROM authenticated;
REVOKE DELETE ON TABLE collections_public.field FROM authenticated;


DROP POLICY can_select_field ON collections_public.field;
DROP POLICY can_insert_field ON collections_public.field;
DROP POLICY can_update_field ON collections_public.field;
DROP POLICY can_delete_field ON collections_public.field;

COMMIT;
