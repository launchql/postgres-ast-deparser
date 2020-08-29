-- Verify schemas/files_private/schema  on pg

BEGIN;

SELECT verify_schema ('files_private');

ROLLBACK;
