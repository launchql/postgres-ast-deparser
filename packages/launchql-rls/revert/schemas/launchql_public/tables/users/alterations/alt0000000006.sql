-- Revert: schemas/launchql_public/tables/users/alterations/alt0000000006 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".users
    ENABLE ROW LEVEL SECURITY;

COMMIT;  

