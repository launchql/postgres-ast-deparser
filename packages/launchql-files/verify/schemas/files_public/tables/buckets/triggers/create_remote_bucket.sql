-- Verify schemas/files_public/tables/buckets/triggers/create_remote_bucket  on pg

BEGIN;

SELECT verify_function ('files_private.tg_create_remote_bucket'); 
SELECT verify_trigger ('files_public.create_remote_bucket');

ROLLBACK;
