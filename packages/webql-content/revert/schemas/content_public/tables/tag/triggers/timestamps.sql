-- Revert schemas/content_public/tables/tag/triggers/timestamps from pg

BEGIN;

ALTER TABLE content_public.tag DROP COLUMN created_at;
ALTER TABLE content_public.tag DROP COLUMN updated_at;
DROP TRIGGER update_content_public_tags_modtime ON content_public.tag;

COMMIT;
