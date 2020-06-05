-- Revert schemas/roles_public/tables/membership_invites/indexes/uniq_role_id_invites from pg

BEGIN;

DROP INDEX roles_private.uniq_role_id_invites;

COMMIT;
