-- Verify schemas/permissions_private/tables/profile_permissions/indexes/profile_permissions_organization_id_idx  on pg

BEGIN;

SELECT verify_index ('permissions_private.profile_permissions', 'profile_permissions_organization_id_idx');

ROLLBACK;
