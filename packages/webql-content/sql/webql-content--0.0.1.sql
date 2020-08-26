\echo Use "CREATE EXTENSION webql-content" to load this file. \quit
CREATE SCHEMA content_private;

GRANT USAGE ON SCHEMA content_private TO authenticated;

CREATE SCHEMA content_public;

GRANT USAGE ON SCHEMA content_public TO authenticated, anonymous;

ALTER DEFAULT PRIVILEGES IN SCHEMA content_public 
 GRANT EXECUTE ON FUNCTIONS  TO authenticated;

CREATE TABLE content_public.tag (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	project_id uuid NOT NULL REFERENCES projects_public.project ON DELETE CASCADE,
	name varchar(191) NOT NULL,
	slug varchar(191) NOT NULL,
	description text,
	feature_image varchar(2000) DEFAULT ( NULL ),
	parent_id varchar(191) DEFAULT ( NULL ),
	visibility varchar(50) NOT NULL DEFAULT ( 'public' ),
	meta_title varchar(2000) DEFAULT ( NULL ),
	meta_description varchar(2000) DEFAULT ( NULL ),
	UNIQUE ( slug ) 
);

CREATE TABLE content_public.content (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	project_id uuid NOT NULL REFERENCES projects_public.project ON DELETE CASCADE,
	type citext NOT NULL DEFAULT ( 'post' ),
	title varchar(2000) NOT NULL,
	slug varchar(191) NOT NULL,
	data text,
	status varchar(50) NOT NULL DEFAULT ( 'draft' ),
	locale varchar(6) DEFAULT ( NULL ),
	visibility varchar(50) NOT NULL DEFAULT ( 'public' ),
	meta_title varchar(2000) DEFAULT ( NULL ),
	meta_description varchar(2000) DEFAULT ( NULL ),
	custom_excerpt varchar(2000) DEFAULT ( NULL ),
	canonical_url text,
	UNIQUE ( slug, project_id ) 
);

CREATE TABLE content_public.content_tag (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	project_id uuid NOT NULL REFERENCES projects_public.project ON DELETE CASCADE,
	content_id uuid NOT NULL REFERENCES content_public.content ON DELETE CASCADE,
	tag_id uuid NOT NULL REFERENCES content_public.tag ON DELETE CASCADE,
	UNIQUE ( content_id, tag_id ) 
);

ALTER TABLE content_public.content_tag ENABLE ROW LEVEL SECURITY;

CREATE FUNCTION content_private.contents_tags_policy_fn ( role_id uuid ) RETURNS boolean AS $EOFCODE$
BEGIN
  RETURN TRUE;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE POLICY can_select_contents_tags ON content_public.content_tag FOR SELECT TO PUBLIC USING ( (TRUE) );

CREATE POLICY can_insert_contents_tags ON content_public.content_tag FOR INSERT TO PUBLIC WITH CHECK ( (TRUE) );

CREATE POLICY can_update_contents_tags ON content_public.content_tag FOR UPDATE TO PUBLIC USING ( (TRUE) );

CREATE POLICY can_delete_contents_tags ON content_public.content_tag FOR DELETE TO PUBLIC USING ( (TRUE) );

GRANT INSERT ON TABLE content_public.content_tag TO authenticated, anonymous;

GRANT SELECT ON TABLE content_public.content_tag TO authenticated, anonymous;

GRANT UPDATE ON TABLE content_public.content_tag TO authenticated, anonymous;

GRANT DELETE ON TABLE content_public.content_tag TO authenticated, anonymous;

ALTER TABLE content_public.content ADD COLUMN  published_at timestamptz NULL;

ALTER TABLE content_public.content ADD COLUMN  published_by uuid NULL;

CREATE INDEX content_project_id_idx ON content_public.content ( project_id );

ALTER TABLE content_public.content ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_contents ON content_public.content FOR SELECT TO PUBLIC USING ( collaboration_private.permitted_on_project('read', 'content', project_id) );

CREATE POLICY can_insert_contents ON content_public.content FOR INSERT TO PUBLIC WITH CHECK ( collaboration_private.permitted_on_project('add', 'content', project_id) );

CREATE POLICY can_update_contents ON content_public.content FOR UPDATE TO PUBLIC USING ( collaboration_private.permitted_on_project('edit', 'content', project_id) );

CREATE POLICY can_delete_contents ON content_public.content FOR DELETE TO PUBLIC USING ( collaboration_private.permitted_on_project('destroy', 'content', project_id) );

GRANT INSERT ON TABLE content_public.content TO authenticated, anonymous;

GRANT SELECT ON TABLE content_public.content TO authenticated, anonymous;

GRANT UPDATE ON TABLE content_public.content TO authenticated, anonymous;

GRANT DELETE ON TABLE content_public.content TO authenticated, anonymous;

CREATE FUNCTION content_private.tg_before_content_insert (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  v_project projects_public.project;
BEGIN
  NEW.published_by = NULL;
  NEW.published_at = NULL;

  IF (NEW.status is NULL) THEN
    NEW.status = 'draft';
  END IF;

  SELECT * FROM projects_public.project
    WHERE id=NEW.project_id
    INTO v_project;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'CONTENT_REQUIRES_PROJECT';
  END IF;
  
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER before_content_insert 
 BEFORE INSERT ON content_public.content 
 FOR EACH ROW
 EXECUTE PROCEDURE content_private. tg_before_content_insert (  );

ALTER TABLE content_public.content ADD COLUMN  created_by uuid;

ALTER TABLE content_public.content ADD COLUMN  updated_by uuid;

CREATE TRIGGER update_content_public_contents_moduser 
 BEFORE INSERT OR UPDATE ON content_public.content 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_peoplestamps (  );

CREATE FUNCTION content_private.tg_status_changed (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  NEW.published_by = roles_public.current_role_id ();
  NEW.published_at = NOW();
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER status_changed 
 BEFORE UPDATE ON content_public.content 
 FOR EACH ROW
 WHEN ( (new.status IS DISTINCT FROM old.status AND ((new.status) = ('published'))) ) 
 EXECUTE PROCEDURE content_private. tg_status_changed (  );

ALTER TABLE content_public.content ADD COLUMN  created_at timestamptz;

ALTER TABLE content_public.content ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE content_public.content ADD COLUMN  updated_at timestamptz;

ALTER TABLE content_public.content ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER update_content_public_contents_modtime 
 BEFORE INSERT OR UPDATE ON content_public.content 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_timestamps (  );

ALTER TABLE content_public.tag ENABLE ROW LEVEL SECURITY;

CREATE FUNCTION content_private.tags_policy_fn ( role_id uuid ) RETURNS boolean AS $EOFCODE$
BEGIN
  RETURN TRUE;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE POLICY can_select_tags ON content_public.tag FOR SELECT TO PUBLIC USING ( (TRUE) );

CREATE POLICY can_insert_tags ON content_public.tag FOR INSERT TO PUBLIC WITH CHECK ( (TRUE) );

CREATE POLICY can_update_tags ON content_public.tag FOR UPDATE TO PUBLIC USING ( (TRUE) );

CREATE POLICY can_delete_tags ON content_public.tag FOR DELETE TO PUBLIC USING ( (TRUE) );

GRANT INSERT ON TABLE content_public.tag TO authenticated, anonymous;

GRANT SELECT ON TABLE content_public.tag TO authenticated, anonymous;

GRANT UPDATE ON TABLE content_public.tag TO authenticated, anonymous;

GRANT DELETE ON TABLE content_public.tag TO authenticated, anonymous;

ALTER TABLE content_public.tag ADD COLUMN  created_by uuid;

ALTER TABLE content_public.tag ADD COLUMN  updated_by uuid;

CREATE TRIGGER update_content_public_tags_moduser 
 BEFORE INSERT OR UPDATE ON content_public.tag 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_peoplestamps (  );

ALTER TABLE content_public.tag ADD COLUMN  created_at timestamptz;

ALTER TABLE content_public.tag ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE content_public.tag ADD COLUMN  updated_at timestamptz;

ALTER TABLE content_public.tag ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER update_content_public_tags_modtime 
 BEFORE INSERT OR UPDATE ON content_public.tag 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_timestamps (  );