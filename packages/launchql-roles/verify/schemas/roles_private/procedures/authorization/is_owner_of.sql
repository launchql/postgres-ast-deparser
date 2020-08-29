-- Verify schemas/roles_private/procedures/authorization/is_owner_of  on pg

BEGIN;

SELECT verify_function ('roles_private.is_owner_of');

ROLLBACK;
