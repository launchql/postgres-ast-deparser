-- Deploy: schemas/collections_public/tables/policy/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/policy/table
-- requires: schemas/collections_public/tables/policy/policies/authenticated_can_delete_on_policy

BEGIN;
GRANT SELECT ON TABLE collections_public.policy TO authenticated;
COMMIT;
