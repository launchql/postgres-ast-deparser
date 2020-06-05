-- Deploy schemas/collections_public/tables/database/policies/project_database_policy to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/database/table
-- requires: schemas/collections_public/tables/database/policies/enable_row_level_security

BEGIN;

-- CREATE FUNCTION collections_private.database_policy_fn(
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

CREATE POLICY can_select_database ON collections_public.database
  FOR SELECT
  USING (
    collaboration_private.permitted_on_project ('read', 'project', project_id)
  );

CREATE POLICY can_insert_database ON collections_public.database
  FOR INSERT
  WITH CHECK (
    collaboration_private.permitted_on_project ('add', 'project', project_id)
  );

CREATE POLICY can_update_database ON collections_public.database
  FOR UPDATE
  USING (
    collaboration_private.permitted_on_project ('edit', 'project', project_id)
  );

CREATE POLICY can_delete_database ON collections_public.database
  FOR DELETE
  USING (
    collaboration_private.permitted_on_project ('destroy', 'project', project_id)
  );


GRANT INSERT ON TABLE collections_public.database TO authenticated;
GRANT SELECT ON TABLE collections_public.database TO authenticated;
GRANT UPDATE ON TABLE collections_public.database TO authenticated;
GRANT DELETE ON TABLE collections_public.database TO authenticated;


COMMIT;
