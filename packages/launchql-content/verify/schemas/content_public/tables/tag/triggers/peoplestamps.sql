-- Verify schemas/content_public/tables/tag/triggers/peoplestamps  on pg

BEGIN;

SELECT created_by FROM content_public.tag LIMIT 1;
SELECT updated_by FROM content_public.tag LIMIT 1;
SELECT verify_trigger ('content_public.update_content_public_tags_moduser');

ROLLBACK;
