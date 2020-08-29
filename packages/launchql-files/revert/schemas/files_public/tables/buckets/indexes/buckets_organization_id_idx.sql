-- Revert schemas/files_public/tables/buckets/indexes/buckets_organization_id_idx from pg

BEGIN;

DROP INDEX files_public.buckets_organization_id_idx;

COMMIT;
