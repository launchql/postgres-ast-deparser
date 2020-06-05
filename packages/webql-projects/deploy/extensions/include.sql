-- Deploy webql-projects:extensions/include to pg

BEGIN;

GRANT EXECUTE ON FUNCTION gen_random_bytes TO public;
GRANT EXECUTE ON FUNCTION pgp_sym_encrypt(text, text, text) TO public;
GRANT EXECUTE ON FUNCTION pgp_sym_decrypt(bytea, text) TO public;

COMMIT;
