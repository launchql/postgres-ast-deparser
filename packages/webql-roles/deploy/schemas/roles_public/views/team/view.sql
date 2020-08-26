-- Deploy schemas/roles_public/views/team/view to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/types/role_type

BEGIN;
CREATE VIEW roles_public.team AS
SELECT
  *
FROM
  roles_public.roles
WHERE
  TYPE = 'Team'::roles_public.role_type;
GRANT SELECT ON roles_public.team TO authenticated;
COMMIT;

