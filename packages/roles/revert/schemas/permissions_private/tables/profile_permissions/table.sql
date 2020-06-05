-- Revert schemas/permissions_private/tables/profile_permissions/table from pg

BEGIN;

DROP TABLE permissions_public.profile_permissions;

COMMIT;
