-- Revert schemas/collaboration_public/schema from pg

BEGIN;

DROP SCHEMA collaboration_public;

COMMIT;
