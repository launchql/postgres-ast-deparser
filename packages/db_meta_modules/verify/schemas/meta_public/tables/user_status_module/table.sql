-- Verify schemas/meta_public/tables/user_status_module/table on pg

BEGIN;

SELECT verify_table ('meta_public.user_status_module');

ROLLBACK;
