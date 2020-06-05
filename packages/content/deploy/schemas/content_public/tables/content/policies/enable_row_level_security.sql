-- Deploy schemas/content_public/tables/content/policies/enable_row_level_security to pg

-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/content/table

BEGIN;

ALTER TABLE content_public.content
    ENABLE ROW LEVEL SECURITY;

COMMIT;
