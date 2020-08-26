-- Revert schemas/roles_public/tables/membership_invites/indexes/uniq_email_invites from pg

BEGIN;

DROP INDEX roles_private.uniq_email_invites;

COMMIT;
