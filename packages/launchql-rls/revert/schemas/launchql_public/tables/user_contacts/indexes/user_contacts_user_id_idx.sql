-- Revert: schemas/launchql_public/tables/user_contacts/indexes/user_contacts_user_id_idx from pg

BEGIN;


DROP INDEX "launchql_rls_public".user_contacts_user_id_idx;

COMMIT;  

