-- Deploy: schemas/launchql_private/tables/user_secrets/constraints/user_secrets_pkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_secrets/table
-- requires: schemas/launchql_private/tables/user_secrets/columns/value/column

BEGIN;

ALTER TABLE "launchql_private".user_secrets
    ADD CONSTRAINT user_secrets_pkey PRIMARY KEY (id);
COMMIT;
