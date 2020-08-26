-- Verify schemas/roles_public/tables/memberships/triggers/ensure_proper_membership  on pg

BEGIN;

SELECT verify_trigger ('roles_private.ensure_proper_membership');

ROLLBACK;
