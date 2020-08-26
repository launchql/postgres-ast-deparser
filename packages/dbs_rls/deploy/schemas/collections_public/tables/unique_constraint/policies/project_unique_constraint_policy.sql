-- Deploy schemas/collections_public/tables/unique_constraint/policies/project_unique_constraint_policy to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/unique_constraint/table
-- requires: schemas/collections_public/tables/unique_constraint/policies/enable_row_level_security
-- requires: schemas/collections_public/tables/constraint/alterations/alter_table_add_project_id 

BEGIN;

CREATE POLICY can_select_unique_constraint ON collections_public.unique_constraint
  FOR SELECT
  USING (
    collaboration_private.permitted_on_project ('read', 'database', project_id)
  );

CREATE POLICY can_insert_unique_constraint ON collections_public.unique_constraint
  FOR INSERT
  WITH CHECK (
    collaboration_private.permitted_on_project ('add', 'database', project_id)
  );

CREATE POLICY can_update_unique_constraint ON collections_public.unique_constraint
  FOR UPDATE
  USING (
    collaboration_private.permitted_on_project ('edit', 'database', project_id)
  );

CREATE POLICY can_delete_unique_constraint ON collections_public.unique_constraint
  FOR DELETE
  USING (
    collaboration_private.permitted_on_project ('destroy', 'database', project_id)
  );


GRANT INSERT ON TABLE collections_public.unique_constraint TO authenticated;
GRANT SELECT ON TABLE collections_public.unique_constraint TO authenticated;
GRANT UPDATE ON TABLE collections_public.unique_constraint TO authenticated;
GRANT DELETE ON TABLE collections_public.unique_constraint TO authenticated;


COMMIT;
