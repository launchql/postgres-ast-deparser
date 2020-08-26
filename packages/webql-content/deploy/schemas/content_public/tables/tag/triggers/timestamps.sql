-- Deploy schemas/content_public/tables/tag/triggers/timestamps to pg

-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/tag/table

BEGIN;

ALTER TABLE content_public.tag ADD COLUMN created_at TIMESTAMPTZ;
ALTER TABLE content_public.tag ALTER COLUMN created_at SET DEFAULT NOW();

ALTER TABLE content_public.tag ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE content_public.tag ALTER COLUMN updated_at SET DEFAULT NOW();

CREATE TRIGGER update_content_public_tags_modtime
BEFORE UPDATE OR INSERT ON content_public.tag
FOR EACH ROW
EXECUTE PROCEDURE tg_update_timestamps();

COMMIT;
