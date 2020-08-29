-- Verify schemas/roles_private/triggers/tg_ensure_proper_role  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_ensure_proper_role', current_user);

ROLLBACK;
