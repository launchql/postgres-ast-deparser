-- Verify schemas/permissions_public/tables/permission/table on pg

BEGIN;

SELECT verify_table ('permissions_public.permission');

ROLLBACK;
