-- Verify schemas/auth_private/tables/client/indexes/client_role_id_idx  on pg

BEGIN;

SELECT verify_index ('auth_private.client', 'client_role_id_idx');

ROLLBACK;
