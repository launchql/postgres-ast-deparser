-- Revert schemas/content_public/tables/content/indexes/content_project_id_idx from pg

BEGIN;

DROP INDEX content_public.content_project_id_idx;

COMMIT;
