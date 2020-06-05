-- Verify schemas/roles_public/tables/membership_invites/policies/membership_invite_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_membership_invite', 'roles_public.membership_invites');
SELECT verify_policy ('can_insert_membership_invite', 'roles_public.membership_invites');
SELECT verify_policy ('can_update_membership_invite', 'roles_public.membership_invites');
SELECT verify_policy ('can_delete_membership_invite', 'roles_public.membership_invites');

SELECT has_table_privilege('authenticated', 'roles_public.membership_invites', 'SELECT');
SELECT has_table_privilege('authenticated', 'roles_public.membership_invites', 'INSERT');
SELECT has_table_privilege('authenticated', 'roles_public.membership_invites', 'UPDATE');
SELECT has_table_privilege('authenticated', 'roles_public.membership_invites', 'DELETE');

ROLLBACK;
