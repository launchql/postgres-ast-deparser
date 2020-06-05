-- Revert schemas/roles_public/tables/invites/table from pg

BEGIN;

DROP TABLE roles_public.invites;

COMMIT;
