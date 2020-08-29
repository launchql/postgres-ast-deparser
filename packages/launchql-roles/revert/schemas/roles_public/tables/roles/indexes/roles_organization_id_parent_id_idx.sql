-- Revert schemas/roles_public/tables/roles/indexes/roles_organization_id_parent_id_idx from pg

BEGIN;

DROP INDEX roles_public.roles_organization_id_parent_id_idx;

COMMIT;
