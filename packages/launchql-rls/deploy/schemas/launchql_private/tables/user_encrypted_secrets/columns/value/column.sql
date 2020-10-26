-- Deploy: schemas/launchql_private/tables/user_encrypted_secrets/columns/value/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/table
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/columns/name/alterations/alt0000000030

BEGIN;

ALTER TABLE "launchql_private".user_encrypted_secrets ADD COLUMN value bytea;
COMMIT;
