-- Deploy schemas/roles_public/tables/memberships/policies/enable_row_level_security to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/memberships/table

BEGIN;

ALTER TABLE roles_public.memberships
    ENABLE ROW LEVEL SECURITY;

COMMIT;
