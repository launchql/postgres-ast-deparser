-- Deploy schemas/collections_public/tables/primary_key_constraint/policies/project_primary_key_policy to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/primary_key_constraint/table
-- requires: schemas/collections_public/tables/primary_key_constraint/policies/enable_row_level_security
-- requires: schemas/collections_public/tables/constraint/triggers/before_insert_constraint_set_project_id 

BEGIN;

-- CREATE FUNCTION collections_private.primary_key_constraint_policy_fn(
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

CREATE POLICY can_select_primary_key_constraint ON collections_public.primary_key_constraint
  FOR SELECT
  USING (
    collaboration_private.permitted_on_project ('read', 'database', project_id)
  );

CREATE POLICY can_insert_primary_key_constraint ON collections_public.primary_key_constraint
  FOR INSERT
  WITH CHECK (
    collaboration_private.permitted_on_project ('add', 'database', project_id)
  );

CREATE POLICY can_update_primary_key_constraint ON collections_public.primary_key_constraint
  FOR UPDATE
  USING (
    collaboration_private.permitted_on_project ('edit', 'database', project_id)
  );

CREATE POLICY can_delete_primary_key_constraint ON collections_public.primary_key_constraint
  FOR DELETE
  USING (
    collaboration_private.permitted_on_project ('destroy', 'database', project_id)
  );


GRANT INSERT ON TABLE collections_public.primary_key_constraint TO authenticated;
GRANT SELECT ON TABLE collections_public.primary_key_constraint TO authenticated;
GRANT UPDATE ON TABLE collections_public.primary_key_constraint TO authenticated;
GRANT DELETE ON TABLE collections_public.primary_key_constraint TO authenticated;


COMMIT;
