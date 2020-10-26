-- Revert: schemas/launchql_public/tables/user_characteristics/columns/id/alterations/alt0000000055 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_characteristics 
    ALTER COLUMN id DROP NOT NULL;


COMMIT;  

