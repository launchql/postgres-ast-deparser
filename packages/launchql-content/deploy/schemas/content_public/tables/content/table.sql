-- Deploy schemas/content_public/tables/content/table to pg
-- requires: schemas/content_public/schema

BEGIN;
CREATE TABLE content_public.content (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  project_id uuid NOT NULL REFERENCES projects_public.project ON DELETE CASCADE,

  type citext NOT NULL DEFAULT 'post',
  title varchar(2000) NOT NULL,
  slug varchar(191) NOT NULL,
  data text,
  -- mobiledoc longtext,
  -- html longtext,
  -- comment_id varchar(50) DEFAULT NULL,
  -- plaintext longtext,
  -- feature_image varchar(2000) DEFAULT NULL,
  -- featured tinyint(1) NOT NULL DEFAULT '0',
  -- page tinyint(1) NOT NULL DEFAULT '0',

  status varchar(50) NOT NULL DEFAULT 'draft',
  locale varchar(6) DEFAULT NULL,
  visibility varchar(50) NOT NULL DEFAULT 'public',
  meta_title varchar(2000) DEFAULT NULL,
  meta_description varchar(2000) DEFAULT NULL,

  -- author_id uuid NOT NULL,

  custom_excerpt varchar(2000) DEFAULT NULL,
  -- codeinjection_head text,
  -- codeinjection_foot text,
  -- og_image varchar(2000) DEFAULT NULL,
  -- og_title varchar(300) DEFAULT NULL,
  -- og_description varchar(500) DEFAULT NULL,
  -- twitter_image varchar(2000) DEFAULT NULL,
  -- twitter_title varchar(300) DEFAULT NULL,
  -- twitter_description varchar(500) DEFAULT NULL,
  -- custom_template varchar(100) DEFAULT NULL,

  canonical_url text,
  UNIQUE (slug, project_id)
);

COMMIT;

