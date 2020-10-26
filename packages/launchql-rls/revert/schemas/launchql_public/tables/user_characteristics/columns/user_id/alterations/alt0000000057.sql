-- Revert: schemas/launchql_public/tables/user_characteristics/columns/user_id/alterations/alt0000000057 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_characteristics 
    ALTER COLUMN user_id DROP NOT NULL;


COMMIT;  

