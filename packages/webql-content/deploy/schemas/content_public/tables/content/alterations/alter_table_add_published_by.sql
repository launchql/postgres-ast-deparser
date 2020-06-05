-- Deploy schemas/content_public/tables/content/alterations/alter_table_add_published_by to pg

-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/content/table

BEGIN;

ALTER TABLE content_public.content
    ADD COLUMN published_by UUID NULL;

COMMIT;
