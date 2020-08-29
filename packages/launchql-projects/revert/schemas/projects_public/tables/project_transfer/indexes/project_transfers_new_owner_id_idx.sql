-- Revert schemas/projects_public/tables/project_transfer/indexes/project_transfers_new_owner_id_idx from pg

BEGIN;

DROP INDEX projects_public.project_transfers_new_owner_id_idx;

COMMIT;
