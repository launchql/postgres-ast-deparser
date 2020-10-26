-- Revert: schemas/launchql_public/tables/goals/indexes/goals_vector_index from pg

BEGIN;
DROP INDEX "launchql_rls_public".goals_vector_index;
COMMIT;  

