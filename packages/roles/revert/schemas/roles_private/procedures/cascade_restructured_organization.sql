-- Revert schemas/roles_private/procedures/cascade_restructured_organization from pg

BEGIN;

DROP FUNCTION roles_private.cascade_restructured_organization;

COMMIT;
