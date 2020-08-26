-- Deploy schemas/content_public/tables/tag/policies/tags_policy to pg

-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/tag/table
-- requires: schemas/content_public/tables/tag/policies/enable_row_level_security

BEGIN;

CREATE FUNCTION content_private.tags_policy_fn(
  role_id uuid
)
   RETURNS boolean AS
$$
BEGIN
  RETURN TRUE;
END;
$$
LANGUAGE 'plpgsql' STABLE SECURITY DEFINER;

CREATE POLICY can_select_tags ON content_public.tag
  FOR SELECT
  USING (
    TRUE
  );

CREATE POLICY can_insert_tags ON content_public.tag
  FOR INSERT
  WITH CHECK (
    TRUE
  );

CREATE POLICY can_update_tags ON content_public.tag
  FOR UPDATE
  USING (
    TRUE
  );

CREATE POLICY can_delete_tags ON content_public.tag
  FOR DELETE
  USING (
    TRUE
  );


GRANT INSERT ON TABLE content_public.tag TO authenticated, anonymous;
GRANT SELECT ON TABLE content_public.tag TO authenticated, anonymous;
GRANT UPDATE ON TABLE content_public.tag TO authenticated, anonymous;
GRANT DELETE ON TABLE content_public.tag TO authenticated, anonymous;


COMMIT;
