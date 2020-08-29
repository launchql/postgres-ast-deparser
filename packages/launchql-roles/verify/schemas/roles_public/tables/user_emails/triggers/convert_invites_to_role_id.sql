-- Verify schemas/roles_public/tables/user_emails/triggers/convert_invites_to_role_id  on pg

BEGIN;

SELECT verify_function ('roles_public.tg_convert_invites_to_role_id', current_user); 
SELECT verify_trigger ('roles_public.convert_invites_to_role_id');

ROLLBACK;
