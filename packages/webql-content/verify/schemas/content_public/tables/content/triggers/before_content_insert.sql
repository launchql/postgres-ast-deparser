-- Verify schemas/content_public/tables/content/triggers/before_content_insert  on pg

BEGIN;

SELECT verify_function ('content_private.tg_before_content_insert'); 
SELECT verify_trigger ('content_public.before_content_insert');

ROLLBACK;
