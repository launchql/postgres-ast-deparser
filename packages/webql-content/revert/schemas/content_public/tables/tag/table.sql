-- Revert schemas/content_public/tables/tag/table from pg

BEGIN;

DROP TABLE content_public.tag;

COMMIT;
