-- Verify schemas/roles_public/procedures/current_role on pg

BEGIN;

SELECT
    verify_function ('roles_public.current_role',
        current_user);

ROLLBACK;
