-- Verify schemas/permissions_private/views/team_permits/view on pg

BEGIN;

SELECT verify_table ('permissions_private.team_permits');

ROLLBACK;
