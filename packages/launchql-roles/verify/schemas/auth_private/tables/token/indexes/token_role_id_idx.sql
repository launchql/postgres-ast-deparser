-- Verify schemas/auth_private/tables/token/indexes/token_role_id_idx  on pg

BEGIN;

SELECT verify_index ('auth_private.token', 'token_role_id_idx');

ROLLBACK;
