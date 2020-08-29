-- Deploy schemas/collaboration_public/tables/collaboration/indexes/collaboration_project_id_idx to pg

-- requires: schemas/collaboration_public/schema
-- requires: schemas/collaboration_public/tables/collaboration/table

BEGIN;

CREATE INDEX collaboration_project_id_idx ON collaboration_public.collaboration (
 project_id
);

COMMIT;
