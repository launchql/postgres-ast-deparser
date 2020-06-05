-- Deploy schemas/permissions_public/tables/permission/fixtures/1591327747203_fixture to pg

-- requires: schemas/permissions_public/schema
-- requires: schemas/permissions_public/tables/permission/table

BEGIN;

INSERT INTO permissions_public.permission (name, object_type, action_type) VALUES

-- project based permission

( 'Browse Databases', 'database', 'browse' ),
( 'Read Databases', 'database', 'read' ),
( 'Edit Databases', 'database', 'edit' ),
( 'Add Databases', 'database', 'add' ),
( 'Delete Databases', 'database', 'destroy' )

;


COMMIT;
