-- Revert: schemas/launchql_public/tables/user_settings/indexes/user_settings_user_id_idx from pg

BEGIN;


DROP INDEX "launchql_rls_public".user_settings_user_id_idx;

COMMIT;  

