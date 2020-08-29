-- Verify schemas/content_public/tables/content_tag/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('content_public.content_tag');

ROLLBACK;
