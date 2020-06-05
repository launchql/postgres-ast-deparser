-- Deploy schemas/collaboration_public/tables/collaboration/indexes/collaboration_role_id_idx to pg

-- requires: schemas/collaboration_public/schema
-- requires: schemas/collaboration_public/tables/collaboration/table

BEGIN;

CREATE INDEX collaboration_role_id_idx ON collaboration_public.collaboration (
 role_id
);

COMMIT;
