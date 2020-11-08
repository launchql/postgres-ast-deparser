-- Deploy schemas/ast_helpers/procedures/smart_comments to pg

-- requires: schemas/ast_helpers/schema

BEGIN;

-- TODO ask benjie his opinion of this one

CREATE FUNCTION ast_helpers.smart_comments(tags jsonb, description text default null)
  RETURNS text
  AS $$
DECLARE
  key text;
  value jsonb;
  tvalue text;
  attrs text[] = ARRAY[]::text[];
  _key text;
  _value text;
BEGIN

  FOR key IN SELECT jsonb_object_keys(tags)
  LOOP
  	value = tags->key;
    tvalue = tags->>key;
	IF (jsonb_typeof(value) = 'boolean') THEN
	    IF (tvalue = 'true') THEN
			attrs = array_append(attrs, concat('@', key));
	    END IF;
	ELSIF (jsonb_typeof(value) = 'array') THEN
    FOR _value IN SELECT * FROM jsonb_array_elements(value)
    LOOP
      -- json text includes double quotes, so lets remove them!
			attrs = array_append(attrs, concat('@', key, ' ', trim(both '"' from _value)));
    END LOOP;
	ELSE
		attrs = array_append(attrs, concat('@', key, ' ', tvalue));
	END IF;
    
  END LOOP;

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
