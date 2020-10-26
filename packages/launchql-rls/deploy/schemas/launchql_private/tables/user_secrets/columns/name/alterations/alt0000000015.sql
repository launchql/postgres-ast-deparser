-- Deploy: schemas/launchql_private/tables/user_secrets/columns/name/alterations/alt0000000015 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_secrets/table
-- requires: schemas/launchql_private/tables/user_secrets/columns/name/column

BEGIN;

ALTER TABLE "launchql_private".user_secrets 
    ALTER COLUMN name SET NOT NULL;
COMMIT;
