-- Deploy schemas/permissions_public/procedures/add_permissions_to_profile to pg
-- requires: schemas/permissions_public/schema
-- requires: schemas/permissions_public/tables/profile/table
-- requires: schemas/permissions_public/tables/permission/table
-- requires: schemas/permissions_private/tables/profile_permissions/table

BEGIN;

CREATE FUNCTION permissions_public.add_permissions_to_profile (
  profile_id uuid,
  object_type text[],
  action_type text[]
)
  RETURNS void
  AS $$
DECLARE
  perm_id uuid;
BEGIN
  FOR perm_id IN
  SELECT
    id
  FROM
    permissions_public.permission p
  WHERE
    p.object_type = ANY (add_permissions_to_profile.object_type)
    AND p.action_type = ANY (add_permissions_to_profile.action_type)
    LOOP
      INSERT INTO permissions_private.profile_permissions (profile_id, permission_id)
      VALUES (add_permissions_to_profile.profile_id, perm_id) ON CONFLICT DO NOTHING;
    END LOOP;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE;

CREATE FUNCTION permissions_public.add_permissions_to_profile (
  profile_id uuid,
  object_type text[],
  action_type text
)
  RETURNS void
  AS $$
DECLARE
  perm_id uuid;
BEGIN
  IF (action_type = 'all') THEN
    FOR perm_id IN
    SELECT
      id
    FROM
      permissions_public.permission p
    WHERE
      p.object_type = ANY (add_permissions_to_profile.object_type)
      LOOP
        INSERT INTO permissions_private.profile_permissions (profile_id, permission_id)
        VALUES (add_permissions_to_profile.profile_id, perm_id) ON CONFLICT DO NOTHING;
      END LOOP;
  ELSE
    FOR perm_id IN
    SELECT
      id
    FROM
      permissions_public.permission p
    WHERE
      p.object_type = ANY (add_permissions_to_profile.object_type)
      AND p.action_type = add_permissions_to_profile.action_type LOOP
        INSERT INTO permissions_private.profile_permissions (profile_id, permission_id)
        VALUES (add_permissions_to_profile.profile_id, perm_id) ON CONFLICT DO NOTHING;
      END LOOP;
  END IF;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE;

COMMIT;

