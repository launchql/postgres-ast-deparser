-- Deploy schemas/meta_public/tables/user_status_module/table to pg

-- requires: schemas/meta_public/schema

BEGIN;

CREATE TABLE meta_public.user_status_module (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  database_id uuid NOT NULL,

  --
  schema_id uuid,
  private_schema_id uuid,
  --
  
  CONSTRAINT db_fkey FOREIGN KEY (database_id) REFERENCES collections_public.database (id),
  CONSTRAINT schema_fkey FOREIGN KEY (schema_id) REFERENCES collections_public.schema (id),
  CONSTRAINT pschema_fkey FOREIGN KEY (private_schema_id) REFERENCES collections_public.schema (id)
);

COMMENT ON CONSTRAINT db_fkey ON meta_public.user_status_module IS E'@omit manyToMany';
COMMENT ON CONSTRAINT schema_fkey ON meta_public.user_status_module IS E'@omit manyToMany';
COMMENT ON CONSTRAINT pschema_fkey ON meta_public.user_status_module IS E'@omit manyToMany';
CREATE INDEX user_status_module_database_id_idx ON meta_public.user_status_module ( database_id );

COMMIT;
