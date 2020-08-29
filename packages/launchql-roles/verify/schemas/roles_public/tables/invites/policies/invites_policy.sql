-- Verify schemas/roles_public/tables/invites/policies/invites_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_invites', 'roles_public.invites');
SELECT verify_policy ('can_insert_invites', 'roles_public.invites');
SELECT verify_policy ('can_delete_invites', 'roles_public.invites');
SELECT verify_policy ('can_update_invites', 'roles_public.invites');


SELECT has_table_privilege('authenticated', 'roles_public.invites', 'INSERT');
SELECT has_table_privilege('authenticated', 'roles_public.invites', 'SELECT');
SELECT has_table_privilege('authenticated', 'roles_public.invites', 'DELETE');
SELECT has_table_privilege('authenticated', 'roles_public.invites', 'UPDATE');

ROLLBACK;
