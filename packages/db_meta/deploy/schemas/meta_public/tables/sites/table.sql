-- Deploy schemas/meta_public/tables/sites/table to pg

-- requires: schemas/meta_public/schema
-- requires: schemas/meta_public/tables/domains/table 
-- requires: schemas/collections_public/tables/database/table 

BEGIN;

CREATE TABLE meta_public.sites (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  database_id uuid NOT NULL REFERENCES collections_public.database (id) ON DELETE CASCADE,
  domain_id uuid NOT NULL,
  title text,
  description text,
  og_image image,
  favicon upload,
  apple_touch_icon image,
  logo image,
  dbname text NOT NULL DEFAULT current_database(),
  CHECK ( character_length(title) <= 120 ),
  CHECK ( character_length(description) <= 120 ),
  UNIQUE ( domain_id )
);

ALTER TABLE meta_public.sites ADD CONSTRAINT sites_domain_id_fkey FOREIGN KEY ( domain_id ) REFERENCES meta_public.domains ( id );
COMMENT ON CONSTRAINT sites_domain_id_fkey ON meta_public.sites IS E'@omit manyToMany';
CREATE INDEX sites_domain_id_idx ON meta_public.sites ( domain_id );

CREATE INDEX sites_database_id_idx ON meta_public.sites ( database_id );

COMMIT;
