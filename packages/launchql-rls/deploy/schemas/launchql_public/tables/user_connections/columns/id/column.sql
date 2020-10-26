-- Deploy: schemas/launchql_public/tables/user_connections/columns/id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/alterations/alt0000000062

BEGIN;

ALTER TABLE "launchql_public".user_connections ADD COLUMN id uuid;
COMMIT;
