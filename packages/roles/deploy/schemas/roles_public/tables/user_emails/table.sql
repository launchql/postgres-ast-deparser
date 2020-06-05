-- Deploy schemas/roles_public/tables/user_emails/table to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table

BEGIN;

CREATE TABLE roles_public.user_emails (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    role_id uuid NOT NULL DEFAULT roles_public.current_role_id() REFERENCES roles_public.roles (id) ON DELETE CASCADE,
    email email NOT NULL UNIQUE,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE
);

COMMIT;
