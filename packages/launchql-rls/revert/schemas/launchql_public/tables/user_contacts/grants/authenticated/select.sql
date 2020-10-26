-- Revert: schemas/launchql_public/tables/user_contacts/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE "launchql_rls_public".user_contacts FROM authenticated;
COMMIT;  

