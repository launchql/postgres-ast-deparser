-- Revert schemas/website_private/tables/contact_form_message/triggers/timestamps from pg

BEGIN;

ALTER TABLE website_private.contact_form_message DROP COLUMN created_at;
ALTER TABLE website_private.contact_form_message DROP COLUMN updated_at;
DROP TRIGGER update_website_private_contact_form_message_modtime ON website_private.contact_form_message;

COMMIT;
