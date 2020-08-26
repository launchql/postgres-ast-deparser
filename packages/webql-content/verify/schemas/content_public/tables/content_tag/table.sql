-- Verify schemas/content_public/tables/content_tag/table on pg

BEGIN;

SELECT verify_table ('content_public.content_tag');

ROLLBACK;
