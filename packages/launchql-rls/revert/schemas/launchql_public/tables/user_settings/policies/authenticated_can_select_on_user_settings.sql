-- Revert: schemas/launchql_public/tables/user_settings/policies/authenticated_can_select_on_user_settings from pg

BEGIN;
DROP POLICY authenticated_can_select_on_user_settings ON "launchql_rls_public".user_settings;
COMMIT;  

