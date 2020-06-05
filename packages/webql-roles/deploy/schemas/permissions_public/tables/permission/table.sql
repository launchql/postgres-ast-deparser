-- Deploy schemas/permissions_public/tables/permission/table to pg

-- requires: schemas/permissions_public/schema

BEGIN;

CREATE TABLE permissions_public.permission (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    name varchar(50) NOT NULL,
    object_type varchar(50) NOT NULL,
    action_type varchar(50) NOT NULL,
    -- object_id varchar(24) DEFAULT NULL,
    UNIQUE(name)
);

COMMIT;
