-- Deploy schemas/services_public/tables/services/fixtures/1592792912978_fixture to pg

-- requires: schemas/services_public/schema
-- requires: schemas/services_public/tables/services/table

BEGIN;

-- TODO REMOVE THIS FROM PROD! 
-- just to help while developing

insert into services_public.services (subdomain, dbname, role_name, anon_role, schemas) VALUES 
('admin', 'webql-db', 'postgres', 'postgres', ARRAY['collections_public']),
('services', 'webql-db', 'postgres', 'postgres', ARRAY['services_public'])
;

-- with auth
insert into services_public.services (subdomain, dbname, role_name, anon_role, schemas, auth, role_key) VALUES 
('api', 'webql-db', 'authenticated', 'anonymous', ARRAY['collections_public'], ARRAY['auth_private', 'authenticate'], 'role_id')
;

COMMIT;
