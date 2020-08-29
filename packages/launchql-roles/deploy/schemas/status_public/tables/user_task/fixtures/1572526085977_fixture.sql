-- Deploy schemas/status_public/tables/user_task/fixtures/1572526085977_fixture to pg

-- requires: schemas/status_public/schema
-- requires: schemas/status_public/tables/user_task/table
-- requires: schemas/status_public/tables/user_achievement/fixtures/1572526077811_fixture

BEGIN;

  INSERT INTO 
    status_public.user_task (name, achievement_id, priority) VALUES
        ('accept_terms', (SELECT id FROM status_public.user_achievement WHERE name='profile_complete'), 10),
        ('set_password', (SELECT id FROM status_public.user_achievement WHERE name='profile_complete'), 20),
        ('verify_email', (SELECT id FROM status_public.user_achievement WHERE name='profile_complete'), 30),
        ('create_display_name', (SELECT id FROM status_public.user_achievement WHERE name='profile_complete'), 40),
        ('create_username', (SELECT id FROM status_public.user_achievement WHERE name='profile_complete'), 50),
        ('invite_code', (SELECT id FROM status_public.user_achievement WHERE name='profile_complete'), 60);

COMMIT;