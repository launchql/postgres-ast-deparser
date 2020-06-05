-- Revert schemas/content_public/tables/content_tag/table from pg

BEGIN;

DROP TABLE content_public.content_tag;

COMMIT;
