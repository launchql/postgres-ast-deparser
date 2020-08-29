-- Deploy schemas/collaboration_private/views/project_permits/view to pg

-- requires: schemas/collaboration_private/schema
-- requires: schemas/collaboration_private/views/admin_project_permits/view 
-- requires: schemas/collaboration_private/views/team_project_permits/view 
-- requires: schemas/collaboration_private/views/user_project_permits/view 
-- requires: schemas/projects_public/tables/project/table


BEGIN;

CREATE VIEW collaboration_private.project_permits AS
SELECT * FROM
collaboration_private.team_project_permits
UNION
SELECT * FROM
collaboration_private.user_project_permits
UNION
SELECT * FROM
collaboration_private.admin_project_permits
;

COMMIT;
