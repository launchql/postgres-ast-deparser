-- Revert: schemas/launchql_public/tables/user_emails/policies/authenticated_can_select_on_user_emails from pg

BEGIN;
DROP POLICY authenticated_can_select_on_user_emails ON "launchql_rls_public".user_emails;
COMMIT;  

