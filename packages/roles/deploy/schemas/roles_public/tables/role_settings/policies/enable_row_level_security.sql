-- Deploy schemas/roles_public/tables/role_settings/policies/enable_row_level_security to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/role_settings/table

BEGIN;

ALTER TABLE roles_public.role_settings
    ENABLE ROW LEVEL SECURITY;

COMMIT;
