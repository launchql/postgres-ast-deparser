-- Deploy schemas/roles_public/tables/memberships/indexes/memberships_invited_by_id_idx to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/memberships/table

BEGIN;
CREATE INDEX memberships_invited_by_id_idx ON roles_public.memberships (invited_by_id);
COMMIT;

