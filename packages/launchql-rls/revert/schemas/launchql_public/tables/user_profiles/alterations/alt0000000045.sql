-- Revert: schemas/launchql_public/tables/user_profiles/alterations/alt0000000045 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_profiles
    ENABLE ROW LEVEL SECURITY;

COMMIT;  

