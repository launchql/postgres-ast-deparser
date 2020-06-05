-- Revert schemas/collections_public/tables/table/policies/project_table_policy from pg

BEGIN;


REVOKE INSERT ON TABLE collections_public.table FROM authenticated;
REVOKE SELECT ON TABLE collections_public.table FROM authenticated;
REVOKE UPDATE ON TABLE collections_public.table FROM authenticated;
REVOKE DELETE ON TABLE collections_public.table FROM authenticated;


DROP POLICY can_select_table ON collections_public.table;
DROP POLICY can_insert_table ON collections_public.table;
DROP POLICY can_update_table ON collections_public.table;
DROP POLICY can_delete_table ON collections_public.table;

DROP FUNCTION collections_private.table_policy_fn;

COMMIT;
