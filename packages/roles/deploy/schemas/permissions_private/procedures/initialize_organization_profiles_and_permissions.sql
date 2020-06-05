-- Deploy schemas/permissions_private/procedures/initialize_organization_profiles_and_permissions to pg
-- requires: schemas/permissions_private/schema
-- requires: schemas/permissions_public/tables/profile/table
-- requires: schemas/permissions_public/tables/permission/table
-- requires: schemas/permissions_public/procedures/add_permissions_to_profile

BEGIN;
CREATE FUNCTION permissions_private.initialize_organization_profiles_and_permissions (
  organization_id uuid
)
  RETURNS void
  AS $$
DECLARE
  v_owner permissions_public.profile;
  v_administrator permissions_public.profile;
  v_editor permissions_public.profile;
  v_author permissions_public.profile;
  v_contributor permissions_public.profile;
  v_member permissions_public.profile;
  v_subscriber permissions_public.profile;
  perm_id uuid;
BEGIN
  --- Owner
  INSERT INTO permissions_public.profile (name, description, organization_id)
  VALUES ('Owner', 'Owners', organization_id)
RETURNING
  * INTO v_owner;

    PERFORM permissions_public.add_permissions_to_profile
      (v_owner.id, ARRAY[
        'project',
        'content',
        'secret',
        'post',
        'invite',
        'user',
        'team',
        'role',
        'role_profile',
        'role_setting'
      ], 'all');

  --- Administrator
  INSERT INTO permissions_public.profile (name, description, organization_id)
  VALUES ('Administrator', 'Administrators', organization_id)
RETURNING
  * INTO v_administrator;

    PERFORM permissions_public.add_permissions_to_profile
      (v_administrator.id, ARRAY[
        'project',
        'content',
        'secret',
        'post',
        'invite',
        'user',
        'team',
        'role',
        'role_profile',
        'role_setting'
      ], 'all');


  --- Editor
  INSERT INTO permissions_public.profile (name, description, organization_id)
  VALUES ('Editor', 'Editors', organization_id)
RETURNING
  * INTO v_editor;
 
    PERFORM permissions_public.add_permissions_to_profile
      (v_editor.id, ARRAY[
        'project',
        'content',
        'secret',
        'post',
        'invite'
      ], ARRAY[
        'read', 'browse', 'add', 'edit', 'destroy'
      ]);
  
    PERFORM permissions_public.add_permissions_to_profile
      (v_editor.id, ARRAY[
        'user',
        'team',
        'role',
        'role_profile',
        'role_setting'
      ], ARRAY[
        'read', 'browse'
      ]);

    PERFORM permissions_public.add_permissions_to_profile
      (v_editor.id, ARRAY[
        'content'
      ], ARRAY[
        'upload'
      ]);

  --- Author
  INSERT INTO permissions_public.profile (name, description, organization_id)
  VALUES ('Author', 'Authors', organization_id)
RETURNING
  * INTO v_author;
 
    PERFORM permissions_public.add_permissions_to_profile
      (v_author.id, ARRAY[
        'project',
        'content',
        'secret',
        'post',
        'invite'
      ], ARRAY[
        'read', 'browse', 'add', 'edit', 'destroy'
      ]);
  
    PERFORM permissions_public.add_permissions_to_profile
      (v_author.id, ARRAY[
        'user',
        'team',
        'role',
        'role_profile',
        'role_setting'
      ], ARRAY[
        'read', 'browse'
      ]);

    PERFORM permissions_public.add_permissions_to_profile
      (v_author.id, ARRAY[
        'content'
      ], ARRAY[
        'upload'
      ]);

  --- Contributor
  INSERT INTO permissions_public.profile (name, description, organization_id)
  VALUES ('Contributor', 'Contributors', organization_id)
RETURNING
  * INTO v_contributor;
  
    PERFORM permissions_public.add_permissions_to_profile
      (v_contributor.id, ARRAY[
        'project',
        'content',
        'secret',
        'post',
        'invite'
      ], ARRAY[
        'read', 'browse', 'add', 'edit', 'destroy'
      ]);
  
    PERFORM permissions_public.add_permissions_to_profile
      (v_contributor.id, ARRAY[
        'user',
        'team',
        'role',
        'role_profile',
        'role_setting'
      ], ARRAY[
        'read', 'browse'
      ]);

    PERFORM permissions_public.add_permissions_to_profile
      (v_contributor.id, ARRAY[
        'content'
      ], ARRAY[
        'upload'
      ]);
  

  --- Member
  INSERT INTO permissions_public.profile (name, description, organization_id)
  VALUES ('Member', 'Members', organization_id)
RETURNING
  * INTO v_member;

    PERFORM permissions_public.add_permissions_to_profile
      (v_member.id, ARRAY[
        'project',
        'content',
        'secret',
        'post',
        'user',
        'team',
        'role',
        'role_profile',
        'role_setting',
        'invite'
      ], ARRAY[
        'read', 'browse'
      ]);

END;
$$
LANGUAGE 'plpgsql'
VOLATILE;
COMMIT;
