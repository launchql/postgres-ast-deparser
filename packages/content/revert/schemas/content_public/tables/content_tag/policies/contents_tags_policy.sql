-- Revert schemas/content_public/tables/content_tag/policies/contents_tags_policy from pg

BEGIN;


REVOKE INSERT ON TABLE content_public.content_tag FROM authenticated, anonymous;
REVOKE SELECT ON TABLE content_public.content_tag FROM authenticated, anonymous;
REVOKE UPDATE ON TABLE content_public.content_tag FROM authenticated, anonymous;
REVOKE DELETE ON TABLE content_public.content_tag FROM authenticated, anonymous;


DROP POLICY can_select_contents_tags ON content_public.content_tag;
DROP POLICY can_insert_contents_tags ON content_public.content_tag;
DROP POLICY can_update_contents_tags ON content_public.content_tag;
DROP POLICY can_delete_contents_tags ON content_public.content_tag;

DROP FUNCTION content_private.contents_tags_policy_fn;

COMMIT;
