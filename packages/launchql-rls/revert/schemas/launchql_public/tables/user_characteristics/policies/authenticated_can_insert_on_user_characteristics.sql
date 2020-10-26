-- Revert: schemas/launchql_public/tables/user_characteristics/policies/authenticated_can_insert_on_user_characteristics from pg

BEGIN;
DROP POLICY authenticated_can_insert_on_user_characteristics ON "launchql_rls_public".user_characteristics;
COMMIT;  

