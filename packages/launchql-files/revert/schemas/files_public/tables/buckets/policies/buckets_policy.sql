-- Revert schemas/files_public/tables/buckets/policies/buckets_policy from pg

BEGIN;


REVOKE INSERT ON TABLE files_public.buckets FROM authenticated;
REVOKE SELECT ON TABLE files_public.buckets FROM authenticated;
REVOKE UPDATE ON TABLE files_public.buckets FROM authenticated;
REVOKE DELETE ON TABLE files_public.buckets FROM authenticated;


DROP POLICY can_select_buckets ON files_public.buckets;
DROP POLICY can_insert_buckets ON files_public.buckets;
DROP POLICY can_update_buckets ON files_public.buckets;
DROP POLICY can_delete_buckets ON files_public.buckets;

DROP FUNCTION files_private.buckets_policy_fn;

COMMIT;
