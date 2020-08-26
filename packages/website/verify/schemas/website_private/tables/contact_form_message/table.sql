-- Verify schemas/website_private/tables/contact_form_message/table on pg

BEGIN;

SELECT verify_table ('website_private.contact_form_message');

ROLLBACK;
