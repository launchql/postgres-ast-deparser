-- Deploy schemas/collections_public/tables/field/policies/project_field_policy to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/field/table
-- requires: schemas/collections_public/tables/field/policies/enable_row_level_security
-- requires: schemas/collections_public/tables/field/alterations/alter_table_add_project_id


BEGIN;

CREATE POLICY can_select_field ON collections_public.field
  FOR SELECT
  USING (
    collaboration_private.permitted_on_project ('read', 'database', project_id)
  );

CREATE POLICY can_insert_field ON collections_public.field
  FOR INSERT
  WITH CHECK (
    collaboration_private.permitted_on_project ('add', 'database', project_id)
  );

CREATE POLICY can_update_field ON collections_public.field
  FOR UPDATE
  USING (
    collaboration_private.permitted_on_project ('edit', 'database', project_id)
  );

CREATE POLICY can_delete_field ON collections_public.field
  FOR DELETE
  USING (
    collaboration_private.permitted_on_project ('destroy', 'database', project_id)
  );


GRANT INSERT ON TABLE collections_public.field TO authenticated;
GRANT SELECT ON TABLE collections_public.field TO authenticated;
GRANT UPDATE ON TABLE collections_public.field TO authenticated;
GRANT DELETE ON TABLE collections_public.field TO authenticated;


COMMIT;
