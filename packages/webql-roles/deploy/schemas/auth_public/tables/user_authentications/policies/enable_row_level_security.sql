-- Deploy schemas/auth_public/tables/user_authentications/policies/enable_row_level_security to pg

-- requires: schemas/auth_public/schema
-- requires: schemas/auth_public/tables/user_authentications/table

BEGIN;

ALTER TABLE auth_public.user_authentications
    ENABLE ROW LEVEL SECURITY;

COMMIT;
