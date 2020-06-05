-- Verify schemas/roles_public/procedures/register_team  on pg

BEGIN;

SELECT verify_function ('roles_public.create_team', current_user);

ROLLBACK;
