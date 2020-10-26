-- Revert: schemas/launchql_public/tables/user_contacts/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE "launchql_rls_public".user_contacts FROM authenticated;
COMMIT;  

