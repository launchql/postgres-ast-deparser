-- Revert: schemas/launchql_public/tables/user_contacts/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE "launchql_rls_public".user_contacts FROM authenticated;
COMMIT;  

