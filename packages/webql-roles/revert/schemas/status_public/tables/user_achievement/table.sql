-- Revert schemas/status_public/tables/user_achievement/table from pg

BEGIN;

DROP TABLE status_public.user_feature;

COMMIT;
