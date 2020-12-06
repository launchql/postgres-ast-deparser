-- Revert schemas/meta_public/tables/jobs_module/table from pg

BEGIN;

DROP TABLE meta_public.jobs_module;

COMMIT;
