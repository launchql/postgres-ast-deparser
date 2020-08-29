-- Revert procedures/tg_update_peoplestamps from pg

BEGIN;

DROP FUNCTION public.tg_update_peoplestamps;

COMMIT;
