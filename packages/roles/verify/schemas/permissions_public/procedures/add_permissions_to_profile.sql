-- Verify schemas/permissions_public/procedures/add_permissions_to_profile  on pg

BEGIN;

SELECT verify_function ('permissions_public.add_permissions_to_profile');

ROLLBACK;
