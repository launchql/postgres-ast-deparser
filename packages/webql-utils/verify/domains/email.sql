-- Verify domains/email on pg

BEGIN;

SELECT verify_domain ('email');

ROLLBACK;
