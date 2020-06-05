-- Deploy schemas/auth_private/grants/procedures/authenticate/grant_execute_to_anonymous to pg

-- requires: schemas/auth_private/schema
-- requires: schemas/auth_private/procedures/authenticate

BEGIN;

GRANT EXECUTE ON FUNCTION auth_private.authenticate TO anonymous;

COMMIT;
