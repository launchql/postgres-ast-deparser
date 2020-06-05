\echo Use "CREATE EXTENSION webql-files" to load this file. \quit
CREATE SCHEMA files_private;

GRANT USAGE ON SCHEMA files_private TO authenticated;

CREATE SCHEMA files_public;

GRANT USAGE ON SCHEMA files_public TO authenticated;

CREATE TABLE files_public.buckets (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	name text,
	exists boolean NOT NULL DEFAULT ( (FALSE) ),
	type varchar(255) NOT NULL DEFAULT ( 'uploads' ),
	owner_id uuid NOT NULL REFERENCES roles_public.roles ( id ),
	organization_id uuid NOT NULL REFERENCES roles_public.roles ( id ),
	UNIQUE ( owner_id, type ) 
);

COMMENT ON COLUMN files_public.buckets.name IS E'@omit';

COMMENT ON COLUMN files_public.buckets.exists IS E'@omit';

CREATE INDEX buckets_organization_id_idx ON files_public.buckets ( organization_id );

ALTER TABLE files_public.buckets ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_buckets ON files_public.buckets FOR SELECT TO PUBLIC USING ( permissions_private.permitted_on_role('read', 'project', owner_id) );

CREATE POLICY can_insert_buckets ON files_public.buckets FOR INSERT TO PUBLIC WITH CHECK ( permissions_private.permitted_on_role('add', 'project', owner_id) );

CREATE POLICY can_update_buckets ON files_public.buckets FOR UPDATE TO PUBLIC USING ( permissions_private.permitted_on_role('edit', 'project', owner_id) );

CREATE POLICY can_delete_buckets ON files_public.buckets FOR DELETE TO PUBLIC USING ( permissions_private.permitted_on_role('destroy', 'project', owner_id) );

GRANT INSERT ON TABLE files_public.buckets TO authenticated;

GRANT SELECT ON TABLE files_public.buckets TO authenticated;

GRANT UPDATE ON TABLE files_public.buckets TO authenticated;

GRANT DELETE ON TABLE files_public.buckets TO authenticated;

CREATE FUNCTION files_private.tg_create_remote_bucket (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  IF (NEW.exists IS FALSE) THEN
    PERFORM
      app_jobs.add_job ('files__create_remote_bucket',
        json_build_object('id', NEW.id::text));
  END IF;
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER create_remote_bucket 
 AFTER INSERT ON files_public.buckets 
 FOR EACH ROW
 EXECUTE PROCEDURE files_private. tg_create_remote_bucket (  );

ALTER TABLE files_public.buckets ADD COLUMN  created_by uuid;

ALTER TABLE files_public.buckets ADD COLUMN  updated_by uuid;

CREATE TRIGGER update_files_public_buckets_moduser 
 BEFORE INSERT OR UPDATE ON files_public.buckets 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_peoplestamps (  );

ALTER TABLE files_public.buckets ADD COLUMN  created_at timestamptz;

ALTER TABLE files_public.buckets ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE files_public.buckets ADD COLUMN  updated_at timestamptz;

ALTER TABLE files_public.buckets ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER update_files_public_buckets_modtime 
 BEFORE INSERT OR UPDATE ON files_public.buckets 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_timestamps (  );

CREATE TABLE files_public.files (
 	id uuid NOT NULL,
	filename text NOT NULL,
	mimetype text NOT NULL,
	encoding text NOT NULL,
	sha1 text NOT NULL,
	etag text NOT NULL,
	size int NOT NULL,
	key text NOT NULL,
	url text NULL,
	owner_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	organization_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE 
);

CREATE INDEX files_organization_id_idx ON files_public.files ( organization_id );

CREATE INDEX files_owner_id_idx ON files_public.files ( owner_id );

ALTER TABLE files_public.files ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_files ON files_public.files FOR SELECT TO PUBLIC USING ( permissions_private.permitted_on_role('browse', 'content', owner_id) );

CREATE POLICY can_insert_files ON files_public.files FOR INSERT TO PUBLIC WITH CHECK ( permissions_private.permitted_on_role('upload', 'content', owner_id) );

CREATE POLICY can_update_files ON files_public.files FOR UPDATE TO PUBLIC USING ( permissions_private.permitted_on_role('edit', 'content', owner_id) );

CREATE POLICY can_delete_files ON files_public.files FOR DELETE TO PUBLIC USING ( permissions_private.permitted_on_role('destroy', 'content', owner_id) );

GRANT INSERT ON TABLE files_public.files TO authenticated;

GRANT SELECT ON TABLE files_public.files TO authenticated;

GRANT UPDATE ON TABLE files_public.files TO authenticated;

GRANT DELETE ON TABLE files_public.files TO authenticated;

ALTER TABLE files_public.files ADD COLUMN  created_by uuid;

ALTER TABLE files_public.files ADD COLUMN  updated_by uuid;

CREATE TRIGGER update_files_public_files_moduser 
 BEFORE INSERT OR UPDATE ON files_public.files 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_peoplestamps (  );

ALTER TABLE files_public.files ADD COLUMN  created_at timestamptz;

ALTER TABLE files_public.files ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE files_public.files ADD COLUMN  updated_at timestamptz;

ALTER TABLE files_public.files ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER update_files_public_files_modtime 
 BEFORE INSERT OR UPDATE ON files_public.files 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_timestamps (  );