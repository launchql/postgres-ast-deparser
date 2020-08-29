-- Revert schemas/permissions_public/tables/permission/table from pg

BEGIN;

DROP TABLE permissions_public.permission;

COMMIT;
