-- Verify schemas/files_public/schema  on pg

BEGIN;

SELECT verify_schema ('files_public');

ROLLBACK;
