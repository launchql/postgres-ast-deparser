-- Deploy schemas/roles_public/tables/role_profiles/policies/enable_row_level_security to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/role_profiles/table

BEGIN;

ALTER TABLE roles_public.role_profiles
    ENABLE ROW LEVEL SECURITY;

COMMIT;
