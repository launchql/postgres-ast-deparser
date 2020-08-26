-- Verify schemas/files_public/tables/buckets/triggers/peoplestamps  on pg

BEGIN;

SELECT created_by FROM files_public.buckets LIMIT 1;
SELECT updated_by FROM files_public.buckets LIMIT 1;
SELECT verify_trigger ('files_public.update_files_public_buckets_moduser');

ROLLBACK;
