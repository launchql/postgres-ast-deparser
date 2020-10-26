-- Deploy: schemas/launchql_private/tables/user_encrypted_secrets/columns/id/alterations/alt0000000028 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/table
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/columns/id/column
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/columns/id/alterations/alt0000000027

BEGIN;

ALTER TABLE "launchql_private".user_encrypted_secrets 
    ALTER COLUMN id SET DEFAULT "launchql_private".uuid_generate_v4();
COMMIT;
