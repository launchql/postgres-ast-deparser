-- Deploy schemas/faker/procedures/utils to pg

-- requires: schemas/faker/schema
-- requires: schemas/faker/tables/dictionary/table

BEGIN;


CREATE FUNCTION faker.words() returns text as $$
SELECT 

(SELECT word FROM faker.dictionary 
WHERE type = 'adjectives'
OFFSET floor( random() * (select count(*) from faker.dictionary WHERE type = 'adjectives' ) ) LIMIT 1)
|| ' ' ||
(SELECT word FROM faker.dictionary 
WHERE type = 'colors'
OFFSET floor( random() * (select count(*) from faker.dictionary WHERE type = 'colors' ) ) LIMIT 1)
|| ' ' ||
(SELECT word FROM faker.dictionary 
WHERE type = 'animals'
OFFSET floor( random() * (select count(*) from faker.dictionary WHERE type = 'animals' ) ) LIMIT 1)
$$
LANGUAGE 'sql';

CREATE FUNCTION faker.word_type() returns text as $$
SELECT (CASE (RANDOM() * 2)::INT
      WHEN 0 THEN 'adjectives'
      WHEN 1 THEN 'colors'
      WHEN 2 THEN 'animals'
    END);
$$
LANGUAGE 'sql';

CREATE FUNCTION faker.word(wordtype text default null) returns text as $$
DECLARE
  vword text;
  vtype text;
BEGIN
  IF (wordtype IS NOT NULL) THEN 
    vtype = wordtype;
  ELSE
    vtype = faker.word_type();
  END IF;

SELECT word FROM faker.dictionary 
WHERE type = vtype
OFFSET floor( random() * (select count(*) from faker.dictionary WHERE type = vtype ) ) LIMIT 1
INTO vword;

RETURN vword;

END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION faker.sentence(unit text default 'word', min int default 7, max int default 20, cat text default 'lorem', period text default '.') returns text as $$
DECLARE
  num int = faker.integer(min, max);
  txt text;
  vtype text;
  n int;
  c int;
BEGIN

  IF (unit = 'word') THEN
    txt = initcap(faker.word(cat));
    FOR n IN 
    SELECT * FROM generate_series(1, num) g(n)
    LOOP 
      txt = txt || ' ' || faker.word(cat);
    END LOOP;
    RETURN txt || period;
  ELSEIF (unit = 'char' OR unit = 'chars') THEN 
    txt = initcap(faker.word(cat));
    c = char_length(txt);
    IF (c = num) THEN 
      RETURN concat(txt, period);
    END IF;
    IF (c > num) THEN 
      RETURN substring(txt from 1 for num) || period;
    END IF;
    WHILE (c < num)
    LOOP 
      txt = txt || ' ' || faker.word(cat);
      c = char_length(txt);
    END LOOP;
    IF (c = num) THEN 
      RETURN txt || period;
    END IF;
    IF (c > num) THEN 
      RETURN substring(txt from 1 for num) || period;
    END IF;
  END IF;
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION faker.paragraph(unit text default 'word', min int default 7, max int default 20, cat text default 'lorem') returns text as $$
DECLARE
  num int = faker.integer(min, max);
  txt text;
  words text[];
  n int;
  needscaps boolean = false;
BEGIN
  txt = faker.sentence(unit, min, max, cat, '');
  words = string_to_array(txt, ' ');
  txt = '';

  FOR n IN
  SELECT * FROM generate_series(1, cardinality(words)) g(n)
  LOOP 
      IF (needscaps IS TRUE) THEN
        txt = concat(txt, ' ', initcap(words[n]));
      ELSE
        txt = concat(txt, ' ', words[n]);
      END IF;

      IF (faker.integer(1,100) > 70) THEN 
        txt = txt || '.';
        needscaps = true;
      ELSE
        needscaps = false;
      END IF;

  END LOOP;

  IF (trim(txt) ~ '\.$') THEN 
    RETURN trim(txt);
  ELSE
    RETURN trim(txt || '.');
  END IF;

END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION faker.email() returns text as $$
SELECT
  faker.word() || (RANDOM() * 100)::INT || '@' || (
    CASE (RANDOM() * 3)::INT
      WHEN 0 THEN 'gmail'
      WHEN 1 THEN 'hotmail'
      WHEN 2 THEN 'yahoo'
      WHEN 3 THEN faker.word()
    END
  ) || '.com' AS email
$$
LANGUAGE 'sql';

CREATE FUNCTION faker.uuid() returns uuid as $$
SELECT
  uuid_generate_v4();
$$
LANGUAGE 'sql';

CREATE FUNCTION faker.token(bytes int default 16) returns text as $$
SELECT
  encode( gen_random_bytes( bytes ), 'hex' )
$$
LANGUAGE 'sql';

CREATE FUNCTION faker.password() returns text as $$
DECLARE
  chars text[] =  regexp_split_to_array('!@#$%^&*():";''<>?,./~`'::text, '');
  num_special int = faker.integer(0, 4);
  n int = 0;
  pass text;
BEGIN

  IF (num_special = 0) THEN
    pass = encode( gen_random_bytes( 16 ), 'hex' );
  ELSE
    pass = encode( gen_random_bytes( 4 ), 'hex' );
    FOR n IN
    SELECT * FROM generate_series(1, num_special) g(n)
    LOOP
      pass = pass ||
      encode( gen_random_bytes( faker.integer(1,4) ), 'hex' ) ||
      chars[ faker.integer(1, cardinality(chars)) ] ||
      encode( gen_random_bytes( faker.integer(1,4) ), 'hex' );

    END LOOP;
  END IF;


  RETURN pass;

END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION faker.hostname() returns text as $$
SELECT
  faker.word() || '.' || (
    CASE (RANDOM() * 4)::INT
      WHEN 0 THEN 'com'
      WHEN 1 THEN 'net'
      WHEN 2 THEN 'io'
      WHEN 3 THEN 'org'
      WHEN 4 THEN 'co'
    END
  )
$$
LANGUAGE 'sql';

CREATE FUNCTION faker.time_unit() returns text as $$
SELECT
  (
    CASE (RANDOM() * 5)::INT
      WHEN 0 THEN 'millisecond'
      WHEN 1 THEN 'second'
      WHEN 2 THEN 'minute'
      WHEN 3 THEN 'hour'
      WHEN 4 THEN 'day'
      WHEN 5 THEN 'week'
    END
  )
$$
LANGUAGE 'sql';

CREATE FUNCTION faker.float(min int default 0, max int default 100) returns float as $$
DECLARE
  num float;
BEGIN
  min = ceil(min);
  max = floor(max);
  num = (RANDOM() * ( max - min + 1 )) + min;
  RETURN num;
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION faker.integer(min int default 0, max int default 100) returns int as $$
DECLARE
  num int;
BEGIN
  min = ceil(min);
  max = floor(max);
  num = floor(RANDOM() * ( max - min + 1 )) + min;
  RETURN num;
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION faker.date(future boolean default false) returns date as $$
DECLARE
  d date;
BEGIN
IF (future) THEN 
  d = now()::date + 10;
ELSE
  d = now()::date - 10;
END IF;
RETURN d;
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION faker.interval() returns interval as $$
DECLARE
  ival text;
BEGIN
  SELECT faker.time_unit() INTO ival;
  ival = (RANDOM() * 100)::text || ' ' || ival;
  RETURN ival::interval;
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION faker.timestamptz(future boolean default false) returns timestamptz as $$
DECLARE
  ival interval;
  t timestamptz;
BEGIN
  ival = faker.interval();
  IF (future) THEN
    SELECT now() + ival INTO t;
  ELSE
    SELECT now() - ival INTO t;
  END IF;
  RETURN t;
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION faker.mime() returns text as $$
  SELECT faker.word('mime');
$$
LANGUAGE 'sql';

CREATE FUNCTION faker.ext(mime text default faker.mime()) returns text as $$
DECLARE 
  ext text;
BEGIN
  IF (mime IS NULL) THEN 
    ext = faker.word(faker.mime());
  ELSE
    ext = faker.word(mime);
  END IF;
  RETURN ext;
END;
$$
LANGUAGE 'plpgsql';


CREATE FUNCTION faker.image_mime() returns text as $$
SELECT
  (
    CASE (RANDOM() * 3)::INT
      WHEN 0 THEN 'image/svg+xml'
      WHEN 1 THEN 'image/png'
      WHEN 2 THEN 'image/gif'
      WHEN 3 THEN 'image/jpeg'
    END
  )
$$
LANGUAGE 'sql';

CREATE FUNCTION faker.image(width int default null, height int default null) returns image as $$
DECLARE
  w int;
  h int;
  obj jsonb = '{}'::jsonb;
  url text;
BEGIN
  IF (width IS NULL) THEN 
    w = faker.integer(800,1200);
  ELSE
    w = width;
  END IF;
  IF (height IS NULL) THEN 
    h = faker.integer(800,1200);
  ELSE
    h = height;
  END IF;

  url = concat('https://picsum.photos/', w::text, '/', h::text);

  obj = jsonb_set(obj, '{url}', to_jsonb(url));
  obj = jsonb_set(obj, '{mime}', to_jsonb(faker.image_mime()));

  RETURN obj;

END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION faker.url(mime text default null) returns url as $$
DECLARE
  obj jsonb = '{}'::jsonb;
  url text;
BEGIN
  url = concat('https://', faker.hostname(), '/', faker.word(), '.', faker.ext(mime));
  RETURN url;
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION faker.upload(mime text default null) returns upload as $$
BEGIN
  RETURN faker.url(mime);
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION faker.ip(mime text default null) returns text as $$
BEGIN
  RETURN 
    array_to_string(ARRAY[
      faker.integer(0,255),
      faker.integer(0,255),
      faker.integer(0,255),
      faker.integer(0,255)
    ]::text[], '.');
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION faker.attachment(mime text default null) returns attachment as $$
DECLARE
  obj jsonb = '{}'::jsonb;
BEGIN
  IF (mime IS NULL) THEN
    mime = faker.mime();
  END IF;
  obj = jsonb_set(obj, '{url}', to_jsonb(faker.url(mime)::text));
  obj = jsonb_set(obj, '{mime}', to_jsonb(mime));
  RETURN obj;
END;
$$
LANGUAGE 'plpgsql';

COMMIT;
