-- Revert schemas/auth_public/tables/user_authentications/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE auth_public.user_authentications
    DISABLE ROW LEVEL SECURITY;

COMMIT;
