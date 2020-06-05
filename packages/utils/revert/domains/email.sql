-- Revert domains/email from pg

BEGIN;

DROP DOMAIN email;

COMMIT;
