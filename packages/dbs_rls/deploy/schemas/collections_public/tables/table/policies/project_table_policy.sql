-- Deploy schemas/collections_public/tables/table/policies/project_table_policy to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/table/table
-- requires: schemas/collections_public/tables/table/policies/enable_row_level_security
-- requires: schemas/collections_public/tables/table/alterations/alter_table_add_project_id


BEGIN;

-- CREATE FUNCTION collections_private.table_policy_fn(
--   role_id uuid
--   -- TODO other args
-- )
--    RETURNS boolean AS
-- $$
-- BEGIN
--   -- TODO fill out policy function here
-- END;
-- $$
-- LANGUAGE 'plpgsql' STABLE SECURITY DEFINER;

CREATE POLICY can_select_table ON collections_public.table
  FOR SELECT
  USING (
    collaboration_private.permitted_on_project ('read', 'database', project_id)
  );

CREATE POLICY can_insert_table ON collections_public.table
  FOR INSERT
  WITH CHECK (
    collaboration_private.permitted_on_project ('add', 'database', project_id)
  );

CREATE POLICY can_update_table ON collections_public.table
  FOR UPDATE
  USING (
    collaboration_private.permitted_on_project ('edit', 'database', project_id)
  );

CREATE POLICY can_delete_table ON collections_public.table
  FOR DELETE
  USING (
    collaboration_private.permitted_on_project ('destroy', 'database', project_id)
  );


GRANT INSERT ON TABLE collections_public.table TO authenticated;
GRANT SELECT ON TABLE collections_public.table TO authenticated;
GRANT UPDATE ON TABLE collections_public.table TO authenticated;
GRANT DELETE ON TABLE collections_public.table TO authenticated;


COMMIT;
