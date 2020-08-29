-- Verify schemas/roles_private/procedures/get_all_parent_roles  on pg

BEGIN;

SELECT verify_function ('roles_private.get_all_parent_roles', current_user);

ROLLBACK;
