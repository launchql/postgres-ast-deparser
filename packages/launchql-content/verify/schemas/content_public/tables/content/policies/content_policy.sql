-- Verify schemas/content_public/tables/content/policies/content_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_contents', 'content_public.content');
SELECT verify_policy ('can_insert_contents', 'content_public.content');
SELECT verify_policy ('can_update_contents', 'content_public.content');
SELECT verify_policy ('can_delete_contents', 'content_public.content');

SELECT verify_function ('content_private.contents_policy_fn');


SELECT has_table_privilege('authenticated', 'content_public.content', 'INSERT');
SELECT has_table_privilege('authenticated', 'content_public.content', 'SELECT');
SELECT has_table_privilege('authenticated', 'content_public.content', 'UPDATE');
SELECT has_table_privilege('authenticated', 'content_public.content', 'DELETE');
SELECT has_table_privilege('anonymous', 'content_public.content', 'INSERT');
SELECT has_table_privilege('anonymous', 'content_public.content', 'SELECT');
SELECT has_table_privilege('anonymous', 'content_public.content', 'UPDATE');
SELECT has_table_privilege('anonymous', 'content_public.content', 'DELETE');

ROLLBACK;
