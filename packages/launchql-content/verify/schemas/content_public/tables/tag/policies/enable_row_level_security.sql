-- Verify schemas/content_public/tables/tag/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('content_public.tag');

ROLLBACK;
