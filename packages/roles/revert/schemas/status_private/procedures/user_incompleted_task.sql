-- Revert schemas/status_private/procedures/user_incompleted_task from pg

BEGIN;

DROP FUNCTION status_private.user_incompleted_task;

COMMIT;
