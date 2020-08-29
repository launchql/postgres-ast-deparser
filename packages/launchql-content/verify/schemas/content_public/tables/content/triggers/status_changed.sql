-- Verify schemas/content_public/tables/content/triggers/status_changed  on pg

BEGIN;

SELECT verify_function ('content_private.tg_status_changed'); 
SELECT verify_trigger ('content_public.status_changed');

ROLLBACK;
