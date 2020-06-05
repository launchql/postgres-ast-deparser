-- Verify schemas/roles_public/tables/memberships/table on pg

BEGIN;

SELECT verify_table ('roles_public.memberships');

ROLLBACK;
