-- Revert schemas/permissions_public/tables/profile/table from pg

BEGIN;

DROP TABLE permissions_public.profile;

COMMIT;
