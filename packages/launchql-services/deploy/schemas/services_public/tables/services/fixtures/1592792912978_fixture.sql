-- Deploy schemas/services_public/tables/services/fixtures/1592792912978_fixture to pg

-- requires: schemas/services_public/schema
-- requires: schemas/services_public/tables/services/table
-- requires: schemas/services_public/tables/services/triggers/ensure_domain 
-- requires: schemas/services_public/tables/config/fixtures/1595032695960_fixture

BEGIN;

-- TODO REMOVE THIS FROM PROD! 
-- just to help while developing

insert into services_public.services (subdomain, dbname, role_name, anon_role, schemas) VALUES 
('admin', current_database(), 'administrator', 'administrator', ARRAY['collections_public']),
('services', current_database(), 'administrator', 'administrator', ARRAY['services_public'])
;

-- with auth
insert into services_public.services (subdomain, dbname, role_name, anon_role, schemas, auth, role_key) VALUES 
('api', current_database(), 'authenticated', 'anonymous', ARRAY['collections_public'], ARRAY['auth_private', 'authenticate'], 'role_id')
;

COMMIT;
