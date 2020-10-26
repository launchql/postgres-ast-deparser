-- Verify: schemas/launchql_public/tables/user_settings/indexes/user_location_gist_idx on pg

BEGIN;
SELECT verify_index('launchql_rls_public.user_settings', 'user_location_gist_idx');
COMMIT;  

