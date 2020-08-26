-- Revert schemas/website_private/tables/contact_form_message/table from pg

BEGIN;

DROP TABLE website_private.contact_form_message;

COMMIT;
