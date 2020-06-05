-- Deploy schemas/website_private/tables/contact_form_message/triggers/timestamps to pg

-- requires: schemas/website_private/schema
-- requires: schemas/website_private/tables/contact_form_message/table

BEGIN;

ALTER TABLE website_private.contact_form_message ADD COLUMN created_at TIMESTAMPTZ;
ALTER TABLE website_private.contact_form_message ALTER COLUMN created_at SET DEFAULT NOW();

ALTER TABLE website_private.contact_form_message ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE website_private.contact_form_message ALTER COLUMN updated_at SET DEFAULT NOW();

CREATE TRIGGER update_website_private_contact_form_message_modtime
BEFORE UPDATE OR INSERT ON website_private.contact_form_message
FOR EACH ROW
EXECUTE PROCEDURE tg_update_timestamps();

COMMIT;
