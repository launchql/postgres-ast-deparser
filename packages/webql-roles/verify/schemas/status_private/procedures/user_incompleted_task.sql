-- Verify schemas/status_private/procedures/user_incompleted_task  on pg

BEGIN;

SELECT verify_function ('status_private.user_incompleted_task');

ROLLBACK;
