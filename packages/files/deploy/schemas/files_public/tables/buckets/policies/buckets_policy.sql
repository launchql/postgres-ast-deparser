-- Deploy schemas/files_public/tables/buckets/policies/buckets_policy to pg
-- requires: schemas/files_public/schema
-- requires: schemas/files_public/tables/buckets/table
-- requires: schemas/files_public/tables/buckets/policies/enable_row_level_security

BEGIN;
CREATE POLICY can_select_buckets ON files_public.buckets
  FOR SELECT
    USING (permissions_private.permitted_on_role ('read', 'project', owner_id));
CREATE POLICY can_insert_buckets ON files_public.buckets
  FOR INSERT
    WITH CHECK (permissions_private.permitted_on_role ('add', 'project', owner_id));
CREATE POLICY can_update_buckets ON files_public.buckets
  FOR UPDATE
    USING (permissions_private.permitted_on_role ('edit', 'project', owner_id));
CREATE POLICY can_delete_buckets ON files_public.buckets
  FOR DELETE
    USING (permissions_private.permitted_on_role ('destroy', 'project', owner_id));
GRANT INSERT ON TABLE files_public.buckets TO authenticated;
GRANT SELECT ON TABLE files_public.buckets TO authenticated;
GRANT UPDATE ON TABLE files_public.buckets TO authenticated;
GRANT DELETE ON TABLE files_public.buckets TO authenticated;
COMMIT;

