-- Verify schemas/meta_public/tables/jobs_module/table on pg

BEGIN;

SELECT verify_table ('meta_public.jobs_module');

ROLLBACK;
