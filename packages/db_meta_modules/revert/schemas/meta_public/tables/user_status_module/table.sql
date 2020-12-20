-- Revert schemas/meta_public/tables/user_status_module/table from pg

BEGIN;

DROP TABLE meta_public.user_status_module;

COMMIT;
