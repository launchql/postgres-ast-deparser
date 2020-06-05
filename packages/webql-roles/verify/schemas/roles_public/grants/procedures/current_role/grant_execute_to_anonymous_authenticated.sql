-- Verify schemas/roles_public/grants/procedures/current_role/grant_execute_to_anonymous_authenticated  on pg

BEGIN;

  SELECT
      verify_function ('roles_public.current_role',
          'anonymous');
  SELECT
      verify_function ('roles_public.current_role',
          'authenticated');

ROLLBACK;
