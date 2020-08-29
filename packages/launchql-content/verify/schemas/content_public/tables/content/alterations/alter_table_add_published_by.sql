-- Verify schemas/content_public/tables/content/alterations/alter_table_add_published_by  on pg

BEGIN;

SELECT published_by FROM content_public.content LIMIT 1;

ROLLBACK;
