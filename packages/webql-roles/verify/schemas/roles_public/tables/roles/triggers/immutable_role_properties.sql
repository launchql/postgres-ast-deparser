-- Verify schemas/roles_public/tables/roles/triggers/immutable_role_properties  on pg

BEGIN;

SELECT verify_trigger ('roles_public.immutable_role_properties');

ROLLBACK;
