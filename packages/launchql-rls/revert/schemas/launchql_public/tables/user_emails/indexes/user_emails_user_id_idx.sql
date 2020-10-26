-- Revert: schemas/launchql_public/tables/user_emails/indexes/user_emails_user_id_idx from pg

BEGIN;


DROP INDEX "launchql_rls_public".user_emails_user_id_idx;

COMMIT;  

