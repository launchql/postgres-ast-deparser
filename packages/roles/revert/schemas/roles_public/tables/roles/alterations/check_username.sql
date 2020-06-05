-- Revert schemas/roles_public/tables/roles/alterations/check_username from pg

BEGIN;

ALTER TABLE roles_public.roles
    DROP CONSTRAINT fk_roles_public_roles_username;

COMMIT;
