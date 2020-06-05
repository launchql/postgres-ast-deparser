-- Verify schemas/content_public/tables/content/table on pg

BEGIN;

SELECT verify_table ('content_public.content');

ROLLBACK;
