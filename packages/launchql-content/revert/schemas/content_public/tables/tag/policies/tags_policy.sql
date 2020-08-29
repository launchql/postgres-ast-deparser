-- Revert schemas/content_public/tables/tag/policies/tags_policy from pg

BEGIN;


REVOKE INSERT ON TABLE content_public.tag FROM authenticated, anonymous;
REVOKE SELECT ON TABLE content_public.tag FROM authenticated, anonymous;
REVOKE UPDATE ON TABLE content_public.tag FROM authenticated, anonymous;
REVOKE DELETE ON TABLE content_public.tag FROM authenticated, anonymous;


DROP POLICY can_select_tags ON content_public.tag;
DROP POLICY can_insert_tags ON content_public.tag;
DROP POLICY can_update_tags ON content_public.tag;
DROP POLICY can_delete_tags ON content_public.tag;

DROP FUNCTION content_private.tags_policy_fn;

COMMIT;
