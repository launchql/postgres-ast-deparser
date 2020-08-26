-- Verify schemas/services_public/tables/config/table on pg

BEGIN;

SELECT verify_table ('services_public.config');

ROLLBACK;
