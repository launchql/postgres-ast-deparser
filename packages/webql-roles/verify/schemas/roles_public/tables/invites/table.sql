-- Verify schemas/roles_public/tables/invites/table on pg

BEGIN;

SELECT verify_table ('roles_public.invites');

ROLLBACK;
