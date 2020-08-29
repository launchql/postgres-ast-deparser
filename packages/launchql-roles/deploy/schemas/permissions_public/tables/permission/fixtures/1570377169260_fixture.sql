-- Deploy schemas/permissions_public/tables/permission/fixtures/1570377169260_fixture to pg

-- requires: schemas/permissions_public/schema
-- requires: schemas/permissions_public/tables/permission/table

BEGIN;

-- TODO check here for more:
-- https://www.drupal.org/node/132202
-- Blog module

-- create blog entries
-- Permission to create new blog entries.
-- delete any blog entry
-- Permission to delete any user's blog entry.
-- delete own blog entries
-- Permission to delete a user's own blog entry.
-- edit any blog entry
-- Permission to edit any user's blog entry.
-- edit own blog entries
-- Permission to edit a user's own blog entry.

INSERT INTO permissions_public.permission (name, object_type, action_type) VALUES
-- organization based permission

( 'Browse Projects', 'project', 'browse' ),
( 'Read Projects', 'project', 'read' ),
( 'Edit Projects', 'project', 'edit' ),
( 'Add Projects', 'project', 'add' ),
( 'Transfer Projects', 'project', 'transfer' ),
( 'Delete Projects', 'project', 'destroy' ),

-- project based permission
( 'Browse Secrets', 'secret', 'browse' ),
( 'Read Secrets', 'secret', 'read' ),
( 'Edit Secrets', 'secret', 'edit' ),
( 'Add Secrets', 'secret', 'add' ),
( 'Delete Secrets', 'secret', 'destroy' ),

( 'Browse Content', 'content', 'browse' ),
( 'Read Content', 'content', 'read' ),
( 'Edit Content', 'content', 'edit' ),
( 'Upload Content', 'content', 'upload' ),
( 'Add Content', 'content', 'add' ),
( 'Delete Content', 'content', 'destroy' ),

( 'Browse Posts', 'post', 'browse' ),
( 'Read Posts', 'post', 'read' ),
( 'Edit Posts', 'post', 'edit' ),
( 'Add Posts', 'post', 'add' ),
( 'Delete Posts', 'post', 'destroy' ),

-- role based permission
( 'Browse Users', 'user', 'browse' ),
( 'Read Users', 'user', 'read' ),
( 'Edit Users', 'user', 'edit' ),
( 'Add Users', 'user', 'add' ),
( 'Delete Users', 'user', 'destroy' ),

( 'Browse Teams', 'team', 'browse' ),
( 'Read Teams', 'team', 'read' ),
( 'Edit Teams', 'team', 'edit' ),
( 'Add Teams', 'team', 'add' ),
( 'Delete Teams', 'team', 'destroy' ),

( 'Browse Roles', 'role', 'browse' ),
( 'Read Roles', 'role', 'read' ),
( 'Edit Roles', 'role', 'edit' ),
( 'Add Roles', 'role', 'add' ),
( 'Delete Roles', 'role', 'destroy' ),

-- TODO replace profiles anad settings w 'role'
( 'Browse Role Profiles', 'role_profile', 'browse' ),
( 'Read Role Profiles', 'role_profile', 'read' ),
( 'Edit Role Profiles', 'role_profile', 'edit' ),
( 'Add Role Profiles', 'role_profile', 'add' ),
( 'Delete Role Profiles', 'role_profile', 'destroy' ),

( 'Browse Role Settings', 'role_setting', 'browse' ),
( 'Read Role Settings', 'role_setting', 'read' ),
( 'Edit Role Settings', 'role_setting', 'edit' ),
( 'Add Role Settings', 'role_setting', 'add' ),
( 'Delete Role Settings', 'role_setting', 'destroy' ),

( 'Browse Invites', 'invite', 'browse' ),
( 'Read Invites', 'invite', 'read' ),
( 'Approve Invites', 'invite', 'approve' ),
( 'Edit Invites', 'invite', 'edit' ),
( 'Add Invites', 'invite', 'add' ),
( 'Delete Invites', 'invite', 'destroy' )


;

COMMIT;
