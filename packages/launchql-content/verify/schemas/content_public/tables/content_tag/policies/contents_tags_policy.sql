-- Verify schemas/content_public/tables/content_tag/policies/contents_tags_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_contents_tags', 'content_public.content_tag');
SELECT verify_policy ('can_insert_contents_tags', 'content_public.content_tag');
SELECT verify_policy ('can_update_contents_tags', 'content_public.content_tag');
SELECT verify_policy ('can_delete_contents_tags', 'content_public.content_tag');

SELECT verify_function ('content_private.contents_tags_policy_fn');


SELECT has_table_privilege('authenticated', 'content_public.content_tag', 'INSERT');
SELECT has_table_privilege('authenticated', 'content_public.content_tag', 'SELECT');
SELECT has_table_privilege('authenticated', 'content_public.content_tag', 'UPDATE');
SELECT has_table_privilege('authenticated', 'content_public.content_tag', 'DELETE');
SELECT has_table_privilege('anonymous', 'content_public.content_tag', 'INSERT');
SELECT has_table_privilege('anonymous', 'content_public.content_tag', 'SELECT');
SELECT has_table_privilege('anonymous', 'content_public.content_tag', 'UPDATE');
SELECT has_table_privilege('anonymous', 'content_public.content_tag', 'DELETE');

ROLLBACK;
