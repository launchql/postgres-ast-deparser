-- Deploy skitch-extension-defaults:defaults/public to pg

BEGIN;


DO $$
DECLARE
  sql text;
BEGIN
select format('REVOKE ALL ON DATABASE %I FROM PUBLIC', current_database()) into sql;
execute sql;
END $$;

ALTER DEFAULT PRIVILEGES REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

COMMIT;
