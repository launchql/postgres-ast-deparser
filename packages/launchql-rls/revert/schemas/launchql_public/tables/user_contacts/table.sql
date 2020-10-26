-- Revert: schemas/launchql_public/tables/user_contacts/table from pg

BEGIN;
DROP TABLE "launchql_rls_public".user_contacts;
COMMIT;  

