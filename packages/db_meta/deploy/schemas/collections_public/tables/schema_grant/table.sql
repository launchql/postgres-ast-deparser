-- Deploy schemas/collections_public/tables/schema_grant/table to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/schema/table

BEGIN;

CREATE TABLE collections_public.schema_grant (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    database_id uuid NOT NULL REFERENCES collections_public.database (id) ON DELETE CASCADE,
    schema_id uuid NOT NULL REFERENCES collections_public.schema(id),
    grantee_name text NOT NULL
);

CREATE INDEX schema_grant_database_id_idx ON collections_public.schema_grant ( database_id );

COMMIT;
