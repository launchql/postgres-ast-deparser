BEGIN;

DELETE FROM services_public.services WHERE TRUE;

GRANT USAGE ON SCHEMA services_public TO administrator;
GRANT SELECT ON services_public.services TO administrator;
GRANT CONNECT ON DATABASE "service-db" TO app_user;
GRANT CONNECT ON DATABASE "service-db" TO app_admin;
GRANT CONNECT ON DATABASE "launchql-db-v1" TO app_user;
GRANT CONNECT ON DATABASE "launchql-db-v1" TO app_admin;

INSERT INTO services_public.services 
(
    subdomain,
    domain,
    dbname,
    role_name,
    anon_role,
    schemas
) VALUES 
(
    'api',
    'lql.io',
    'launchql-db-v1',
    'authenticated',
    'anonymous',
    ARRAY['collections_public', 'modules_public']
);
        
INSERT INTO services_public.services 
(
    subdomain,
    domain,
    dbname,
    role_name,
    anon_role,
    schemas
) VALUES 
(
    'svc',
    'lql.io',
    'service-db',
    'administrator',
    'administrator',
    ARRAY['services_public']
);

INSERT INTO services_public.services 
(
    subdomain,
    domain,
    dbname,
    role_name,
    anon_role,
    schemas
) VALUES 
(
    'admin',
    'lql.io',
    'launchql-db-v1',
    'administrator',
    'administrator',
    ARRAY['collections_public', 'modules_public']
);
        
COMMIT;