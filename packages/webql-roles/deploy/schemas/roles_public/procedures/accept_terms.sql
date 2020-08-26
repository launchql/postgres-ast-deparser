-- Deploy schemas/roles_public/procedures/accept_terms to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/procedures/current_role_id
-- requires: schemas/status_private/procedures/user_completed_task

BEGIN;
CREATE FUNCTION roles_public.accept_terms ()
  RETURNS boolean
  AS $$
  BEGIN
  PERFORM
    status_private.user_completed_task ('accept_terms');
RETURN TRUE;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE;
COMMIT;

