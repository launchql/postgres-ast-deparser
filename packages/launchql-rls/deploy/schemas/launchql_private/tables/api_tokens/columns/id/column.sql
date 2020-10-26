-- Deploy: schemas/launchql_private/tables/api_tokens/columns/id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/api_tokens/alterations/alt0000000017

BEGIN;

ALTER TABLE "launchql_private".api_tokens ADD COLUMN id uuid;
COMMIT;
