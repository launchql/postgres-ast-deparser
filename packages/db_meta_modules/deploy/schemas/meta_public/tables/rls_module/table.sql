-- Deploy schemas/meta_public/tables/rls_module/table to pg

-- requires: schemas/meta_public/schema

BEGIN;

CREATE TABLE meta_public.rls_module (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    database_id uuid NOT NULL,
    schema_id uuid NOT NULL,
    private_schema_id uuid NOT NULL,

    -- requires!
    tokens_table_id uuid,
    users_table_id uuid,
    --

    -- TODO add api
    -- api_id uuid NOT NULL REFERENCES meta_public.apis (id),

    authenticate text NOT NULL DEFAULT 'authenticate',
    "current_role" text NOT NULL DEFAULT 'current_user',
    current_role_id text NOT NULL DEFAULT 'current_user_id',
    current_group_ids text NOT NULL DEFAULT 'current_group_ids',
    -- UNIQUE(api_id)

        --
    CONSTRAINT db_fkey FOREIGN KEY (database_id) REFERENCES collections_public.database (id),
    CONSTRAINT tokens_table_fkey FOREIGN KEY (tokens_table_id) REFERENCES collections_public.table (id),
    CONSTRAINT users_table_fkey FOREIGN KEY (users_table_id) REFERENCES collections_public.table (id),
    CONSTRAINT schema_fkey FOREIGN KEY (schema_id) REFERENCES collections_public.schema (id),
    CONSTRAINT pschema_fkey FOREIGN KEY (private_schema_id) REFERENCES collections_public.schema (id)
);

COMMENT ON CONSTRAINT db_fkey ON meta_public.rls_module IS E'@omit manyToMany';
COMMENT ON CONSTRAINT tokens_table_fkey ON meta_public.rls_module IS E'@omit manyToMany';
COMMENT ON CONSTRAINT users_table_fkey ON meta_public.rls_module IS E'@omit manyToMany';
COMMENT ON CONSTRAINT schema_fkey ON meta_public.rls_module IS E'@omit manyToMany';
COMMENT ON CONSTRAINT pschema_fkey ON meta_public.rls_module IS E'@omit manyToMany';
CREATE INDEX rls_module_database_id_idx ON meta_public.rls_module ( database_id );

COMMIT;
