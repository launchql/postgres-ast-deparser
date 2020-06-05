-- Revert schemas/content_public/tables/content/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE content_public.content
    DISABLE ROW LEVEL SECURITY;

COMMIT;
