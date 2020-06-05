-- Revert schemas/roles_public/tables/memberships/table from pg

BEGIN;

DROP TABLE roles_public.memberships;

COMMIT;
