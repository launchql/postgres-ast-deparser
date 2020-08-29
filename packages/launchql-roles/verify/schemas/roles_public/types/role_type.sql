-- Verify schemas/roles_public/types/role_type on pg

BEGIN;

SELECT verify_type ('roles_public.role_type');

ROLLBACK;
