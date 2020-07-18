-- Deploy schemas/services_public/tables/services/table to pg

-- requires: schemas/services_public/schema

BEGIN;

CREATE TABLE services_public.services (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
    database_id uuid,
    is_public bool,

    name text,
    subdomain citext,
    domain citext,
    dbname text,
    role_name text,
    anon_role text,
    role_key text,
    schemas text[],
    auth text[],
    pubkey_challenge text[],
    UNIQUE(subdomain, domain)
);

COMMIT;
