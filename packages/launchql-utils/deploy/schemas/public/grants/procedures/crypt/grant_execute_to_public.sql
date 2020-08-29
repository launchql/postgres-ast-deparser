-- Deploy schemas/public/grants/procedures/crypt/grant_execute_to_public to pg

BEGIN;

GRANT EXECUTE ON FUNCTION crypt TO PUBLIC;

COMMIT;
