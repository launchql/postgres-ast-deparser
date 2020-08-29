-- Deploy schemas/roles_public/tables/membership_invites/indexes/uniq_email_invites to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/membership_invites/table

BEGIN;

CREATE UNIQUE INDEX uniq_email_invites ON roles_public.membership_invites (
  group_id, email
) WHERE email IS NOT NULL;

COMMIT;
