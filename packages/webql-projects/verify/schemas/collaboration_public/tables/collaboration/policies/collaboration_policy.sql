-- Verify schemas/collaboration_public/tables/collaboration/policies/collaboration_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_collaboration', 'collaboration_public.collaboration');
SELECT verify_policy ('can_insert_collaboration', 'collaboration_public.collaboration');
SELECT verify_policy ('can_update_collaboration', 'collaboration_public.collaboration');
SELECT verify_policy ('can_delete_collaboration', 'collaboration_public.collaboration');

SELECT has_table_privilege('authenticated', 'collaboration_public.collaboration', 'INSERT');
SELECT has_table_privilege('authenticated', 'collaboration_public.collaboration', 'SELECT');
SELECT has_table_privilege('authenticated', 'collaboration_public.collaboration', 'UPDATE');
SELECT has_table_privilege('authenticated', 'collaboration_public.collaboration', 'DELETE');

ROLLBACK;
