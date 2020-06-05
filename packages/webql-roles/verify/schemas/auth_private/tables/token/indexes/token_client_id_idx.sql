-- Verify schemas/auth_private/tables/token/indexes/token_client_id_idx  on pg

BEGIN;

SELECT verify_index ('auth_private.token', 'token_client_id_idx');

ROLLBACK;
