-- Deploy schemas/content_public/tables/content/triggers/timestamps to pg

-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/content/table

BEGIN;

ALTER TABLE content_public.content ADD COLUMN created_at TIMESTAMPTZ;
ALTER TABLE content_public.content ALTER COLUMN created_at SET DEFAULT NOW();

ALTER TABLE content_public.content ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE content_public.content ALTER COLUMN updated_at SET DEFAULT NOW();

CREATE TRIGGER update_content_public_contents_modtime
BEFORE UPDATE OR INSERT ON content_public.content
FOR EACH ROW
EXECUTE PROCEDURE tg_update_timestamps();

COMMIT;
