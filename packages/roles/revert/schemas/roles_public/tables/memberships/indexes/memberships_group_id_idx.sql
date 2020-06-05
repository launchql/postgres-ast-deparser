-- Revert schemas/roles_public/tables/memberships/indexes/memberships_group_id_idx from pg

BEGIN;

DROP INDEX roles_public.memberships_group_id_idx;

COMMIT;
