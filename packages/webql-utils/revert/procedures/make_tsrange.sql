-- Revert procedures/make_tsrange from pg

BEGIN;

DROP FUNCTION public.make_tsrange;

COMMIT;
