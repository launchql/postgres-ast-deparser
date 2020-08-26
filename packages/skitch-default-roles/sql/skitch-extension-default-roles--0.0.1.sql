\echo Use "CREATE EXTENSION skitch-extension-default-roles" to load this file. \quit
DO $$
  BEGIN
    IF NOT EXISTS (
            SELECT
                1
            FROM
                pg_roles
            WHERE
                rolname = 'administrator') THEN
            CREATE ROLE administrator;
            COMMENT ON ROLE administrator IS 'Administration group';
    END IF;
END $$;

DO $$
  BEGIN
    IF NOT EXISTS (
            SELECT
                1
            FROM
                pg_roles
            WHERE
                rolname = 'anonymous') THEN
            CREATE ROLE anonymous;
            COMMENT ON ROLE anonymous IS 'Anonymous group';
    END IF;
END $$;

DO $$
  BEGIN
    IF NOT EXISTS (
            SELECT
                1
            FROM
                pg_roles
            WHERE
                rolname = 'authenticated') THEN
            CREATE ROLE authenticated;
            COMMENT ON ROLE authenticated IS 'Authenticated group';
    END IF;
END $$;