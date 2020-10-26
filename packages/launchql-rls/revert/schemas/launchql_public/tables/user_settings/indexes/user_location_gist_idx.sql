-- Revert: schemas/launchql_public/tables/user_settings/indexes/user_location_gist_idx from pg

BEGIN;
DROP INDEX "launchql_rls_public".user_location_gist_idx;
COMMIT;  

