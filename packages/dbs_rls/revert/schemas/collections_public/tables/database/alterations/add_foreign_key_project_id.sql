-- Revert schemas/collections_public/tables/database/alterations/add_foreign_key_project_id from pg

BEGIN;

ALTER TABLE collections_public.database
    DROP CONSTRAINT fk_collections_public_database_project_id;

COMMIT;
