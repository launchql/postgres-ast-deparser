-- Revert schemas/auth_public/tables/user_authentications/policies/can_delete_authentication from pg

BEGIN;


REVOKE DELETE ON TABLE auth_public.user_authentications FROM authenticated;


DROP POLICY delete_own ON auth_public.user_authentications;

COMMIT;
