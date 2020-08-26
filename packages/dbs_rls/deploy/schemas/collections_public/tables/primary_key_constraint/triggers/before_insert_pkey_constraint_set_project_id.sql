-- Deploy schemas/collections_public/tables/primary_key_constraint/triggers/before_insert_pkey_constraint_set_project_id to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/primary_key_constraint/table
-- requires: schemas/collections_public/tables/constraint/triggers/before_insert_constraint_set_project_id 

BEGIN;



CREATE FUNCTION collections_private.tg_before_insert_pkey_constraint_set_project_id()
RETURNS TRIGGER AS $$
DECLARE
  proj_id uuid;
BEGIN
  SELECT project_id FROM collections_public.table 
    WHERE id = NEW.table_id
  INTO proj_id;

  NEW.project_id = proj_id;

 RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER before_insert_pkey_constraint_set_project_id
BEFORE INSERT ON collections_public.primary_key_constraint
FOR EACH ROW
EXECUTE PROCEDURE collections_private.tg_before_insert_pkey_constraint_set_project_id ();

COMMIT;
