-- Verify schemas/website_private/tables/contact_form_message/triggers/timestamps  on pg

BEGIN;

SELECT created_at FROM website_private.contact_form_message LIMIT 1;
SELECT updated_at FROM website_private.contact_form_message LIMIT 1;
SELECT verify_trigger ('website_private.update_website_private_contact_form_message_modtime');

ROLLBACK;
