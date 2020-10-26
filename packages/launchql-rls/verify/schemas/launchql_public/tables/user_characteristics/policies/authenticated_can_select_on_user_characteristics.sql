-- Verify: schemas/launchql_public/tables/user_characteristics/policies/authenticated_can_select_on_user_characteristics on pg

BEGIN;
SELECT verify_policy('authenticated_can_select_on_user_characteristics', 'launchql_rls_public.user_characteristics');
COMMIT;  

