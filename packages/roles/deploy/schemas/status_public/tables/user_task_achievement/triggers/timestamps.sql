-- Deploy schemas/status_public/tables/user_task_achievement/triggers/timestamps to pg

-- requires: schemas/status_public/schema
-- requires: schemas/status_public/tables/user_task_achievement/table

BEGIN;

ALTER TABLE status_public.user_task_achievement ADD COLUMN created_at TIMESTAMPTZ;
ALTER TABLE status_public.user_task_achievement ALTER COLUMN created_at SET DEFAULT NOW();

ALTER TABLE status_public.user_task_achievement ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE status_public.user_task_achievement ALTER COLUMN updated_at SET DEFAULT NOW();

CREATE TRIGGER update_status_public_user_task_achievement_modtime
BEFORE UPDATE OR INSERT ON status_public.user_task_achievement
FOR EACH ROW
EXECUTE PROCEDURE tg_update_timestamps();

COMMIT;
