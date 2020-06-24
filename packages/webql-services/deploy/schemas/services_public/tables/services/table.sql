-- Deploy schemas/services_public/tables/services/table to pg

-- requires: schemas/services_public/schema

BEGIN;

CREATE TABLE services_public.services (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
    name text,
    subdomain text,
    domain text,
    dbname text,
    role_name text,
    anon_role text,
    role_key text,
    schemas text[],
    auth text[],
    UNIQUE(subdomain, domain)
);


COMMIT;
