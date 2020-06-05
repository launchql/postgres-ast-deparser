-- Revert skitch-extension-defaults:defaults/public from pg

BEGIN;

ALTER DEFAULT privileges GRANT EXECUTE ON functions
TO public;

DO $$
DECLARE
 sql text;
BEGIN
	select format('GRANT ALL ON DATABASE %I TO PUBLIC', current_database()) into sql;
	execute sql;
END
$$;

GRANT ALL ON SCHEMA public TO PUBLIC;

COMMIT;
