\echo Use "CREATE EXTENSION webql-services" to load this file. \quit
CREATE SCHEMA services_private;

CREATE SCHEMA services_public;

CREATE TABLE services_public.services (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
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

INSERT INTO services_public.services ( subdomain, dbname, role_name, anon_role, schemas ) VALUES ('admin', 'webql-db', 'postgres', 'postgres', ARRAY['collections_public']), ('services', 'webql-db', 'postgres', 'postgres', ARRAY['services_public']);

INSERT INTO services_public.services ( subdomain, dbname, role_name, anon_role, schemas, auth, role_key ) VALUES ('api', 'webql-db', 'authenticated', 'anonymous', ARRAY['collections_public'], ARRAY['auth_private', 'authenticate'], 'role_id');