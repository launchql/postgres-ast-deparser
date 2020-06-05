-- Deploy schemas/auth_private/tables/token/triggers/on_create_token to pg

-- requires: schemas/auth_private/schema
-- requires: schemas/auth_private/tables/token/table
-- requires: schemas/auth_private/types/token_type
-- requires: schemas/roles_private/tables/user_secrets/table

BEGIN;

CREATE FUNCTION auth_private.tg_on_create_token()
RETURNS TRIGGER AS $$
DECLARE
  secret roles_private.user_secrets;
  current_token auth_private.token;
BEGIN

  IF (NEW.role_id IS NULL) THEN
    RAISE EXCEPTION 'TOKENS_REQUIRE_ROLE';
  END IF;

  SELECT * INTO secret FROM roles_private.user_secrets
    WHERE role_id = NEW.role_id;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'TOKENS_REQUIRE_USER_ROLE';
  END IF;

  NEW.refresh_token = NULL;

  IF (NEW.type = 'auth'::auth_private.token_type) THEN
    IF (secret.multi_factor_secret IS NOT NULL) THEN
      SELECT *
        FROM auth_private.current_token()
        INTO current_token;
      IF (current_token.type = 'totp'::auth_private.token_type) THEN
        NEW.type = 'auth'::auth_private.token_type;
        NEW.refresh_token = encode( gen_random_bytes( 48 ), 'hex' );
        NEW.access_token_expires_at = NOW() + interval '1 hour';
      ELSE
        NEW.type = 'totp'::auth_private.token_type;
        NEW.access_token_expires_at = NOW() + interval '10 minutes';
      END IF;
    ELSE
      NEW.refresh_token = encode( gen_random_bytes( 48 ), 'hex' );
    END IF;
  ELSIF (NEW.type = 'totp'::auth_private.token_type) THEN
    RAISE EXCEPTION 'TOKENS_CANT_CREATE_TOTP';
  ELSIF (NEW.type = 'service'::auth_private.token_type) THEN
    NEW.access_token_expires_at = NOW() + interval '10 minutes';
  END IF;

  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER on_create_token
BEFORE INSERT ON auth_private.token
FOR EACH ROW
EXECUTE PROCEDURE auth_private.tg_on_create_token ();

COMMIT;
