-- Revert: schemas/launchql_public/tables/user_profiles/policies/authenticated_can_delete_on_user_profiles from pg

BEGIN;
DROP POLICY authenticated_can_delete_on_user_profiles ON "launchql_rls_public".user_profiles;
COMMIT;  

