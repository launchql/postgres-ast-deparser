-- Deploy schemas/services_public/tables/config/fixtures/1595032695960_fixture to pg

-- requires: schemas/services_public/schema
-- requires: schemas/services_public/tables/config/table

BEGIN;

    INSERT INTO services_public.config DEFAULT VALUES;

COMMIT;
