-- Revert schemas/services_public/tables/services/triggers/ensure_domain from pg

BEGIN;

DROP TRIGGER ensure_domain ON services_public.services;
DROP FUNCTION services_private.tg_ensure_domain; 

COMMIT;
