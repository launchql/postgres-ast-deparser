-- Deploy schemas/content_public/tables/content/indexes/content_project_id_idx to pg

-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/content/table

BEGIN;

CREATE INDEX content_project_id_idx ON content_public.content (
 project_id
);

COMMIT;
