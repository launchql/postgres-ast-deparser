-- Revert: schemas/launchql_public/tables/user_settings/columns/search_radius/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_settings DROP COLUMN search_radius;
COMMIT;  

