-- Revert schemas/roles_public/views/user/view from pg

BEGIN;

DROP VIEW roles_public.user;

COMMIT;
