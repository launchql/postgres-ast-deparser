-- Verify schemas/roles_public/tables/roles/triggers/timestamps  on pg

BEGIN;

SELECT created_at FROM roles_public.roles LIMIT 1;
SELECT updated_at FROM roles_public.roles LIMIT 1;
SELECT verify_trigger ('roles_public.update_roles_public_roles_modtime');

ROLLBACK;
