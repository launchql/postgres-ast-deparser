-- Deploy schemas/roles_public/tables/user_emails/policies/enable_row_level_security to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/user_emails/table

BEGIN;

ALTER TABLE roles_public.user_emails
    ENABLE ROW LEVEL SECURITY;

COMMIT;
