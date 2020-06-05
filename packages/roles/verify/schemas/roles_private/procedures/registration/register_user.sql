-- Verify schemas/roles_private/procedures/registration/register_user  on pg

BEGIN;

SELECT verify_function ('roles_private.register_user', current_user);

ROLLBACK;
