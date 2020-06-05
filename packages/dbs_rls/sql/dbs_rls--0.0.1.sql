\echo Use "CREATE EXTENSION dbs_rls" to load this file. \quit
GRANT USAGE ON SCHEMA collections_private TO authenticated, anonymous;

GRANT EXECUTE ON FUNCTION collections_private.get_available_schema_name TO authenticated;

GRANT EXECUTE ON FUNCTION collections_private.database_name_hash TO authenticated;

GRANT EXECUTE ON FUNCTION collections_private.table_name_hash TO authenticated;

GRANT EXECUTE ON FUNCTION collections_private.get_schema_name_by_database_id TO authenticated;

GRANT EXECUTE ON FUNCTION collections_private.is_valid_type TO authenticated;

GRANT USAGE ON SCHEMA collections_public TO authenticated;

ALTER TABLE collections_public."constraint" ADD COLUMN  project_id uuid NOT NULL;

ALTER TABLE collections_public."constraint" ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_constraint ON collections_public."constraint" FOR SELECT TO PUBLIC USING ( collaboration_private.permitted_on_project('read', 'database', project_id) );

CREATE POLICY can_insert_constraint ON collections_public."constraint" FOR INSERT TO PUBLIC WITH CHECK ( collaboration_private.permitted_on_project('add', 'database', project_id) );

CREATE POLICY can_update_constraint ON collections_public."constraint" FOR UPDATE TO PUBLIC USING ( collaboration_private.permitted_on_project('edit', 'database', project_id) );

CREATE POLICY can_delete_constraint ON collections_public."constraint" FOR DELETE TO PUBLIC USING ( collaboration_private.permitted_on_project('destroy', 'database', project_id) );

GRANT INSERT ON TABLE collections_public."constraint" TO authenticated;

GRANT SELECT ON TABLE collections_public."constraint" TO authenticated;

GRANT UPDATE ON TABLE collections_public."constraint" TO authenticated;

GRANT DELETE ON TABLE collections_public."constraint" TO authenticated;

CREATE FUNCTION collections_private.tg_before_insert_constraint_set_project_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  proj_id uuid;
BEGIN
  SELECT project_id FROM collections_public.table 
    WHERE id = NEW.table_id
  INTO proj_id;

  NEW.project_id = proj_id;

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_insert_constraint_set_project_id 
 BEFORE INSERT ON collections_public."constraint" 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_before_insert_constraint_set_project_id (  );

ALTER TABLE collections_public.database ADD COLUMN  project_id uuid NOT NULL;

ALTER TABLE collections_public.database ADD CONSTRAINT fk_collections_public_database_project_id FOREIGN KEY ( project_id ) REFERENCES projects_public.project ( id ) ON DELETE CASCADE;

ALTER TABLE collections_public.database ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_database ON collections_public.database FOR SELECT TO PUBLIC USING ( collaboration_private.permitted_on_project('read', 'database', project_id) );

CREATE POLICY can_insert_database ON collections_public.database FOR INSERT TO PUBLIC WITH CHECK ( collaboration_private.permitted_on_project('add', 'database', project_id) );

CREATE POLICY can_update_database ON collections_public.database FOR UPDATE TO PUBLIC USING ( collaboration_private.permitted_on_project('edit', 'database', project_id) );

CREATE POLICY can_delete_database ON collections_public.database FOR DELETE TO PUBLIC USING ( collaboration_private.permitted_on_project('destroy', 'database', project_id) );

GRANT INSERT ON TABLE collections_public.database TO authenticated;

GRANT SELECT ON TABLE collections_public.database TO authenticated;

GRANT UPDATE ON TABLE collections_public.database TO authenticated;

GRANT DELETE ON TABLE collections_public.database TO authenticated;

ALTER TABLE collections_public.field ADD COLUMN  project_id uuid NOT NULL;

ALTER TABLE collections_public.field ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_field ON collections_public.field FOR SELECT TO PUBLIC USING ( collaboration_private.permitted_on_project('read', 'database', project_id) );

CREATE POLICY can_insert_field ON collections_public.field FOR INSERT TO PUBLIC WITH CHECK ( collaboration_private.permitted_on_project('add', 'database', project_id) );

CREATE POLICY can_update_field ON collections_public.field FOR UPDATE TO PUBLIC USING ( collaboration_private.permitted_on_project('edit', 'database', project_id) );

CREATE POLICY can_delete_field ON collections_public.field FOR DELETE TO PUBLIC USING ( collaboration_private.permitted_on_project('destroy', 'database', project_id) );

GRANT INSERT ON TABLE collections_public.field TO authenticated;

GRANT SELECT ON TABLE collections_public.field TO authenticated;

GRANT UPDATE ON TABLE collections_public.field TO authenticated;

GRANT DELETE ON TABLE collections_public.field TO authenticated;

CREATE FUNCTION collections_private.tg_before_insert_field_set_project_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  proj_id uuid;
BEGIN
  SELECT project_id FROM collections_public.table 
    WHERE id = NEW.table_id
  INTO proj_id;

  NEW.project_id = proj_id;

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_insert_field_set_project_id 
 BEFORE INSERT ON collections_public.field 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_before_insert_field_set_project_id (  );

ALTER TABLE collections_public.foreign_key_constraint ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_foreign_key_constraint ON collections_public.foreign_key_constraint FOR SELECT TO PUBLIC USING ( collaboration_private.permitted_on_project('read', 'database', project_id) );

CREATE POLICY can_insert_foreign_key_constraint ON collections_public.foreign_key_constraint FOR INSERT TO PUBLIC WITH CHECK ( collaboration_private.permitted_on_project('add', 'database', project_id) );

CREATE POLICY can_update_foreign_key_constraint ON collections_public.foreign_key_constraint FOR UPDATE TO PUBLIC USING ( collaboration_private.permitted_on_project('edit', 'database', project_id) );

CREATE POLICY can_delete_foreign_key_constraint ON collections_public.foreign_key_constraint FOR DELETE TO PUBLIC USING ( collaboration_private.permitted_on_project('destroy', 'database', project_id) );

GRANT INSERT ON TABLE collections_public.foreign_key_constraint TO authenticated;

GRANT SELECT ON TABLE collections_public.foreign_key_constraint TO authenticated;

GRANT UPDATE ON TABLE collections_public.foreign_key_constraint TO authenticated;

GRANT DELETE ON TABLE collections_public.foreign_key_constraint TO authenticated;

CREATE FUNCTION collections_private.tg_before_insert_fkey_constraint_set_project_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  proj_id uuid;
BEGIN
  SELECT project_id FROM collections_public.table 
    WHERE id = NEW.table_id
  INTO proj_id;

  NEW.project_id = proj_id;

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_insert_fkey_constraint_set_project_id 
 BEFORE INSERT ON collections_public.foreign_key_constraint 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_before_insert_fkey_constraint_set_project_id (  );

ALTER TABLE collections_public.primary_key_constraint ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_primary_key_constraint ON collections_public.primary_key_constraint FOR SELECT TO PUBLIC USING ( collaboration_private.permitted_on_project('read', 'database', project_id) );

CREATE POLICY can_insert_primary_key_constraint ON collections_public.primary_key_constraint FOR INSERT TO PUBLIC WITH CHECK ( collaboration_private.permitted_on_project('add', 'database', project_id) );

CREATE POLICY can_update_primary_key_constraint ON collections_public.primary_key_constraint FOR UPDATE TO PUBLIC USING ( collaboration_private.permitted_on_project('edit', 'database', project_id) );

CREATE POLICY can_delete_primary_key_constraint ON collections_public.primary_key_constraint FOR DELETE TO PUBLIC USING ( collaboration_private.permitted_on_project('destroy', 'database', project_id) );

GRANT INSERT ON TABLE collections_public.primary_key_constraint TO authenticated;

GRANT SELECT ON TABLE collections_public.primary_key_constraint TO authenticated;

GRANT UPDATE ON TABLE collections_public.primary_key_constraint TO authenticated;

GRANT DELETE ON TABLE collections_public.primary_key_constraint TO authenticated;

CREATE FUNCTION collections_private.tg_before_insert_pkey_constraint_set_project_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  proj_id uuid;
BEGIN
  SELECT project_id FROM collections_public.table 
    WHERE id = NEW.table_id
  INTO proj_id;

  NEW.project_id = proj_id;

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_insert_pkey_constraint_set_project_id 
 BEFORE INSERT ON collections_public.primary_key_constraint 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_before_insert_pkey_constraint_set_project_id (  );

ALTER TABLE collections_public."table" ADD COLUMN  project_id uuid NOT NULL;

ALTER TABLE collections_public."table" ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_table ON collections_public."table" FOR SELECT TO PUBLIC USING ( collaboration_private.permitted_on_project('read', 'database', project_id) );

CREATE POLICY can_insert_table ON collections_public."table" FOR INSERT TO PUBLIC WITH CHECK ( collaboration_private.permitted_on_project('add', 'database', project_id) );

CREATE POLICY can_update_table ON collections_public."table" FOR UPDATE TO PUBLIC USING ( collaboration_private.permitted_on_project('edit', 'database', project_id) );

CREATE POLICY can_delete_table ON collections_public."table" FOR DELETE TO PUBLIC USING ( collaboration_private.permitted_on_project('destroy', 'database', project_id) );

GRANT INSERT ON TABLE collections_public."table" TO authenticated;

GRANT SELECT ON TABLE collections_public."table" TO authenticated;

GRANT UPDATE ON TABLE collections_public."table" TO authenticated;

GRANT DELETE ON TABLE collections_public."table" TO authenticated;

CREATE FUNCTION collections_private.tg_before_insert_table_set_project_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  proj_id uuid;
BEGIN
  SELECT project_id FROM collections_public.database 
    WHERE id = NEW.database_id
  INTO proj_id;

  NEW.project_id = proj_id;
 
 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_insert_table_set_project_id 
 BEFORE INSERT ON collections_public."table" 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_before_insert_table_set_project_id (  );

ALTER TABLE collections_public.unique_constraint ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_unique_constraint ON collections_public.unique_constraint FOR SELECT TO PUBLIC USING ( collaboration_private.permitted_on_project('read', 'database', project_id) );

CREATE POLICY can_insert_unique_constraint ON collections_public.unique_constraint FOR INSERT TO PUBLIC WITH CHECK ( collaboration_private.permitted_on_project('add', 'database', project_id) );

CREATE POLICY can_update_unique_constraint ON collections_public.unique_constraint FOR UPDATE TO PUBLIC USING ( collaboration_private.permitted_on_project('edit', 'database', project_id) );

CREATE POLICY can_delete_unique_constraint ON collections_public.unique_constraint FOR DELETE TO PUBLIC USING ( collaboration_private.permitted_on_project('destroy', 'database', project_id) );

GRANT INSERT ON TABLE collections_public.unique_constraint TO authenticated;

GRANT SELECT ON TABLE collections_public.unique_constraint TO authenticated;

GRANT UPDATE ON TABLE collections_public.unique_constraint TO authenticated;

GRANT DELETE ON TABLE collections_public.unique_constraint TO authenticated;

CREATE FUNCTION collections_private.tg_before_insert_unique_constraint_set_project_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  proj_id uuid;
BEGIN
  SELECT project_id FROM collections_public.table 
    WHERE id = NEW.table_id
  INTO proj_id;

  NEW.project_id = proj_id;

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_insert_unique_constraint_set_project_id 
 BEFORE INSERT ON collections_public.unique_constraint 
 FOR EACH ROW
 EXECUTE PROCEDURE collections_private. tg_before_insert_unique_constraint_set_project_id (  );

INSERT INTO permissions_public.permission ( name, object_type, action_type ) VALUES ('Browse Databases', 'database', 'browse'), ('Read Databases', 'database', 'read'), ('Edit Databases', 'database', 'edit'), ('Add Databases', 'database', 'add'), ('Delete Databases', 'database', 'destroy');