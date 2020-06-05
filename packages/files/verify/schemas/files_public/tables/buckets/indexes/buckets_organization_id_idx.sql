-- Verify schemas/files_public/tables/buckets/indexes/buckets_organization_id_idx  on pg

BEGIN;

SELECT verify_index ('files_public.buckets', 'buckets_organization_id_idx');

ROLLBACK;
