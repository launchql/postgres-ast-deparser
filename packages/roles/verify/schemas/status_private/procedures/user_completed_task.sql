-- Verify schemas/status_private/procedures/user_completed_task  on pg

BEGIN;

SELECT verify_function ('status_private.user_completed_task');

ROLLBACK;
