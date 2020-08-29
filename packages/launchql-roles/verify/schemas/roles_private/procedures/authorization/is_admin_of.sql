-- Verify schemas/roles_private/procedures/authorization/is_admin_of  on pg

BEGIN;

SELECT verify_function ('roles_private.is_admin_of', current_user);

ROLLBACK;
