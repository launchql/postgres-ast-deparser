-- Deploy: schemas/launchql_private/tables/user_encrypted_secrets/columns/user_id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/table
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/columns/id/alterations/alt0000000028

BEGIN;

ALTER TABLE "launchql_private".user_encrypted_secrets ADD COLUMN user_id uuid;
COMMIT;
