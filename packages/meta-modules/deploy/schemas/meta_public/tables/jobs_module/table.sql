-- Deploy schemas/meta_public/tables/jobs_module/table to pg

-- requires: schemas/meta_public/schema

BEGIN;

CREATE TABLE meta_public.jobs_module (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    api_id uuid NOT NULL REFERENCES meta_public.apis (id),
    use_extension boolean default false,
    UNIQUE(api_id)
);

COMMIT;
