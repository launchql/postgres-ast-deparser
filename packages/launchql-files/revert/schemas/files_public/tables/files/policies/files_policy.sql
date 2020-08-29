-- Revert schemas/files_public/tables/files/policies/files_policy from pg

BEGIN;


REVOKE INSERT ON TABLE files_public.files FROM authenticated;
REVOKE SELECT ON TABLE files_public.files FROM authenticated;
REVOKE UPDATE ON TABLE files_public.files FROM authenticated;
REVOKE DELETE ON TABLE files_public.files FROM authenticated;


DROP POLICY can_select_files ON files_public.files;
DROP POLICY can_insert_files ON files_public.files;
DROP POLICY can_update_files ON files_public.files;
DROP POLICY can_delete_files ON files_public.files;

COMMIT;
