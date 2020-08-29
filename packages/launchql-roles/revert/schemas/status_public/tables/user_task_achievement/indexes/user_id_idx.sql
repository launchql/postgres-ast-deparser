-- Revert schemas/status_public/tables/user_task_achievement/indexes/user_id_idx from pg

BEGIN;

DROP INDEX status_public.user_id_idx;

COMMIT;
