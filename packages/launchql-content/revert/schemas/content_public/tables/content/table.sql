-- Revert schemas/content_public/tables/content/table from pg

BEGIN;

DROP TABLE content_public.content;

COMMIT;
