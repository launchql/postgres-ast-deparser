-- Revert schemas/status_public/tables/user_task/table from pg

BEGIN;

DROP TABLE status_public.user_task;

COMMIT;
