-- Deploy schemas/content_public/tables/content/policies/content_policy to pg
-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/content/table
-- requires: schemas/content_public/tables/content/policies/enable_row_level_security

BEGIN;
CREATE POLICY can_select_contents ON content_public.content
  FOR SELECT
    USING (collaboration_private.permitted_on_project ('read', 'content', project_id));
CREATE POLICY can_insert_contents ON content_public.content
  FOR INSERT
    WITH CHECK (collaboration_private.permitted_on_project ('add', 'content', project_id));
CREATE POLICY can_update_contents ON content_public.content
  FOR UPDATE
    USING (collaboration_private.permitted_on_project ('edit', 'content', project_id));
CREATE POLICY can_delete_contents ON content_public.content
  FOR DELETE
    USING (collaboration_private.permitted_on_project ('destroy', 'content', project_id));
GRANT INSERT ON TABLE content_public.content TO authenticated, anonymous;
GRANT SELECT ON TABLE content_public.content TO authenticated, anonymous;
GRANT UPDATE ON TABLE content_public.content TO authenticated, anonymous;
GRANT DELETE ON TABLE content_public.content TO authenticated, anonymous;
COMMIT;

