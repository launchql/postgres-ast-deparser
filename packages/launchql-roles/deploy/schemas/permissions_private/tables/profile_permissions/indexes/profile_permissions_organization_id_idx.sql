-- Deploy schemas/permissions_private/tables/profile_permissions/indexes/profile_permissions_organization_id_idx to pg

-- requires: schemas/permissions_private/schema
-- requires: schemas/permissions_private/tables/profile_permissions/table

BEGIN;

CREATE INDEX profile_permissions_organization_id_idx ON permissions_private.profile_permissions (
 organization_id
);

COMMIT;
