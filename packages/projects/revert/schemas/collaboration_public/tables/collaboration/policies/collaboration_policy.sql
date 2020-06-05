-- Revert schemas/collaboration_public/tables/collaboration/policies/collaboration_policy from pg

BEGIN;

REVOKE INSERT ON TABLE collaboration_public.collaboration FROM authenticated;
REVOKE SELECT ON TABLE collaboration_public.collaboration FROM authenticated;
REVOKE UPDATE ON TABLE collaboration_public.collaboration FROM authenticated;
REVOKE DELETE ON TABLE collaboration_public.collaboration FROM authenticated;

DROP POLICY can_select_collaboration ON collaboration_public.collaboration;
DROP POLICY can_insert_collaboration ON collaboration_public.collaboration;
DROP POLICY can_update_collaboration ON collaboration_public.collaboration;
DROP POLICY can_delete_collaboration ON collaboration_public.collaboration;

COMMIT;
