-- Revert schemas/roles_public/tables/membership_invites/indexes/membership_invites_organization_id_idx from pg

BEGIN;

DROP INDEX roles_public.membership_invites_organization_id_idx;

COMMIT;
