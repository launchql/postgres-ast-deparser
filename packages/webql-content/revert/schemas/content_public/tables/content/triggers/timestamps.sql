-- Revert schemas/content_public/tables/content/triggers/timestamps from pg

BEGIN;

ALTER TABLE content_public.content DROP COLUMN created_at;
ALTER TABLE content_public.content DROP COLUMN updated_at;
DROP TRIGGER update_content_public_contents_modtime ON content_public.content;

COMMIT;
