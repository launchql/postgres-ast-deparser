-- Deploy schemas/status_public/tables/user_task_achievement/indexes/user_id_idx to pg

-- requires: schemas/status_public/schema
-- requires: schemas/status_public/tables/user_task_achievement/table

BEGIN;

CREATE INDEX user_id_idx ON status_public.user_task_achievement (
 user_id
);

COMMIT;
