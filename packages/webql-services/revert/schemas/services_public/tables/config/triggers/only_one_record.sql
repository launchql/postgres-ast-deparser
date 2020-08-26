-- Revert schemas/services_public/tables/config/triggers/only_one_record from pg

BEGIN;

DROP TRIGGER only_one_record ON services_public.config;
DROP FUNCTION services_private.tg_only_one_record; 

COMMIT;
