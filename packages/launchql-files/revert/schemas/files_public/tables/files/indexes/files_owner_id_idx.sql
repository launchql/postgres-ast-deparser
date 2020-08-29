-- Revert schemas/files_public/tables/files/indexes/files_owner_id_idx from pg

BEGIN;

DROP INDEX files_public.files_owner_id_idx;

COMMIT;
