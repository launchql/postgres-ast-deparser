-- Deploy: schemas/launchql_public/tables/user_connections/columns/accepted/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/constraints/user_connections_pkey

BEGIN;

ALTER TABLE "launchql_public".user_connections ADD COLUMN accepted bool;
COMMIT;
