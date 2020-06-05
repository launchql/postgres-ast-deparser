-- Verify schemas/roles_public/tables/memberships/triggers/timestamps  on pg

BEGIN;

SELECT created_at FROM roles_public.memberships LIMIT 1;
SELECT updated_at FROM roles_public.memberships LIMIT 1;
SELECT verify_trigger ('roles_public.update_roles_public_memberships_modtime');

ROLLBACK;
