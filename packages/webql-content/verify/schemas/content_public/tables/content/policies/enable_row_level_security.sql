-- Verify schemas/content_public/tables/content/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('content_public.content');

ROLLBACK;
