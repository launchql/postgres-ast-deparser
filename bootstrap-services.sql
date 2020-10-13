BEGIN;
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
    'admin',
    'lql.io',
    'launchql-db-v1',
    'administrator',
    'administrator',
    ARRAY['collections_public', 'modules_public']
);
        
COMMIT;