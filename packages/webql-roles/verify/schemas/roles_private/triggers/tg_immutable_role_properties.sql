-- Verify schemas/roles_private/triggers/tg_immutable_role_properties  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_immutable_role_properties', current_user);

ROLLBACK;
