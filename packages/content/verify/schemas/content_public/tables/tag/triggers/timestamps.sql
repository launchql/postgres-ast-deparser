-- Verify schemas/content_public/tables/tag/triggers/timestamps  on pg

BEGIN;

SELECT created_at FROM content_public.tag LIMIT 1;
SELECT updated_at FROM content_public.tag LIMIT 1;
SELECT verify_trigger ('content_public.update_content_public_tags_modtime');

ROLLBACK;
