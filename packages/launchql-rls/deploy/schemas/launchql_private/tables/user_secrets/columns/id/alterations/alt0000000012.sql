-- Deploy: schemas/launchql_private/tables/user_secrets/columns/id/alterations/alt0000000012 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_secrets/table
-- requires: schemas/launchql_private/tables/user_secrets/columns/id/column

BEGIN;

ALTER TABLE "launchql_private".user_secrets 
    ALTER COLUMN id SET NOT NULL;
COMMIT;
