-- Deploy schemas/public/grants/procedures/gen_salt/grant_execute_to_public to pg

BEGIN;

GRANT EXECUTE ON FUNCTION gen_salt (text) TO PUBLIC;

COMMIT;
