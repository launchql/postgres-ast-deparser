-- Revert schemas/services_public/tables/config/table from pg

BEGIN;

DROP TABLE services_public.config;

COMMIT;
