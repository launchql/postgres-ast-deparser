-- Deploy schemas/roles_public/tables/membership_invites/indexes/uniq_role_id_invites to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/membership_invites/table

BEGIN;

CREATE UNIQUE INDEX uniq_role_id_invites ON roles_public.membership_invites (
  group_id, role_id
) WHERE role_id IS NOT NULL;

COMMIT;
