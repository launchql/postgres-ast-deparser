-- Verify schemas/roles_private/procedures/membership_cascade_hierarchy  on pg

BEGIN;

SELECT verify_function ('roles_private.membership_cascade_hierarchy');

ROLLBACK;
