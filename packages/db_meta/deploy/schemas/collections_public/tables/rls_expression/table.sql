-- Deploy schemas/collections_public/tables/rls_expression/table to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/table/table
-- requires: schemas/collections_public/tables/policy/table

BEGIN;

CREATE TABLE collections_public.rls_expression (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    -- database_id uuid NOT NULL REFERENCES collections_public.database (id) ON DELETE CASCADE,
    -- table_id uuid NOT NULL REFERENCES collections_public.table (id) ON DELETE CASCADE,
    
    expr json
    -- rls_func_id uuid NULL REFERENCES collections_public.rls_function (id) ON DELETE CASCADE,
    -- field uuid NULL REFERENCES collections_public.field (id) ON DELETE CASCADE,
    -- ref_field uuid NULL REFERENCES collections_public.field (id) ON DELETE CASCADE
);

COMMIT;
