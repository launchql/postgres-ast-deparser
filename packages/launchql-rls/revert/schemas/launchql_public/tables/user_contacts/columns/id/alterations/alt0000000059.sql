-- Revert: schemas/launchql_public/tables/user_contacts/columns/id/alterations/alt0000000059 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_contacts 
    ALTER COLUMN id DROP NOT NULL;


COMMIT;  

