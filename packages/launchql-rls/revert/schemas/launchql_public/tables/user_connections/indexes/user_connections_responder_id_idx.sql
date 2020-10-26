-- Revert: schemas/launchql_public/tables/user_connections/indexes/user_connections_responder_id_idx from pg

BEGIN;


DROP INDEX "launchql_rls_public".user_connections_responder_id_idx;

COMMIT;  

