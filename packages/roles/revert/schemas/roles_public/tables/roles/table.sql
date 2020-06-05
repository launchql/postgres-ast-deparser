-- Revert schemas/roles_public/tables/roles/table from pg

BEGIN;

DROP TABLE roles_public.roles;

COMMIT;
