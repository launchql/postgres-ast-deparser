-- Verify schemas/content_public/tables/content/triggers/timestamps  on pg

BEGIN;

SELECT created_at FROM content_public.content LIMIT 1;
SELECT updated_at FROM content_public.content LIMIT 1;
SELECT verify_trigger ('content_public.update_content_public_contents_modtime');

ROLLBACK;
