-- Verify schemas/permissions_private/tables/profile_permissions/table on pg

BEGIN;

SELECT verify_table ('permissions_public.profile_permissions');

ROLLBACK;
