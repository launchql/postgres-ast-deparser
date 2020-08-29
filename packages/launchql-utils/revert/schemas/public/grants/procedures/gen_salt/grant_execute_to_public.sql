-- Revert schemas/public/grants/procedures/gen_salt/grant_execute_to_public from pg

BEGIN;

REVOKE EXECUTE ON public.gen_salt FROM PUBLIC;

COMMIT;
