-- Revert schemas/auth_private/tables/client/indexes/client_role_id_idx from pg

BEGIN;

DROP INDEX auth_private.client_role_id_idx;

COMMIT;
