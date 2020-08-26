-- Deploy schemas/services_public/tables/config/table to pg

-- requires: schemas/services_public/schema

BEGIN;

CREATE TABLE services_public.config (
    id int PRIMARY KEY DEFAULT 1,
    domain citext NOT NULL DEFAULT 'localhost'
);

COMMIT;
