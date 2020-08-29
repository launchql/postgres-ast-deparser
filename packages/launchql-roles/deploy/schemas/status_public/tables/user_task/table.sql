-- Deploy schemas/status_public/tables/user_task/table to pg
-- requires: schemas/status_public/schema
-- requires: schemas/status_public/tables/user_achievement/table

BEGIN;
CREATE TABLE status_public.user_task (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  name citext NOT NULL,
  achievement_id uuid NOT NULL REFERENCES status_public.user_achievement (id) ON DELETE CASCADE,
  priority int DEFAULT 10000,
  UNIQUE (name)
);
COMMIT;

