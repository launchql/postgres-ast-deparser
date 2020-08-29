-- Deploy schemas/auth_private/tables/token/indexes/token_client_id_idx to pg

-- requires: schemas/auth_private/schema
-- requires: schemas/auth_private/tables/token/table

BEGIN;

CREATE INDEX token_client_id_idx ON auth_private.token (
 client_id
);

COMMIT;
