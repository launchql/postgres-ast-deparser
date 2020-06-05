\echo Use "CREATE EXTENSION dbs_rls" to load this file. \quit
ALTER TABLE collections_public."constraint" ENABLE ROW LEVEL SECURITY;

ALTER TABLE collections_public.database ENABLE ROW LEVEL SECURITY;

ALTER TABLE collections_public.field ENABLE ROW LEVEL SECURITY;

ALTER TABLE collections_public."table" ENABLE ROW LEVEL SECURITY;