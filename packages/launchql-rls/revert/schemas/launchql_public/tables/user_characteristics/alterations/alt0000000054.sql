-- Revert: schemas/launchql_public/tables/user_characteristics/alterations/alt0000000054 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_characteristics
    ENABLE ROW LEVEL SECURITY;

COMMIT;  

