-- Verify schemas/permissions_public/tables/profile/indexes/profile_organization_id_idx  on pg

BEGIN;

SELECT verify_index ('permissions_public.profile', 'profile_organization_id_idx');

ROLLBACK;
