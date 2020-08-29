-- Verify schemas/content_public/tables/content/indexes/content_project_id_idx  on pg

BEGIN;

SELECT verify_index ('content_public.content', 'content_project_id_idx');

ROLLBACK;
