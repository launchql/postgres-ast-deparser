-- Deploy schemas/content_public/tables/content_tag/table to pg

-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/tag/table
-- requires: schemas/content_public/tables/content/table

BEGIN;

CREATE TABLE content_public.content_tag (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    project_id uuid NOT NULL REFERENCES projects_public.project ON DELETE CASCADE,
    content_id uuid NOT NULL REFERENCES content_public.content ON DELETE CASCADE,
    tag_id uuid NOT NULL REFERENCES content_public.tag ON DELETE CASCADE,
    UNIQUE (content_id, tag_id)
);

COMMIT;
