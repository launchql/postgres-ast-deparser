-- Revert: schemas/launchql_public/tables/user_contacts/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE "launchql_rls_public".user_contacts FROM authenticated;
COMMIT;  

