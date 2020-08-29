-- Deploy schemas/auth_private/grants/procedures/set_multi_factor_secret/grant_execute_to_authenticated to pg

-- requires: schemas/auth_private/schema
-- requires: schemas/auth_private/procedures/set_multi_factor_secret

BEGIN;

GRANT EXECUTE ON FUNCTION auth_private.set_multi_factor_secret TO authenticated;

COMMIT;
