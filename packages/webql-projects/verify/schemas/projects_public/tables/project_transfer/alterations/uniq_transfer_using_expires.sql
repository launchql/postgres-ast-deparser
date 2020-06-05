-- Verify schemas/projects_public/tables/project_transfer/alterations/uniq_transfer_using_expires  on pg

BEGIN;

SELECT verify_constraint('projects_public.project_transfers', 'uniq_transfer_using_expires');

ROLLBACK;
