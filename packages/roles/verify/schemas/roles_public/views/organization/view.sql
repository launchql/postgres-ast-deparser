-- Verify schemas/roles_public/views/organization/view on pg

BEGIN;

SELECT verify_table ('roles_public.organization');

ROLLBACK;
