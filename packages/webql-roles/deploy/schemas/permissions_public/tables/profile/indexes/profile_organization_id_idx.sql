-- Deploy schemas/permissions_public/tables/profile/indexes/profile_organization_id_idx to pg

-- requires: schemas/permissions_public/schema
-- requires: schemas/permissions_public/tables/profile/table

BEGIN;

CREATE INDEX profile_organization_id_idx ON permissions_public.profile (
 organization_id
);

COMMIT;
