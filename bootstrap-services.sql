BEGIN;

DELETE FROM services_public.services WHERE TRUE;

GRANT USAGE ON SCHEMA services_public TO administrator;
GRANT SELECT ON services_public.services TO administrator;
GRANT CONNECT ON DATABASE "service-db" TO app_user;
GRANT CONNECT ON DATABASE "service-db" TO app_admin;
GRANT CONNECT ON DATABASE "launchql-db-v1" TO app_user;
GRANT CONNECT ON DATABASE "launchql-db-v1" TO app_admin;

SELECT services_public.add_api_service(
    subdomain := 'api',
    domain := 'lql.io',
    dbname := 'launchql-db-v1',
    role_name := 'authenticated',
    anon_role := 'anonymous',
    schemas := ARRAY['collections_public', 'modules_public']
);

SELECT services_public.add_api_service(
    subdomain := 'svc',
    domain := 'lql.io',
    dbname := 'service-db',
    role_name := 'administrator',
    anon_role := 'administrator',
    schemas := ARRAY['services_public']
);

SELECT services_public.add_api_service(
    subdomain := 'admin',
    domain := 'lql.io',
    dbname := 'launchql-db-v1',
    role_name := 'administrator',
    anon_role := 'administrator',
    schemas := ARRAY['collections_public', 'modules_public']
);
        
COMMIT;