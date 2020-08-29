-- Deploy schemas/public/domains/attachment to pg
-- requires: schemas/public/schema

BEGIN;
CREATE DOMAIN attachment AS jsonb CHECK (
  value ?& ARRAY['url', 'mime']
  AND
  value->>'url' ~ '^(https?)://[^\s/$.?#].[^\s]*$'
);
COMMENT ON DOMAIN attachment IS E'@name launchqlInternalTypeAttachment';
COMMIT;

