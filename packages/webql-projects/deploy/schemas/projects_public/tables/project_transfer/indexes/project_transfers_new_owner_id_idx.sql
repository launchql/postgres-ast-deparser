-- Deploy schemas/projects_public/tables/project_transfer/indexes/project_transfers_new_owner_id_idx to pg

-- requires: schemas/projects_public/schema
-- requires: schemas/projects_public/tables/project_transfer/table

BEGIN;

CREATE INDEX project_transfers_new_owner_id_idx ON projects_public.project_transfer (
  new_owner_id
);

COMMIT;
