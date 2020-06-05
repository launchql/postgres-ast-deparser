-- Deploy schemas/permissions_public/tables/profile/policies/enable_row_level_security to pg

-- requires: schemas/permissions_public/schema
-- requires: schemas/permissions_public/tables/profile/table

BEGIN;

ALTER TABLE permissions_public.profile
    ENABLE ROW LEVEL SECURITY;

COMMIT;
