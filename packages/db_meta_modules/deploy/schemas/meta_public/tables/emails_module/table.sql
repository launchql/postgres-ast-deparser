-- Deploy schemas/meta_public/tables/emails_module/table to pg

-- requires: schemas/meta_public/schema

BEGIN;

CREATE TABLE meta_public.emails_module (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    database_id uuid NOT NULL,
    schema_id uuid NOT NULL,
    table_id uuid,

    emails_table text,
    multiple_emails boolean default FALSE,

    --
    CONSTRAINT db_fkey FOREIGN KEY (database_id) REFERENCES collections_public.database (id),
    CONSTRAINT table_fkey FOREIGN KEY (table_id) REFERENCES collections_public.table (id),
    CONSTRAINT schema_fkey FOREIGN KEY (schema_id) REFERENCES collections_public.schema (id)
);

COMMENT ON CONSTRAINT schema_fkey ON meta_public.emails_module IS E'@omit manyToMany';
COMMENT ON CONSTRAINT table_fkey ON meta_public.emails_module IS E'@omit manyToMany';
COMMENT ON CONSTRAINT db_fkey ON meta_public.emails_module IS E'@omit manyToMany';
CREATE INDEX emails_module_database_id_idx ON meta_public.emails_module ( database_id );


COMMIT;
