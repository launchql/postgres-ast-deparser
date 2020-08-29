-- Deploy schemas/files_public/tables/files/table to pg

-- requires: schemas/files_public/schema
-- requires: schemas/files_public/tables/buckets/table

BEGIN;

-- [ ] should be same bucket_id for all files with same project_id

CREATE TABLE files_public.files (
    id UUID NOT NULL,
    filename text NOT NULL,
    mimetype text NOT NULL,
    encoding text NOT NULL,
    sha1 text NOT NULL,
    etag text NOT NULL,
    size int NOT NULL,
    key text NOT NULL,
    url text NULL,
    owner_id UUID NOT NULL REFERENCES roles_public.roles (id) ON DELETE CASCADE,
    organization_id UUID NOT NULL REFERENCES roles_public.roles (id) ON DELETE CASCADE

    -- bucket text NOT NULL,
    -- project_id UUID NOT NULL REFERENCES projects_public.project (id) ON DELETE CASCADE,
    -- bucket_id UUID NOT NULL REFERENCES files_public.buckets (id) ON DELETE CASCADE,
    -- PRIMARY KEY(project_id, id)
);

COMMIT;
