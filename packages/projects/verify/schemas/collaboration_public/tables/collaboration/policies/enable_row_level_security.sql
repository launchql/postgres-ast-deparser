-- Verify schemas/collaboration_public/tables/collaboration/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('collaboration_public.collaboration');

ROLLBACK;
