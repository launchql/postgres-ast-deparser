-- Verify schemas/roles_private/triggers/tg_ensure_proper_role_parents  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_ensure_proper_role_parents', current_user);

ROLLBACK;
