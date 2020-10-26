-- Deploy: schemas/launchql_private/procedures/uuid_generate_seeded_uuid/procedure to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/procedures/uuid_generate_v4/procedure

BEGIN;

CREATE FUNCTION "launchql_private".uuid_generate_seeded_uuid(
	seed text
)
    RETURNS uuid
AS $$
DECLARE
    new_uuid char(36);
    md5_str char(32);
    md5_str2 char(32);
    uid text;
BEGIN
    md5_str := md5(concat(random(), now()));
    md5_str2 := md5(concat(random(), now()));
    
    new_uuid := concat(
        LEFT (md5(seed), 2),
        LEFT (md5(concat(extract(year FROM now()), extract(week FROM now()))), 2),
        substring(md5_str, 1, 4),
        '-',
        substring(md5_str, 5, 4),
        '-4',
        substring(md5_str2, 9, 3),
        '-',
        substring(md5_str, 13, 4),
        '-', 
        substring(md5_str2, 17, 12)
    );
    RETURN new_uuid;
END;
$$
LANGUAGE plpgsql VOLATILE;
COMMIT;
