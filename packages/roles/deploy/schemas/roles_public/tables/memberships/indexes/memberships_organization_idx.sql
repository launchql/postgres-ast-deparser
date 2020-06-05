-- Deploy schemas/roles_public/tables/memberships/indexes/memberships_organization_idx to pg
-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/memberships/table

BEGIN;
CREATE INDEX memberships_organization_idx ON roles_public.memberships (organization_id);
COMMIT;

