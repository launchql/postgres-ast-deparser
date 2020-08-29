-- Verify schemas/roles_public/procedures/sign_in  on pg

BEGIN;

SELECT
    verify_function ('roles_public.sign_in',
        current_user);

ROLLBACK;
