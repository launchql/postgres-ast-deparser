
INSERT INTO services_public.services 
(
    subdomain,
    domain,
    dbname,
    role_name,
    anon_role,
    schemas,
    -- role_key,
    -- auth
) VALUES 
(
    'api',
    'lql.io',
    'launchql-db-v1',
    'authenticated',
    'anonymous',
    ARRAY['collections_public', 'modules_public']
    -- 'user_id',
    -- ARRAY['dashboard_private','authenticate']
);
        
          
INSERT INTO services_public.services 
(
    subdomain,
    domain,
    dbname,
    role_name,
    anon_role,
    schemas,
    role_key,
    auth
) VALUES 
(
    'admin',
    'lql.io',
    'launchql-db-v1',
    'authenticated',
    'anonymous',
    ARRAY['collections_public', 'modules_public']
    -- 'user_id',
    -- ARRAY['dashboard_private','authenticate']
);
        
          