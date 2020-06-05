-- Verify skitch-extension-defaults:defaults/public on pg

BEGIN;

select 1/count(*) from pg_default_acl WHERE defaclnamespace = 0::oid;

ROLLBACK;
