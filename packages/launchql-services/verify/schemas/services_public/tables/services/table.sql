-- Verify schemas/services_public/tables/services/table on pg

BEGIN;

SELECT verify_table ('services_public.services');

ROLLBACK;
