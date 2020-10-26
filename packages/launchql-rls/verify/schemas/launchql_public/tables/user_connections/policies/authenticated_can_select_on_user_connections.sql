-- Verify: schemas/launchql_public/tables/user_connections/policies/authenticated_can_select_on_user_connections on pg

BEGIN;
SELECT verify_policy('authenticated_can_select_on_user_connections', 'launchql_rls_public.user_connections');
COMMIT;  

