-- Revert schemas/public/grants/procedures/crypt/grant_execute_to_public from pg

BEGIN;

REVOKE EXECUTE ON public.crypt FROM PUBLIC;

COMMIT;
