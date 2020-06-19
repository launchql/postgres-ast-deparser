CREATE ROLE administrator;
CREATE ROLE anonymous;
CREATE ROLE authenticated;
CREATE ROLE app_user LOGIN PASSWORD 'app_password';

GRANT anonymous TO administrator;
GRANT authenticated TO administrator;
GRANT administrator TO app_user;
ALTER ROLE administrator BYPASSRLS;

GRANT anonymous TO app_user;
GRANT authenticated TO app_user;
