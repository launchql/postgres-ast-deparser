-- Verify procedures/make_tsrange  on pg

BEGIN;

SELECT verify_function ('public.make_tsrange', current_user);

ROLLBACK;
