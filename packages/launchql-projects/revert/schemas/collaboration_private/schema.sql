-- Revert schemas/collaboration_private/schema from pg

BEGIN;

DROP SCHEMA collaboration_private;

COMMIT;
