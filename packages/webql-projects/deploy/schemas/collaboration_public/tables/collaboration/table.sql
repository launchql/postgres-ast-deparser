-- Deploy schemas/collaboration_public/tables/collaboration/table to pg

-- requires: schemas/collaboration_public/schema

BEGIN;

CREATE TABLE collaboration_public.collaboration (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    
    -- WHO 
    role_id uuid NOT NULL REFERENCES roles_public.roles (id) ON DELETE CASCADE,
    -- WHAT THEY CAN DO
    profile_id uuid NOT NULL REFERENCES permissions_public.profile (id) ON DELETE CASCADE,

    -- WHERE CAN THEY DO IT
    project_id uuid NOT NULL REFERENCES projects_public.project (id) ON DELETE CASCADE,
    organization_id uuid NOT NULL REFERENCES roles_public.roles (id) ON DELETE CASCADE,

    --- WHO INVITED THEM
    invited_by_id uuid NULL REFERENCES roles_public.roles (id),
    
    inherited boolean default false,
    collaboration_id uuid NULL REFERENCES collaboration_public.collaboration (id) ON DELETE CASCADE,

    UNIQUE (role_id, project_id)
);

COMMIT;
