-- Deploy schemas/inflection/tables/inflection_regexp/table to pg

-- requires: schemas/inflection/schema

BEGIN;

CREATE TABLE inflection.inflection_regexp (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    type text, -- singular, plural
    name text, -- man, person
    test text -- '^(m|wom)an$'
);

COMMIT;
