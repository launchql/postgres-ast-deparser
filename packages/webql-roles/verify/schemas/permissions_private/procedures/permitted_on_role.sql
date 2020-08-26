-- Verify schemas/permissions_private/procedures/permitted_on_role  on pg

BEGIN;

SELECT verify_function ('permissions_private.permitted_on_role');

ROLLBACK;
