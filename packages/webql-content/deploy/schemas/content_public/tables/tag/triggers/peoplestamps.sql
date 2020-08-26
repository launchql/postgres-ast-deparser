-- Deploy schemas/content_public/tables/tag/triggers/peoplestamps to pg

-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/tag/table

BEGIN;

ALTER TABLE content_public.tag ADD COLUMN created_by UUID;
ALTER TABLE content_public.tag ADD COLUMN updated_by UUID;

CREATE TRIGGER update_content_public_tags_moduser
BEFORE UPDATE OR INSERT ON content_public.tag
FOR EACH ROW
EXECUTE PROCEDURE tg_update_peoplestamps();

COMMIT;
