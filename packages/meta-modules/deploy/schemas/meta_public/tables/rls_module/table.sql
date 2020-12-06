-- Deploy schemas/meta_public/tables/rls_module/table to pg

-- requires: schemas/meta_public/schema

BEGIN;

CREATE TABLE meta_public.rls_module (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    api_id uuid NOT NULL REFERENCES meta_public.apis (id),
    authenticate text NOT NULL DEFAULT 'authenticate',
    "current_role" text NOT NULL DEFAULT 'current_user',
    users_table_id uuid NOT NULL,
    current_role_id text NOT NULL DEFAULT 'current_user_id',
    current_group_ids text NOT NULL DEFAULT 'current_group_ids',
    tokens_table_id text NOT NULL,
    UNIQUE(api_id)
);

COMMIT;
