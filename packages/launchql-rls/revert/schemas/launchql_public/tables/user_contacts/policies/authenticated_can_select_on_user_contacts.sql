-- Revert: schemas/launchql_public/tables/user_contacts/policies/authenticated_can_select_on_user_contacts from pg

BEGIN;
DROP POLICY authenticated_can_select_on_user_contacts ON "launchql_rls_public".user_contacts;
COMMIT;  

