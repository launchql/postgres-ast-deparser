-- Verify schemas/roles_private/procedures/authorization/is_member_of  on pg

BEGIN;

SELECT verify_function ('roles_private.is_member_of', current_user);

ROLLBACK;
