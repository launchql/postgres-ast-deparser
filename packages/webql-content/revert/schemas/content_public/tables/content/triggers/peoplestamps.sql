-- Revert schemas/content_public/tables/content/triggers/peoplestamps from pg

BEGIN;

ALTER TABLE content_public.content DROP COLUMN created_by;
ALTER TABLE content_public.content DROP COLUMN updated_by;
DROP TRIGGER update_content_public_contents_moduser ON content_public.content;

COMMIT;
