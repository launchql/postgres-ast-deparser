-- Verify schemas/roles_private/procedures/registration/register_auth_role  on pg

BEGIN;

SELECT verify_function ('roles_private.register_auth_role', current_user);

ROLLBACK;
