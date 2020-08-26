\echo Use "CREATE EXTENSION webql-roles" to load this file. \quit
CREATE SCHEMA roles_public;

CREATE FUNCTION roles_public.current_role_id (  ) RETURNS uuid AS $EOFCODE$
DECLARE
  role_id uuid;
BEGIN
  IF current_setting('jwt.claims.role_id', TRUE)
    IS NOT NULL THEN
    BEGIN
      role_id = current_setting('jwt.claims.role_id', TRUE)::uuid;
    EXCEPTION
      WHEN OTHERS THEN
      RAISE NOTICE 'Invalid UUID value: "%".  Returning NULL.', current_setting('jwt.claims.role_id', TRUE);
    RETURN NULL;
    END;
    RETURN role_id;
  ELSE
    RETURN NULL;
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

GRANT EXECUTE ON FUNCTION roles_public.current_role_id TO anonymous, authenticated;

CREATE FUNCTION tg_update_peoplestamps (  ) RETURNS trigger AS $EOFCODE$
BEGIN
    IF TG_OP = 'INSERT' THEN
      NEW.created_by = roles_public.current_role_id();
      NEW.updated_by = roles_public.current_role_id();
    ELSIF TG_OP = 'UPDATE' THEN
      NEW.created_by = OLD.created_by;
      NEW.updated_by = roles_public.current_role_id();
    END IF;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql;

CREATE SCHEMA auth_private;

GRANT USAGE ON SCHEMA auth_private TO anonymous;

GRANT USAGE ON SCHEMA auth_private TO authenticated;

CREATE TYPE auth_private.token_type AS ENUM (
 	'auth',
	'totp',
	'service' 
);

CREATE TYPE roles_public.role_type AS ENUM (
 	'Organization',
	'Team',
	'User' 
);

CREATE TABLE roles_public.roles (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	type roles_public.role_type NOT NULL,
	username citext NULL,
	parent_id uuid NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	organization_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE 
);

COMMENT ON TABLE roles_public.roles IS E'A user of the forum.';

COMMENT ON COLUMN roles_public.roles.username IS E'Unique username.';

COMMENT ON COLUMN roles_public.roles.parent_id IS E'A Team role has a parent.';

COMMENT ON COLUMN roles_public.roles.organization_id IS E'A Team role has an owner.';

CREATE TABLE auth_private.client (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	label text NOT NULL,
	api_key text NOT NULL DEFAULT ( encode(gen_random_bytes(24), 'hex') ),
	secret_key text NOT NULL DEFAULT ( encode(gen_random_bytes(48), 'hex') ),
	role_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE 
);

CREATE SCHEMA auth_public;

CREATE TABLE auth_public.user_authentications (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	role_id uuid NOT NULL REFERENCES roles_public.roles ON DELETE CASCADE,
	service text NOT NULL,
	identifier text NOT NULL,
	details jsonb NOT NULL DEFAULT ( '{}'::jsonb ),
	CONSTRAINT uniq_user_authentications UNIQUE ( service, identifier ) 
);

COMMENT ON TABLE auth_public.user_authentications IS E'@omit all
Contains information about the login providers this user has used, so that they may disconnect them should they wish.';

COMMENT ON COLUMN auth_public.user_authentications.role_id IS E'@omit';

COMMENT ON COLUMN auth_public.user_authentications.service IS E'The login service used, e.g. `twitter` or `github`.';

COMMENT ON COLUMN auth_public.user_authentications.identifier IS E'A unique identifier for the user within the login service.';

COMMENT ON COLUMN auth_public.user_authentications.details IS E'@omit
Additional profile details extracted from this login method';

CREATE TABLE auth_private.token (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	type auth_private.token_type NOT NULL,
	access_token text NOT NULL DEFAULT ( encode(gen_random_bytes(48), 'hex') ),
	access_token_expires_at timestamptz NOT NULL DEFAULT ( ((now()) + ('6 hours'::interval)) ),
	refresh_token text NULL DEFAULT ( NULL ),
	role_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	auth_id uuid NULL DEFAULT ( NULL ) REFERENCES auth_public.user_authentications ( id ) ON DELETE CASCADE,
	client_id uuid NULL DEFAULT ( NULL ) REFERENCES auth_private.client ( id ) ON DELETE CASCADE,
	UNIQUE ( access_token ) 
);

COMMENT ON TABLE auth_private.token IS E'Tokens used for authentication';

CREATE FUNCTION auth_private.authenticate ( token text ) RETURNS SETOF auth_private.token AS $EOFCODE$
SELECT
    tkn.*
FROM
    auth_private.token AS tkn
WHERE
    tkn.access_token = authenticate.token
    AND EXTRACT(EPOCH FROM (tkn.access_token_expires_at-NOW())) > 0;
$EOFCODE$ LANGUAGE sql STABLE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION auth_private.authenticate TO anonymous;

CREATE SCHEMA roles_private;

ALTER DEFAULT PRIVILEGES IN SCHEMA roles_private 
 GRANT EXECUTE ON FUNCTIONS  TO authenticated;

CREATE TABLE roles_private.user_secrets (
 	role_id uuid PRIMARY KEY REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	invites_approved boolean NOT NULL DEFAULT ( (FALSE) ),
	invited_by_id uuid NULL,
	password_hash text NOT NULL,
	password_attempts int NOT NULL DEFAULT ( 0 ),
	first_failed_password_attempt timestamptz,
	reset_password_token text,
	reset_password_token_generated timestamptz,
	reset_password_attempts int NOT NULL DEFAULT ( 0 ),
	first_failed_reset_password_attempt timestamptz,
	multi_factor_attempts int NOT NULL DEFAULT ( 0 ),
	first_failed_multi_factor_attempt timestamptz,
	multi_factor_secret text 
);

COMMENT ON TABLE roles_private.user_secrets IS E'The contents of this table should never be visible to the user. Contains data mostly related to authentication.';

COMMENT ON COLUMN roles_private.user_secrets.multi_factor_secret IS E'Secret for the Time-Based One-time Password (TOTP) algorithm defined in RFC 6238';

CREATE FUNCTION auth_private.set_multi_factor_secret ( secret text DEFAULT NULL ) RETURNS boolean AS $EOFCODE$
DECLARE
  secrets roles_private.user_secrets;
BEGIN

  SELECT st.* FROM roles_private.user_secrets AS st
    WHERE st.role_id = roles_public.current_role_id()
    INTO secrets;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  IF (secrets.multi_factor_secret IS NULL) THEN
    IF (secret IS NULL) THEN
      RAISE EXCEPTION 'MFA_NOT_ENABLED';
    END IF;
    UPDATE roles_private.user_secrets sts
      SET multi_factor_secret=secret
      WHERE sts.role_id = roles_public.current_role_id();
    RETURN TRUE;
  ELSE
    IF (secret IS NOT NULL) THEN
      RAISE EXCEPTION 'MFA_ENABLED_TWICE';
    END IF;
    UPDATE roles_private.user_secrets sts
      SET multi_factor_secret=secret
      WHERE sts.role_id = roles_public.current_role_id();
    RETURN FALSE;
  END IF;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION auth_private.set_multi_factor_secret TO authenticated;

CREATE FUNCTION auth_private.current_token (  ) RETURNS auth_private.token AS $EOFCODE$
DECLARE
  token auth_private.token;
BEGIN
  IF current_setting('jwt.claims.access_token', TRUE)
    IS NOT NULL THEN
    SELECT
      tkn.*
    FROM
      auth_private.token AS tkn
    WHERE
      tkn.access_token = current_setting('jwt.claims.access_token', TRUE)
      AND EXTRACT(EPOCH FROM (tkn.access_token_expires_at - NOW())) > 0 INTO token;
    RETURN token;
  ELSE
    RETURN NULL;
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION auth_private.multi_factor_auth ( verified boolean ) RETURNS auth_private.token AS $EOFCODE$
DECLARE
secret roles_private.user_secrets;
current_token auth_private.token;
token auth_private.token;
mfa_attempt_window_duration interval = interval '1 hours';
mfa_max_attempts int = 5;
BEGIN

  SELECT * FROM auth_private.current_token()
    INTO current_token;

  IF (current_token.type != 'totp'::auth_private.token_type) THEN
    RETURN NULL;
  END IF;

  SELECT st.* FROM roles_private.user_secrets AS st
    WHERE st.role_id = current_token.role_id
    INTO secret;

  IF (NOT FOUND) THEN
    RETURN NULL;
  END IF;

  IF (secret.first_failed_multi_factor_attempt is not null
    AND secret.first_failed_multi_factor_attempt > NOW() - mfa_attempt_window_duration
    AND secret.multi_factor_attempts >= mfa_max_attempts) THEN
      RAISE EXCEPTION 'ACCOUNT_LOCKED_EXCEED_MFA_ATTEMPTS';
  END IF;

  IF verified THEN
    -- green light! login...
    -- reset the attempts
    UPDATE roles_private.user_secrets scts
      SET multi_factor_attempts = 0, first_failed_multi_factor_attempt = null
      WHERE scts.role_id = current_token.role_id;

    INSERT INTO auth_private.token (type, role_id)
    VALUES ('auth'::auth_private.token_type, secret.role_id)
    RETURNING
      *
    INTO token;

    RETURN token;
  ELSE
    -- bad login!
    UPDATE roles_private.user_secrets scts
      SET
        multi_factor_attempts = (CASE WHEN first_failed_multi_factor_attempt is NULL OR first_failed_multi_factor_attempt < NOW() - mfa_attempt_window_duration THEN 1 ELSE multi_factor_attempts + 1 END),
        first_failed_multi_factor_attempt = (CASE WHEN first_failed_multi_factor_attempt is NULL OR first_failed_multi_factor_attempt < NOW() - mfa_attempt_window_duration THEN NOW() ELSE first_failed_multi_factor_attempt END)
      WHERE scts.role_id = current_token.role_id;

    RETURN NULL;
  END IF;

END;
$EOFCODE$ LANGUAGE plpgsql STRICT SECURITY DEFINER;

COMMENT ON FUNCTION auth_private.multi_factor_auth IS E'Upon success, should return a login auth_private.token';

CREATE INDEX client_role_id_idx ON auth_private.client ( role_id );

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE auth_private.token TO administrator;

CREATE INDEX token_client_id_idx ON auth_private.token ( client_id );

CREATE INDEX token_role_id_idx ON auth_private.token ( role_id );

CREATE FUNCTION auth_private.tg_on_create_token (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  secret roles_private.user_secrets;
  current_token auth_private.token;
BEGIN

  IF (NEW.role_id IS NULL) THEN
    RAISE EXCEPTION 'TOKENS_REQUIRE_ROLE';
  END IF;

  SELECT * INTO secret FROM roles_private.user_secrets
    WHERE role_id = NEW.role_id;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'TOKENS_REQUIRE_USER_ROLE';
  END IF;

  NEW.refresh_token = NULL;

  IF (NEW.type = 'auth'::auth_private.token_type) THEN
    IF (secret.multi_factor_secret IS NOT NULL) THEN
      SELECT *
        FROM auth_private.current_token()
        INTO current_token;
      IF (current_token.type = 'totp'::auth_private.token_type) THEN
        NEW.type = 'auth'::auth_private.token_type;
        NEW.refresh_token = encode( gen_random_bytes( 48 ), 'hex' );
        NEW.access_token_expires_at = NOW() + interval '1 hour';
      ELSE
        NEW.type = 'totp'::auth_private.token_type;
        NEW.access_token_expires_at = NOW() + interval '10 minutes';
      END IF;
    ELSE
      NEW.refresh_token = encode( gen_random_bytes( 48 ), 'hex' );
    END IF;
  ELSIF (NEW.type = 'totp'::auth_private.token_type) THEN
    RAISE EXCEPTION 'TOKENS_CANT_CREATE_TOTP';
  ELSIF (NEW.type = 'service'::auth_private.token_type) THEN
    NEW.access_token_expires_at = NOW() + interval '10 minutes';
  END IF;

  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_create_token 
 BEFORE INSERT ON auth_private.token 
 FOR EACH ROW
 EXECUTE PROCEDURE auth_private. tg_on_create_token (  );

ALTER TABLE auth_private.token ADD COLUMN  created_at timestamptz;

ALTER TABLE auth_private.token ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE auth_private.token ADD COLUMN  updated_at timestamptz;

ALTER TABLE auth_private.token ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER update_auth_private_token_modtime 
 BEFORE INSERT OR UPDATE ON auth_private.token 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_timestamps (  );

CREATE TABLE auth_private.user_authentication_secrets (
 	user_authentication_id uuid NOT NULL PRIMARY KEY REFERENCES auth_public.user_authentications ON DELETE CASCADE,
	details jsonb NOT NULL DEFAULT ( '{}'::jsonb ) 
);

ALTER TABLE auth_private.user_authentication_secrets ENABLE ROW LEVEL SECURITY;

GRANT USAGE ON SCHEMA auth_public TO administrator;

GRANT USAGE ON SCHEMA auth_public TO anonymous;

GRANT USAGE ON SCHEMA auth_public TO authenticated;

CREATE FUNCTION auth_public.create_service_token (  ) RETURNS auth_private.token AS $EOFCODE$
DECLARE
  v_token auth_private.token;
BEGIN
  INSERT INTO auth_private.token (TYPE, role_id)
    VALUES ('service'::auth_private.token_type, roles_public.current_role_id ())
  RETURNING
    * INTO v_token;
  RETURN v_token;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION auth_public.create_service_token TO authenticated;

CREATE FUNCTION auth_public.refresh_token ( access_token text, refresh_token text ) RETURNS auth_private.token AS $EOFCODE$
DECLARE
  updated_token auth_private.token;
  existing_token auth_private.token;
BEGIN
  SELECT tokens.* FROM auth_private.token tokens
    WHERE tokens.access_token = refresh_token.access_token
    AND tokens.refresh_token = refresh_token.refresh_token
  INTO existing_token;

  IF (NOT FOUND) THEN
    -- TODO after many bad attempts, we should destroy the token
    RETURN NULL;
  END IF;
 
  IF (existing_token.type = 'totp'::auth_private.token_type) THEN
    RAISE EXCEPTION 'TOKENS_REFRESH_TOTP';
  ELSIF (existing_token.type = 'service'::auth_private.token_type) THEN
    RAISE EXCEPTION 'TOKENS_REFRESH_SERVICE';
  ELSIF (existing_token.type != 'auth'::auth_private.token_type) THEN
    RAISE EXCEPTION 'TOKENS_REFRESH_NON_AUTH';
  END IF;

  UPDATE auth_private.token tkns
    SET
      access_token_expires_at = NOW() + interval '1 hour',
      access_token = encode( gen_random_bytes( 48 ), 'hex' )
    WHERE tkns.access_token = refresh_token.access_token
    RETURNING
      *
    INTO updated_token;

  RETURN updated_token;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION auth_public.refresh_token TO anonymous;

ALTER TABLE auth_public.user_authentications ENABLE ROW LEVEL SECURITY;

CREATE POLICY delete_own ON auth_public.user_authentications FOR DELETE TO PUBLIC USING ( ((role_id) = (roles_public.current_role_id())) );

GRANT DELETE ON TABLE auth_public.user_authentications TO authenticated;

CREATE POLICY select_own ON auth_public.user_authentications FOR SELECT TO PUBLIC USING ( ((role_id) = (roles_public.current_role_id())) );

GRANT SELECT ON TABLE auth_public.user_authentications TO authenticated;

ALTER TABLE auth_public.user_authentications ADD COLUMN  created_at timestamptz;

ALTER TABLE auth_public.user_authentications ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE auth_public.user_authentications ADD COLUMN  updated_at timestamptz;

ALTER TABLE auth_public.user_authentications ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER update_auth_public_user_authentications_modtime 
 BEFORE INSERT OR UPDATE ON auth_public.user_authentications 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_timestamps (  );

CREATE SCHEMA permissions_private;

GRANT USAGE ON SCHEMA permissions_private TO authenticated, anonymous;

ALTER DEFAULT PRIVILEGES IN SCHEMA permissions_private 
 GRANT EXECUTE ON FUNCTIONS  TO authenticated;

CREATE SCHEMA permissions_public;

GRANT USAGE ON SCHEMA permissions_public TO authenticated, anonymous;

ALTER DEFAULT PRIVILEGES IN SCHEMA permissions_public 
 GRANT EXECUTE ON FUNCTIONS  TO authenticated;

CREATE TABLE permissions_public.profile (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	name text,
	description text,
	organization_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	UNIQUE ( organization_id, name ) 
);

CREATE TABLE permissions_public.permission (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	name varchar(50) NOT NULL,
	object_type varchar(50) NOT NULL,
	action_type varchar(50) NOT NULL,
	UNIQUE ( name ) 
);

CREATE TABLE permissions_private.profile_permissions (
 	profile_id uuid NOT NULL REFERENCES permissions_public.profile ( id ) ON DELETE CASCADE,
	permission_id uuid NOT NULL REFERENCES permissions_public.permission ( id ) ON DELETE CASCADE,
	organization_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	PRIMARY KEY ( profile_id, permission_id ) 
);

CREATE FUNCTION permissions_public.add_permissions_to_profile ( profile_id uuid, object_type text[], action_type text[] ) RETURNS void AS $EOFCODE$
DECLARE
  perm_id uuid;
BEGIN
  FOR perm_id IN
  SELECT
    id
  FROM
    permissions_public.permission p
  WHERE
    p.object_type = ANY (add_permissions_to_profile.object_type)
    AND p.action_type = ANY (add_permissions_to_profile.action_type)
    LOOP
      INSERT INTO permissions_private.profile_permissions (profile_id, permission_id)
      VALUES (add_permissions_to_profile.profile_id, perm_id) ON CONFLICT DO NOTHING;
    END LOOP;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION permissions_public.add_permissions_to_profile ( profile_id uuid, object_type text[], action_type text ) RETURNS void AS $EOFCODE$
DECLARE
  perm_id uuid;
BEGIN
  IF (action_type = 'all') THEN
    FOR perm_id IN
    SELECT
      id
    FROM
      permissions_public.permission p
    WHERE
      p.object_type = ANY (add_permissions_to_profile.object_type)
      LOOP
        INSERT INTO permissions_private.profile_permissions (profile_id, permission_id)
        VALUES (add_permissions_to_profile.profile_id, perm_id) ON CONFLICT DO NOTHING;
      END LOOP;
  ELSE
    FOR perm_id IN
    SELECT
      id
    FROM
      permissions_public.permission p
    WHERE
      p.object_type = ANY (add_permissions_to_profile.object_type)
      AND p.action_type = add_permissions_to_profile.action_type LOOP
        INSERT INTO permissions_private.profile_permissions (profile_id, permission_id)
        VALUES (add_permissions_to_profile.profile_id, perm_id) ON CONFLICT DO NOTHING;
      END LOOP;
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION permissions_private.initialize_organization_profiles_and_permissions ( organization_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  v_owner permissions_public.profile;
  v_administrator permissions_public.profile;
  v_editor permissions_public.profile;
  v_author permissions_public.profile;
  v_contributor permissions_public.profile;
  v_member permissions_public.profile;
  v_subscriber permissions_public.profile;
  perm_id uuid;
  all_types text[];
BEGIN

SELECT array_agg(distinct(object_type))
  FROM permissions_public.permission
INTO all_types;

  --- Owner
  INSERT INTO permissions_public.profile (name, description, organization_id)
  VALUES ('Owner', 'Owners', organization_id)
RETURNING
  * INTO v_owner;


    PERFORM permissions_public.add_permissions_to_profile
      (v_owner.id, all_types, 'all');

  --- Administrator
  INSERT INTO permissions_public.profile (name, description, organization_id)
  VALUES ('Administrator', 'Administrators', organization_id)
RETURNING
  * INTO v_administrator;

    PERFORM permissions_public.add_permissions_to_profile
      (v_administrator.id, all_types, 'all');


  --- Editor
  INSERT INTO permissions_public.profile (name, description, organization_id)
  VALUES ('Editor', 'Editors', organization_id)
RETURNING
  * INTO v_editor;
 
    PERFORM permissions_public.add_permissions_to_profile
      (v_editor.id, ARRAY[
        'project',
        'content',
        'secret',
        'post',
        'invite'
      ], ARRAY[
        'read', 'browse', 'add', 'edit', 'destroy'
      ]);
  
    PERFORM permissions_public.add_permissions_to_profile
      (v_editor.id, ARRAY[
        'user',
        'team',
        'role',
        'role_profile',
        'role_setting'
      ], ARRAY[
        'read', 'browse'
      ]);

    PERFORM permissions_public.add_permissions_to_profile
      (v_editor.id, ARRAY[
        'content'
      ], ARRAY[
        'upload'
      ]);

  --- Author
  INSERT INTO permissions_public.profile (name, description, organization_id)
  VALUES ('Author', 'Authors', organization_id)
RETURNING
  * INTO v_author;
 
    PERFORM permissions_public.add_permissions_to_profile
      (v_author.id, ARRAY[
        'project',
        'content',
        'secret',
        'post',
        'invite'
      ], ARRAY[
        'read', 'browse', 'add', 'edit', 'destroy'
      ]);
  
    PERFORM permissions_public.add_permissions_to_profile
      (v_author.id, ARRAY[
        'user',
        'team',
        'role',
        'role_profile',
        'role_setting'
      ], ARRAY[
        'read', 'browse'
      ]);

    PERFORM permissions_public.add_permissions_to_profile
      (v_author.id, ARRAY[
        'content'
      ], ARRAY[
        'upload'
      ]);

  --- Contributor
  INSERT INTO permissions_public.profile (name, description, organization_id)
  VALUES ('Contributor', 'Contributors', organization_id)
RETURNING
  * INTO v_contributor;
  
    PERFORM permissions_public.add_permissions_to_profile
      (v_contributor.id, ARRAY[
        'project',
        'content',
        'secret',
        'post',
        'invite'
      ], ARRAY[
        'read', 'browse', 'add', 'edit', 'destroy'
      ]);
  
    PERFORM permissions_public.add_permissions_to_profile
      (v_contributor.id, ARRAY[
        'user',
        'team',
        'role',
        'role_profile',
        'role_setting'
      ], ARRAY[
        'read', 'browse'
      ]);

    PERFORM permissions_public.add_permissions_to_profile
      (v_contributor.id, ARRAY[
        'content'
      ], ARRAY[
        'upload'
      ]);
  

  --- Member
  INSERT INTO permissions_public.profile (name, description, organization_id)
  VALUES ('Member', 'Members', organization_id)
RETURNING
  * INTO v_member;

    PERFORM permissions_public.add_permissions_to_profile
      (v_member.id, all_types, ARRAY[
        'read', 'browse'
      ]);

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TABLE roles_public.role_profiles (
 	role_id uuid PRIMARY KEY REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	organization_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	display_name text NULL,
	avatar_url text CHECK ( ((avatar_url) ~ ('^https?://[^/]+')) ),
	bio text NULL,
	url text NULL,
	company text NULL,
	location text NULL 
);

CREATE TABLE roles_public.memberships (
 	id uuid PRIMARY KEY NOT NULL DEFAULT ( uuid_generate_v4() ),
	profile_id uuid NOT NULL REFERENCES permissions_public.profile ( id ) ON DELETE CASCADE,
	role_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	group_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	organization_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	invited_by_id uuid NULL REFERENCES roles_public.roles ( id ),
	inherited boolean NOT NULL DEFAULT ( (FALSE) ),
	membership_id uuid NULL REFERENCES roles_public.memberships ( id ) ON DELETE CASCADE,
	UNIQUE ( role_id, group_id ) 
);

COMMENT ON CONSTRAINT memberships_membership_id_fkey ON roles_public . memberships IS E'@fieldName parent';

COMMENT ON COLUMN roles_public.memberships.role_id IS E'the role granted a membership';

COMMENT ON COLUMN roles_public.memberships.group_id IS E'the group that is accessed via this membership';

COMMENT ON COLUMN roles_public.memberships.organization_id IS E'the organization owns the group';

CREATE VIEW permissions_private.team_permits AS SELECT perm.id AS permission_id,
perm.action_type AS action_type,
perm.object_type AS object_type,
membership.group_id AS role_id,
membership.role_id AS actor_id,
rp.display_name AS "group",
r.username,
perm.name AS name FROM roles_public.memberships AS membership INNER JOIN permissions_private.profile_permissions AS jtbl ON (((jtbl.profile_id) = (membership.profile_id)) AND ((jtbl.organization_id) = (membership.organization_id))) INNER JOIN permissions_public.permission AS perm ON ((jtbl.permission_id) = (perm.id)) INNER JOIN roles_public.roles AS r ON ((membership.role_id) = (r.id)) INNER JOIN roles_public.roles AS r2 ON ((membership.group_id) = (r2.id)) INNER JOIN roles_public.role_profiles AS rp ON ((rp.role_id) = (r2.id)) WHERE ((r.type) = ('User'::roles_public.role_type));

CREATE FUNCTION permissions_private.permitted_on_role ( action_type citext, object_type citext, role_id uuid, actor_id uuid DEFAULT roles_public.current_role_id() ) RETURNS boolean AS $EOFCODE$
  SELECT
    role_id = actor_id
    OR
    EXISTS (
      SELECT
        1
      FROM
        permissions_private.team_permits p
      WHERE
        p.action_type = permitted_on_role.action_type
        AND p.object_type = permitted_on_role.object_type
        AND p.role_id = permitted_on_role.role_id
        AND p.actor_id = permitted_on_role.actor_id);
$EOFCODE$ LANGUAGE sql STABLE SECURITY DEFINER;

GRANT SELECT, INSERT, DELETE ON TABLE permissions_private.profile_permissions TO authenticated;

CREATE INDEX profile_permissions_organization_id_idx ON permissions_private.profile_permissions ( organization_id );

CREATE FUNCTION permissions_private.tg_on_insert_set_org_id (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  v_profile permissions_public.profile;
BEGIN
  SELECT * FROM permissions_public.profile
    WHERE id=NEW.profile_id
    INTO v_profile
    ;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'OBJECT_NOT_FOUND';
  END IF;

  NEW.organization_id = v_profile.organization_id;

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_insert_set_org_id 
 BEFORE INSERT ON permissions_private.profile_permissions 
 FOR EACH ROW
 EXECUTE PROCEDURE permissions_private. tg_on_insert_set_org_id (  );

GRANT USAGE ON SCHEMA permissions_public TO anonymous;

GRANT USAGE ON SCHEMA permissions_public TO authenticated;

INSERT INTO permissions_public.permission ( name, object_type, action_type ) VALUES ('Browse Projects', 'project', 'browse'), ('Read Projects', 'project', 'read'), ('Edit Projects', 'project', 'edit'), ('Add Projects', 'project', 'add'), ('Transfer Projects', 'project', 'transfer'), ('Delete Projects', 'project', 'destroy'), ('Browse Secrets', 'secret', 'browse'), ('Read Secrets', 'secret', 'read'), ('Edit Secrets', 'secret', 'edit'), ('Add Secrets', 'secret', 'add'), ('Delete Secrets', 'secret', 'destroy'), ('Browse Content', 'content', 'browse'), ('Read Content', 'content', 'read'), ('Edit Content', 'content', 'edit'), ('Upload Content', 'content', 'upload'), ('Add Content', 'content', 'add'), ('Delete Content', 'content', 'destroy'), ('Browse Posts', 'post', 'browse'), ('Read Posts', 'post', 'read'), ('Edit Posts', 'post', 'edit'), ('Add Posts', 'post', 'add'), ('Delete Posts', 'post', 'destroy'), ('Browse Users', 'user', 'browse'), ('Read Users', 'user', 'read'), ('Edit Users', 'user', 'edit'), ('Add Users', 'user', 'add'), ('Delete Users', 'user', 'destroy'), ('Browse Teams', 'team', 'browse'), ('Read Teams', 'team', 'read'), ('Edit Teams', 'team', 'edit'), ('Add Teams', 'team', 'add'), ('Delete Teams', 'team', 'destroy'), ('Browse Roles', 'role', 'browse'), ('Read Roles', 'role', 'read'), ('Edit Roles', 'role', 'edit'), ('Add Roles', 'role', 'add'), ('Delete Roles', 'role', 'destroy'), ('Browse Role Profiles', 'role_profile', 'browse'), ('Read Role Profiles', 'role_profile', 'read'), ('Edit Role Profiles', 'role_profile', 'edit'), ('Add Role Profiles', 'role_profile', 'add'), ('Delete Role Profiles', 'role_profile', 'destroy'), ('Browse Role Settings', 'role_setting', 'browse'), ('Read Role Settings', 'role_setting', 'read'), ('Edit Role Settings', 'role_setting', 'edit'), ('Add Role Settings', 'role_setting', 'add'), ('Delete Role Settings', 'role_setting', 'destroy'), ('Browse Invites', 'invite', 'browse'), ('Read Invites', 'invite', 'read'), ('Approve Invites', 'invite', 'approve'), ('Edit Invites', 'invite', 'edit'), ('Add Invites', 'invite', 'add'), ('Delete Invites', 'invite', 'destroy');

GRANT SELECT ON TABLE permissions_public.permission TO authenticated;

CREATE INDEX permission_action_type_object_type_idx ON permissions_public.permission ( action_type, object_type );

CREATE INDEX profile_organization_id_idx ON permissions_public.profile ( organization_id );

ALTER TABLE permissions_public.profile ENABLE ROW LEVEL SECURITY;

CREATE FUNCTION roles_private.is_member_of_organization ( role_id uuid, organization_id uuid ) RETURNS boolean AS $EOFCODE$
  SELECT
    EXISTS (
      SELECT
        1
      FROM
        roles_public.memberships m
      WHERE
        m.role_id = is_member_of_organization.role_id
        AND m.organization_id = is_member_of_organization.organization_id);
$EOFCODE$ LANGUAGE sql STABLE SECURITY DEFINER;

CREATE FUNCTION roles_private.is_admin_of ( role_id uuid, group_id uuid ) RETURNS boolean AS $EOFCODE$
BEGIN
    IF role_id = group_id THEN
        RETURN TRUE;
    ELSIF EXISTS (
            SELECT
                1
            FROM
                roles_public.memberships m
                JOIN permissions_public.profile p
                ON (m.profile_id = p.id AND m.organization_id = p.organization_id)
            WHERE
            		(p.name = 'Administrator' or p.name = 'Owner')
		        AND m.role_id = is_admin_of.role_id
                AND m.group_id = is_admin_of.group_id
            ) THEN
            RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE POLICY can_select_profile ON permissions_public.profile FOR SELECT TO PUBLIC USING ( roles_private.is_member_of_organization(roles_public.current_role_id(), organization_id) );

CREATE POLICY can_insert_profile ON permissions_public.profile FOR INSERT TO PUBLIC WITH CHECK ( roles_private.is_admin_of(roles_public.current_role_id(), organization_id) );

CREATE POLICY can_update_profile ON permissions_public.profile FOR UPDATE TO PUBLIC USING ( roles_private.is_admin_of(roles_public.current_role_id(), organization_id) );

CREATE POLICY can_delete_profile ON permissions_public.profile FOR DELETE TO PUBLIC USING ( roles_private.is_admin_of(roles_public.current_role_id(), organization_id) );

GRANT INSERT ON TABLE permissions_public.profile TO authenticated;

GRANT SELECT ON TABLE permissions_public.profile TO authenticated;

GRANT UPDATE ON TABLE permissions_public.profile TO authenticated;

GRANT DELETE ON TABLE permissions_public.profile TO authenticated;

GRANT USAGE ON SCHEMA roles_private TO anonymous;

GRANT USAGE ON SCHEMA roles_private TO authenticated;

CREATE FUNCTION roles_private.actor_role_admin_owner_authorized_profiles ( actor_id uuid, group_id uuid, profile_id uuid, organization_id uuid ) RETURNS boolean AS $EOFCODE$
DECLARE
  v_profile_grantor permissions_public.profile;
  v_profile_member permissions_public.profile;
BEGIN
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
  SELECT
    p.*
  FROM
    roles_public.memberships m
    JOIN permissions_public.profile p ON (m.profile_id = p.id
        AND m.organization_id = p.organization_id)
  WHERE
    m.role_id = actor_id
    AND m.group_id = actor_role_admin_owner_authorized_profiles.group_id
    AND m.organization_id = actor_role_admin_owner_authorized_profiles.organization_id INTO v_profile_grantor;
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

CREATE FUNCTION roles_private.is_member_of ( role_id uuid, group_id uuid ) RETURNS boolean AS $EOFCODE$
BEGIN
    IF role_id = group_id THEN
        RETURN TRUE;
    ELSIF EXISTS (
            SELECT
                1
            FROM
                roles_public.memberships m
            WHERE
                m.role_id = is_member_of.role_id
                AND m.group_id = is_member_of.group_id) THEN
            RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE FUNCTION roles_private.is_owner_of ( role_id uuid, group_id uuid ) RETURNS boolean AS $EOFCODE$
BEGIN
    IF role_id = group_id THEN
        RETURN TRUE;
    ELSIF EXISTS (
            SELECT
                1
            FROM
                roles_public.memberships m
                JOIN permissions_public.profile p
                ON (m.profile_id = p.id AND m.organization_id = p.organization_id)
            WHERE
            		p.name = 'Owner'
		        AND m.role_id = is_owner_of.role_id
                AND m.group_id = is_owner_of.group_id
            ) THEN
            RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE FUNCTION roles_private.membership_cascade_hierarchy ( membership roles_public.memberships ) RETURNS void AS $EOFCODE$
DECLARE
  membership_role roles_public.roles;
  membership_profile permissions_public.profile;
  obj record;
BEGIN

  SELECT
    *
  FROM
    roles_public.roles
  WHERE
    id = membership.group_id INTO membership_role;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'OBJECT_NOT_FOUND';
  END IF;

  SELECT
    *
  FROM
    permissions_public.profile
  WHERE
    id = membership.profile_id 
    AND organization_id = membership.organization_id
  INTO membership_profile;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'OBJECT_NOT_FOUND';
  END IF;

  IF (
    membership_role.type = 'Organization'::roles_public.role_type 
    AND (
           membership_profile.name = 'Owner'
        OR membership_profile.name = 'Administrator'
      )
    ) THEN
    
    -- if it is organization
    -- cascade admins only

      FOR obj IN 
      with recursive cte as (
        select r2.* from roles_public.roles r2
          WHERE r2.id=membership.group_id
        union
        select r.*
        from roles_public.roles r, cte curr
        WHERE
          r.parent_id = curr.id AND
          r.organization_id = curr.organization_id
      )
      select * from cte
      LOOP
        INSERT INTO roles_public.memberships
        (role_id, group_id, profile_id, organization_id, inherited, membership_id)
        VALUES
        (membership.role_id, obj.id, membership.profile_id, obj.organization_id, true, membership.id)
        ON CONFLICT (role_id, group_id) DO NOTHING;

      END LOOP;


  ELSIF (membership_role.type = 'Team'::roles_public.role_type) THEN
    -- if it is a team
    -- cascade all
      FOR obj IN 
      with recursive cte as (
        select r2.* from roles_public.roles r2
          WHERE r2.id=membership.group_id
        union
        select r.*
        from roles_public.roles r, cte curr
        WHERE
          r.parent_id = curr.id AND
          r.organization_id = curr.organization_id
      )
      select * from cte
      LOOP
        INSERT INTO roles_public.memberships
        (role_id, group_id, profile_id, organization_id, inherited, membership_id)
        VALUES
        (membership.role_id, obj.id, membership.profile_id, obj.organization_id, true, membership.id)
        ON CONFLICT (role_id, group_id) DO NOTHING;

      END LOOP;


  END IF;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE FUNCTION roles_private.cascade_restructured_organization ( re_organization_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  membership_rec roles_public.memberships;
BEGIN

  -- 1. DELETE ALL INHERITED MEMBERSHIPS
  DELETE
    FROM roles_public.memberships
    WHERE inherited=TRUE
    AND organization_id = re_organization_id;

  -- 2. CASCADE MEMBERSHIPS

  FOR membership_rec in 
  SELECT * 
  FROM roles_public.memberships
    WHERE
      organization_id = re_organization_id
    -- newer first, not best, but for most cases this works
    ORDER BY created_at DESC
  LOOP
  PERFORM
  roles_private.membership_cascade_hierarchy
    (membership_rec)
  ;

  END LOOP;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE FUNCTION roles_private.create_email_verification_job ( email text, user_email_id text, verification_token text ) RETURNS void AS $EOFCODE$
BEGIN
  IF (verification_token IS NOT NULL) THEN
    PERFORM
      app_jobs.add_job ('user_emails__send_verification',
        json_build_object(
          'email', email,
          'user_email_id', user_email_id,
          'verification_token', verification_token
        )
      );
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE FUNCTION roles_private.get_all_parent_roles ( check_role_id uuid DEFAULT roles_public.current_role_id() ) RETURNS uuid[] AS $EOFCODE$
DECLARE
   results uuid[];
   base_role roles_public.roles;
BEGIN

IF check_role_id IS NULL THEN
  RETURN ARRAY[];
END IF;

SELECT * FROM roles_public.roles WHERE id=check_role_id INTO base_role;

WITH RECURSIVE cte (role_id, parent_id, organization_id) AS (
    SELECT
        base_role.id, base_role.parent_id, base_role.organization_id
    UNION
    SELECT
        r.id, r.parent_id, r.organization_id
    FROM
        roles_public.roles r,
        cte curr
    WHERE
        curr.parent_id = r.id
        AND r.organization_id = curr.organization_id
)
SELECT
    array_agg(distinct(role_id))
FROM
    cte
INTO results;

RETURN results;

END;
$EOFCODE$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE TABLE roles_public.user_emails (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	role_id uuid NOT NULL DEFAULT ( roles_public.current_role_id() ) REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	email email NOT NULL UNIQUE,
	is_verified boolean NOT NULL DEFAULT ( (FALSE) ) 
);

CREATE TABLE roles_private.user_email_secrets (
 	user_email_id uuid PRIMARY KEY REFERENCES roles_public.user_emails ON DELETE CASCADE,
	verification_token text,
	password_reset_email_sent_at timestamptz 
);

COMMENT ON TABLE roles_private.user_email_secrets IS E'The contents of this table should never be visible to the user. Contains data mostly related to email verification and avoiding spamming users.';

CREATE FUNCTION roles_private.prepare_secrets_for_email_validation ( email_id uuid ) RETURNS roles_private.user_email_secrets AS $EOFCODE$
DECLARE
  v_secret roles_private.user_email_secrets;
  v_email roles_public.user_emails;
  v_verification_token text := encode(gen_random_bytes(16), 'hex');
BEGIN

  SELECT * FROM roles_public.user_emails
  INTO v_email
  WHERE id = email_id;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'EMAIL_NOT_FOUND';
  END IF;

  SELECT * FROM roles_private.user_email_secrets
  INTO v_secret
  WHERE user_email_id = email_id;

  IF (NOT FOUND) THEN
    INSERT INTO roles_private.user_email_secrets
     (user_email_id, verification_token)
      VALUES
      (email_id, v_verification_token)
    RETURNING * INTO v_secret;
  END IF;

  IF (v_secret.verification_token IS NULL) THEN
    UPDATE roles_private.user_email_secrets
    SET verification_token=v_verification_token
    WHERE user_email_id = email_id;
  END IF;

  IF (v_email.is_verified IS TRUE) THEN
    UPDATE roles_private.user_email_secrets
    SET verification_token=NULL
    WHERE user_email_id = email_id
    RETURNING * INTO v_secret;
  END IF;

  RETURN v_secret;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TABLE roles_public.membership_invites (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	profile_id uuid NOT NULL REFERENCES permissions_public.profile ( id ) ON DELETE CASCADE,
	role_id uuid NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	email email NULL,
	approved boolean NOT NULL DEFAULT ( (FALSE) ),
	accepted boolean NOT NULL DEFAULT ( (FALSE) ),
	group_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	organization_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	sender_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	invite_token text NOT NULL DEFAULT ( encode(gen_random_bytes(32), 'hex') ),
	expires_at timestamptz NOT NULL DEFAULT ( ((now()) + ('1 week'::interval)) ),
	created_at timestamptz NOT NULL DEFAULT ( now() ),
	UNIQUE ( invite_token ) 
);

COMMENT ON COLUMN roles_public.membership_invites.invite_token IS E'@omit';

CREATE TABLE roles_public.invites (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	email email NULL,
	sender_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE DEFAULT ( roles_public.current_role_id() ),
	invite_token text NOT NULL DEFAULT ( encode(gen_random_bytes(32), 'hex') ),
	invite_used boolean NOT NULL DEFAULT ( (FALSE) ),
	expires_at timestamptz NOT NULL DEFAULT ( ((now()) + ('12 months'::interval)) ),
	created_at timestamptz NOT NULL DEFAULT ( now() ),
	UNIQUE ( email, sender_id ),
	UNIQUE ( invite_token ) 
);

COMMENT ON COLUMN roles_public.invites.invite_token IS E'@omit';

CREATE FUNCTION roles_private.register_user ( username text, display_name text, email text, email_is_verified bool, avatar_url text, password text DEFAULT encode(gen_random_bytes(12), 'hex'), invite_token text DEFAULT NULL ) RETURNS roles_public.roles AS $EOFCODE$
DECLARE
  v_user roles_public.roles;
  v_membership_invite roles_public.membership_invites;
  v_invite roles_public.invites;
  v_invited_by_id uuid;
  v_inviter_approved_status boolean = FALSE;
BEGIN
  SELECT
    *
  FROM
    roles_private.register_role ('User',
      username,
      display_name,
      avatar_url) INTO v_user;
  -- check invites
  SELECT
    *
  FROM
    roles_public.invites invites
  WHERE
    invites.invite_token = register_user.invite_token
    AND EXTRACT(EPOCH FROM (expires_at - NOW())) > 0 INTO v_invite;
  -- if invite found...
  IF (FOUND) THEN
    IF (v_invite.email IS NOT NULL) THEN
      IF (v_invite.email::email = email::email) THEN
        email_is_verified = TRUE;
      ELSE
        RAISE
        EXCEPTION 'INVITE_WRONG_EMAIL';
      END IF;
    END IF;
    -- requester
    v_invited_by_id = v_invite.sender_id;
    -- checkout the invite status
    SELECT
      invites_approved
    FROM
      roles_private.user_secrets
    WHERE
      role_id = v_invited_by_id INTO v_inviter_approved_status;

    IF (v_inviter_approved_status) THEN
      -- potentially mark the invite task completed here
    END IF;

    -- expire it
    UPDATE
      roles_public.invites invites
    SET
      -- the reason you can expire this one is because its a regular invite, literally just access to get into the platform
      expires_at = NOW()
    WHERE
      invites.invite_token = register_user.invite_token;
  ELSE
    -- membership invites
    SELECT
      *
    FROM
      roles_public.membership_invites mvites
    WHERE
      mvites.invite_token = register_user.invite_token
      AND approved IS TRUE
      AND accepted IS FALSE
      AND EXTRACT(EPOCH FROM (expires_at - NOW())) > 0 INTO v_membership_invite;
    -- if membership invite found...
    IF (FOUND) THEN
      IF (v_membership_invite.email IS NOT NULL) THEN
        IF (v_membership_invite.email::email = email::email) THEN
          email_is_verified = TRUE;
        ELSE
          RAISE EXCEPTION 'INVITE_WRONG_EMAIL';
        END IF;
      END IF;
      -- requester
      v_invited_by_id = v_membership_invite.sender_id;
      -- checkout the invite status
      SELECT
        invites_approved
      FROM
        roles_private.user_secrets
      WHERE
        role_id = v_invited_by_id INTO v_inviter_approved_status;
      
      -- TODO remove this approved invites thingn when product opens
      IF (v_inviter_approved_status) THEN
        -- mark invite completed
      END IF;

      UPDATE
        roles_public.membership_invites invites
      SET
        role_id = v_user.id,
        accepted = TRUE,
        expires_at = NOW()
      WHERE
        invites.invite_token = register_user.invite_token;
        
    END IF;
  END IF;
  -- check email
  INSERT INTO roles_public.user_emails (role_id, email, is_verified)
    VALUES (v_user.id, email, email_is_verified);
  INSERT INTO roles_private.user_secrets (role_id, password_hash, invited_by_id)
    VALUES (v_user.id, crypt(PASSWORD, gen_salt('bf')), v_invited_by_id);
  RETURN v_user;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_private.register_user TO anonymous;

REVOKE EXECUTE ON FUNCTION roles_private.register_user FROM authenticated;

CREATE FUNCTION roles_private.link_or_register_user ( f_role_id uuid, f_service text, f_identifier text, f_profile json, f_auth_details json ) RETURNS roles_public.roles AS $EOFCODE$
DECLARE
    v_matched_role_id uuid;
    v_matched_authentication_id uuid;
    v_email email;
    v_display_name text;
    v_avatar_url text;
    v_user roles_public.roles;
    v_user_email roles_public.user_emails;
BEGIN
    -- See if a user account already matches these details
    SELECT
        id,
        role_id INTO v_matched_authentication_id,
        v_matched_role_id
    FROM
        auth_public.user_authentications
    WHERE
        service = f_service
        AND identifier = f_identifier
    LIMIT 1;

    IF v_matched_role_id IS NOT NULL AND f_role_id IS NOT NULL AND v_matched_role_id <> f_role_id THEN
        raise
        exception 'A different user already has this account linked.'
            USING errcode = 'TAKEN';
    END IF;

    v_email = f_profile ->> 'email';
    v_display_name := f_profile ->> 'display_name';
    v_avatar_url := f_profile ->> 'avatar_url';

    IF v_matched_authentication_id IS NULL THEN
        IF f_role_id IS NOT NULL THEN
            -- Link new account to logged in user account
            INSERT INTO auth_public.user_authentications (role_id, service, identifier, details)
            VALUES (f_role_id, f_service, f_identifier, f_profile)
        RETURNING
            id, role_id INTO v_matched_authentication_id, v_matched_role_id;
            INSERT INTO auth_private.user_authentication_secrets (user_authentication_id, details)
            VALUES (v_matched_authentication_id, f_auth_details);
        elsif v_email IS NOT NULL THEN
            -- See if the email is registered
            SELECT
                * INTO v_user_email
            FROM
                roles_public.user_emails
            WHERE
                email = v_email
                AND is_verified IS TRUE;
            IF v_user_email IS NOT NULL THEN
                -- User exists!
                INSERT INTO auth_public.user_authentications (role_id, service, identifier, details)
                VALUES (v_user_email.role_id, f_service, f_identifier, f_profile)
            RETURNING
                id, role_id INTO v_matched_authentication_id, v_matched_role_id;
                INSERT INTO auth_private.user_authentication_secrets (user_authentication_id, details)
                VALUES (v_matched_authentication_id, f_auth_details);
            END IF;
        END IF;
    END IF;
    IF v_matched_role_id IS NULL AND f_role_id IS NULL AND v_matched_authentication_id IS NULL THEN
        -- Create and return a new user account
        RETURN roles_private.register_auth_role (
            f_service,
            f_identifier,
            f_profile,
            f_auth_details,
            TRUE);
    ELSE
        IF v_matched_authentication_id IS NOT NULL THEN
            UPDATE
                auth_public.user_authentications
            SET
                details = f_profile
            WHERE
                id = v_matched_authentication_id;

            UPDATE
                auth_private.user_authentication_secrets
            SET
                details = f_auth_details
            WHERE
                user_authentication_id = v_matched_authentication_id;

            UPDATE
                roles_public.role_profiles
            SET
                display_name = coalesce(roles_public.role_profiles.display_name, v_display_name),
                avatar_url = coalesce(roles_public.role_profiles.avatar_url, v_avatar_url)
            WHERE
                role_id = v_matched_role_id;

            SELECT * FROM roles_public.roles WHERE id=v_matched_role_id INTO v_user;

            RETURN v_user;
        ELSE
            -- v_matched_authentication_id is null
            -- -> v_matched_role_id is null (they're paired)
            -- -> f_role_id is not null (because the if clause above)
            -- -> v_matched_authentication_id is not null (because of the separate if block above creating a user_authentications)
            -- -> contradiction.
            raise
            exception 'This should not occur';
        END IF;
    END IF;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_private.link_or_register_user TO anonymous;

COMMENT ON FUNCTION roles_private.link_or_register_user IS E'If you are logged in, this will link an additional OAuth login to your account if necessary. If you are logged out it may find if an account already exists (based on OAuth details or email address) and return that, or create a new user account if necessary.';

CREATE FUNCTION roles_private.register_auth_role ( f_service text, f_identifier text, f_profile json, f_auth_details json, f_email_is_verified boolean DEFAULT (FALSE) ) RETURNS roles_public.roles AS $EOFCODE$
DECLARE
    v_user roles_public.roles;
    v_email email;
    v_display_name text;
    v_username text;
    v_avatar_url text;
    v_user_authentication_id uuid;
BEGIN

    -- Extract data from the user’s OAuth profile data.
    v_email := f_profile ->> 'email';
    v_display_name := f_profile ->> 'display_name';
    v_username := f_profile ->> 'username';
    v_avatar_url := f_profile ->> 'avatar_url';

    -- Create the user
    v_user = roles_private.register_user(
      username => v_username,
      display_name => v_display_name,
      email => v_email,
      email_is_verified => f_email_is_verified,
      avatar_url => v_avatar_url
    );

    -- Insert the user’s private account data (e.g. OAuth tokens)
    INSERT INTO auth_public.user_authentications (role_id,
      service, identifier, details)
      VALUES (v_user.id, f_service, f_identifier, f_profile)
      RETURNING id INTO v_user_authentication_id;

    INSERT INTO auth_private.user_authentication_secrets (user_authentication_id, details)
      VALUES (v_user_authentication_id, f_auth_details);

    RETURN v_user;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

GRANT EXECUTE ON FUNCTION roles_private.register_auth_role TO anonymous;

REVOKE EXECUTE ON FUNCTION roles_private.register_auth_role FROM authenticated;

COMMENT ON FUNCTION roles_private.register_auth_role IS E'Used to register a user from information gleaned from OAuth.';

CREATE FUNCTION roles_private.register_role_profile ( role_id uuid, display_name text, avatar_url text, organization_id uuid ) RETURNS void AS $EOFCODE$
BEGIN
  INSERT INTO roles_public.role_profiles (role_id, display_name, avatar_url, organization_id)
  VALUES (role_id, display_name, avatar_url, organization_id);
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE FUNCTION roles_private.register_role ( type roles_public.role_type, username text, display_name text, avatar_url text, organization_id uuid DEFAULT NULL, parent_id uuid DEFAULT NULL ) RETURNS roles_public.roles AS $EOFCODE$
DECLARE
  new_role roles_public.roles;
  new_organization_id uuid;
  v_username text;
BEGIN
  IF (TYPE = 'User'::roles_public.role_type OR TYPE = 'Organization'::roles_public.role_type) THEN
    SELECT
      *
    FROM
      roles_public.available_username (COALESCE(username, display_name)) INTO v_username;
  END IF;
  INSERT INTO roles_public.roles (TYPE, username, parent_id, organization_id)
  VALUES (TYPE, v_username, parent_id, organization_id)
RETURNING
  * INTO new_role;
  IF (organization_id IS NULL) THEN
    new_organization_id = new_role.id;
  ELSE
    new_organization_id = organization_id;
  END IF;
  PERFORM
    roles_private.register_role_profile (new_role.id,
      display_name,
      avatar_url,
      new_organization_id);
  RETURN new_role;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

GRANT EXECUTE ON FUNCTION roles_private.register_role TO anonymous;

CREATE FUNCTION roles_private.service_sign_in ( user_id uuid, service text ) RETURNS auth_private.token AS $EOFCODE$
DECLARE
  authentications auth_public.user_authentications;
  token auth_private.token;
BEGIN
  SELECT
    ct.* INTO authentications
  FROM
    auth_public.user_authentications AS ct
  WHERE
    ct.role_id = service_sign_in.user_id
    AND ct.service = service_sign_in.service;
  IF (NOT FOUND) THEN
    RETURN NULL;
  END IF;
  INSERT INTO auth_private.token (TYPE, role_id, auth_id)
  VALUES ('auth'::auth_private.token_type, service_sign_in.user_id, authentications.id)
RETURNING
  * INTO token;
  RETURN token;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_private.service_sign_in TO anonymous;

REVOKE EXECUTE ON FUNCTION roles_private.service_sign_in FROM authenticated;

COMMENT ON FUNCTION roles_private.service_sign_in IS E'Grants a token without any auth. The auth is done by a 3rd party. This should never, ever touch the client API.';

CREATE FUNCTION roles_private.send_membership_invite_approval_email ( invite_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  v_invite roles_public.membership_invites;
  v_group_role roles_public.roles;
  v_group roles_public.role_profiles;
  v_inviter roles_public.role_profiles;
  v_invitee roles_public.role_profiles;
  v_invitee_email text;
  v_admin_emails text;

BEGIN
  -- TODO get admin email

  SELECT * FROM roles_public.membership_invites
  INTO v_invite
  WHERE id=invite_id;

  SELECT * FROM roles_public.role_profiles
  INTO v_inviter
  WHERE role_id=v_invite.sender_id;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'OBJECT_NOT_FOUND';
  END IF;

  SELECT * FROM roles_public.role_profiles
  INTO v_group
  WHERE role_id=v_invite.group_id;

  SELECT * FROM roles_public.roles
  INTO v_group_role
  WHERE id=v_invite.group_id;

  IF (v_invite.role_id IS NOT NULL) THEN
    SELECT email FROM roles_public.user_emails e
      WHERE e.role_id=v_invite.role_id
      INTO v_invitee_email;
  ELSE
    v_invitee_email = v_invite.email;
  END IF;

  -- group managers/admins
  SELECT string_agg(distinct(e.email), ',')
  	FROM roles_public.memberships m
    JOIN roles_public.user_emails e ON m.role_id =e.role_id
    JOIN permissions_public.profile p ON (m.profile_id = p.id AND m.organization_id = p.organization_id)
    WHERE 
        (p.name = 'Administrator' or p.name = 'Owner')
        AND m.group_id = v_group_role.id
    INTO v_admin_emails;

  PERFORM
    app_jobs.add_job ('membership__invite_member_approval_email',
      json_build_object(
        'type', v_group_role.type::text,
        'invitee_email', v_invitee_email,
        'admin_emails', v_admin_emails::text,
        'inviter_name', v_inviter.display_name::text,
        'group_name', v_group.display_name::text,
        'invite_token', v_invite.invite_token::text
      ));
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE FUNCTION roles_private.send_membership_invite_email ( invite_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  v_invite roles_public.membership_invites;
  v_group_role roles_public.roles;
  v_group roles_public.role_profiles;
  v_inviter roles_public.role_profiles;
BEGIN

  SELECT * FROM roles_public.membership_invites
  INTO v_invite
  WHERE id=invite_id;

  SELECT * FROM roles_public.role_profiles
  INTO v_inviter
  WHERE role_id=v_invite.sender_id;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'OBJECT_NOT_FOUND';
  END IF;

  SELECT * FROM roles_public.role_profiles
  INTO v_group
  WHERE role_id=v_invite.group_id;

  SELECT * FROM roles_public.roles
  INTO v_group_role
  WHERE id=v_invite.group_id;

  PERFORM
    app_jobs.add_job ('membership__invite_member_email',
      json_build_object(
        'type', v_group_role.type::text,
        'email', v_invite.email::text,
        'inviter_name', v_inviter.display_name::text,
        'group_name', v_group.display_name::text,
        'invite_token', v_invite.invite_token::text
      ));
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE FUNCTION roles_private.get_team_parent_roles ( role_id uuid ) RETURNS SETOF roles_public.roles AS $EOFCODE$
WITH RECURSIVE cte AS (
    SELECT
        r2.* from roles_public.roles r2 WHERE r2.id=get_team_parent_roles.role_id
    UNION
    SELECT
        r.*
    FROM
        roles_public.roles r,
        cte curr
    WHERE
        curr.parent_id = r.id
        AND r.organization_id = curr.organization_id
) SELECT * FROM cte;
$EOFCODE$ LANGUAGE sql STABLE;

CREATE FUNCTION roles_private.team_cascade_memberships ( team_id uuid, organization_id uuid ) RETURNS void AS $EOFCODE$
DECLARE
  parent record;
  membership record;
BEGIN

    FOR parent in
    SELECT *
    FROM roles_private.get_team_parent_roles(team_cascade_memberships.team_id)
    LOOP

      FOR membership in SELECT *
      FROM roles_public.memberships m
      WHERE (m.group_id = parent.id AND m.organization_id = parent.organization_id)
      LOOP
        INSERT INTO roles_public.memberships
        (role_id, group_id, profile_id, organization_id, inherited, membership_id)
        VALUES
        (membership.role_id, team_cascade_memberships.team_id, membership.profile_id, team_cascade_memberships.organization_id, true, membership.id)
        ON CONFLICT (role_id, group_id) DO NOTHING;

      END LOOP;
    END LOOP;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE FUNCTION roles_private.validate_role_parent ( role_to_validate roles_public.roles ) RETURNS void AS $EOFCODE$
DECLARE
  parent_roles uuid[];
  parent_role roles_public.roles;
BEGIN

    IF (role_to_validate.type != 'Team'::roles_public.role_type) THEN
      RAISE EXCEPTION 'ROLES_ONLY_TEAMS_HAVE_PARENTS';
    END IF;
    SELECT * FROM roles_private.get_all_parent_roles(role_to_validate.parent_id) INTO parent_roles;
    IF (role_to_validate.id = ANY(parent_roles)) THEN
      RAISE EXCEPTION 'ROLES_TEAM_CIRCULAR_REF';
    END IF;

    -- NOTE this requires SECURITY DEFINER
    SELECT * FROM roles_public.roles WHERE id=role_to_validate.parent_id INTO parent_role;

    IF (parent_role.type != 'Team'::roles_public.role_type) THEN
      IF (parent_role.type != 'Organization'::roles_public.role_type) THEN
        RAISE EXCEPTION 'ROLES_TEAM_PARENT_TYPE_MISMATCH';
      END IF;
    END IF;

    IF (role_to_validate.organization_id != parent_role.organization_id) THEN
      RAISE EXCEPTION 'ORGANIZATION_MISMASTCH';
    END IF;

END;
$EOFCODE$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

ALTER TABLE roles_private.user_email_secrets ENABLE ROW LEVEL SECURITY;

ALTER TABLE roles_private.user_secrets ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_user_secrets ON roles_private.user_secrets FOR SELECT TO PUBLIC USING ( ((roles_public.current_role_id()) = (role_id)) );

CREATE POLICY can_insert_user_secrets ON roles_private.user_secrets FOR INSERT TO PUBLIC WITH CHECK ( ((roles_public.current_role_id()) = (role_id)) );

CREATE POLICY can_update_user_secrets ON roles_private.user_secrets FOR UPDATE TO PUBLIC USING ( ((roles_public.current_role_id()) = (role_id)) );

CREATE POLICY can_delete_user_secrets ON roles_private.user_secrets FOR DELETE TO PUBLIC USING ( ((roles_public.current_role_id()) = (role_id)) );

GRANT INSERT ON TABLE roles_private.user_secrets TO authenticated;

GRANT SELECT ON TABLE roles_private.user_secrets TO authenticated;

GRANT UPDATE ON TABLE roles_private.user_secrets TO authenticated;

GRANT DELETE ON TABLE roles_private.user_secrets TO authenticated;

CREATE FUNCTION roles_private.tg_ensure_proper_membership (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  grantee_role roles_public.roles;
  group_role roles_public.roles;
  v_organization_id uuid;
BEGIN
  SELECT * FROM roles_public.roles WHERE id=NEW.role_id INTO grantee_role;
  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'ROLES_ROLE_DOES_NOT_EXIST';
  END IF;

  SELECT * FROM roles_public.roles WHERE id=NEW.group_id INTO group_role;
  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'ROLES_ROLE_DOES_NOT_EXIST';
  END IF;

  IF (grantee_role.type = 'Team'::roles_public.role_type) THEN
    IF (group_role.type = 'Team'::roles_public.role_type) THEN
      RAISE EXCEPTION 'MEMBERSHIPS_CANNOT_GRANT_TEAM';
    END IF;
  END IF;

  IF (grantee_role.type = 'Organization'::roles_public.role_type) THEN
    IF (group_role.type = 'Team'::roles_public.role_type) THEN
      RAISE EXCEPTION 'MEMBERSHIPS_CANNOT_GRANT_ORG_TEAM';
    END IF;
  END IF;
  IF (grantee_role.type = 'Team'::roles_public.role_type) THEN
    IF (group_role.type = 'Organization'::roles_public.role_type) THEN
      RAISE EXCEPTION 'MEMBERSHIPS_CANNOT_GRANT_TEAM';
    END IF;
  END IF;

  IF (group_role.type = 'User'::roles_public.role_type) THEN
    RAISE EXCEPTION 'MEMBERSHIPS_CANNOT_GRANT_USER';
  END IF;

  -- sanitize organization_id
  IF (group_role.type = 'User'::roles_public.role_type) THEN
    v_organization_id = group_role.id;
  ELSIF (group_role.type = 'Team'::roles_public.role_type) THEN
    v_organization_id = group_role.organization_id;
  ELSIF (group_role.type = 'Organization'::roles_public.role_type) THEN
    v_organization_id = group_role.id;
  END IF;

  NEW.organization_id = v_organization_id;

  -- TODO avoid circular grants
  -- NOTE in order to avoid circular grants for now
  IF (grantee_role.type != 'User'::roles_public.role_type) THEN
    RAISE EXCEPTION 'MEMBERSHIPS_ONLY_USERS';
  END IF;

  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE FUNCTION roles_private.tg_ensure_proper_role_parents (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  PERFORM roles_private.validate_role_parent(NEW);
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION roles_private.tg_ensure_proper_role (  ) RETURNS trigger AS $EOFCODE$
BEGIN


  IF (NEW.type = 'Team'::roles_public.role_type) THEN
    IF (NEW.organization_id IS NULL) THEN
      RAISE EXCEPTION 'TEAMS_REQUIRE_ORGANIZATION_ID';
    END IF;
    IF (NEW.parent_id IS NULL) THEN
      NEW.parent_id = NEW.organization_id;
    END IF;
    PERFORM roles_private.validate_role_parent(NEW);
    IF (NEW.username IS NOT NULL) THEN
      RAISE EXCEPTION 'TEAMS_NO_USERNAME';
    END IF;
  END IF;

  IF (NEW.type = 'Organization'::roles_public.role_type) THEN
    NEW.organization_id = NEW.id;
    IF (NEW.parent_id IS NOT NULL) THEN
      RAISE EXCEPTION 'ROLES_ORGANIZATION_NO_PARENT';
    END IF;
  END IF;

  IF (NEW.type = 'User'::roles_public.role_type) THEN
    NEW.organization_id = NEW.id;
    IF (NEW.parent_id IS NOT NULL) THEN
      RAISE EXCEPTION 'ROLES_USER_NO_PARENT';
    END IF;
  END IF;

  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION roles_private.tg_immutable_role_properties (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  RAISE EXCEPTION 'IMMUTABLE_PROPERTIES';
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

GRANT USAGE ON SCHEMA roles_public TO administrator;

GRANT USAGE ON SCHEMA roles_public TO anonymous, authenticated;

CREATE SCHEMA status_private;

GRANT USAGE ON SCHEMA status_private TO authenticated, anonymous;

ALTER DEFAULT PRIVILEGES IN SCHEMA status_private 
 GRANT EXECUTE ON FUNCTIONS  TO authenticated;

CREATE SCHEMA status_public;

GRANT USAGE ON SCHEMA status_public TO authenticated, anonymous;

ALTER DEFAULT PRIVILEGES IN SCHEMA status_public 
 GRANT EXECUTE ON FUNCTIONS  TO authenticated;

CREATE TABLE status_public.user_achievement (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	name citext NOT NULL,
	UNIQUE ( name ) 
);

CREATE TABLE status_public.user_task (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	name citext NOT NULL,
	achievement_id uuid NOT NULL REFERENCES status_public.user_achievement ( id ) ON DELETE CASCADE,
	priority int DEFAULT ( 10000 ),
	UNIQUE ( name ) 
);

CREATE TABLE status_public.user_task_achievement (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	task_id uuid NOT NULL REFERENCES status_public.user_task ( id ) ON DELETE CASCADE,
	user_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE 
);

CREATE FUNCTION status_private.user_completed_task ( task citext, role_id uuid DEFAULT roles_public.current_role_id() ) RETURNS void AS $EOFCODE$
  INSERT INTO status_public.user_task_achievement (user_id, task_id)
  VALUES (role_id, (
      SELECT
        t.id
      FROM
        status_public.user_task t
      WHERE
        name = task));
$EOFCODE$ LANGUAGE sql VOLATILE SECURITY DEFINER;

CREATE FUNCTION roles_public.accept_terms (  ) RETURNS boolean AS $EOFCODE$
  BEGIN
  PERFORM
    status_private.user_completed_task ('accept_terms');
RETURN TRUE;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

GRANT EXECUTE ON FUNCTION roles_public.accept_terms TO authenticated;

GRANT EXECUTE ON FUNCTION roles_public.current_role_id TO anonymous;

GRANT EXECUTE ON FUNCTION roles_public.current_role_id TO authenticated;

CREATE FUNCTION roles_public.current_role (  ) RETURNS roles_public.roles AS $EOFCODE$
DECLARE
  v_user roles_public.roles;
BEGIN
  IF roles_public.current_role_id() IS NOT NULL THEN
     SELECT * FROM roles_public.roles WHERE id = roles_public.current_role_id() INTO v_user;
     RETURN v_user;
  ELSE
     RETURN NULL;
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

GRANT EXECUTE ON FUNCTION roles_public."current_role" TO anonymous, authenticated;

GRANT EXECUTE ON FUNCTION roles_public."current_role" TO authenticated;

GRANT EXECUTE ON FUNCTION roles_public."current_role" TO anonymous;

CREATE FUNCTION roles_public.sign_in ( email text, password text ) RETURNS auth_private.token AS $EOFCODE$
DECLARE
  secret roles_private.user_secrets;
  v_token auth_private.token;
  v_email roles_public.user_emails;
  v_sign_in_attempt_window_duration interval = interval '6 hours';
  v_sign_in_max_attempts int = 10;
BEGIN
  SELECT
    user_email.*
  FROM
    roles_public.user_emails AS user_email
  WHERE
    user_email.email = sign_in.email::email INTO v_email;
  -- NOT FOUND
  IF (NOT FOUND) THEN
    RETURN NULL;
  END IF;
  -- get secrets
  SELECT
    st.*
  FROM
    roles_private.user_secrets AS st
  WHERE
    st.role_id = v_email.role_id INTO secret;
  IF (NOT FOUND) THEN
    RETURN NULL;
  END IF;
  IF (secret.first_failed_password_attempt IS NOT NULL AND secret.first_failed_password_attempt > NOW() - v_sign_in_attempt_window_duration AND secret.password_attempts >= v_sign_in_max_attempts) THEN
    RAISE EXCEPTION 'ACCOUNT_LOCKED_EXCEED_ATTEMPTS';
  END IF;
  IF secret.password_hash = crypt(PASSWORD, secret.password_hash) THEN
    -- green light! login...

    -- NOT yet verified
    IF (NOT v_email.is_verified) THEN
      RAISE EXCEPTION 'EMAIL_NOT_VERIFIED';
    END IF;

    -- reset the attempts
    UPDATE
      roles_private.user_secrets
    SET
      password_attempts = 0,
      first_failed_password_attempt = NULL
    WHERE
      role_id = v_email.role_id;
    
    -- create a token
    INSERT INTO auth_private.token (TYPE, role_id)
      VALUES ('auth'::auth_private.token_type, secret.role_id)
    RETURNING
      * INTO v_token;

    -- return the token
    RETURN v_token;
  ELSE
    -- bad login!
    UPDATE
      roles_private.user_secrets
    SET
      password_attempts = (
        CASE WHEN first_failed_password_attempt IS NULL
          OR first_failed_password_attempt < NOW() - v_sign_in_attempt_window_duration THEN
          1
        ELSE
          password_attempts + 1
        END),
      first_failed_password_attempt = (
        CASE WHEN first_failed_password_attempt IS NULL
          OR first_failed_password_attempt < NOW() - v_sign_in_attempt_window_duration THEN
          NOW()
        ELSE
          first_failed_password_attempt
        END)
    WHERE
      role_id = v_email.role_id;
    RETURN NULL;
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql STRICT SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_public.sign_in TO anonymous;

GRANT EXECUTE ON FUNCTION roles_public.sign_in TO anonymous;

CREATE FUNCTION roles_public.available_username ( v_username text ) RETURNS text AS $EOFCODE$
BEGIN
  v_username = regexp_replace(v_username, '^[^a-z]+', '', 'ig');
  v_username = regexp_replace(v_username, '[^a-z0-9]+', '_', 'ig');

  IF v_username IS NULL OR length(v_username) < 3 THEN
      v_username = 'user';
  END IF;

  SELECT
    (
        CASE WHEN i = 0 THEN
            v_username
        ELSE
            v_username || i::text
        END) INTO v_username
  FROM
    generate_series(0, 1000) i
  WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            roles_public.roles
        WHERE
            roles_public.roles.username = (
                CASE WHEN i = 0 THEN
                    v_username
                ELSE
                    v_username || i::text
                END)::citext)
    LIMIT 1;
    RETURN v_username;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

GRANT EXECUTE ON FUNCTION roles_public.available_username TO anonymous, authenticated;

CREATE FUNCTION roles_public.sign_up ( display_name text, email text, password text, invite_token text DEFAULT NULL, accept_terms boolean DEFAULT (FALSE) ) RETURNS auth_private.token AS $EOFCODE$
DECLARE
  v_user roles_public.roles;
  v_token auth_private.token;
  v_supplied_password boolean := FALSE;
BEGIN

  IF (password IS NOT NULL) THEN
    SELECT true INTO v_supplied_password;
  ELSE 
    SELECT encode(gen_random_bytes(12), 'hex') INTO password;
  END IF;
    
  SELECT
    *
  FROM
    roles_private.register_user (NULL,
      display_name,
      email,
      FALSE,
      NULL,
      password,
      invite_token) INTO v_user;
  
  IF (accept_terms) THEN
    PERFORM status_private.user_completed_task('accept_terms', v_user.id);
  END IF;

  IF (v_supplied_password) THEN
    PERFORM status_private.user_completed_task('set_password', v_user.id);
  END IF;

  -- RETURN v_user;
  INSERT INTO auth_private.token (type, role_id)
      VALUES ('auth'::auth_private.token_type, v_user.id)
    RETURNING
      * INTO v_token;

    RETURN v_token;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_public.sign_up TO anonymous;

COMMENT ON FUNCTION roles_public.sign_up IS E'Creates a user signs them up.';

GRANT EXECUTE ON FUNCTION roles_public.sign_up TO anonymous;

CREATE FUNCTION roles_public.forgot_password ( email email ) RETURNS boolean AS $EOFCODE$
DECLARE
    v_user_email roles_public.user_emails;
    v_reset_token text;
    v_reset_min_duration_between_emails interval = interval '30 minutes';
    v_reset_max_duration interval = interval '3 days';
BEGIN
    -- Find the matching user_email
    SELECT
        user_emails.* INTO v_user_email
    FROM
        roles_public.user_emails
    WHERE
        user_emails.email = forgot_password.email::email
    ORDER BY
        is_verified DESC,
        created_at DESC;
    -- bail out
    IF (NOT FOUND) THEN
        RETURN FALSE;
    END IF;
    -- See if we've triggered a reset recently
    IF EXISTS (
            SELECT
                1
            FROM
                roles_private.user_email_secrets
            WHERE
                user_email_id = v_user_email.id AND password_reset_email_sent_at IS NOT NULL AND password_reset_email_sent_at > NOW() - v_reset_min_duration_between_emails) THEN
            RETURN TRUE;
    END IF;
    -- Fetch or generate reset token
    UPDATE
        roles_private.user_secrets
    SET
        reset_password_token = ( CASE WHEN reset_password_token IS NULL
                OR reset_password_token_generated < NOW() - v_reset_max_duration THEN
                encode(gen_random_bytes(6), 'hex')
            ELSE
                reset_password_token
            END),
        reset_password_token_generated = ( CASE WHEN reset_password_token IS NULL
                OR reset_password_token_generated < NOW() - v_reset_max_duration THEN
                NOW()
            ELSE
                reset_password_token_generated
END)
WHERE
    role_id = v_user_email.role_id
RETURNING
    reset_password_token INTO v_reset_token;
-- Don't allow spamming an email
UPDATE
    roles_private.user_email_secrets
SET
    password_reset_email_sent_at = NOW()
WHERE
    user_email_id = v_user_email.id;
-- Trigger email send
PERFORM
    app_jobs.add_job ('user__forgot_password',
        json_build_object('id', v_user_email.role_id, 'email', v_user_email.email::text, 'token', v_reset_token));
RETURN TRUE;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_public.forgot_password TO anonymous;

CREATE FUNCTION roles_public.register_organization ( display_name text ) RETURNS roles_public.roles AS $EOFCODE$
DECLARE
  v_organization roles_public.roles;
  v_admin_profile permissions_public.profile;
BEGIN
  
  SELECT
    *
  FROM
    roles_private.register_role ('Organization',
      NULL,
      display_name, 
      NULL) INTO v_organization;
  
  PERFORM permissions_private.initialize_organization_profiles_and_permissions (v_organization.id);

  SELECT
    *
  FROM
    permissions_public.profile pf
  WHERE
    name = 'Owner' INTO v_admin_profile
    AND pf.organization_id = v_organization.id;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'CANNOT_CREATE_ORG';
  END IF;

  INSERT INTO roles_public.memberships (profile_id, role_id, group_id, organization_id)
    VALUES (v_admin_profile.id, roles_public.current_role_id (), v_organization.id, v_organization.id);
  RETURN v_organization;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_public.register_organization TO authenticated;

CREATE FUNCTION roles_public.register_team ( display_name text, organization_id uuid, parent_id uuid DEFAULT NULL ) RETURNS roles_public.roles AS $EOFCODE$
DECLARE
  team roles_public.roles;
BEGIN
  SELECT * FROM roles_private.register_role
    ('Team', NULL, display_name, NULL, organization_id, parent_id) INTO team;
  RETURN team;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

GRANT EXECUTE ON FUNCTION roles_public.register_team TO authenticated;

CREATE FUNCTION roles_public.reset_password ( role_id uuid, reset_token text, new_password text ) RETURNS roles_public.roles AS $EOFCODE$
DECLARE
    v_user roles_public.roles;
    v_user_secret roles_private.user_secrets;
    v_reset_max_duration interval = interval '3 days';
    v_reset_max_attempts int = 10;
BEGIN
    SELECT
        u.* INTO v_user
    FROM
        roles_public.roles as u
    WHERE
        id = role_id;

    IF (NOT FOUND) THEN
      RETURN NULL;
    END IF;

    -- Load their secrets
    SELECT
        * INTO v_user_secret
    FROM
        roles_private.user_secrets
    WHERE
        roles_private.user_secrets.role_id = v_user.id;

    -- Have there been too many reset attempts?
    IF (v_user_secret.first_failed_reset_password_attempt IS NOT NULL
      AND v_user_secret.first_failed_reset_password_attempt > NOW() - v_reset_max_duration
      AND v_user_secret.reset_password_attempts >= v_reset_max_attempts) THEN
        RAISE
        EXCEPTION 'PASSWORD_RESET_LOCKED_EXCEED_ATTEMPTS';
    END IF;

    -- Not too many reset attempts, let's check the token
    IF v_user_secret.reset_password_token = reset_token THEN
        -- Excellent - they're legit; let's reset the password as requested
        UPDATE
            roles_private.user_secrets
        SET
            password_hash = crypt(new_password, gen_salt('bf')),
            password_attempts = 0,
            first_failed_password_attempt = NULL,
            reset_password_token = NULL,
            reset_password_token_generated = NULL,
            reset_password_attempts = 0,
            first_failed_reset_password_attempt = NULL
        WHERE
            roles_private.user_secrets.role_id = v_user.id;
        RETURN v_user;
    ELSE
        -- Wrong token, bump all the attempt tracking figures
        UPDATE
            roles_private.user_secrets
        SET
            reset_password_attempts = (
                CASE WHEN first_failed_reset_password_attempt IS NULL
                    OR first_failed_reset_password_attempt < NOW() - v_reset_max_duration THEN
                    1
                ELSE
                    reset_password_attempts + 1
                END),
            first_failed_reset_password_attempt = (
                CASE WHEN first_failed_reset_password_attempt IS NULL
                    OR first_failed_reset_password_attempt < NOW() - v_reset_max_duration THEN
                    NOW()
                ELSE
                    first_failed_reset_password_attempt
                END)
        WHERE
            roles_private.user_secrets.role_id = v_user.id;
                RETURN NULL;
            END IF;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_public.reset_password TO anonymous;

CREATE FUNCTION status_public.user_achieved ( achievement citext, role_id uuid DEFAULT roles_public.current_role_id() ) RETURNS boolean AS $EOFCODE$
DECLARE
  v_achievement status_public.user_achievement;
  v_task status_public.user_task;
  v_value boolean = TRUE;
BEGIN
  SELECT * FROM status_public.user_achievement
    WHERE name = achievement
    INTO v_achievement;

  IF (NOT FOUND) THEN
    RETURN FALSE;
  END IF;

  FOR v_task IN
  SELECT * FROM
    status_public.user_task
    WHERE achievement_id = v_achievement.id
  LOOP

    SELECT EXISTS(
      SELECT 1
      FROM status_public.user_task_achievement
      WHERE 
        user_id = role_id
        AND task_id = v_task.id
    ) AND v_value
      INTO v_value;
    
  END LOOP;

  RETURN v_value;

END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION roles_public.send_verification_email ( email email ) RETURNS boolean AS $EOFCODE$
DECLARE
  v_secret roles_private.user_email_secrets;
  v_email roles_public.user_emails;
  v_user roles_public.roles;
  v_verification_token text;
BEGIN

  SELECT * FROM roles_public.roles
    WHERE id = roles_public.current_role_id()
    INTO v_user;

  SELECT * FROM roles_public.user_emails e
    WHERE e.role_id = v_user.id
    AND e.email = send_verification_email.email
    INTO v_email;

  IF ( v_email.is_verified IS TRUE ) THEN
    IF (status_public.user_achieved('verify_email') IS FALSE) THEN
      PERFORM status_private.user_completed_task('verify_email');
    END IF;
    RETURN FALSE;
  END IF;

  SELECT * FROM 
  roles_private.prepare_secrets_for_email_validation(v_email.id)
  INTO v_secret;

  PERFORM 
    roles_private.create_email_verification_job (
      v_email.email::text,
      v_email.id::text,
      v_secret.verification_token::text
    );

  RETURN TRUE;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_public.send_verification_email TO authenticated;

CREATE FUNCTION roles_public.set_password ( new_password text ) RETURNS boolean AS $EOFCODE$
DECLARE
  v_user roles_public.roles;
  v_user_secret roles_private.user_secrets;
BEGIN
  SELECT
    u.* INTO v_user
  FROM
    roles_public.roles AS u
  WHERE
    id = roles_public.current_role_id ();
  IF (NOT FOUND) THEN
    RETURN FALSE;
  END IF;
  -- not dry, copied from reset-password
  UPDATE
    roles_private.user_secrets
  SET
    password_hash = crypt(new_password, gen_salt('bf')),
    password_attempts = 0,
    first_failed_password_attempt = NULL,
    reset_password_token = NULL,
    reset_password_token_generated = NULL,
    reset_password_attempts = 0,
    first_failed_reset_password_attempt = NULL
  WHERE
    roles_private.user_secrets.role_id = v_user.id;
  -- complete
  PERFORM
    status_private.user_completed_task ('set_password',
      v_user.id);
  RETURN TRUE;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

GRANT EXECUTE ON FUNCTION roles_public.set_password TO authenticated;

CREATE FUNCTION roles_public.submit_invite_code ( token text ) RETURNS boolean AS $EOFCODE$
DECLARE
  v_user roles_public.roles;
  v_email roles_public.user_emails;
  v_invite roles_public.invites;
  v_inviter_secrets roles_private.user_secrets;
BEGIN
  SELECT
    *
  FROM
    roles_public.roles
  WHERE
    id = roles_public.current_role_id ()
  INTO v_user;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'OBJECT_NOT_FOUND';
  END IF;
  -- get the invite
  SELECT
    *
  FROM
    roles_public.invites
  WHERE
    invite_token = token
  INTO v_invite;
  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'INVITE_NOT_FOUND';
  END IF;

  -- get the email
  SELECT
    *
  FROM
    roles_public.user_emails
  WHERE
    email = v_invite.email
    AND role_id = v_user.id
  INTO v_email;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'INVITE_EMAIL_NOT_FOUND';
  END IF;

  -- update invite to used
  UPDATE
    roles_public.invites
  SET
    invite_used = TRUE
  WHERE
    id = v_invite.id;
  -- give credit on secrets
  UPDATE roles_private.user_secrets
    SET invited_by_id = v_invite.sender_id
  WHERE role_id = v_user.id;


  -- get the inviter secrets
  -- later this can just be removed
  SELECT
    *
  FROM
    roles_private.user_secrets
  WHERE
    role_id = v_invite.sender_id
  INTO v_inviter_secrets;

  IF (v_inviter_secrets.invites_approved) THEN 
    -- they did it
    PERFORM
      status_private.user_completed_task ('invite_code');
  ELSE
    RAISE EXCEPTION 'INVITE_DOES_NOT_GRANT_ACCESS';
  END IF;

  -- its ok
  RETURN TRUE;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_public.submit_invite_code TO authenticated;

CREATE FUNCTION roles_public.verify_email ( id uuid, token text ) RETURNS boolean AS $EOFCODE$
DECLARE
  v_secret roles_private.user_email_secrets;
  v_email roles_public.user_emails;
  v_role_id uuid;
BEGIN

  SELECT
    roles_public.current_role_id () INTO v_role_id;

  -- Find Email
  -- if user is not logged in, find the email without scoping it to user
  -- if user is, scope it
  IF (v_role_id IS NULL) THEN
    SELECT
      *
    FROM
      roles_public.user_emails e
    WHERE
      e.id = verify_email.id INTO v_email;
  ELSE
    SELECT
      *
    FROM
      roles_public.user_emails e
    WHERE
      e.role_id = v_role_id
      AND e.id = verify_email.id INTO v_email;
  END IF;
  
  -- if no email found return false
  IF (NOT FOUND) THEN
    RETURN FALSE;
  END IF;

  -- before we go further
  -- the email had already been verified, and just return true in that case
  IF (v_email.is_verified) THEN
    RETURN TRUE;
  END IF;


  -- look up the secrets
  SELECT
    *
  FROM
    roles_private.user_email_secrets s
  WHERE
    s.user_email_id = verify_email.id
    AND s.verification_token IS NOT NULL
    AND s.verification_token = verify_email.token INTO v_secret;

  IF (NOT FOUND) THEN
    RETURN FALSE;
  END IF;

  UPDATE
    roles_private.user_email_secrets s
  SET
    verification_token = NULL
  WHERE
    s.user_email_id = verify_email.id;
  UPDATE
    roles_public.user_emails e
  SET
    is_verified = TRUE
  WHERE
    e.id = verify_email.id;
  -- use v_email.role_id since v_role_id can be null
  
  PERFORM status_private.user_completed_task('verify_email', v_email.role_id);

  RETURN TRUE;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_public.verify_email TO anonymous, authenticated;

ALTER TABLE roles_public.invites ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_invites ON roles_public.invites FOR SELECT TO PUBLIC USING ( ((roles_public.current_role_id()) = (sender_id)) );

CREATE POLICY can_insert_invites ON roles_public.invites FOR INSERT TO PUBLIC WITH CHECK ( ((roles_public.current_role_id()) = (sender_id)) );

CREATE POLICY can_update_invites ON roles_public.invites FOR UPDATE TO PUBLIC USING ( ((roles_public.current_role_id()) = (sender_id)) );

CREATE POLICY can_delete_invites ON roles_public.invites FOR DELETE TO PUBLIC USING ( (invite_used IS FALSE AND ((roles_public.current_role_id()) = (sender_id))) );

GRANT INSERT ( email, expires_at ) ON TABLE roles_public.invites TO authenticated;

GRANT UPDATE ( expires_at ) ON TABLE roles_public.invites TO authenticated;

GRANT SELECT ON TABLE roles_public.invites TO authenticated;

GRANT DELETE ON TABLE roles_public.invites TO authenticated;

CREATE FUNCTION roles_private.tg_on_invite_created (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  v_current_role_id uuid = roles_public.current_role_id ();
  v_inviter_profile roles_public.role_profiles;
BEGIN
  SELECT
    *
  FROM
    roles_public.role_profiles INTO v_inviter_profile
  WHERE
    role_id = v_current_role_id;
  PERFORM
    app_jobs.add_job ('invites__invite_email',
      json_build_object('inviter_name', v_inviter_profile.display_name, 'email', NEW.email::text, 'invite_token', NEW.invite_token::text));
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_invite_created 
 AFTER INSERT ON roles_public.invites 
 FOR EACH ROW
 EXECUTE PROCEDURE roles_private. tg_on_invite_created (  );

CREATE INDEX membership_invites_organization_id_idx ON roles_public.membership_invites ( organization_id );

CREATE INDEX membership_invites_sender_id_idx ON roles_public.membership_invites ( sender_id );

CREATE UNIQUE INDEX uniq_email_invites ON roles_public.membership_invites ( group_id, email ) WHERE email IS NOT NULL;

CREATE UNIQUE INDEX uniq_role_id_invites ON roles_public.membership_invites ( group_id, role_id ) WHERE role_id IS NOT NULL;

ALTER TABLE roles_public.membership_invites ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_membership_invite ON roles_public.membership_invites FOR SELECT TO PUBLIC USING ( (((roles_public.current_role_id()) = (sender_id)) OR permissions_private.permitted_on_role('browse', 'invite', group_id) OR (role_id IS NOT NULL AND ((roles_public.current_role_id()) = (role_id)) AND ((pg_catalog.date_part('epoch', ((expires_at) - (now())))) > (0)))) );

CREATE POLICY can_insert_membership_invite ON roles_public.membership_invites FOR INSERT TO PUBLIC WITH CHECK ( (permissions_private.permitted_on_role('add', 'invite', group_id) AND roles_private.actor_role_admin_owner_authorized_profiles(roles_public.current_role_id(), group_id, profile_id, organization_id)) );

CREATE POLICY can_update_membership_invite ON roles_public.membership_invites FOR UPDATE TO PUBLIC USING ( ((role_id IS NOT NULL AND ((roles_public.current_role_id()) = (role_id)) AND ((pg_catalog.date_part('epoch', ((expires_at) - (now())))) > (0))) OR (permissions_private.permitted_on_role('edit', 'invite', group_id) AND roles_private.actor_role_admin_owner_authorized_profiles(roles_public.current_role_id(), group_id, profile_id, organization_id))) );

CREATE POLICY can_delete_membership_invite ON roles_public.membership_invites FOR DELETE TO PUBLIC USING ( ((role_id IS NOT NULL AND ((roles_public.current_role_id()) = (role_id))) OR ((roles_public.current_role_id()) = (sender_id)) OR (permissions_private.permitted_on_role('destroy', 'invite', group_id) AND roles_private.actor_role_admin_owner_authorized_profiles(roles_public.current_role_id(), group_id, profile_id, organization_id))) );

GRANT SELECT ON TABLE roles_public.membership_invites TO authenticated;

GRANT INSERT ( role_id, email, profile_id, group_id, organization_id, expires_at ) ON TABLE roles_public.membership_invites TO authenticated;

GRANT UPDATE ( approved, accepted, expires_at ) ON TABLE roles_public.membership_invites TO authenticated;

GRANT DELETE ON TABLE roles_public.membership_invites TO authenticated;

CREATE FUNCTION roles_private.tg_after_update_membership_invite (  ) RETURNS trigger AS $EOFCODE$
BEGIN

  IF (NEW.approved AND NOT NEW.accepted) THEN
    PERFORM roles_private.send_membership_invite_email(NEW.id);
  END IF;

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER after_update_membership_invite 
 AFTER UPDATE ON roles_public.membership_invites 
 FOR EACH ROW
 WHEN ( NEW.approved IS DISTINCT FROM OLD.approved ) 
 EXECUTE PROCEDURE roles_private. tg_after_update_membership_invite (  );

CREATE FUNCTION roles_private.invite_member_email_fn (  ) RETURNS trigger AS $EOFCODE$
BEGIN

  IF (NEW.approved AND NOT NEW.accepted) THEN
    PERFORM roles_private.send_membership_invite_email(NEW.id);
  ELSIF (NOT NEW.approved) THEN
    PERFORM roles_private.send_membership_invite_approval_email(NEW.id);
  END IF;

  RETURN NEW;

END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER invite_member_email 
 AFTER INSERT ON roles_public.membership_invites 
 FOR EACH ROW
 EXECUTE PROCEDURE roles_private. invite_member_email_fn (  );

CREATE FUNCTION roles_private.tg_on_membership_invite_accepted (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  v_current_role_id uuid = roles_public.current_role_id ();
BEGIN
  IF (NEW.role_id IS NULL) THEN
    RAISE
    EXCEPTION 'INVITES_ONLY_ACCEPT_AFTER_ACCOUNT';
  END IF;
  IF (v_current_role_id != NEW.role_id) THEN
    RAISE
    EXCEPTION 'INVITES_ONLY_INVITEE_ACCEPT';
  END IF;
  IF (NEW.approved AND NEW.accepted) THEN
    INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id, invited_by_id)
      VALUES (NEW.role_id, NEW.group_id, NEW.profile_id, NEW.organization_id, NEW.sender_id);
  END IF;
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_invite_accepted 
 BEFORE UPDATE ON roles_public.membership_invites 
 FOR EACH ROW
 WHEN ( NEW.accepted IS DISTINCT FROM OLD.accepted ) 
 EXECUTE PROCEDURE roles_private. tg_on_membership_invite_accepted (  );

CREATE FUNCTION roles_private.tg_on_membership_invite_approval (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  v_current_role_id uuid = roles_public.current_role_id ();
BEGIN
  -- RLS checks the rest, we only need to check that it is not the invitee that changes this prop
  IF (v_current_role_id = NEW.role_id) THEN
    RAISE
    EXCEPTION 'INVITES_ONLY_ADMIN_APPROVE';
  END IF;

  IF (NEW.approved AND NOT NEW.accepted) THEN
     NEW.invite_token = encode( gen_random_bytes( 32 ), 'hex' );
  END IF;
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_invite_approval 
 BEFORE UPDATE ON roles_public.membership_invites 
 FOR EACH ROW
 WHEN ( NEW.approved IS DISTINCT FROM OLD.approved ) 
 EXECUTE PROCEDURE roles_private. tg_on_membership_invite_approval (  );

CREATE FUNCTION roles_private.tg_on_membership_invite_created (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  v_role_id uuid;
  v_email email;
  v_sender_id uuid = roles_public.current_role_id ();
  v_approved boolean = FALSE;
  v_organization_id uuid;
  v_group roles_public.roles;
  v_profile permissions_public.profile;
  v_is_admin boolean;
  v_is_owner boolean;
BEGIN
  IF (NEW.role_id IS NOT NULL) THEN
    v_role_id = NEW.role_id;
  ELSIF (NEW.email IS NOT NULL) THEN
    v_email = NEW.email;
    SELECT
      e.role_id
    FROM
      roles_public.user_emails e
    WHERE
      e.email = NEW.email
      AND e.is_verified = TRUE INTO v_role_id;
    IF (v_role_id IS NOT NULL) THEN
      v_email = NULL;
    END IF;
  ELSE
    RAISE
    EXCEPTION 'INVITES_NO_INVITEE';
  END IF;
  SELECT
    *
  FROM
    roles_public.roles
  WHERE
    id = NEW.group_id INTO v_group;
  IF (NOT FOUND) THEN
    RAISE
    EXCEPTION 'INVITES_GROUP_NOT_FOUND';
  END IF;
  -- sanitize organization_id
  IF (v_group.type = 'User'::roles_public.role_type) THEN
    v_organization_id = v_group.id;
  ELSIF (v_group.type = 'Team'::roles_public.role_type) THEN
    v_organization_id = v_group.organization_id;
  ELSIF (v_group.type = 'Organization'::roles_public.role_type) THEN
    v_organization_id = v_group.id;
  END IF;
  -- check admin can only invite admin
  
  v_is_admin = roles_private.is_admin_of (v_sender_id,
    NEW.group_id);

  v_is_owner = roles_private.is_owner_of (v_sender_id,
    NEW.group_id);

  IF (NEW.profile_id IS NOT NULL) THEN
    SELECT * FROM permissions_public.profile 
    WHERE id = NEW.profile_id 
    AND organization_id = v_organization_id
    INTO v_profile;

    IF (NOT FOUND) THEN
      RAISE EXCEPTION 'INVITES_BAD_PROFILE_ID';
    END IF;

  END IF;

  IF (v_profile.name = 'Owner' AND NOT v_is_owner) THEN
    RAISE EXCEPTION 'INVITES_ONLY_OWNER_INVITE_OWNER';
  END IF;

  IF (v_profile.name = 'Administrator' AND NOT v_is_admin) THEN
    RAISE EXCEPTION 'INVITES_ONLY_ADMIN_INVITE_ADMIN';
  END IF;

  -- approvals automatic for admins
  IF (v_is_admin) THEN
    v_approved = TRUE;
  END IF;

  NEW.role_id = v_role_id;
  NEW.email = v_email;
  NEW.sender_id = v_sender_id;
  NEW.approved = v_approved;
  NEW.organization_id = v_organization_id;
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_invite_created 
 BEFORE INSERT ON roles_public.membership_invites 
 FOR EACH ROW
 EXECUTE PROCEDURE roles_private. tg_on_membership_invite_created (  );

CREATE FUNCTION roles_private.tg_on_invite_expires_updated (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  v_current_role_id uuid = roles_public.current_role_id ();
BEGIN
  -- RLS checks the rest, we only need to check that it is not the invitee that changes this prop
  IF (v_current_role_id = NEW.role_id) THEN
    RAISE EXCEPTION 'INVITES_ONLY_MEMBERS_CHANGE_EXPIRY';
  END IF;
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_invite_expires_updated 
 BEFORE UPDATE ON roles_public.membership_invites 
 FOR EACH ROW
 WHEN ( NEW.expires_at IS DISTINCT FROM OLD.expires_at ) 
 EXECUTE PROCEDURE roles_private. tg_on_invite_expires_updated (  );

CREATE INDEX memberships_group_id_idx ON roles_public.memberships ( group_id );

CREATE INDEX memberships_invited_by_id_idx ON roles_public.memberships ( invited_by_id );

CREATE INDEX memberships_membership_id_idx ON roles_public.memberships ( membership_id );

CREATE INDEX memberships_organization_idx ON roles_public.memberships ( organization_id );

CREATE INDEX memberships_role_id_idx ON roles_public.memberships ( role_id );

ALTER TABLE roles_public.memberships ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_membership ON roles_public.memberships FOR SELECT TO PUBLIC USING ( (((roles_public.current_role_id()) = (role_id)) OR permissions_private.permitted_on_role('browse', 'user', group_id)) );

CREATE POLICY can_insert_membership ON roles_public.memberships FOR INSERT TO PUBLIC WITH CHECK ( (permissions_private.permitted_on_role('add', 'user', group_id) AND roles_private.actor_role_admin_owner_authorized_profiles(roles_public.current_role_id(), group_id, profile_id, organization_id)) );

CREATE POLICY can_update_membership ON roles_public.memberships FOR UPDATE TO PUBLIC USING ( (permissions_private.permitted_on_role('edit', 'user', group_id) AND roles_private.actor_role_admin_owner_authorized_profiles(roles_public.current_role_id(), group_id, profile_id, organization_id)) );

CREATE POLICY can_delete_membership ON roles_public.memberships FOR DELETE TO PUBLIC USING ( (((roles_public.current_role_id()) = (role_id)) OR (permissions_private.permitted_on_role('destroy', 'user', group_id) AND roles_private.actor_role_admin_owner_authorized_profiles(roles_public.current_role_id(), group_id, profile_id, organization_id))) );

GRANT SELECT ON TABLE roles_public.memberships TO authenticated;

GRANT INSERT ON TABLE roles_public.memberships TO authenticated;

GRANT UPDATE ON TABLE roles_public.memberships TO authenticated;

GRANT DELETE ON TABLE roles_public.memberships TO authenticated;

CREATE TRIGGER ensure_proper_membership 
 BEFORE INSERT ON roles_public.memberships 
 FOR EACH ROW
 EXECUTE PROCEDURE roles_private. tg_ensure_proper_membership (  );

CREATE FUNCTION roles_private.tg_on_create_cascade_hierarchy (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  PERFORM roles_private.membership_cascade_hierarchy(NEW);
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_create_cascade_hierarchy 
 AFTER INSERT ON roles_public.memberships 
 FOR EACH ROW
 WHEN ( ((new.inherited) <> ((TRUE))) ) 
 EXECUTE PROCEDURE roles_private. tg_on_create_cascade_hierarchy (  );

CREATE FUNCTION roles_private.tg_on_create_inherit_profile_if_null (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  mbr roles_public.memberships;
BEGIN
 IF (NEW.profile_id IS NULL) THEN

  -- GET ORG PROFILE, IF EXISTS
  SELECT * FROM 
    roles_public.memberships m
      WHERE 
      m.organization_id=NEW.organization_id
      AND m.group_id=NEW.organization_id
      AND m.role_id=NEW.role_id
  INTO mbr;

  IF (FOUND) THEN
    NEW.profile_id = mbr.profile_id;
  END IF;   

 END IF;

 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_create_inherit_profile_if_null 
 BEFORE INSERT ON roles_public.memberships 
 FOR EACH ROW
 EXECUTE PROCEDURE roles_private. tg_on_create_inherit_profile_if_null (  );

CREATE FUNCTION roles_private.tg_on_delete_ensure_one_owner (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  grant_role roles_public.roles;
  membership_profile permissions_public.profile;
  
  admin_grant roles_public.memberships;
  
BEGIN

  SELECT * FROM roles_public.roles r
  WHERE
      r.id = OLD.group_id
  INTO grant_role;

  IF (NOT FOUND) THEN
    -- this means the organization or team was removed
    RETURN OLD;
  END IF;

  SELECT * FROM permissions_public.profile p
  WHERE
      p.id = OLD.profile_id
  INTO membership_profile;

  IF (NOT FOUND) THEN
    -- this means was removed
    RETURN OLD;
  END IF;

  -- we only care about Organizations
  IF (grant_role.type != 'Organization'::roles_public.role_type) THEN
    RETURN OLD;
  END IF;

  -- we only care about Removing Administrator
  -- IF (membership_profile.name != 'Administrator' OR membership_profile.name != 'Owner') THEN
  --   RETURN OLD;
  -- END IF;

  -- we only care about Removing Owners
  IF (membership_profile.name != 'Owner') THEN
    RETURN OLD;
  END IF;

  SELECT *
      FROM roles_public.memberships m
      JOIN permissions_public.profile p
      ON (m.profile_id = p.id AND m.organization_id = p.organization_id)
  WHERE 
    p.name = 'Owner'
    AND m.role_id != OLD.role_id

    AND m.group_id = OLD.group_id
    AND m.organization_id = OLD.organization_id
  INTO admin_grant;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'ORGANIZATIONS_REQUIRE_ONE_OWNER';
  END IF;

  RETURN OLD;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE TRIGGER on_delete_ensure_one_owner 
 BEFORE DELETE ON roles_public.memberships 
 FOR EACH ROW
 WHEN ( ((old.inherited) = ((FALSE))) ) 
 EXECUTE PROCEDURE roles_private. tg_on_delete_ensure_one_owner (  );

ALTER TABLE roles_public.memberships ADD COLUMN  created_at timestamptz;

ALTER TABLE roles_public.memberships ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE roles_public.memberships ADD COLUMN  updated_at timestamptz;

ALTER TABLE roles_public.memberships ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER update_roles_public_memberships_modtime 
 BEFORE INSERT OR UPDATE ON roles_public.memberships 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_timestamps (  );

ALTER TABLE roles_public.role_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_role_profiles ON roles_public.role_profiles FOR SELECT TO PUBLIC USING ( permissions_private.permitted_on_role('browse', 'role_profile', role_id) );

CREATE POLICY can_insert_role_profiles ON roles_public.role_profiles FOR INSERT TO PUBLIC WITH CHECK ( permissions_private.permitted_on_role('edit', 'role_profile', role_id) );

CREATE POLICY can_update_role_profiles ON roles_public.role_profiles FOR UPDATE TO PUBLIC USING ( permissions_private.permitted_on_role('edit', 'role_profile', role_id) );

GRANT INSERT ON TABLE roles_public.role_profiles TO authenticated;

GRANT SELECT ON TABLE roles_public.role_profiles TO authenticated;

GRANT UPDATE ( display_name, avatar_url, bio, url, company, location ) ON TABLE roles_public.role_profiles TO authenticated;

CREATE FUNCTION status_private.user_incompleted_task ( task citext, role_id uuid DEFAULT roles_public.current_role_id() ) RETURNS void AS $EOFCODE$
  DELETE FROM status_public.user_task_achievement
  WHERE user_id = role_id
    AND task_id = (
      SELECT
        t.id
      FROM
        status_public.user_task t
      WHERE
        name = task);
$EOFCODE$ LANGUAGE sql VOLATILE SECURITY DEFINER;

CREATE FUNCTION roles_private.tg_on_update_display_name_set_achievement (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  v_role_type roles_public.role_type;
BEGIN
  SELECT type 
    FROM roles_public.roles
    WHERE id = NEW.role_id
    INTO v_role_type;

  IF (v_role_type != 'User'::roles_public.role_type) THEN
    RETURN NEW;
  END IF;

  IF (NEW.display_name IS NULL) THEN
    PERFORM status_private.user_incompleted_task('create_display_name', NEW.role_id);
  ELSE
    PERFORM status_private.user_completed_task('create_display_name', NEW.role_id);
  END IF;
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_insert_display_name_set_achievement 
 AFTER INSERT ON roles_public.role_profiles 
 FOR EACH ROW
 EXECUTE PROCEDURE roles_private. tg_on_update_display_name_set_achievement (  );

CREATE TRIGGER on_update_display_name_set_achievement 
 AFTER UPDATE ON roles_public.role_profiles 
 FOR EACH ROW
 WHEN ( NEW.display_name IS DISTINCT FROM OLD.display_name ) 
 EXECUTE PROCEDURE roles_private. tg_on_update_display_name_set_achievement (  );

CREATE TABLE roles_public.role_settings (
 	role_id uuid PRIMARY KEY REFERENCES roles_public.roles ( id ) ON DELETE CASCADE,
	organization_id uuid NOT NULL REFERENCES roles_public.roles ( id ) ON DELETE CASCADE 
);

ALTER TABLE roles_public.role_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_role_settings ON roles_public.role_settings FOR SELECT TO PUBLIC USING ( permissions_private.permitted_on_role('browse', 'role_setting', role_id) );

CREATE POLICY can_insert_role_settings ON roles_public.role_settings FOR INSERT TO PUBLIC WITH CHECK ( permissions_private.permitted_on_role('edit', 'role_setting', role_id) );

CREATE POLICY can_update_role_settings ON roles_public.role_settings FOR UPDATE TO PUBLIC USING ( permissions_private.permitted_on_role('edit', 'role_setting', role_id) );

GRANT INSERT ON TABLE roles_public.role_settings TO authenticated;

GRANT SELECT ON TABLE roles_public.role_settings TO authenticated;

GRANT UPDATE ON TABLE roles_public.role_settings TO authenticated;

ALTER TABLE roles_public.roles ADD CONSTRAINT fk_roles_public_roles_username CHECK ( ((username) ~ ('^[a-zA-Z]([a-zA-Z0-9][_]?)+$')) );

CREATE INDEX parent_idx ON roles_public.roles ( parent_id );

CREATE INDEX roles_organization_id_parent_id_idx ON roles_public.roles ( organization_id, parent_id );

CREATE INDEX roles_organization_idx ON roles_public.roles ( organization_id );

CREATE UNIQUE INDEX unique_username ON roles_public.roles ( username ) WHERE username IS NOT NULL;

ALTER TABLE roles_public.roles ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_roles ON roles_public.roles FOR SELECT TO PUBLIC USING ( (permissions_private.permitted_on_role('read', 'role', id) OR permissions_private.permitted_on_role('browse', 'role', organization_id)) );

CREATE POLICY can_insert_roles ON roles_public.roles FOR INSERT TO PUBLIC WITH CHECK ( CASE WHEN parent_id IS NOT NULL THEN permissions_private.permitted_on_role('add', 'team', parent_id) ELSE (TRUE) END );

CREATE POLICY can_update_roles ON roles_public.roles FOR UPDATE TO PUBLIC USING ( permissions_private.permitted_on_role('edit', 'role', id) );

CREATE POLICY can_delete_roles ON roles_public.roles FOR DELETE TO PUBLIC USING ( permissions_private.permitted_on_role('destroy', 'role', id) );

GRANT INSERT ON TABLE roles_public.roles TO authenticated;

GRANT SELECT ON TABLE roles_public.roles TO authenticated;

GRANT UPDATE ( username, parent_id ) ON TABLE roles_public.roles TO authenticated;

GRANT DELETE ON TABLE roles_public.roles TO authenticated;

CREATE TRIGGER ensure_proper_role_parents 
 BEFORE UPDATE ON roles_public.roles 
 FOR EACH ROW
 WHEN ( NEW.parent_id IS DISTINCT FROM OLD.parent_id ) 
 EXECUTE PROCEDURE roles_private. tg_ensure_proper_role_parents (  );

CREATE TRIGGER ensure_proper_role 
 BEFORE INSERT ON roles_public.roles 
 FOR EACH ROW
 EXECUTE PROCEDURE roles_private. tg_ensure_proper_role (  );

CREATE TRIGGER immutable_role_properties 
 BEFORE UPDATE ON roles_public.roles 
 FOR EACH ROW
 WHEN ( (new.type IS DISTINCT FROM old.type OR new.organization_id IS DISTINCT FROM old.organization_id) ) 
 EXECUTE PROCEDURE roles_private. tg_immutable_role_properties (  );

CREATE FUNCTION roles_private.tg_on_create_role_cascade_memberships (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  PERFORM
    roles_private.team_cascade_memberships(NEW.id, NEW.organization_id);
 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_create_role_cascade_memberships 
 AFTER INSERT ON roles_public.roles 
 FOR EACH ROW
 WHEN ( ((new.type) = ('Team'::roles_public.role_type)) ) 
 EXECUTE PROCEDURE roles_private. tg_on_create_role_cascade_memberships (  );

CREATE FUNCTION roles_private.tg_on_update_team_parent_cascade_memberships (  ) RETURNS trigger AS $EOFCODE$
BEGIN

  PERFORM
  roles_private.cascade_restructured_organization
    (NEW.organization_id)
  ;

  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_update_team_parent_cascade_memberships 
 AFTER UPDATE ON roles_public.roles 
 FOR EACH ROW
 WHEN ( NEW.parent_id IS DISTINCT FROM OLD.parent_id ) 
 EXECUTE PROCEDURE roles_private. tg_on_update_team_parent_cascade_memberships (  );

CREATE FUNCTION roles_private.tg_on_update_username_set_achievement (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  IF (NEW.username IS NULL) THEN
    PERFORM status_private.user_incompleted_task('create_username', NEW.id);
  ELSE
    PERFORM status_private.user_completed_task('create_username', NEW.id);
  END IF;
 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_update_username_set_achievement 
 AFTER UPDATE ON roles_public.roles 
 FOR EACH ROW
 WHEN ( (new.username IS DISTINCT FROM old.username AND ((new.type) = ('User'::roles_public.role_type))) ) 
 EXECUTE PROCEDURE roles_private. tg_on_update_username_set_achievement (  );

CREATE TRIGGER on_insert_username_set_achievement 
 AFTER INSERT ON roles_public.roles 
 FOR EACH ROW
 EXECUTE PROCEDURE roles_private. tg_on_update_username_set_achievement (  );

ALTER TABLE roles_public.roles ADD COLUMN  created_at timestamptz;

ALTER TABLE roles_public.roles ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE roles_public.roles ADD COLUMN  updated_at timestamptz;

ALTER TABLE roles_public.roles ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER update_roles_public_roles_modtime 
 BEFORE INSERT OR UPDATE ON roles_public.roles 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_timestamps (  );

ALTER TABLE roles_public.user_emails ENABLE ROW LEVEL SECURITY;

CREATE POLICY delete_own ON roles_public.user_emails FOR DELETE TO PUBLIC USING ( ((role_id) = (roles_public.current_role_id())) );

GRANT DELETE ON TABLE roles_public.user_emails TO authenticated;

CREATE POLICY insert_own ON roles_public.user_emails FOR INSERT TO PUBLIC WITH CHECK ( ((role_id) = (roles_public.current_role_id())) );

GRANT INSERT ( email ) ON TABLE roles_public.user_emails TO authenticated;

CREATE POLICY select_own ON roles_public.user_emails FOR SELECT TO PUBLIC USING ( ((role_id) = (roles_public.current_role_id())) );

GRANT SELECT ON TABLE roles_public.user_emails TO authenticated;

CREATE FUNCTION roles_private.tg_after_is_verified_set_achievement (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  IF (NEW.is_verified) THEN
    PERFORM status_private.user_completed_task('verify_email', NEW.role_id);
  END IF;
 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER after_is_verified_set_achievement_insert 
 AFTER INSERT ON roles_public.user_emails 
 FOR EACH ROW
 EXECUTE PROCEDURE roles_private. tg_after_is_verified_set_achievement (  );

CREATE TRIGGER after_is_verified_set_achievement_update 
 AFTER UPDATE ON roles_public.user_emails 
 FOR EACH ROW
 WHEN ( NEW.is_verified IS DISTINCT FROM OLD.is_verified ) 
 EXECUTE PROCEDURE roles_private. tg_after_is_verified_set_achievement (  );

CREATE FUNCTION roles_public.tg_convert_invites_to_role_id (  ) RETURNS trigger AS $EOFCODE$
BEGIN

  IF (NEW.is_verified) THEN
    UPDATE roles_public.membership_invites invites
    SET role_id=NEW.role_id
    WHERE invites.email=NEW.email;
  END IF;

  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER convert_invites_to_role_id_after_insert 
 AFTER INSERT ON roles_public.user_emails 
 FOR EACH ROW
 EXECUTE PROCEDURE roles_public. tg_convert_invites_to_role_id (  );

CREATE TRIGGER convert_invites_to_role_id_after_update 
 AFTER UPDATE ON roles_public.user_emails 
 FOR EACH ROW
 WHEN ( NEW.is_verified IS DISTINCT FROM OLD.is_verified ) 
 EXECUTE PROCEDURE roles_public. tg_convert_invites_to_role_id (  );

CREATE FUNCTION roles_private.tg_create_email_secrets (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  v_secret roles_private.user_email_secrets;
BEGIN

  SELECT * FROM
    roles_private.prepare_secrets_for_email_validation(NEW.id)
  INTO v_secret;

  -- PERFORM
  --   app_jobs.add_job ('user_welcome__send_welcome',
  --     json_build_object(
  --       'email', NEW.email::text
  --     )
  --   );

  -- only TRUE in testing
  IF (NEW.is_verified IS FALSE) THEN
    PERFORM 
      roles_private.create_email_verification_job (
        NEW.email::text,
        NEW.id::text,
        v_secret.verification_token::text
      );
  END IF;

  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TRIGGER create_email_secrets 
 AFTER INSERT ON roles_public.user_emails 
 FOR EACH ROW
 EXECUTE PROCEDURE roles_private. tg_create_email_secrets (  );

ALTER TABLE roles_public.user_emails ADD COLUMN  created_at timestamptz;

ALTER TABLE roles_public.user_emails ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE roles_public.user_emails ADD COLUMN  updated_at timestamptz;

ALTER TABLE roles_public.user_emails ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER update_roles_public_user_emails_modtime 
 BEFORE INSERT OR UPDATE ON roles_public.user_emails 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_timestamps (  );

CREATE VIEW roles_public.organization AS SELECT * FROM roles_public.roles WHERE ((type) = ('Organization'::roles_public.role_type));

GRANT SELECT ON TABLE roles_public.organization TO authenticated;

GRANT INSERT ON TABLE roles_public.organization TO authenticated;

GRANT UPDATE ( username ) ON TABLE roles_public.organization TO authenticated;

GRANT DELETE ON TABLE roles_public.organization TO authenticated;

CREATE FUNCTION roles_private.tg_on_insert_instead_of_create_role (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  v_role roles_public.roles;
BEGIN
  SELECT
    *
  FROM
    roles_public.register_organization (NEW.username) INTO v_role;
  RETURN v_role;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_insert_instead_of_create_role 
 INSTEAD OF INSERT ON roles_public.organization 
 FOR EACH ROW
 EXECUTE PROCEDURE roles_private. tg_on_insert_instead_of_create_role (  );

CREATE VIEW roles_public.team AS SELECT * FROM roles_public.roles WHERE ((type) = ('Team'::roles_public.role_type));

GRANT SELECT ON TABLE roles_public.team TO authenticated;

CREATE VIEW roles_public."user" AS SELECT * FROM roles_public.roles WHERE ((type) = ('User'::roles_public.role_type));

GRANT SELECT ON TABLE roles_public."user" TO authenticated;

CREATE FUNCTION status_public.tasks_required_for ( achievement citext, role_id uuid DEFAULT roles_public.current_role_id() ) RETURNS SETOF status_public.user_task AS $EOFCODE$
BEGIN
  RETURN QUERY
    SELECT
      t.*
    FROM
      status_public.user_task t
    FULL OUTER JOIN status_public.user_task_achievement u ON (
      u.task_id = t.id
      AND u.user_id = role_id
    )
    JOIN status_public.user_achievement f ON (t.achievement_id = f.id)
  WHERE
    u.user_id IS NULL
    AND f.name = achievement
  ORDER BY t.priority ASC
;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

INSERT INTO status_public.user_achievement ( name ) VALUES ('profile_complete');

GRANT SELECT ON TABLE status_public.user_achievement TO authenticated;

CREATE INDEX user_id_idx ON status_public.user_task_achievement ( user_id );

ALTER TABLE status_public.user_task_achievement ENABLE ROW LEVEL SECURITY;

CREATE POLICY can_select_user_task_achievement ON status_public.user_task_achievement FOR SELECT TO PUBLIC USING ( ((roles_public.current_role_id()) = (user_id)) );

CREATE POLICY can_insert_user_task_achievement ON status_public.user_task_achievement FOR INSERT TO PUBLIC WITH CHECK ( (FALSE) );

CREATE POLICY can_update_user_task_achievement ON status_public.user_task_achievement FOR UPDATE TO PUBLIC USING ( (FALSE) );

CREATE POLICY can_delete_user_task_achievement ON status_public.user_task_achievement FOR DELETE TO PUBLIC USING ( (FALSE) );

GRANT INSERT ON TABLE status_public.user_task_achievement TO authenticated;

GRANT SELECT ON TABLE status_public.user_task_achievement TO authenticated;

GRANT UPDATE ON TABLE status_public.user_task_achievement TO authenticated;

GRANT DELETE ON TABLE status_public.user_task_achievement TO authenticated;

ALTER TABLE status_public.user_task_achievement ADD COLUMN  created_at timestamptz;

ALTER TABLE status_public.user_task_achievement ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE status_public.user_task_achievement ADD COLUMN  updated_at timestamptz;

ALTER TABLE status_public.user_task_achievement ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER update_status_public_user_task_achievement_modtime 
 BEFORE INSERT OR UPDATE ON status_public.user_task_achievement 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_timestamps (  );

INSERT INTO status_public.user_task ( name, achievement_id, priority ) VALUES ('accept_terms', (SELECT id FROM status_public.user_achievement WHERE ((name) = ('profile_complete'))), 10), ('set_password', (SELECT id FROM status_public.user_achievement WHERE ((name) = ('profile_complete'))), 20), ('verify_email', (SELECT id FROM status_public.user_achievement WHERE ((name) = ('profile_complete'))), 30), ('create_display_name', (SELECT id FROM status_public.user_achievement WHERE ((name) = ('profile_complete'))), 40), ('create_username', (SELECT id FROM status_public.user_achievement WHERE ((name) = ('profile_complete'))), 50), ('invite_code', (SELECT id FROM status_public.user_achievement WHERE ((name) = ('profile_complete'))), 60);

GRANT SELECT ON TABLE status_public.user_task TO authenticated;