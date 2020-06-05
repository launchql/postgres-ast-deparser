-- Verify schemas/status_public/tables/user_achievement/table on pg

BEGIN;

SELECT verify_table ('status_public.user_feature');

ROLLBACK;
