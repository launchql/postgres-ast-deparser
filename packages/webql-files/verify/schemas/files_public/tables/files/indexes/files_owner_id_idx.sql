-- Verify schemas/files_public/tables/files/indexes/files_owner_id_idx  on pg

BEGIN;

SELECT verify_index ('files_public.files', 'files_owner_id_idx');

ROLLBACK;
