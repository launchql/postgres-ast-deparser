-- Revert: schemas/launchql_public/tables/user_contacts/columns/vcf/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_contacts DROP COLUMN vcf;
COMMIT;  

