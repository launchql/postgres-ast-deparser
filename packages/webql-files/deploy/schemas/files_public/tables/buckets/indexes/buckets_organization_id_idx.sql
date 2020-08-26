-- Deploy schemas/files_public/tables/buckets/indexes/buckets_organization_id_idx to pg
-- requires: schemas/files_public/schema
-- requires: schemas/files_public/tables/buckets/table

BEGIN;
CREATE INDEX buckets_organization_id_idx ON files_public.buckets (organization_id);
COMMIT;

