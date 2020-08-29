-- Deploy schemas/roles_public/views/organization/view to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/types/role_type

BEGIN;
CREATE VIEW roles_public.organization AS
SELECT
  *
FROM
  roles_public.roles
WHERE
  TYPE = 'Organization'::roles_public.role_type;
GRANT SELECT ON roles_public.organization TO authenticated;
GRANT INSERT ON roles_public.organization TO authenticated;
GRANT UPDATE (username) ON roles_public.organization TO authenticated;
GRANT DELETE ON roles_public.organization TO authenticated;
COMMIT;

