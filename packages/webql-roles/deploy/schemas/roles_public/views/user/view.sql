-- Deploy schemas/roles_public/views/user/view to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/types/role_type

BEGIN;
CREATE VIEW roles_public.user AS
SELECT
  *
FROM
  roles_public.roles
WHERE
  TYPE = 'User'::roles_public.role_type;
GRANT SELECT ON roles_public.user TO authenticated;
COMMIT;

