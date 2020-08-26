-- Verify schemas/website_public/procedures/submit_contact_form  on pg

BEGIN;

SELECT verify_function ('website_public.submit_contact_form');

ROLLBACK;
