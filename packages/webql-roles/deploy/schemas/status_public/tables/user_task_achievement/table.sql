-- Deploy schemas/status_public/tables/user_task_achievement/table to pg

-- requires: schemas/status_public/schema
-- requires: schemas/status_public/tables/user_task/table
-- requires: schemas/roles_public/tables/roles/table

BEGIN;

CREATE TABLE status_public.user_task_achievement (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  task_id uuid NOT NULL REFERENCES status_public.user_task (id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES roles_public.roles (id) ON DELETE CASCADE
);

COMMIT;
