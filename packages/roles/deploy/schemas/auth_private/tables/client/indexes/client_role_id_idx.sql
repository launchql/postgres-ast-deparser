-- Deploy schemas/auth_private/tables/client/indexes/client_role_id_idx to pg

-- requires: schemas/auth_private/schema
-- requires: schemas/auth_private/tables/client/table

BEGIN;

CREATE INDEX client_role_id_idx ON auth_private.client (
 role_id
);

COMMIT;
