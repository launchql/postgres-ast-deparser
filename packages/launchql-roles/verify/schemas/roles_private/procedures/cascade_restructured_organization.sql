-- Verify schemas/roles_private/procedures/cascade_restructured_organization  on pg

BEGIN;

SELECT verify_function ('roles_private.cascade_restructured_organization');

ROLLBACK;
