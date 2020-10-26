-- Deploy: schemas/launchql_private/trigger_fns/user_encrypted_secrets_hash to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/constraints/user_encrypted_secrets_user_id_name_key

BEGIN;

CREATE FUNCTION "launchql_private".user_encrypted_secrets_hash ()
RETURNS TRIGGER
AS $CODEZ$
BEGIN
   
IF (NEW.enc = 'crypt') THEN
    NEW.value = crypt(NEW.value::text, gen_salt('bf'));
ELSIF (NEW.enc = 'pgp') THEN
    NEW.value = pgp_sym_encrypt(encode(NEW.value::bytea, 'hex'), NEW.user_id::text, 'compress-algo=1, cipher-algo=aes256');
ELSE
    NEW.enc = 'none';
END IF;
RETURN NEW;
END;
$CODEZ$
LANGUAGE plpgsql VOLATILE;
COMMIT;
