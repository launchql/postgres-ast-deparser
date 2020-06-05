-- Deploy schemas/collections_public/tables/database/alterations/add_foreign_key_project_id to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/projects_public/schema
-- requires: schemas/collections_public/tables/database/table
-- requires: schemas/projects_public/tables/project/table
-- requires: schemas/collections_public/tables/database/alterations/alter_table_add_project_id 

BEGIN;


ALTER TABLE collections_public.database
    ADD CONSTRAINT fk_collections_public_database_project_id
    FOREIGN KEY (project_id)
    REFERENCES projects_public.project (id)
    ON DELETE CASCADE;


COMMIT;
