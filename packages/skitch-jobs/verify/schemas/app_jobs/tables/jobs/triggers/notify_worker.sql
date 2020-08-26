-- Verify schemas/app_jobs/tables/jobs/triggers/notify_worker  on pg

BEGIN;


SELECT verify_trigger ('app_jobs.notify_worker');

ROLLBACK;
