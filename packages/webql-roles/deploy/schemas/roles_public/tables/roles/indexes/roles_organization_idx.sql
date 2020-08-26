-- Deploy schemas/roles_public/tables/roles/indexes/roles_organization_idx to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table

BEGIN;

CREATE INDEX roles_organization_idx ON roles_public.roles (organization_id);

COMMIT;
