-- Deploy schemas/roles_private/grants/grant_schema_to_anonymous to pg

-- requires: schemas/roles_private/schema

-- NOTE This is to access roles_public.membership_invites inside of sign_up

BEGIN;

GRANT USAGE ON SCHEMA roles_private TO anonymous;

COMMIT;
