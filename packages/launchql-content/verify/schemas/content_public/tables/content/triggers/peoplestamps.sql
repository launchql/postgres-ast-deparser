-- Verify schemas/content_public/tables/content/triggers/peoplestamps  on pg

BEGIN;

SELECT created_by FROM content_public.content LIMIT 1;
SELECT updated_by FROM content_public.content LIMIT 1;
SELECT verify_trigger ('content_public.update_content_public_contents_moduser');

ROLLBACK;
