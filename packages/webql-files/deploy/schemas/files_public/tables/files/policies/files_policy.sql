-- Deploy schemas/files_public/tables/files/policies/files_policy to pg
-- requires: schemas/files_public/schema
-- requires: schemas/files_public/tables/files/table
-- requires: schemas/files_public/tables/files/policies/enable_row_level_security

BEGIN;
CREATE POLICY can_select_files ON files_public.files
  FOR SELECT
    USING (permissions_private.permitted_on_role ('browse', 'content', owner_id));
CREATE POLICY can_insert_files ON files_public.files
  FOR INSERT
    WITH CHECK (permissions_private.permitted_on_role ('upload', 'content', owner_id));
CREATE POLICY can_update_files ON files_public.files
  FOR UPDATE
    USING (permissions_private.permitted_on_role ('edit', 'content', owner_id));
CREATE POLICY can_delete_files ON files_public.files
  FOR DELETE
    USING (permissions_private.permitted_on_role ('destroy', 'content', owner_id));
GRANT INSERT ON TABLE files_public.files TO authenticated;
GRANT SELECT ON TABLE files_public.files TO authenticated;
GRANT UPDATE ON TABLE files_public.files TO authenticated;
GRANT DELETE ON TABLE files_public.files TO authenticated;
COMMIT;

