-- Revert: schemas/launchql_public/tables/user_settings/constraints/user_settings_user_id_key from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_settings 
    DROP CONSTRAINT user_settings_user_id_key;

COMMIT;  

