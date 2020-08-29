-- Verify schemas/auth_private/types/token_type on pg

BEGIN;

SELECT verify_type ('auth_private.token_type');

ROLLBACK;
