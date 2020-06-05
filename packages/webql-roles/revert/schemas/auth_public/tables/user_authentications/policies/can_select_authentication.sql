-- Revert schemas/auth_public/tables/user_authentications/policies/can_select_authentication from pg

BEGIN;


REVOKE SELECT ON TABLE auth_public.user_authentications FROM authenticated;


DROP POLICY select_own ON auth_public.user_authentications;

COMMIT;
