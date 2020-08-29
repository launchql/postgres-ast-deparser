-- Deploy schemas/roles_public/procedures/available_username to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table

BEGIN;

CREATE FUNCTION roles_public.available_username(
  v_username text
) returns text as $$
BEGIN
  v_username = regexp_replace(v_username, '^[^a-z]+', '', 'ig');
  v_username = regexp_replace(v_username, '[^a-z0-9]+', '_', 'ig');

  IF v_username IS NULL OR length(v_username) < 3 THEN
      v_username = 'user';
  END IF;

  SELECT
    (
        CASE WHEN i = 0 THEN
            v_username
        ELSE
            v_username || i::text
        END) INTO v_username
  FROM
    generate_series(0, 1000) i
  WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            roles_public.roles
        WHERE
            roles_public.roles.username = (
                CASE WHEN i = 0 THEN
                    v_username
                ELSE
                    v_username || i::text
                END)::citext)
    LIMIT 1;
    RETURN v_username;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

GRANT EXECUTE ON FUNCTION roles_public.available_username to anonymous, authenticated;

COMMIT;
