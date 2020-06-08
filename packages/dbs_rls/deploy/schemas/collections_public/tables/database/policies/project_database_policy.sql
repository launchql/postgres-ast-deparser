-- Deploy schemas/collections_public/tables/database/policies/project_database_policy to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/database/table
-- requires: schemas/collections_public/tables/database/policies/enable_row_level_security
-- requires: schemas/collections_public/tables/database/alterations/alter_table_add_project_id

BEGIN;

CREATE POLICY can_select_database ON collections_public.database
  FOR SELECT
  USING (
    collaboration_private.permitted_on_project ('read', 'database', project_id)
  );

CREATE POLICY can_insert_database ON collections_public.database
  FOR INSERT
  WITH CHECK (
    collaboration_private.permitted_on_project ('add', 'database', project_id)
  );

CREATE POLICY can_update_database ON collections_public.database
  FOR UPDATE
  USING (
    collaboration_private.permitted_on_project ('edit', 'database', project_id)
  );

CREATE POLICY can_delete_database ON collections_public.database
  FOR DELETE
  USING (
    collaboration_private.permitted_on_project ('destroy', 'database', project_id)
  );

GRANT INSERT ON TABLE collections_public.database TO authenticated;
GRANT SELECT ON TABLE collections_public.database TO authenticated;
GRANT UPDATE ON TABLE collections_public.database TO authenticated;
GRANT DELETE ON TABLE collections_public.database TO authenticated;

COMMIT;
