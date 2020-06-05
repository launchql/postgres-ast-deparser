-- Revert schemas/roles_public/tables/memberships/triggers/ensure_proper_membership from pg

BEGIN;

DROP TRIGGER ensure_proper_membership ON roles_public.memberships;

COMMIT;
