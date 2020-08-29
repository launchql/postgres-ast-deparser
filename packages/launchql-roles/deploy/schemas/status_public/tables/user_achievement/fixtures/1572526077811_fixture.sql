-- Deploy schemas/status_public/tables/user_achievement/fixtures/1572526077811_fixture to pg
-- requires: schemas/status_public/schema
-- requires: schemas/status_public/tables/user_achievement/table

BEGIN;
INSERT INTO status_public.user_achievement (name)
  VALUES ('profile_complete');
COMMIT;

