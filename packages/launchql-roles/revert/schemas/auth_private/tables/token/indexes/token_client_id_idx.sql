-- Revert schemas/auth_private/tables/token/indexes/token_client_id_idx from pg

BEGIN;

DROP INDEX auth_private.token_client_id_idx;

COMMIT;
