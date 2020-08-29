-- Revert schemas/content_public/tables/content/policies/content_policy from pg

BEGIN;


REVOKE INSERT ON TABLE content_public.content FROM authenticated, anonymous;
REVOKE SELECT ON TABLE content_public.content FROM authenticated, anonymous;
REVOKE UPDATE ON TABLE content_public.content FROM authenticated, anonymous;
REVOKE DELETE ON TABLE content_public.content FROM authenticated, anonymous;


DROP POLICY can_select_contents ON content_public.content;
DROP POLICY can_insert_contents ON content_public.content;
DROP POLICY can_update_contents ON content_public.content;
DROP POLICY can_delete_contents ON content_public.content;

DROP FUNCTION content_private.contents_policy_fn;

COMMIT;
