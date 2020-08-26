-- Deploy schemas/content_public/tables/content/triggers/peoplestamps to pg

-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/content/table

BEGIN;

ALTER TABLE content_public.content ADD COLUMN created_by UUID;
ALTER TABLE content_public.content ADD COLUMN updated_by UUID;

CREATE TRIGGER update_content_public_contents_moduser
BEFORE UPDATE OR INSERT ON content_public.content
FOR EACH ROW
EXECUTE PROCEDURE tg_update_peoplestamps();

COMMIT;
