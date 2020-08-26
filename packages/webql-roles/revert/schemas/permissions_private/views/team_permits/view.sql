-- Revert schemas/permissions_private/views/team_permits/view from pg

BEGIN;

DROP VIEW permissions_private.team_permits;

COMMIT;
