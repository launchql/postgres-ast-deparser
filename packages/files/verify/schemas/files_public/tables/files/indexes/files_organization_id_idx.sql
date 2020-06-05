-- Verify schemas/files_public/tables/files/indexes/files_organization_id_idx  on pg

BEGIN;

SELECT verify_index ('files_public.files', 'files_organization_id_idx');

ROLLBACK;
