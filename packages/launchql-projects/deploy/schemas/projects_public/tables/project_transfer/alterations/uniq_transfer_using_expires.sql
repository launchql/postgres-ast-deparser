-- Deploy schemas/projects_public/tables/project_transfer/alterations/uniq_transfer_using_expires to pg

-- requires: schemas/projects_public/tables/project_transfer/table

BEGIN;

ALTER TABLE projects_public.project_transfer
  ADD CONSTRAINT uniq_transfer_using_expires
    EXCLUDE USING gist
    ( project_id WITH =,
      make_tsrange(created_at, expires_at) WITH &&
    );

COMMIT;
