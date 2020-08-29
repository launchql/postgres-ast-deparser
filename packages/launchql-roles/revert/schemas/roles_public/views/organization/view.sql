-- Revert schemas/roles_public/views/organization/view from pg

BEGIN;

DROP VIEW roles_public.organization;

COMMIT;
