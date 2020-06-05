-- Revert schemas/content_public/tables/content_tag/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE content_public.content_tag
    DISABLE ROW LEVEL SECURITY;

COMMIT;
