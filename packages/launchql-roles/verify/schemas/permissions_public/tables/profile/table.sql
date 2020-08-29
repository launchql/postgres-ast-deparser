-- Verify schemas/permissions_public/tables/profile/table on pg

BEGIN;

SELECT verify_table ('permissions_public.profile');

ROLLBACK;
