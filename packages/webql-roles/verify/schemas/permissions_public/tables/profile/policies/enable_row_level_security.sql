-- Verify schemas/permissions_public/tables/profile/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('permissions_public.profile');

ROLLBACK;
