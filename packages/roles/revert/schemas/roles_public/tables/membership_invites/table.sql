-- Revert schemas/roles_public/tables/membership_invites/table from pg

BEGIN;

DROP TABLE roles_public.membership_invites;

COMMIT;
