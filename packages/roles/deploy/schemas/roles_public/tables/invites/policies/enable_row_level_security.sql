-- Deploy schemas/roles_public/tables/invites/policies/enable_row_level_security to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/invites/table

BEGIN;

ALTER TABLE roles_public.invites
    ENABLE ROW LEVEL SECURITY;

COMMIT;
