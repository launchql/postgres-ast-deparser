\echo Use "CREATE EXTENSION launchql-projects" to load this file. \quit
GRANT EXECUTE ON FUNCTION gen_random_bytes TO PUBLIC;

GRANT EXECUTE ON FUNCTION pgp_sym_encrypt ( text,text,text ) TO PUBLIC;

GRANT EXECUTE ON FUNCTION pgp_sym_decrypt ( bytea,text ) TO PUBLIC;

CREATE SCHEMA collaboration_private;

GRANT USAGE ON SCHEMA collaboration_private TO authenticated, anonymous;

ALTER DEFAULT PRIVILEGES IN SCHEMA collaboration_private 
 GRANT EXECUTE ON FUNCTIONS  TO authenticated;

CREATE FUNCTION collaboration_private.collaboration_actor_role_admin_owner_authorized_profiles ( actor_id uuid, project_id uuid, profile_id uuid, organization_id uuid ) RETURNS boolean AS $EOFCODE$
DECLARE
  v_profile_grantor permissions_public.profile;
  v_profile_member permissions_public.profile;
BEGIN
  RETURN TRUE;
  SELECT
    p.*
  FROM
    permissions_public.profile p
  WHERE
    p.id = actor_role_admin_owner_authorized_profiles.profile_id
    AND p.organization_id = actor_role_admin_owner_authorized_profiles.organization_id INTO v_profile_member;
  IF (NOT FOUND) THEN
    RETURN TRUE;
  END IF;
  -- this checks direct collaborations
  SELECT
    p.*
  FROM
    collaboration_public.collaboration c
    JOIN permissions_public.profile p ON (c.profile_id = p.id
        AND c.organization_id = p.organization_id)
  WHERE
    c.role_id = actor_id
    AND c.project_id = actor_role_admin_owner_authorized_profiles.project_id
    AND c.organization_id = actor_role_admin_owner_authorized_profiles.organization_id INTO v_profile_grantor;
  IF (NOT FOUND) THEN
    -- get org membership
    -- TODO look through all project permits, including profile_id (which currently they do not have)
    SELECT
      p.*
    FROM
      roles_public.memberships m
      JOIN permissions_public.profile p ON (m.profile_id = p.id
          AND m.organization_id = p.organization_id)
    WHERE
      m.role_id = actor_id
      AND m.group_id = actor_role_admin_owner_authorized_profiles.organization_id
      AND m.organization_id = actor_role_admin_owner_authorized_profiles.organization_id INTO v_profile_grantor;
  END IF;
  -- Now check profiles
  IF (v_profile_member.name = 'Administrator') THEN
    IF (v_profile_grantor.name = 'Administrator' OR v_profile_grantor.name = 'Owner') THEN
      RETURN TRUE;
    END IF;
    RETURN FALSE;
  END IF;
  IF (v_profile_member.name = 'Owner') THEN
    IF (v_profile_grantor.name = 'Owner') THEN
      RETURN TRUE;
    END IF;
    RETURN FALSE;
  END IF;
  RETURN TRUE;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE SCHEMA projects_public;

GRANT USAGE ON SCHEMA projects_public TO authenticated;

ALTER DEFAULT PRIVILEGES IN SCHEMA projects_public 
 GRANT EXECUTE ON FUNCTIONS  TO authenticated;

CREATE TABLE projects_public.project (
 	id uuid PRIMARY KEY NOT NULL DEFAULT ( uuid_generate_v4() ),
	name citext NOT NULL CHECK ( ((name) ~* ('^[a-z0-9_-]{3,255}$')) ),
	owner_id uuid NOT NULL REFERENCES roles_public.roles ( id ) DEFAULT ( roles_public.current_role_id() ),
	UNIQUE ( owner_id, name ) 
);

COMMENT ON TABLE projects_public.project IS E'A project is a data structure to manage a project and its resources over time.';

CREATE VIEW collaboration_private.admin_project_permits AS SELECT perm.id AS permission_id,
perm.action_type AS action_type,
perm.object_type AS object_type,
project.id AS project_id,
membership.role_id AS actor_id FROM roles_public.memberships AS membership INNER JOIN projects_public.project AS project ON ((project.owner_id) = (membership.organization_id)) INNER JOIN permissions_private.profile_permissions AS jtbl ON (((jtbl.profile_id) = (membership.profile_id)) AND ((jtbl.organization_id) = (membership.organization_id))) INNER JOIN permissions_public.profile AS prof ON (((prof.id) = (jtbl.profile_id)) AND ((prof.organization_id) = (jtbl.organization_id))) INNER JOIN permissions_public.permission AS perm ON ((jtbl.permission_id) = (perm.id)) INNER JOIN roles_public.roles AS r ON ((membership.role_id) = (r.id)) WHERE (((r.type) = ('User'::roles_public.role_type)) AND ((membership.organization_id) = (membership.group_id)) AND (((prof.name) = ('Administrator')) OR ((prof.name) = ('Owner'))));

CREATE SCHEMA collaboration_public;

GRANT USAGE ON SCHEMA collaboration_public TO authenticated, anonymous;

ALTER DEFAULT PRIVILEGES IN SCHEMA collaboration_public 
 GRANT EXECUTE ON FUNCTIONS  TO authenticated;

CREATE TABLE collaboration_public.collaboration (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	role_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	profile_id uuid NOT NULL REFERENCES permissions_public.profile ( id ) ON DELETE CASCADE,
	project_id uuid NOT NULL REFERENCES projects_public.project ( id ) ON DELETE CASCADE,
	organization_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	invited_by_id uuid NULL REFERENCES roles_public.roles ( id ),
	inherited boolean DEFAULT ( (FALSE) ),
	collaboration_id uuid NULL REFERENCES collaboration_public.collaboration ( id ) ON DELETE CASCADE,
	UNIQUE ( role_id, project_id ) 
);

CREATE VIEW collaboration_private.team_project_permits AS SELECT perm.id AS permission_id,
perm.action_type AS action_type,
perm.object_type AS object_type,
c.project_id AS project_id,
m.role_id AS actor_id FROM permissions_private.profile_permissions AS jtbl INNER JOIN permissions_public.permission AS perm ON ((jtbl.permission_id) = (perm.id)) INNER JOIN collaboration_public.collaboration AS c ON (((jtbl.profile_id) = (c.profile_id)) AND ((jtbl.organization_id) = (c.organization_id))) INNER JOIN roles_public.memberships AS m ON ((m.group_id) = (c.role_id)) INNER JOIN roles_public.roles AS r ON ((c.role_id) = (r.id)) WHERE ((r.type) = ('Team'::roles_public.role_type));

CREATE VIEW collaboration_private.user_project_permits AS SELECT perm.id AS permission_id,
perm.action_type AS action_type,
perm.object_type AS object_type,
c.project_id AS project_id,
c.role_id AS actor_id FROM collaboration_public.collaboration AS c INNER JOIN permissions_private.profile_permissions AS jtbl ON (((jtbl.profile_id) = (c.profile_id)) AND ((jtbl.organization_id) = (c.organization_id))) INNER JOIN permissions_public.permission AS perm ON ((jtbl.permission_id) = (perm.id)) INNER JOIN roles_public.roles AS r ON ((c.role_id) = (r.id)) WHERE ((r.type) = ('User'::roles_public.role_type));

CREATE VIEW collaboration_private.project_permits AS ((SELECT * FROM collaboration_private.team_project_permits) UNION (SELECT * FROM collaboration_private.user_project_permits)) UNION (SELECT * FROM collaboration_private.admin_project_permits);

CREATE FUNCTION collaboration_private.permitted_on_project ( action_type citext, object_type citext, project_id uuid, actor_id uuid DEFAULT roles_public.current_role_id() ) RETURNS boolean AS $EOFCODE$
  SELECT
    -- NOTE we could remove this by adding a membership to yourself
    actor_id = (SELECT owner_id
      FROM projects_public.project
      WHERE id=project_id)
    OR
    EXISTS (
      SELECT
        1
      FROM
        collaboration_private.project_permits p
      WHERE
        p.action_type = permitted_on_project.action_type
        AND p.object_type = permitted_on_project.object_type
        AND p.project_id = permitted_on_project.project_id
        AND p.actor_id = permitted_on_project.actor_id
    );
$EOFCODE$ LANGUAGE sql STABLE SECURITY DEFINER;

CREATE INDEX collaboration_collaboration_id_idx ON collaboration_public.collaboration ( collaboration_id );

CREATE INDEX collaboration_invited_by_id_idx ON collaboration_public.collaboration ( invited_by_id );

CREATE INDEX collaboration_organization_id_idx ON collaboration_public.collaboration ( organization_id );

CREATE INDEX collaboration_project_id_idx ON collaboration_public.collaboration ( project_id );

CREATE INDEX collaboration_role_id_idx ON collaboration_public.collaboration ( role_id );

ALTER TABLE collaboration_public.collaboration ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_collaboration ON collaboration_public.collaboration FOR SELECT TO PUBLIC USING ( collaboration_private.permitted_on_project('read', 'user', project_id) );

CREATE POLICY can_insert_collaboration ON collaboration_public.collaboration FOR INSERT TO PUBLIC WITH CHECK ( (collaboration_private.permitted_on_project('add', 'user', project_id) AND collaboration_private.collaboration_actor_role_admin_owner_authorized_profiles(roles_public.current_role_id(), project_id, profile_id, organization_id)) );

CREATE POLICY can_update_collaboration ON collaboration_public.collaboration FOR UPDATE TO PUBLIC USING ( (collaboration_private.permitted_on_project('edit', 'user', project_id) AND collaboration_private.collaboration_actor_role_admin_owner_authorized_profiles(roles_public.current_role_id(), project_id, profile_id, organization_id)) );

CREATE POLICY can_delete_collaboration ON collaboration_public.collaboration FOR DELETE TO PUBLIC USING ( (collaboration_private.permitted_on_project('destroy', 'user', project_id) AND collaboration_private.collaboration_actor_role_admin_owner_authorized_profiles(roles_public.current_role_id(), project_id, profile_id, organization_id)) );

GRANT INSERT ON TABLE collaboration_public.collaboration TO authenticated;

GRANT SELECT ON TABLE collaboration_public.collaboration TO authenticated;

GRANT UPDATE ON TABLE collaboration_public.collaboration TO authenticated;

GRANT DELETE ON TABLE collaboration_public.collaboration TO authenticated;

CREATE SCHEMA projects_private;

GRANT USAGE ON SCHEMA projects_private TO authenticated;

ALTER DEFAULT PRIVILEGES IN SCHEMA projects_private 
 GRANT EXECUTE ON FUNCTIONS  TO authenticated;

CREATE TABLE projects_private.project_secrets (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	project_id uuid REFERENCES projects_public.project ON DELETE CASCADE,
	name text,
	value bytea,
	UNIQUE ( project_id, name ) 
);

CREATE FUNCTION projects_private.get_project_master_key ( proj_id uuid ) RETURNS text AS $EOFCODE$
DECLARE
  v_master_secret projects_private.project_secrets;
  v_master_key text;
BEGIN
  SELECT
    *
  FROM
    projects_private.project_secrets s
  WHERE
    s.name = 'MASTER_KEY'
    AND s.project_id = proj_id INTO v_master_secret;
  IF (NOT FOUND) THEN
    INSERT INTO projects_private.project_secrets (project_id, name, value)
      VALUES (proj_id, 'MASTER_KEY', pgp_sym_encrypt(encode(gen_random_bytes(48), 'hex'), proj_id::text, 'compress-algo=1, cipher-algo=aes256'))
    RETURNING
      * INTO v_master_secret;
  END IF;
  SELECT
    *
  FROM
    pgp_sym_decrypt(v_master_secret.value, proj_id::text) INTO v_master_key;
  IF (length(v_master_key) < 48) THEN
    RAISE
    EXCEPTION 'SECRETS_NO_KEY_EXISTS';
  END IF;
  RETURN v_master_key;
END
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION projects_private.get_project_secret ( proj_id uuid, secret_name text ) RETURNS text AS $EOFCODE$
DECLARE
  v_master_key text;
  v_secret projects_private.project_secrets;
BEGIN
  IF (secret_name = 'MASTER_KEY') THEN
    RAISE
    EXCEPTION 'GENERIC_NO_OBJECT_EXISTS';
  END IF;
  SELECT
    projects_private.get_project_master_key (proj_id) INTO v_master_key;
  IF (NOT FOUND) THEN
    RAISE
    EXCEPTION 'GENERIC_NO_OBJECT_EXISTS';
  END IF;
  SELECT
    *
  FROM
    projects_private.project_secrets s
  WHERE
    s.name = secret_name
    AND s.project_id = proj_id INTO v_secret;
  IF (NOT FOUND) THEN
    RAISE
    EXCEPTION 'GENERIC_NO_OBJECT_EXISTS';
  END IF;
  RETURN pgp_sym_decrypt(v_secret.value, v_master_key);
END
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE TABLE projects_private.project_grants (
 	role_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	proj_id uuid NOT NULL REFERENCES projects_public.project ( id ) ON DELETE CASCADE,
	PRIMARY KEY ( role_id, proj_id ) 
);

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE projects_private.project_grants TO authenticated;

ALTER TABLE projects_private.project_secrets ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_project_secrets ON projects_private.project_secrets FOR SELECT TO PUBLIC USING ( collaboration_private.permitted_on_project('read', 'secret', project_id) );

CREATE POLICY can_insert_project_secrets ON projects_private.project_secrets FOR INSERT TO PUBLIC WITH CHECK ( collaboration_private.permitted_on_project('add', 'secret', project_id) );

CREATE POLICY can_update_project_secrets ON projects_private.project_secrets FOR UPDATE TO PUBLIC USING ( collaboration_private.permitted_on_project('edit', 'secret', project_id) );

CREATE POLICY can_delete_project_secrets ON projects_private.project_secrets FOR DELETE TO PUBLIC USING ( collaboration_private.permitted_on_project('destroy', 'secret', project_id) );

GRANT INSERT ON TABLE projects_private.project_secrets TO authenticated;

GRANT SELECT ON TABLE projects_private.project_secrets TO authenticated;

GRANT UPDATE ON TABLE projects_private.project_secrets TO authenticated;

GRANT DELETE ON TABLE projects_private.project_secrets TO authenticated;

CREATE FUNCTION projects_public.remove_project_secret ( proj_id uuid, secret_name text ) RETURNS boolean AS $EOFCODE$
DECLARE
  v_proj projects_public.project;
  v_master_secret projects_private.project_secrets;
  v_master_key text;
BEGIN
  IF (secret_name = 'MASTER_KEY') THEN
    RETURN FALSE;
  END IF;
  DELETE FROM projects_private.project_secrets
  WHERE project_id = proj_id
    AND name = secret_name;
  RETURN TRUE;
END
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION projects_public.upsert_project_secret ( proj_id uuid, secret_name text, value text ) RETURNS boolean AS $EOFCODE$
DECLARE
  v_proj projects_public.project;
  v_master_secret projects_private.project_secrets;
  v_master_key text;
  v_value bytea;
BEGIN
  IF (secret_name = 'MASTER_KEY') THEN
    RETURN FALSE;
  END IF;
  SELECT
    projects_private.get_project_master_key (proj_id) INTO v_master_key;
  IF (NOT FOUND) THEN
    RAISE
    EXCEPTION 'GENERIC_NO_OBJECT_EXISTS';
  END IF;
  SELECT
    pgp_sym_encrypt(value, v_master_key, 'compress-algo=1, cipher-algo=aes256') INTO v_value;
  INSERT INTO projects_private.project_secrets (project_id, name, value)
    VALUES (proj_id, secret_name, v_value) ON CONFLICT (project_id, name)
    DO
    UPDATE
    SET
      value = EXCLUDED.value;
  RETURN TRUE;
END
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TABLE projects_public.project_transfer (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	project_id uuid NOT NULL REFERENCES projects_public.project ( id ) ON DELETE CASCADE,
	current_owner_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	new_owner_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	accepted boolean NOT NULL DEFAULT ( (FALSE) ),
	transferred boolean NOT NULL DEFAULT ( (FALSE) ),
	sender_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	transfer_token text NOT NULL DEFAULT ( encode(gen_random_bytes(32), 'hex') ),
	expires_at timestamptz NOT NULL DEFAULT ( ((now()) + ('1 day'::interval)) ),
	created_at timestamptz NOT NULL DEFAULT ( now() ),
	UNIQUE ( transfer_token ) 
);

ALTER TABLE projects_public.project_transfer ADD CONSTRAINT uniq_transfer_using_expires EXCLUDE USING gist ( project_id WITH = , make_tsrange(created_at, expires_at) WITH && );

CREATE INDEX project_transfers_new_owner_id_idx ON projects_public.project_transfer ( new_owner_id );

CREATE INDEX project_transfers_sender_id_idx ON projects_public.project_transfer ( sender_id );

ALTER TABLE projects_public.project_transfer ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_project_transfers ON projects_public.project_transfer FOR SELECT TO PUBLIC USING ( ((((roles_public.current_role_id()) = (sender_id)) OR permissions_private.permitted_on_role('transfer', 'project', current_owner_id) OR collaboration_private.permitted_on_project('transfer', 'project', project_id) OR permissions_private.permitted_on_role('transfer', 'project', new_owner_id)) AND ((pg_catalog.date_part('epoch', ((expires_at) - (now())))) > (0))) );

CREATE POLICY can_insert_project_transfers ON projects_public.project_transfer FOR INSERT TO PUBLIC WITH CHECK ( (permissions_private.permitted_on_role('transfer', 'project', current_owner_id) OR collaboration_private.permitted_on_project('transfer', 'project', project_id)) );

CREATE POLICY can_update_project_transfers ON projects_public.project_transfer FOR UPDATE TO PUBLIC USING ( (permissions_private.permitted_on_role('transfer', 'project', new_owner_id) AND ((pg_catalog.date_part('epoch', ((expires_at) - (now())))) > (0))) );

CREATE POLICY can_delete_project_transfers ON projects_public.project_transfer FOR DELETE TO PUBLIC USING ( (((pg_catalog.date_part('epoch', ((expires_at) - (now())))) > (0)) AND NOT (transferred) AND (permissions_private.permitted_on_role('transfer', 'project', current_owner_id) OR collaboration_private.permitted_on_project('transfer', 'project', project_id) OR permissions_private.permitted_on_role('transfer', 'project', new_owner_id))) );

GRANT INSERT ( project_id, new_owner_id ) ON TABLE projects_public.project_transfer TO authenticated;

GRANT SELECT ( id, project_id, current_owner_id, new_owner_id, accepted, transferred, sender_id, expires_at, created_at ) ON TABLE projects_public.project_transfer TO authenticated;

GRANT UPDATE ( accepted ) ON TABLE projects_public.project_transfer TO authenticated;

GRANT DELETE ON TABLE projects_public.project_transfer TO authenticated;

CREATE FUNCTION projects_private.tg_on_transfer_accepted (  ) RETURNS trigger AS $EOFCODE$
BEGIN

  IF (NEW.transferred) THEN
    RAISE EXCEPTION 'PROJECT_TRANSFERS_ALREADY_TRANSFERRED';
  END IF;

-- TODO [ ] update organization_id
-- TODO [ ] remove grants, maybe we do not even need them by default?
-- TODO [ ] use username or something better than id?
-- TODO [ ] when proj name conflicts?

  IF (NEW.accepted) THEN
    UPDATE projects_public.project
      SET owner_id=NEW.new_owner_id
      WHERE id=NEW.project_id;

    NEW.transferred = TRUE;
  END IF;
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_transfer_accepted 
 BEFORE UPDATE ON projects_public.project_transfer 
 FOR EACH ROW
 WHEN ( NEW.accepted IS DISTINCT FROM OLD.accepted ) 
 EXECUTE PROCEDURE projects_private. tg_on_transfer_accepted (  );

CREATE FUNCTION projects_private.tg_on_transfer_created (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  v_proj projects_public.project;
  v_owner roles_public.roles;
  v_new_owner roles_public.roles;
BEGIN

  SELECT * FROM projects_public.project WHERE id=NEW.project_id
  INTO v_proj;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'PROJECT_TRANSFERS_NOT_FOUND';
  END IF;

  SELECT * FROM roles_public.roles WHERE id=v_proj.owner_id
  INTO v_owner;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'PROJECT_TRANSFERS_OWNER_NOT_FOUND';
  END IF;

  SELECT * FROM roles_public.roles WHERE id=NEW.new_owner_id
  INTO v_new_owner;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'PROJECT_TRANSFERS_NEW_OWNER_NOT_FOUND';
  END IF;


  IF (v_new_owner.type = 'Team'::roles_public.role_type) THEN
    RAISE EXCEPTION 'PROJECT_TRANSFERS_NOT_FOR_TEAMS';
  END IF;

  NEW.current_owner_id = v_proj.owner_id;
  NEW.sender_id = roles_public.current_role_id();

  -- Trigger project transfer email
  PERFORM
    app_jobs.add_job ('project__transfer_project_email',
        json_build_object(
          'project_id', NEW.project_id::text,
          'current_owner_id', NEW.current_owner_id::text,
          'new_owner_id', NEW.new_owner_id::text,
          'sender_id', NEW.sender_id::text,
          'transfer_token', NEW.transfer_token
        ));

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_transfer_created 
 BEFORE INSERT ON projects_public.project_transfer 
 FOR EACH ROW
 EXECUTE PROCEDURE projects_private. tg_on_transfer_created (  );

CREATE UNIQUE INDEX projects_project_name_owner_id_idx ON projects_public.project ( owner_id, name );

ALTER TABLE projects_public.project ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_project ON projects_public.project FOR SELECT TO PUBLIC USING ( (permissions_private.permitted_on_role('browse', 'project', owner_id) OR collaboration_private.permitted_on_project('browse', 'project', id)) );

CREATE POLICY can_insert_project ON projects_public.project FOR INSERT TO PUBLIC WITH CHECK ( permissions_private.permitted_on_role('add', 'project', owner_id) );

CREATE POLICY can_update_project ON projects_public.project FOR UPDATE TO PUBLIC USING ( (permissions_private.permitted_on_role('edit', 'project', owner_id) OR collaboration_private.permitted_on_project('edit', 'project', id)) );

CREATE POLICY can_delete_project ON projects_public.project FOR DELETE TO PUBLIC USING ( (permissions_private.permitted_on_role('destroy', 'project', owner_id) OR collaboration_private.permitted_on_project('destroy', 'project', id)) );

GRANT INSERT ON TABLE projects_public.project TO authenticated;

GRANT SELECT ON TABLE projects_public.project TO authenticated;

GRANT UPDATE ON TABLE projects_public.project TO authenticated;

GRANT DELETE ON TABLE projects_public.project TO authenticated;

CREATE FUNCTION projects_private.tg_on_insert_ensure_proper_owner (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  v_owner roles_public.roles;
BEGIN
  SELECT
    *
  FROM
    roles_public.roles
  WHERE
    id = NEW.owner_id INTO v_owner;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'PROJECTS_NO_OWNER';
  END IF;

  IF (v_owner.type = 'Team'::roles_public.role_type) THEN
    RAISE EXCEPTION 'PROJECTS_NOT_FOR_TEAMS';
  END IF;
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_insert_ensure_proper_owner 
 BEFORE INSERT ON projects_public.project 
 FOR EACH ROW
 EXECUTE PROCEDURE projects_private. tg_on_insert_ensure_proper_owner (  );

ALTER TABLE projects_public.project ADD COLUMN  created_at timestamptz;

ALTER TABLE projects_public.project ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE projects_public.project ADD COLUMN  updated_at timestamptz;

ALTER TABLE projects_public.project ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER update_projects_public_project_modtime 
 BEFORE INSERT OR UPDATE ON projects_public.project 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_timestamps (  );