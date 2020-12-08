-- Deploy schemas/meta_public/tables/domains/table to pg

-- requires: schemas/meta_public/schema
-- requires: schemas/collections_public/tables/database/table 

BEGIN;

CREATE TABLE meta_public.domains (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    database_id uuid NOT NULL REFERENCES collections_public.database (id) ON DELETE CASCADE,
    subdomain hostname,
    domain hostname,
    UNIQUE ( subdomain, domain )
);

CREATE INDEX domains_database_id_idx ON meta_public.domains ( database_id );

COMMIT;
