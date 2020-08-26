-- Deploy schemas/content_public/tables/content_tag/policies/contents_tags_policy to pg

-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/content_tag/table
-- requires: schemas/content_public/tables/content_tag/policies/enable_row_level_security

BEGIN;

CREATE FUNCTION content_private.contents_tags_policy_fn(
  role_id uuid
)
   RETURNS boolean AS
$$
BEGIN
  RETURN TRUE;
END;
$$
LANGUAGE 'plpgsql' STABLE SECURITY DEFINER;

CREATE POLICY can_select_contents_tags ON content_public.content_tag
  FOR SELECT
  USING (
    TRUE
  );

CREATE POLICY can_insert_contents_tags ON content_public.content_tag
  FOR INSERT
  WITH CHECK (
    TRUE
  );

CREATE POLICY can_update_contents_tags ON content_public.content_tag
  FOR UPDATE
  USING (
    TRUE
  );

CREATE POLICY can_delete_contents_tags ON content_public.content_tag
  FOR DELETE
  USING (
    TRUE
  );


GRANT INSERT ON TABLE content_public.content_tag TO authenticated, anonymous;
GRANT SELECT ON TABLE content_public.content_tag TO authenticated, anonymous;
GRANT UPDATE ON TABLE content_public.content_tag TO authenticated, anonymous;
GRANT DELETE ON TABLE content_public.content_tag TO authenticated, anonymous;


COMMIT;
