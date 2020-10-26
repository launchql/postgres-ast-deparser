-- Deploy: schemas/launchql_private/tables/api_tokens/columns/access_token/alterations/alt0000000022 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/api_tokens/columns/access_token/column
-- requires: schemas/launchql_private/tables/api_tokens/columns/access_token/alterations/alt0000000021

BEGIN;

ALTER TABLE "launchql_private".api_tokens 
    ALTER COLUMN access_token SET DEFAULT encode( gen_random_bytes( 48 ), 'hex' );
COMMIT;
