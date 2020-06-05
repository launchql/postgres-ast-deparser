-- Verify schemas/roles_public/procedures/register_organization  on pg

BEGIN;

SELECT verify_function ('roles_public.create_organization', current_user);

ROLLBACK;
