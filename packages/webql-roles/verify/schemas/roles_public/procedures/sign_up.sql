-- Verify schemas/roles_public/procedures/sign_up on pg

BEGIN;

SELECT
    verify_function ('roles_public.sign_up',
        current_user);

ROLLBACK;
