-- Revert: schemas/launchql_public/tables/user_settings/alterations/alt0000000050 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_settings
    ENABLE ROW LEVEL SECURITY;

COMMIT;  

