-- Revert schemas/roles_public/tables/roles/indexes/roles_organization_idx from pg

BEGIN;

DROP INDEX roles_public.roles_organization_idx;

COMMIT;
