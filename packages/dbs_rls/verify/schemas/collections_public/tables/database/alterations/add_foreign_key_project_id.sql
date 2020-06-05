-- Verify schemas/collections_public/tables/database/alterations/add_foreign_key_project_id  on pg

BEGIN;

SELECT verify_constraint('collections_public.database', 'fk_collections_public_database_project_id');

ROLLBACK;
