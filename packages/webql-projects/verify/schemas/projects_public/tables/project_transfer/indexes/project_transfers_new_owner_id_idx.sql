-- Verify schemas/projects_public/tables/project_transfer/indexes/project_transfers_new_owner_id_idx  on pg

BEGIN;

SELECT verify_index ('projects_public.project_transfers', 'project_transfers_new_owner_id_idx');

ROLLBACK;
