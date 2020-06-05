-- Deploy schemas/roles_public/tables/membership_invites/policies/enable_row_level_security to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/membership_invites/table

BEGIN;

ALTER TABLE roles_public.membership_invites
    ENABLE ROW LEVEL SECURITY;

COMMIT;
