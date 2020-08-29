-- Revert schemas/content_public/tables/tag/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE content_public.tag
    DISABLE ROW LEVEL SECURITY;

COMMIT;
