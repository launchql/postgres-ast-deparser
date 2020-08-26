-- Deploy schemas/auth_private/types/token_type to pg

-- requires: schemas/auth_private/schema

BEGIN;

-- TODO consider getting rid of enums!
-- https://stackoverflow.com/questions/1771543/adding-a-new-value-to-an-existing-enum-type
-- ALTER TYPE auth_private.token_type ADD VALUE 'service' AFTER 'totp';

CREATE TYPE auth_private.token_type AS ENUM (
  'auth',
  'totp',
  'service'
);


COMMIT;
