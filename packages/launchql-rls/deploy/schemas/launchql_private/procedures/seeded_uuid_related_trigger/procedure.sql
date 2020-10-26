-- Deploy: schemas/launchql_private/procedures/seeded_uuid_related_trigger/procedure to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/procedures/uuid_generate_seeded_uuid/procedure

BEGIN;

CREATE FUNCTION "launchql_private".seeded_uuid_related_trigger()
RETURNS TRIGGER AS $$
DECLARE
    _seed_column text := to_json(NEW) ->> TG_ARGV[1];
BEGIN
    IF _seed_column IS NULL THEN
        RAISE EXCEPTION 'UUID seed is NULL on table %', TG_TABLE_NAME;
    END IF;
    NEW := NEW #= (TG_ARGV[0] || '=>' || "launchql_private".uuid_generate_seeded_uuid(_seed_column))::hstore;
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;
COMMIT;
