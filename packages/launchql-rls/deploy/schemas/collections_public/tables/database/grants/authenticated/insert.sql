-- Deploy: schemas/collections_public/tables/database/grants/authenticated/insert to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/database/table
-- requires: schemas/collections_public/tables/database/grants/authenticated/select

BEGIN;
GRANT INSERT ON TABLE collections_public.database TO authenticated;
COMMIT;
