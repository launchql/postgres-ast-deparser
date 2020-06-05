-- Deploy schemas/roles_private/procedures/cascade_restructured_organization to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/tables/memberships/table
-- requires: schemas/roles_private/procedures/membership_cascade_hierarchy

BEGIN;

CREATE FUNCTION roles_private.cascade_restructured_organization(
  re_organization_id uuid
)
RETURNS void AS $$
DECLARE
  membership_rec roles_public.memberships;
BEGIN

  -- 1. DELETE ALL INHERITED MEMBERSHIPS
  DELETE
    FROM roles_public.memberships
    WHERE inherited=TRUE
    AND organization_id = re_organization_id;

  -- 2. CASCADE MEMBERSHIPS

  FOR membership_rec in 
  SELECT * 
  FROM roles_public.memberships
    WHERE
      organization_id = re_organization_id
    -- newer first, not best, but for most cases this works
    ORDER BY created_at DESC
  LOOP
  PERFORM
  roles_private.membership_cascade_hierarchy
    (membership_rec)
  ;

  END LOOP;

END;
$$
LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;

COMMIT;
