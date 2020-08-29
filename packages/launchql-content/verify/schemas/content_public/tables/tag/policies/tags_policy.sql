-- Verify schemas/content_public/tables/tag/policies/tags_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_tags', 'content_public.tag');
SELECT verify_policy ('can_insert_tags', 'content_public.tag');
SELECT verify_policy ('can_update_tags', 'content_public.tag');
SELECT verify_policy ('can_delete_tags', 'content_public.tag');

SELECT verify_function ('content_private.tags_policy_fn');


SELECT has_table_privilege('authenticated', 'content_public.tag', 'INSERT');
SELECT has_table_privilege('authenticated', 'content_public.tag', 'SELECT');
SELECT has_table_privilege('authenticated', 'content_public.tag', 'UPDATE');
SELECT has_table_privilege('authenticated', 'content_public.tag', 'DELETE');
SELECT has_table_privilege('anonymous', 'content_public.tag', 'INSERT');
SELECT has_table_privilege('anonymous', 'content_public.tag', 'SELECT');
SELECT has_table_privilege('anonymous', 'content_public.tag', 'UPDATE');
SELECT has_table_privilege('anonymous', 'content_public.tag', 'DELETE');

ROLLBACK;
