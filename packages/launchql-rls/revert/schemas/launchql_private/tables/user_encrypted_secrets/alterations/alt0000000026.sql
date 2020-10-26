-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/alterations/alt0000000026 from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_encrypted_secrets
    ENABLE ROW LEVEL SECURITY;

COMMIT;  

