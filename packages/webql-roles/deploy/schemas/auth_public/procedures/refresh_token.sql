-- Deploy schemas/auth_public/procedures/refresh_token to pg

-- requires: schemas/auth_public/schema
-- requires: schemas/auth_private/tables/token/table
-- requires: schemas/auth_private/types/token_type

BEGIN;

CREATE FUNCTION auth_public.refresh_token(
  access_token text,
  refresh_token text
) returns auth_private.token AS $$
DECLARE
  updated_token auth_private.token;
  existing_token auth_private.token;
BEGIN
  SELECT tokens.* FROM auth_private.token tokens
    WHERE tokens.access_token = refresh_token.access_token
    AND tokens.refresh_token = refresh_token.refresh_token
  INTO existing_token;

  IF (NOT FOUND) THEN
    -- TODO after many bad attempts, we should destroy the token
    RETURN NULL;
  END IF;
 
  IF (existing_token.type = 'totp'::auth_private.token_type) THEN
    RAISE EXCEPTION 'TOKENS_REFRESH_TOTP';
  ELSIF (existing_token.type = 'service'::auth_private.token_type) THEN
    RAISE EXCEPTION 'TOKENS_REFRESH_SERVICE';
  ELSIF (existing_token.type != 'auth'::auth_private.token_type) THEN
    RAISE EXCEPTION 'TOKENS_REFRESH_NON_AUTH';
  END IF;

  UPDATE auth_private.token tkns
    SET
      access_token_expires_at = NOW() + interval '1 hour',
      access_token = encode( gen_random_bytes( 48 ), 'hex' )
    WHERE tkns.access_token = refresh_token.access_token
    RETURNING
      *
    INTO updated_token;

  RETURN updated_token;
END;
$$
LANGUAGE 'plpgsql' VOLATILE
SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION auth_public.refresh_token to anonymous;

COMMIT;
