-- Revert schemas/roles_public/types/role_type from pg

BEGIN;

DROP TYPE roles_public.role_type;

COMMIT;
