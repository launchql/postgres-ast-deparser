-- Deploy: schemas/launchql_private/tables/user_encrypted_secrets/constraints/user_encrypted_secrets_pkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/table
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/columns/enc/column

BEGIN;

ALTER TABLE "launchql_private".user_encrypted_secrets
    ADD CONSTRAINT user_encrypted_secrets_pkey PRIMARY KEY (id);
COMMIT;
