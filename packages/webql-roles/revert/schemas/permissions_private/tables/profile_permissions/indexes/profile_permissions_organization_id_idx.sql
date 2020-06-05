-- Revert schemas/permissions_private/tables/profile_permissions/indexes/profile_permissions_organization_id_idx from pg

BEGIN;

DROP INDEX permissions_private.profile_permissions_organization_id_idx;

COMMIT;
