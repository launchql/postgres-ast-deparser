-- Deploy schemas/website_public/procedures/submit_contact_form to pg
-- requires: schemas/website_public/schema
-- requires: schemas/website_private/tables/contact_form_message/table

BEGIN;
CREATE FUNCTION website_public.submit_contact_form (
  full_name text,
  email email,
  message text
)
  RETURNS boolean
  AS $$
  INSERT INTO website_private.contact_form_message (full_name, email, message)
  VALUES (full_name, email, message);
SELECT
  TRUE;
$$
LANGUAGE 'sql'
VOLATILE
SECURITY DEFINER;
COMMIT;

