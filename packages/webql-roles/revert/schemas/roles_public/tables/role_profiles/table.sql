-- Revert schemas/roles_public/tables/role_profiles/table from pg

BEGIN;

DROP TABLE roles_public.role_profiles;

COMMIT;
