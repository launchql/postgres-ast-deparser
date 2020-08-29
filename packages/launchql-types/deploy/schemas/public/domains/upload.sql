-- Deploy schemas/public/domains/upload to pg

-- requires: schemas/public/schema

BEGIN;

CREATE DOMAIN upload AS text CHECK (VALUE ~ '^(https?)://[^\s/$.?#].[^\s]*$');
COMMENT ON DOMAIN upload IS E'@name launchqlInternalTypeUpload';

COMMIT;
