-- Revert schemas/collections_public/tables/database/policies/project_database_policy from pg

BEGIN;


REVOKE INSERT ON TABLE collections_public.database FROM authenticated;
REVOKE SELECT ON TABLE collections_public.database FROM authenticated;
REVOKE UPDATE ON TABLE collections_public.database FROM authenticated;
REVOKE DELETE ON TABLE collections_public.database FROM authenticated;


DROP POLICY can_select_database ON collections_public.database;
DROP POLICY can_insert_database ON collections_public.database;
DROP POLICY can_update_database ON collections_public.database;
DROP POLICY can_delete_database ON collections_public.database;

DROP FUNCTION collections_private.database_policy_fn;

COMMIT;
