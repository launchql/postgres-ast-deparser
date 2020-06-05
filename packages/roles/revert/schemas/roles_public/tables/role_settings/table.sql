-- Revert schemas/roles_public/tables/role_settings/table from pg

BEGIN;

DROP TABLE roles_public.role_settings;

COMMIT;
