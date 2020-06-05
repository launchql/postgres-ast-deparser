-- Verify schemas/roles_public/views/user/view on pg

BEGIN;

SELECT verify_table ('roles_public.user');

ROLLBACK;
