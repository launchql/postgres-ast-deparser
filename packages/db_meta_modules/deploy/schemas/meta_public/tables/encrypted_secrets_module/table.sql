-- Deploy schemas/meta_public/tables/encrypted_secrets_module/table to pg

-- requires: schemas/meta_public/schema

BEGIN;

CREATE TABLE meta_public.encrypted_secrets_module (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    database_id uuid NOT NULL,
    --
    schema_id uuid,
    table_id uuid,
    table_name text NOT NULL DEFAULT 'encrypted_secrets',
    -- 
    CONSTRAINT db_fkey FOREIGN KEY (database_id) REFERENCES collections_public.database (id),
    CONSTRAINT schema_fkey FOREIGN KEY (schema_id) REFERENCES collections_public.schema (id),
    CONSTRAINT table_fkey FOREIGN KEY (table_id) REFERENCES collections_public.table (id)
);

COMMENT ON CONSTRAINT schema_fkey ON meta_public.encrypted_secrets_module IS E'@omit manyToMany';
COMMENT ON CONSTRAINT db_fkey ON meta_public.encrypted_secrets_module IS E'@omit manyToMany';
CREATE INDEX encrypted_secrets_module_database_id_idx ON meta_public.encrypted_secrets_module ( database_id );

COMMENT ON CONSTRAINT table_fkey
     ON meta_public.encrypted_secrets_module IS E'@omit manyToMany';

COMMIT;
