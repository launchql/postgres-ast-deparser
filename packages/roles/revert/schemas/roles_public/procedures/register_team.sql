-- Revert schemas/roles_public/procedures/register_team from pg

BEGIN;

DROP FUNCTION roles_public.create_team;

COMMIT;
