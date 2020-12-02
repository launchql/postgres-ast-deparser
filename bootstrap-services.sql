BEGIN;

DELETE FROM services_public.services WHERE TRUE;

GRANT USAGE ON SCHEMA services_public TO administrator;
GRANT SELECT ON services_public.services TO administrator;
GRANT CONNECT ON DATABASE "service-db" TO app_user;
GRANT CONNECT ON DATABASE "service-db" TO app_admin;
GRANT CONNECT ON DATABASE "launchql-db-v1" TO app_user;
GRANT CONNECT ON DATABASE "launchql-db-v1" TO app_admin;

SELECT services_public.add_api_service(
    v_subdomain := 'api',
    v_domain := 'lql.io',
    v_dbname := 'launchql-db-v1',
    v_role_name := 'authenticated',
    v_anon_role := 'anonymous',
    v_schemas := ARRAY['collections_public', 'modules_public']
);

SELECT services_public.add_api_service(
    v_subdomain := 'svc',
    v_domain := 'lql.io',
    v_dbname := 'service-db',
    v_role_name := 'administrator',
    v_anon_role := 'administrator',
    v_schemas := ARRAY['services_public']
);

SELECT services_public.add_api_service(
    v_subdomain := 'admin',
    v_domain := 'lql.io',
    v_dbname := 'launchql-db-v1',
    v_role_name := 'administrator',
    v_anon_role := 'administrator',
    v_schemas := ARRAY['collections_public', 'modules_public']
);
        
COMMIT;