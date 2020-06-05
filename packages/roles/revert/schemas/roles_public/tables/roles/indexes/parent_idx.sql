-- Revert schemas/roles_public/tables/roles/indexes/parent_idx from pg

BEGIN;

DROP INDEX roles_public.parent_idx;

COMMIT;
