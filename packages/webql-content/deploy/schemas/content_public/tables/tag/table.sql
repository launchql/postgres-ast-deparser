-- Deploy schemas/content_public/tables/tag/table to pg

-- requires: schemas/content_public/schema

BEGIN;

CREATE TABLE content_public.tag (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    project_id uuid NOT NULL REFERENCES projects_public.project ON DELETE CASCADE,

    name varchar(191) NOT NULL,
    slug varchar(191) NOT NULL,
    description text,
    feature_image varchar(2000) DEFAULT NULL,
    parent_id varchar(191) DEFAULT NULL,
    visibility varchar(50) NOT NULL DEFAULT 'public',
    meta_title varchar(2000) DEFAULT NULL,
    meta_description varchar(2000) DEFAULT NULL,
    -- created_at datetime NOT NULL,
    -- created_by varchar(24) NOT NULL,
    -- updated_at datetime DEFAULT NULL,
    -- updated_by varchar(24) DEFAULT NULL,
    UNIQUE ( slug )
);

COMMIT;
