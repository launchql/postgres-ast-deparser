-- Revert schemas/status_public/tables/user_task_achievement/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE status_public.user_task_achievement
    DISABLE ROW LEVEL SECURITY;

COMMIT;
