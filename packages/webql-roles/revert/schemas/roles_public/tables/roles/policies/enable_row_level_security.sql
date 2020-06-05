-- Revert schemas/roles_public/tables/roles/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE roles_public.roles
  DISABLE ROW LEVEL SECURITY;

COMMIT;
