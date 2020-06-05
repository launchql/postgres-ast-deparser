-- Deploy schemas/content_public/tables/tag/policies/enable_row_level_security to pg

-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/tag/table

BEGIN;

ALTER TABLE content_public.tag
    ENABLE ROW LEVEL SECURITY;

COMMIT;
