-- Revert schemas/files_public/tables/files/indexes/files_organization_id_idx from pg

BEGIN;

DROP INDEX files_public.files_organization_id_idx;

COMMIT;
