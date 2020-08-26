-- Verify schemas/services_public/tables/config/triggers/only_one_record  on pg

BEGIN;

SELECT verify_function ('services_private.tg_only_one_record'); 
SELECT verify_trigger ('services_public.only_one_record');

ROLLBACK;
