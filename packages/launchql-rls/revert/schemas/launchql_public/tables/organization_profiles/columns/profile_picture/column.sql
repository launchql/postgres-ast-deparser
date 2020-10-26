-- Revert: schemas/launchql_public/tables/organization_profiles/columns/profile_picture/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".organization_profiles DROP COLUMN profile_picture;
COMMIT;  

