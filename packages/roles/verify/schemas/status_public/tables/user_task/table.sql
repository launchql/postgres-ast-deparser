-- Verify schemas/status_public/tables/user_task/table on pg

BEGIN;

SELECT verify_table ('status_public.user_task');

ROLLBACK;
