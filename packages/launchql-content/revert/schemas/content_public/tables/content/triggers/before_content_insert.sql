-- Revert schemas/content_public/tables/content/triggers/before_content_insert from pg

BEGIN;

DROP TRIGGER before_content_insert ON content_public.content;
DROP FUNCTION content_private.tg_before_content_insert; 

COMMIT;
