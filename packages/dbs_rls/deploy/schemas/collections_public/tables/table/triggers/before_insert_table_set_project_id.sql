-- Deploy schemas/collections_public/tables/table/triggers/before_insert_table_set_project_id to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/table/table
-- requires: schemas/collections_public/tables/database/alterations/alter_table_add_project_id

BEGIN;

CREATE FUNCTION collections_private.tg_before_insert_table_set_project_id()
RETURNS TRIGGER AS $$
DECLARE
  proj_id uuid;
BEGIN
  SELECT project_id FROM collections_public.database 
    WHERE id = NEW.database_id
  INTO proj_id;

  NEW.project_id = proj_id;
 
 RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER before_insert_table_set_project_id
BEFORE INSERT ON collections_public.table
FOR EACH ROW
EXECUTE PROCEDURE collections_private.tg_before_insert_table_set_project_id ();

COMMIT;
