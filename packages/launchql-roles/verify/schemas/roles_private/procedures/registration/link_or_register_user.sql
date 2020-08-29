-- Verify schemas/roles_private/procedures/registration/link_or_register_user  on pg

BEGIN;

SELECT verify_function ('roles_private.link_or_register_user', current_user);

ROLLBACK;
