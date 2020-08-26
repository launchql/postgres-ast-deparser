-- Verify schemas/roles_public/grants/procedures/sign_in/grant_execute_to_anonymous on pg

BEGIN;

SELECT
    verify_function ('roles_public.sign_in',
        'anonymous');

ROLLBACK;
