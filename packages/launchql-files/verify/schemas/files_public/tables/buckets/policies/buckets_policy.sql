-- Verify schemas/files_public/tables/buckets/policies/buckets_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_buckets', 'files_public.buckets');
SELECT verify_policy ('can_insert_buckets', 'files_public.buckets');
SELECT verify_policy ('can_update_buckets', 'files_public.buckets');
SELECT verify_policy ('can_delete_buckets', 'files_public.buckets');

SELECT verify_function ('files_private.buckets_policy_fn');


SELECT has_table_privilege('authenticated', 'files_public.buckets', 'INSERT');
SELECT has_table_privilege('authenticated', 'files_public.buckets', 'SELECT');
SELECT has_table_privilege('authenticated', 'files_public.buckets', 'UPDATE');
SELECT has_table_privilege('authenticated', 'files_public.buckets', 'DELETE');

ROLLBACK;
