-- Revert schemas/roles_public/tables/roles/triggers/immutable_role_properties from pg

BEGIN;

DROP TRIGGER immutable_role_properties ON roles_public.roles;

COMMIT;
