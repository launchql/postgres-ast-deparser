-- Revert schemas/services_public/tables/services/table from pg

BEGIN;

DROP TABLE services_public.services;

COMMIT;
