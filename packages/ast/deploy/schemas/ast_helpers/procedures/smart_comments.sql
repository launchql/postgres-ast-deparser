-- Deploy schemas/ast_helpers/procedures/smart_comments to pg

-- requires: schemas/ast_helpers/schema

BEGIN;

-- 

CREATE FUNCTION ast_helpers.json_to_smart_tags(tags jsonb)
  RETURNS text[]
  AS $$
DECLARE
  key text;
  value jsonb;
  attrs text[] = ARRAY[]::text[];
  _key text;
  _value jsonb;
BEGIN
  FOR key IN SELECT jsonb_object_keys(tags)
  LOOP
    value = tags->key;
    IF (jsonb_typeof(value) = 'boolean') THEN
        IF (tags->>key = 'true') THEN
        attrs = array_append(attrs, concat('@', key));
        END IF;
    ELSIF (jsonb_typeof(value) = 'array') THEN
      FOR _value IN SELECT * FROM jsonb_array_elements(value)
      LOOP
        attrs = array_append(attrs, concat('@', key, ' ', _value#>>'{}'));
      END LOOP;
    ELSE
      attrs = array_append(attrs, concat('@', key, ' ', value#>>'{}'));
    END IF;
  END LOOP;

  RETURN attrs;
END;
$$
LANGUAGE 'plpgsql'
STABLE;

CREATE FUNCTION ast_helpers.smart_comments(tags jsonb, description text default null)
  RETURNS text
  AS $$
DECLARE
  attrs text[] = ARRAY[]::text[];
BEGIN

  attrs = ast_helpers.json_to_smart_tags(tags);

  IF (description IS NOT NULL) THEN
    attrs = array_append(attrs, description);
  END IF;

  IF (array_length(attrs, 1) > 0) THEN
    RETURN array_to_string(attrs, '\n');
  END IF;

  RETURN NULL;
END;
$$
LANGUAGE 'plpgsql'
STABLE;

COMMIT;
