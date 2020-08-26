-- Deploy schemas/website_private/tables/contact_form_message/table to pg

-- requires: schemas/website_private/schema

BEGIN;

CREATE TABLE website_private.contact_form_message (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    full_name text NOT NULL,
    email email NOT NULL,
    message text NOT NULL
);

COMMIT;
