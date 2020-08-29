-- Verify schemas/content_public/tables/content/alterations/alter_table_add_published_at  on pg

BEGIN;

SELECT published_at FROM content_public.content LIMIT 1;

ROLLBACK;
