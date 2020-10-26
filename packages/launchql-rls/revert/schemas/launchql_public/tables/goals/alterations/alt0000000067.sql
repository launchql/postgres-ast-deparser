-- Revert: schemas/launchql_public/tables/goals/alterations/alt0000000067 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals
    ENABLE ROW LEVEL SECURITY;

COMMIT;  

