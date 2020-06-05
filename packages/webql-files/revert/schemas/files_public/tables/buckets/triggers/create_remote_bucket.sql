-- Revert schemas/files_public/tables/buckets/triggers/create_remote_bucket from pg

BEGIN;

DROP TRIGGER create_remote_bucket ON files_public.buckets;
DROP FUNCTION files_private.tg_create_remote_bucket; 

COMMIT;
