-- Revert schemas/roles_public/tables/membership_invites/indexes/membership_invites_requester_id_idx from pg

BEGIN;

DROP INDEX roles_public.membership_invites_requester_id_idx;

COMMIT;
