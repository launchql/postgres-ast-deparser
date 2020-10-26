-- Revert: schemas/launchql_public/tables/user_characteristics/indexes/user_characteristics_user_id_idx from pg

BEGIN;


DROP INDEX "launchql_rls_public".user_characteristics_user_id_idx;

COMMIT;  

