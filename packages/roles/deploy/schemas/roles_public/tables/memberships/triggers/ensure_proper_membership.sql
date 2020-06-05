-- Deploy schemas/roles_public/tables/memberships/triggers/ensure_proper_membership to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/memberships/table
-- requires: schemas/roles_private/triggers/tg_ensure_proper_membership

BEGIN;

CREATE TRIGGER ensure_proper_membership
BEFORE INSERT ON roles_public.memberships
FOR EACH ROW
EXECUTE PROCEDURE roles_private.tg_ensure_proper_membership ();

COMMIT;
