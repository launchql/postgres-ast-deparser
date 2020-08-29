-- Deploy schemas/roles_public/tables/roles/policies/enable_row_level_security to pg
-- requires: schemas/roles_public/tables/roles/table


BEGIN;

ALTER TABLE roles_public.roles
  ENABLE ROW LEVEL SECURITY;

COMMIT;
