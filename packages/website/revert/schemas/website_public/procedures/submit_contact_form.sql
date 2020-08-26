-- Revert schemas/website_public/procedures/submit_contact_form from pg

BEGIN;

DROP FUNCTION website_public.submit_contact_form;

COMMIT;
