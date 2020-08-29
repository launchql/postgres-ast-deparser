-- Deploy schemas/roles_public/tables/roles/indexes/parent_idx to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table

BEGIN;

CREATE INDEX parent_idx ON roles_public.roles (parent_id);

COMMIT;
