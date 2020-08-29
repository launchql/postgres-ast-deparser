-- Deploy schemas/roles_public/tables/memberships/indexes/memberships_group_id_idx to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/memberships/table

BEGIN;

CREATE INDEX memberships_group_id_idx ON roles_public.memberships (
 group_id
);

COMMIT;
