-- Verify procedures/tg_update_peoplestamps  on pg

BEGIN;

SELECT verify_function ('public.tg_update_peoplestamps', current_user);

ROLLBACK;
