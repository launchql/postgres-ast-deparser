-- Verify schemas/content_public/tables/tag/table on pg

BEGIN;

SELECT verify_table ('content_public.tag');

ROLLBACK;
