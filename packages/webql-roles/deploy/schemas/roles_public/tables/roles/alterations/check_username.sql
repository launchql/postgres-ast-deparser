-- Deploy schemas/roles_public/tables/roles/alterations/check_username to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table

BEGIN;


ALTER TABLE roles_public.roles
    ADD CONSTRAINT fk_roles_public_roles_username
    CHECK(username ~ '^[a-zA-Z]([a-zA-Z0-9][_]?)+$');

COMMIT;
