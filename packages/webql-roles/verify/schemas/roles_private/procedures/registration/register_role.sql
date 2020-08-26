-- Verify schemas/roles_private/procedures/registration/register_role  on pg

BEGIN;

SELECT verify_function ('roles_private.register_role', current_user);

ROLLBACK;
