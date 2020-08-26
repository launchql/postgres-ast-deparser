-- Deploy schemas/files_public/tables/files/indexes/files_owner_id_idx to pg

-- requires: schemas/files_public/schema
-- requires: schemas/files_public/tables/files/table

BEGIN;

CREATE INDEX files_owner_id_idx ON files_public.files (owner_id);

COMMIT;
