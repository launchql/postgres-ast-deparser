-- Verify schemas/collections_public/tables/rls_expression/table on pg

BEGIN;

SELECT verify_table ('collections_public.rls_expression');

ROLLBACK;
