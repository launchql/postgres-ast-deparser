-- Revert schemas/content_public/tables/content/triggers/status_changed from pg

BEGIN;

DROP TRIGGER status_changed ON content_public.content;
DROP FUNCTION content_private.tg_status_changed; 

COMMIT;
