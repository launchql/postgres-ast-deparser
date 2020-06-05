-- Verify schemas/app_jobs/tables/jobs/alterations/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('app_jobs.jobs');

ROLLBACK;
