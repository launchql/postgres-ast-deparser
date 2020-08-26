\echo Use "CREATE EXTENSION webql-website" to load this file. \quit
CREATE SCHEMA website_private;

GRANT USAGE ON SCHEMA website_private TO anonymous;

ALTER DEFAULT PRIVILEGES IN SCHEMA website_private 
 GRANT EXECUTE ON FUNCTIONS  TO anonymous;

CREATE TABLE website_private.contact_form_message (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	full_name text NOT NULL,
	email email NOT NULL,
	message text NOT NULL 
);

ALTER TABLE website_private.contact_form_message ADD COLUMN  created_at timestamptz;

ALTER TABLE website_private.contact_form_message ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE website_private.contact_form_message ADD COLUMN  updated_at timestamptz;

ALTER TABLE website_private.contact_form_message ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER update_website_private_contact_form_message_modtime 
 BEFORE INSERT OR UPDATE ON website_private.contact_form_message 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_timestamps (  );

CREATE SCHEMA website_public;

GRANT USAGE ON SCHEMA website_public TO anonymous, authenticated;

ALTER DEFAULT PRIVILEGES IN SCHEMA website_public 
 GRANT EXECUTE ON FUNCTIONS  TO anonymous, authenticated;

CREATE FUNCTION website_public.submit_contact_form ( full_name text, email email, message text ) RETURNS boolean AS $EOFCODE$
  INSERT INTO website_private.contact_form_message (full_name, email, message)
  VALUES (full_name, email, message);
SELECT
  TRUE;
$EOFCODE$ LANGUAGE sql VOLATILE SECURITY DEFINER;