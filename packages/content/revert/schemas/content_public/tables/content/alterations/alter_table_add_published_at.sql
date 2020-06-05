-- Revert schemas/content_public/tables/content/alterations/alter_table_add_published_at from pg

BEGIN;

ALTER TABLE content_public.content
    DROP COLUMN published_at;

COMMIT;
