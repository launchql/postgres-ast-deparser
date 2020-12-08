-- Deploy schemas/meta_public/tables/users_module/table to pg

-- requires: schemas/meta_public/schema

BEGIN;

-- ARGUMENT for using this instead...
-- because! you're already adding a function modules_private.users_module
-- in other words, you are already adding SQL code... so just do 
-- real SQL instead!

CREATE TABLE meta_public.users_module (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    api_id uuid NOT NULL REFERENCES meta_public.apis (id),
    table_name text NOT NULL DEFAULT 'users',
    UNIQUE(api_id)
);

COMMIT;
