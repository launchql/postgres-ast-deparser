-- Deploy schemas/roles_public/tables/roles/indexes/unique_username to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table

BEGIN;

CREATE UNIQUE INDEX unique_username ON roles_public.roles (
 username
) WHERE username IS NOT NULL;

COMMIT;
