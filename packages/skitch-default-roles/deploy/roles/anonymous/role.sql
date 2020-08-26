-- Deploy roles/anonymous/role to pg


BEGIN;

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

COMMIT;
