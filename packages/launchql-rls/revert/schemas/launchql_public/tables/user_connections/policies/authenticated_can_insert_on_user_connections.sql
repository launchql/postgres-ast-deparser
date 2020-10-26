-- Revert: schemas/launchql_public/tables/user_connections/policies/authenticated_can_insert_on_user_connections from pg

BEGIN;
DROP POLICY authenticated_can_insert_on_user_connections ON "launchql_rls_public".user_connections;
COMMIT;  

