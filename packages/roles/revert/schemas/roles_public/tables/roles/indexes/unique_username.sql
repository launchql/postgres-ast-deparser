-- Revert schemas/roles_public/tables/roles/indexes/unique_username from pg

BEGIN;

DROP INDEX roles_public.unique_username;

COMMIT;
