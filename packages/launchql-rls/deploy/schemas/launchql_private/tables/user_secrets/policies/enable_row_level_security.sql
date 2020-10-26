-- Deploy: schemas/launchql_private/tables/user_secrets/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_secrets/table
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/grants/authenticated/delete
-- requires: schemas/launchql_public/procedures/get_current_user_id/procedure 

BEGIN;

ALTER TABLE "launchql_private".user_secrets
    ENABLE ROW LEVEL SECURITY;
COMMIT;
