-- Revert schemas/content_public/tables/tag/triggers/peoplestamps from pg

BEGIN;

ALTER TABLE content_public.tag DROP COLUMN created_by;
ALTER TABLE content_public.tag DROP COLUMN updated_by;
DROP TRIGGER update_content_public_tags_moduser ON content_public.tag;

COMMIT;
