-- Revert schemas/auth_private/tables/token/indexes/token_role_id_idx from pg

BEGIN;

DROP INDEX auth_private.token_role_id_idx;

COMMIT;
