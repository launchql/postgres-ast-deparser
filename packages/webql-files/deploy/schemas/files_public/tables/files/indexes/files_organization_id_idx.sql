-- Deploy schemas/files_public/tables/files/indexes/files_organization_id_idx to pg

-- requires: schemas/files_public/schema
-- requires: schemas/files_public/tables/files/table

BEGIN;

CREATE INDEX files_organization_id_idx ON files_public.files (organization_id);

COMMIT;
