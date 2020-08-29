-- Deploy schemas/content_public/tables/content_tag/policies/enable_row_level_security to pg

-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/content_tag/table

BEGIN;

ALTER TABLE content_public.content_tag
    ENABLE ROW LEVEL SECURITY;

COMMIT;
