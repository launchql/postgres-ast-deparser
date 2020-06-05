-- Revert schemas/roles_public/tables/memberships/indexes/memberships_organization_idx from pg

BEGIN;

DROP INDEX roles_public.memberships_organization_idx;

COMMIT;
