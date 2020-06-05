-- Deploy schemas/auth_private/procedures/set_multi_factor_secret to pg

-- requires: schemas/auth_private/schema
-- requires: schemas/roles_private/tables/user_secrets/table
-- requires: schemas/roles_public/procedures/current_role_id

BEGIN;

CREATE FUNCTION auth_private.set_multi_factor_secret(
  secret text default null
) returns boolean as $$
DECLARE
  secrets roles_private.user_secrets;
BEGIN

  SELECT st.* FROM roles_private.user_secrets AS st
    WHERE st.role_id = roles_public.current_role_id()
    INTO secrets;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  IF (secrets.multi_factor_secret IS NULL) THEN
    IF (secret IS NULL) THEN
      RAISE EXCEPTION 'MFA_NOT_ENABLED';
    END IF;
    UPDATE roles_private.user_secrets sts
      SET multi_factor_secret=secret
      WHERE sts.role_id = roles_public.current_role_id();
    RETURN TRUE;
  ELSE
    IF (secret IS NOT NULL) THEN
      RAISE EXCEPTION 'MFA_ENABLED_TWICE';
    END IF;
    UPDATE roles_private.user_secrets sts
      SET multi_factor_secret=secret
      WHERE sts.role_id = roles_public.current_role_id();
    RETURN FALSE;
  END IF;

END;
$$
LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;

COMMIT;
