-- Deploy schemas/status_public/tables/user_task/grants/grant_select_to_authenticated to pg

-- requires: schemas/status_public/schema
-- requires: schemas/status_public/tables/user_task/table

BEGIN;

GRANT SELECT ON TABLE status_public.user_task TO authenticated;

COMMIT;
