-- Deploy: schemas/launchql_private/tables/user_encrypted_secrets/columns/user_id/alterations/alt0000000029 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/table
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/columns/user_id/column

BEGIN;

ALTER TABLE "launchql_private".user_encrypted_secrets 
    ALTER COLUMN user_id SET NOT NULL;
COMMIT;