-- Deploy: schemas/launchql_public/tables/user_contacts/columns/vcf/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_contacts/table
-- requires: schemas/launchql_public/tables/user_contacts/constraints/user_contacts_pkey

BEGIN;

ALTER TABLE "launchql_public".user_contacts ADD COLUMN vcf jsonb;
COMMIT;
