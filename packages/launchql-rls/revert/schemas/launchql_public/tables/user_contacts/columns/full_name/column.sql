-- Revert: schemas/launchql_public/tables/user_contacts/columns/full_name/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_contacts DROP COLUMN full_name;
COMMIT;  

