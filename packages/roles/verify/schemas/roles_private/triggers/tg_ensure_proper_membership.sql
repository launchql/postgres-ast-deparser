-- Verify schemas/roles_private/triggers/tg_ensure_proper_membership  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_ensure_proper_membership', current_user);

ROLLBACK;
