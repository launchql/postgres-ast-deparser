-- Revert schemas/permissions_public/tables/profile/indexes/profile_organization_id_idx from pg

BEGIN;

DROP INDEX permissions_public.profile_organization_id_idx;

COMMIT;
