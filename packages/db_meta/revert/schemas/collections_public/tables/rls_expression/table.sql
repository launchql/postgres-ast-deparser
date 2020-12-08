-- Revert schemas/collections_public/tables/rls_expression/table from pg

BEGIN;

DROP TABLE collections_public.rls_expression;

COMMIT;
