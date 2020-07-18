\echo Use "CREATE EXTENSION webql-services" to load this file. \quit
CREATE SCHEMA services_private;

CREATE SCHEMA services_public;

CREATE TABLE services_public.config (
 	id int PRIMARY KEY DEFAULT ( 1 ),
	domain citext NOT NULL DEFAULT ( 'localhost' ) 
);

INSERT INTO services_public.config DEFAULT VALUES;

CREATE FUNCTION services_private.tg_only_one_record (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  c int = 0;
BEGIN
 SELECT count(*) FROM 
    services_public.config
 INTO c;

 IF (c = 0) THEN
     RETURN NEW;
 END IF;

 RAISE EXCEPTION 'ONLY_ONE_RECORD';
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER only_one_record 
 BEFORE INSERT ON services_public.config 
 FOR EACH ROW
 EXECUTE PROCEDURE services_private. tg_only_one_record (  );

CREATE TABLE services_public.services (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	database_id uuid,
	is_public bool,
	name text,
	subdomain citext,
	domain citext,
	dbname text,
	role_name text,
	anon_role text,
	role_key text,
	schemas text[],
	auth text[],
	pubkey_challenge text[],
	UNIQUE ( subdomain, domain ) 
);

CREATE FUNCTION services_private.tg_ensure_domain (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  def_name text;
BEGIN
 IF (NEW.domain IS NULL) THEN
    SELECT domain FROM services_public.config
        WHERE id = 1
    INTO def_name;
    NEW.domain = def_name;    
 END IF;
 RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER ensure_domain 
 BEFORE INSERT ON services_public.services 
 FOR EACH ROW
 EXECUTE PROCEDURE services_private. tg_ensure_domain (  );

INSERT INTO services_public.services ( subdomain, dbname, role_name, anon_role, schemas ) VALUES ('admin', current_database(), 'administrator', 'administrator', ARRAY['collections_public']), ('services', current_database(), 'administrator', 'administrator', ARRAY['services_public']);

INSERT INTO services_public.services ( subdomain, dbname, role_name, anon_role, schemas, auth, role_key ) VALUES ('api', current_database(), 'authenticated', 'anonymous', ARRAY['collections_public'], ARRAY['auth_private', 'authenticate'], 'role_id');