-- Verify schemas/services_public/tables/services/triggers/ensure_domain  on pg

BEGIN;

SELECT verify_function ('services_private.tg_ensure_domain'); 
SELECT verify_trigger ('services_public.ensure_domain');

ROLLBACK;
