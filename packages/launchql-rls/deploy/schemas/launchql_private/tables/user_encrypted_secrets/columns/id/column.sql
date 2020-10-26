-- Deploy: schemas/launchql_private/tables/user_encrypted_secrets/columns/id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/table
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/alterations/alt0000000026

BEGIN;

ALTER TABLE "launchql_private".user_encrypted_secrets ADD COLUMN id uuid;
COMMIT;
