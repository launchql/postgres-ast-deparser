-- Verify procedures/list_memberships on pg

BEGIN;

SELECT
    1/count(has_function_privilege(current_user, p.oid, 'execute'))
FROM
    pg_catalog.pg_proc p
    JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
WHERE
    n.nspname = 'public' AND p.proname = 'list_memberships';

ROLLBACK;
