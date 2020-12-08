-- Deploy schemas/collections_public/tables/table_grant/table to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/table/table

BEGIN;

CREATE TABLE collections_public.table_grant (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    database_id uuid NOT NULL REFERENCES collections_public.database (id) ON DELETE CASCADE,
    table_id uuid NOT NULL REFERENCES collections_public.table (id) ON DELETE CASCADE,
    privilege text NOT NULL,
    role_name text NOT NULL,
    field_ids uuid[],
    unique(table_id, privilege, role_name)
);

COMMIT;
