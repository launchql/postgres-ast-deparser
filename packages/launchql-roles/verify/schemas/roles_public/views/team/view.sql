-- Verify schemas/roles_public/views/team/view on pg

BEGIN;

SELECT verify_table ('roles_public.team');

ROLLBACK;
