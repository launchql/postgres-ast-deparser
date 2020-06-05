-- Revert schemas/roles_public/views/team/view from pg

BEGIN;

DROP VIEW roles_public.team;

COMMIT;
