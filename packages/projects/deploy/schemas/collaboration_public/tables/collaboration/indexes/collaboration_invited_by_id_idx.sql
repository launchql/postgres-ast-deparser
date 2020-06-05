-- Deploy schemas/collaboration_public/tables/collaboration/indexes/collaboration_invited_by_id_idx to pg

-- requires: schemas/collaboration_public/schema
-- requires: schemas/collaboration_public/tables/collaboration/table

BEGIN;

CREATE INDEX collaboration_invited_by_id_idx ON collaboration_public.collaboration (
 invited_by_id
);

COMMIT;
