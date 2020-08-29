-- Revert schemas/projects_public/tables/project_transfer/alterations/uniq_transfer_using_expires from pg

BEGIN;

ALTER TABLE projects_public.project_transfers
    DROP CONSTRAINT uniq_transfer_using_expires;

COMMIT;
