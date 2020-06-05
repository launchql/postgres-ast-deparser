-- Deploy schemas/roles_public/tables/membership_invites/indexes/membership_invites_organization_id_idx to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/membership_invites/table

BEGIN;

CREATE INDEX membership_invites_organization_id_idx ON roles_public.membership_invites (
  organization_id
);

COMMIT;
