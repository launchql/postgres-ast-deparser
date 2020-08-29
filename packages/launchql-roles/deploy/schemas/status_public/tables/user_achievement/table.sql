-- Deploy schemas/status_public/tables/user_achievement/table to pg
-- requires: schemas/status_public/schema

BEGIN;
CREATE TABLE status_public.user_achievement (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  name citext NOT NULL,
  UNIQUE (name)
);
COMMIT;

