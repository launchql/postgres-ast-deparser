-- Verify schemas/auth_public/procedures/create_service_token  on pg

BEGIN;

SELECT verify_function ('auth_public.create_service_token');

ROLLBACK;
