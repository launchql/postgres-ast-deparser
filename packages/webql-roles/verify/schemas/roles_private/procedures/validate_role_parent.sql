-- Verify schemas/roles_private/procedures/validate_role_parent  on pg

BEGIN;

SELECT verify_function ('roles_private.validate_role_parent', current_user);

ROLLBACK;
