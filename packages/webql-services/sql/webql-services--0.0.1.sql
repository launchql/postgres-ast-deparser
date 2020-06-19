\echo Use "CREATE EXTENSION webql-services" to load this file. \quit
CREATE SCHEMA services_private;

CREATE SCHEMA services_public;

CREATE TABLE services_public.services (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	name text,
	subdomain text,
	domain text,
	dbname text,
	role_name text,
	anon_role text,
	role_key text,
	schemas text[],
	auth text[],
	UNIQUE ( subdomain ),
	UNIQUE ( domain ) 
);