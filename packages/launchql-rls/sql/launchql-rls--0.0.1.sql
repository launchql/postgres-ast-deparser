\echo Use "CREATE EXTENSION launchql-rls" to load this file. \quit
CREATE SCHEMA launchql_public;

CREATE TABLE launchql_public.user_profiles (
  
);

CREATE TABLE launchql_public.users (
  
);

ALTER TABLE launchql_public.users DISABLE ROW LEVEL SECURITY;

ALTER TABLE launchql_public.users ADD COLUMN  id uuid;

GRANT USAGE ON SCHEMA launchql_public TO authenticated;

GRANT USAGE ON SCHEMA launchql_public TO anonymous;

CREATE SCHEMA launchql_private;

CREATE FUNCTION launchql_private.tg_timestamps (  ) RETURNS trigger AS $EOFCODE$
BEGIN
    IF TG_OP = 'INSERT' THEN
      NEW.updated_at = NOW();
      NEW.created_at = NOW();
    ELSIF TG_OP = 'UPDATE' THEN
      NEW.updated_at = OLD.updated_at;
      NEW.created_at = NOW();
    END IF;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql;

CREATE FUNCTION launchql_private.tg_peoplestamps (  ) RETURNS trigger AS $EOFCODE$
BEGIN
    IF TG_OP = 'INSERT' THEN
      NEW.updated_by = "launchql_public".get_current_user_id();
      NEW.created_by = "launchql_public".get_current_user_id();
    ELSIF TG_OP = 'UPDATE' THEN
      NEW.updated_by = OLD.updated_by;
      NEW.created_by = "launchql_public".get_current_user_id();
    END IF;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql;

ALTER TABLE launchql_public.user_profiles DISABLE ROW LEVEL SECURITY;

ALTER TABLE launchql_public.user_profiles ADD COLUMN  id uuid;

ALTER TABLE launchql_public.user_profiles ALTER COLUMN id SET NOT NULL;

CREATE FUNCTION launchql_private.uuid_generate_v4 (  ) RETURNS uuid AS $EOFCODE$
DECLARE
    new_uuid char(36);
    md5_str char(32);
    md5_str2 char(32);
    uid text;
BEGIN
    md5_str := md5(concat(random(), now()));
    md5_str2 := md5(concat(random(), now()));
    
    new_uuid := concat(
        LEFT (md5('launchql'), 2),
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
$EOFCODE$ LANGUAGE plpgsql;

ALTER TABLE launchql_public.user_profiles ALTER COLUMN id SET DEFAULT launchql_private.uuid_generate_v4();

ALTER TABLE launchql_public.user_profiles ADD CONSTRAINT user_profiles_pkey PRIMARY KEY ( id );

ALTER TABLE launchql_public.user_profiles ADD COLUMN  profile_picture image;

ALTER TABLE launchql_public.user_profiles ADD COLUMN  bio text;

ALTER TABLE launchql_public.user_profiles ADD COLUMN  reputation numeric;

ALTER TABLE launchql_public.user_profiles ALTER COLUMN reputation SET DEFAULT 0;

ALTER TABLE launchql_public.user_profiles ADD COLUMN  first_name text;

ALTER TABLE launchql_public.user_profiles ADD COLUMN  last_name text;

ALTER TABLE launchql_public.user_profiles ADD COLUMN  tags citext[];

ALTER TABLE launchql_public.user_profiles ADD COLUMN  desired citext[];

ALTER TABLE launchql_public.user_profiles ADD COLUMN  created_by uuid;

ALTER TABLE launchql_public.user_profiles ADD COLUMN  updated_by uuid;

CREATE TRIGGER tg_peoplestamps 
 BEFORE INSERT OR UPDATE ON launchql_public.user_profiles 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. tg_peoplestamps (  );

ALTER TABLE launchql_public.user_profiles ADD COLUMN  created_at timestamptz;

ALTER TABLE launchql_public.user_profiles ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE launchql_public.user_profiles ADD COLUMN  updated_at timestamptz;

ALTER TABLE launchql_public.user_profiles ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER tg_timestamps 
 BEFORE INSERT OR UPDATE ON launchql_public.user_profiles 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. tg_timestamps (  );

ALTER TABLE launchql_public.user_profiles ADD COLUMN  user_id uuid;

ALTER TABLE launchql_public.user_profiles ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE launchql_public.user_profiles ADD CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY ( user_id ) REFERENCES launchql_public.users ( id );

CREATE INDEX user_profiles_user_id_idx ON launchql_public.user_profiles ( user_id );

ALTER TABLE launchql_public.user_profiles ADD CONSTRAINT user_profiles_user_id_key UNIQUE ( user_id );

ALTER TABLE launchql_public.user_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_insert_on_user_profiles ON launchql_public.user_profiles FOR INSERT TO authenticated WITH CHECK ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_update_on_user_profiles ON launchql_public.user_profiles FOR UPDATE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_delete_on_user_profiles ON launchql_public.user_profiles FOR DELETE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

GRANT INSERT ON TABLE launchql_public.user_profiles TO authenticated;

GRANT UPDATE ON TABLE launchql_public.user_profiles TO authenticated;

GRANT DELETE ON TABLE launchql_public.user_profiles TO authenticated;

CREATE POLICY authenticated_can_select_on_user_profiles ON launchql_public.user_profiles FOR SELECT TO authenticated USING ( (TRUE) );

GRANT SELECT ON TABLE launchql_public.user_profiles TO authenticated;

CREATE TABLE launchql_public.user_settings (
  
);

ALTER TABLE launchql_public.user_settings DISABLE ROW LEVEL SECURITY;

ALTER TABLE launchql_public.user_settings ADD COLUMN  id uuid;

ALTER TABLE launchql_public.user_settings ALTER COLUMN id SET NOT NULL;

ALTER TABLE launchql_public.user_settings ALTER COLUMN id SET DEFAULT launchql_private.uuid_generate_v4();

ALTER TABLE launchql_public.user_settings ADD CONSTRAINT user_settings_pkey PRIMARY KEY ( id );

ALTER TABLE launchql_public.user_settings ADD COLUMN  search_radius numeric;

ALTER TABLE launchql_public.user_settings ADD COLUMN  zip int;

ALTER TABLE launchql_public.user_settings ADD COLUMN  location geometry(point, 4326);

ALTER TABLE launchql_public.user_settings ADD COLUMN  created_by uuid;

ALTER TABLE launchql_public.user_settings ADD COLUMN  updated_by uuid;

CREATE TRIGGER tg_peoplestamps 
 BEFORE INSERT OR UPDATE ON launchql_public.user_settings 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. tg_peoplestamps (  );

ALTER TABLE launchql_public.user_settings ADD COLUMN  created_at timestamptz;

ALTER TABLE launchql_public.user_settings ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE launchql_public.user_settings ADD COLUMN  updated_at timestamptz;

ALTER TABLE launchql_public.user_settings ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER tg_timestamps 
 BEFORE INSERT OR UPDATE ON launchql_public.user_settings 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. tg_timestamps (  );

ALTER TABLE launchql_public.user_settings ADD COLUMN  user_id uuid;

ALTER TABLE launchql_public.user_settings ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE launchql_public.user_settings ADD CONSTRAINT user_settings_user_id_fkey FOREIGN KEY ( user_id ) REFERENCES launchql_public.users ( id );

CREATE INDEX user_settings_user_id_idx ON launchql_public.user_settings ( user_id );

ALTER TABLE launchql_public.user_settings ADD CONSTRAINT user_settings_user_id_key UNIQUE ( user_id );

CREATE INDEX user_location_gist_idx ON launchql_public.user_settings USING GIST ( location );

ALTER TABLE launchql_public.user_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_user_settings ON launchql_public.user_settings FOR SELECT TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_insert_on_user_settings ON launchql_public.user_settings FOR INSERT TO authenticated WITH CHECK ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_update_on_user_settings ON launchql_public.user_settings FOR UPDATE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_delete_on_user_settings ON launchql_public.user_settings FOR DELETE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

GRANT SELECT ON TABLE launchql_public.user_settings TO authenticated;

GRANT INSERT ON TABLE launchql_public.user_settings TO authenticated;

GRANT UPDATE ON TABLE launchql_public.user_settings TO authenticated;

GRANT DELETE ON TABLE launchql_public.user_settings TO authenticated;

CREATE TABLE launchql_public.user_characteristics (
  
);

ALTER TABLE launchql_public.user_characteristics DISABLE ROW LEVEL SECURITY;

ALTER TABLE launchql_public.user_characteristics ADD COLUMN  id uuid;

ALTER TABLE launchql_public.user_characteristics ALTER COLUMN id SET NOT NULL;

ALTER TABLE launchql_public.user_characteristics ALTER COLUMN id SET DEFAULT launchql_private.uuid_generate_v4();

ALTER TABLE launchql_public.user_characteristics ADD CONSTRAINT user_characteristics_pkey PRIMARY KEY ( id );

ALTER TABLE launchql_public.user_characteristics ADD COLUMN  income numeric;

ALTER TABLE launchql_public.user_characteristics ADD COLUMN  gender char(1);

ALTER TABLE launchql_public.user_characteristics ADD COLUMN  race text;

ALTER TABLE launchql_public.user_characteristics ADD COLUMN  age int;

ALTER TABLE launchql_public.user_characteristics ADD COLUMN  dob date;

ALTER TABLE launchql_public.user_characteristics ADD COLUMN  education text;

ALTER TABLE launchql_public.user_characteristics ADD COLUMN  home_ownership text;

ALTER TABLE launchql_public.user_characteristics ADD COLUMN  created_by uuid;

ALTER TABLE launchql_public.user_characteristics ADD COLUMN  updated_by uuid;

CREATE TRIGGER tg_peoplestamps 
 BEFORE INSERT OR UPDATE ON launchql_public.user_characteristics 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. tg_peoplestamps (  );

ALTER TABLE launchql_public.user_characteristics ADD COLUMN  created_at timestamptz;

ALTER TABLE launchql_public.user_characteristics ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE launchql_public.user_characteristics ADD COLUMN  updated_at timestamptz;

ALTER TABLE launchql_public.user_characteristics ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER tg_timestamps 
 BEFORE INSERT OR UPDATE ON launchql_public.user_characteristics 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. tg_timestamps (  );

ALTER TABLE launchql_public.user_characteristics ADD COLUMN  user_id uuid;

ALTER TABLE launchql_public.user_characteristics ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE launchql_public.user_characteristics ADD CONSTRAINT user_characteristics_user_id_fkey FOREIGN KEY ( user_id ) REFERENCES launchql_public.users ( id );

CREATE INDEX user_characteristics_user_id_idx ON launchql_public.user_characteristics ( user_id );

ALTER TABLE launchql_public.user_characteristics ADD CONSTRAINT user_characteristics_user_id_key UNIQUE ( user_id );

ALTER TABLE launchql_public.user_characteristics ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_user_characteristics ON launchql_public.user_characteristics FOR SELECT TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_insert_on_user_characteristics ON launchql_public.user_characteristics FOR INSERT TO authenticated WITH CHECK ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_update_on_user_characteristics ON launchql_public.user_characteristics FOR UPDATE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_delete_on_user_characteristics ON launchql_public.user_characteristics FOR DELETE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

GRANT SELECT ON TABLE launchql_public.user_characteristics TO authenticated;

GRANT INSERT ON TABLE launchql_public.user_characteristics TO authenticated;

GRANT UPDATE ON TABLE launchql_public.user_characteristics TO authenticated;

GRANT DELETE ON TABLE launchql_public.user_characteristics TO authenticated;

CREATE TABLE launchql_public.user_contacts (
  
);

ALTER TABLE launchql_public.user_contacts DISABLE ROW LEVEL SECURITY;

ALTER TABLE launchql_public.user_contacts ADD COLUMN  id uuid;

ALTER TABLE launchql_public.user_contacts ALTER COLUMN id SET NOT NULL;

ALTER TABLE launchql_public.user_contacts ALTER COLUMN id SET DEFAULT launchql_private.uuid_generate_v4();

ALTER TABLE launchql_public.user_contacts ADD CONSTRAINT user_contacts_pkey PRIMARY KEY ( id );

ALTER TABLE launchql_public.user_contacts ADD COLUMN  vcf jsonb;

ALTER TABLE launchql_public.user_contacts ADD COLUMN  full_name text;

ALTER TABLE launchql_public.user_contacts ADD COLUMN  emails email[];

ALTER TABLE launchql_public.user_contacts ADD COLUMN  device text;

ALTER TABLE launchql_public.user_contacts ADD COLUMN  created_by uuid;

ALTER TABLE launchql_public.user_contacts ADD COLUMN  updated_by uuid;

CREATE TRIGGER tg_peoplestamps 
 BEFORE INSERT OR UPDATE ON launchql_public.user_contacts 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. tg_peoplestamps (  );

ALTER TABLE launchql_public.user_contacts ADD COLUMN  created_at timestamptz;

ALTER TABLE launchql_public.user_contacts ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE launchql_public.user_contacts ADD COLUMN  updated_at timestamptz;

ALTER TABLE launchql_public.user_contacts ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER tg_timestamps 
 BEFORE INSERT OR UPDATE ON launchql_public.user_contacts 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. tg_timestamps (  );

ALTER TABLE launchql_public.user_contacts ADD COLUMN  user_id uuid;

ALTER TABLE launchql_public.user_contacts ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE launchql_public.user_contacts ADD CONSTRAINT user_contacts_user_id_fkey FOREIGN KEY ( user_id ) REFERENCES launchql_public.users ( id );

CREATE INDEX user_contacts_user_id_idx ON launchql_public.user_contacts ( user_id );

ALTER TABLE launchql_public.user_contacts ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_user_contacts ON launchql_public.user_contacts FOR SELECT TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_insert_on_user_contacts ON launchql_public.user_contacts FOR INSERT TO authenticated WITH CHECK ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_update_on_user_contacts ON launchql_public.user_contacts FOR UPDATE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_delete_on_user_contacts ON launchql_public.user_contacts FOR DELETE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

GRANT SELECT ON TABLE launchql_public.user_contacts TO authenticated;

GRANT INSERT ON TABLE launchql_public.user_contacts TO authenticated;

GRANT UPDATE ON TABLE launchql_public.user_contacts TO authenticated;

GRANT DELETE ON TABLE launchql_public.user_contacts TO authenticated;

CREATE TABLE launchql_public.user_connections (
  
);

ALTER TABLE launchql_public.user_connections DISABLE ROW LEVEL SECURITY;

ALTER TABLE launchql_public.user_connections ADD COLUMN  id uuid;

ALTER TABLE launchql_public.user_connections ALTER COLUMN id SET NOT NULL;

ALTER TABLE launchql_public.user_connections ALTER COLUMN id SET DEFAULT launchql_private.uuid_generate_v4();

ALTER TABLE launchql_public.user_connections ADD CONSTRAINT user_connections_pkey PRIMARY KEY ( id );

ALTER TABLE launchql_public.user_connections ADD COLUMN  accepted bool;

ALTER TABLE launchql_public.user_connections ADD COLUMN  created_by uuid;

ALTER TABLE launchql_public.user_connections ADD COLUMN  updated_by uuid;

CREATE TRIGGER tg_peoplestamps 
 BEFORE INSERT OR UPDATE ON launchql_public.user_connections 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. tg_peoplestamps (  );

ALTER TABLE launchql_public.user_connections ADD COLUMN  created_at timestamptz;

ALTER TABLE launchql_public.user_connections ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE launchql_public.user_connections ADD COLUMN  updated_at timestamptz;

ALTER TABLE launchql_public.user_connections ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER tg_timestamps 
 BEFORE INSERT OR UPDATE ON launchql_public.user_connections 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. tg_timestamps (  );

ALTER TABLE launchql_public.user_connections ADD COLUMN  requester_id uuid;

ALTER TABLE launchql_public.user_connections ALTER COLUMN requester_id SET NOT NULL;

ALTER TABLE launchql_public.user_connections ADD CONSTRAINT user_connections_requester_id_fkey FOREIGN KEY ( requester_id ) REFERENCES launchql_public.users ( id );

CREATE INDEX user_connections_requester_id_idx ON launchql_public.user_connections ( requester_id );

ALTER TABLE launchql_public.user_connections ADD COLUMN  responder_id uuid;

ALTER TABLE launchql_public.user_connections ALTER COLUMN responder_id SET NOT NULL;

ALTER TABLE launchql_public.user_connections ADD CONSTRAINT user_connections_responder_id_fkey FOREIGN KEY ( responder_id ) REFERENCES launchql_public.users ( id );

CREATE INDEX user_connections_responder_id_idx ON launchql_public.user_connections ( responder_id );

ALTER TABLE launchql_public.user_connections ADD CONSTRAINT user_connections_requester_id_responder_id_key UNIQUE ( requester_id, responder_id );

ALTER TABLE launchql_public.user_connections ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_user_connections ON launchql_public.user_connections FOR SELECT TO authenticated USING ( (((responder_id) = (launchql_public.get_current_user_id())) OR ((requester_id) = (launchql_public.get_current_user_id()))) );

CREATE POLICY authenticated_can_delete_on_user_connections ON launchql_public.user_connections FOR DELETE TO authenticated USING ( (((responder_id) = (launchql_public.get_current_user_id())) OR ((requester_id) = (launchql_public.get_current_user_id()))) );

GRANT SELECT ON TABLE launchql_public.user_connections TO authenticated;

GRANT DELETE ON TABLE launchql_public.user_connections TO authenticated;

CREATE POLICY authenticated_can_update_on_user_connections ON launchql_public.user_connections FOR UPDATE TO authenticated USING ( ((responder_id) = (launchql_public.get_current_user_id())) );

GRANT UPDATE ( accepted ) ON TABLE launchql_public.user_connections TO authenticated;

CREATE POLICY authenticated_can_insert_on_user_connections ON launchql_public.user_connections FOR INSERT TO authenticated WITH CHECK ( ((requester_id) = (launchql_public.get_current_user_id())) );

GRANT INSERT ON TABLE launchql_public.user_connections TO authenticated;

CREATE TABLE launchql_public.goals (
  
);

ALTER TABLE launchql_public.goals DISABLE ROW LEVEL SECURITY;

ALTER TABLE launchql_public.goals ADD COLUMN  id uuid;

ALTER TABLE launchql_public.goals ALTER COLUMN id SET NOT NULL;

ALTER TABLE launchql_public.goals ALTER COLUMN id SET DEFAULT launchql_private.uuid_generate_v4();

ALTER TABLE launchql_public.goals ADD CONSTRAINT goals_pkey PRIMARY KEY ( id );

ALTER TABLE launchql_public.goals ADD COLUMN  name text;

ALTER TABLE launchql_public.goals ADD COLUMN  short_name text;

ALTER TABLE launchql_public.goals ADD COLUMN  icon text;

ALTER TABLE launchql_public.goals ADD COLUMN  sub_head text;

ALTER TABLE launchql_public.goals ADD COLUMN  tags citext[];

ALTER TABLE launchql_public.goals ADD COLUMN  search tsvector;

ALTER TABLE launchql_public.goals ADD COLUMN  created_by uuid;

ALTER TABLE launchql_public.goals ADD COLUMN  updated_by uuid;

CREATE TRIGGER tg_peoplestamps 
 BEFORE INSERT OR UPDATE ON launchql_public.goals 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. tg_peoplestamps (  );

ALTER TABLE launchql_public.goals ADD COLUMN  created_at timestamptz;

ALTER TABLE launchql_public.goals ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE launchql_public.goals ADD COLUMN  updated_at timestamptz;

ALTER TABLE launchql_public.goals ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER tg_timestamps 
 BEFORE INSERT OR UPDATE ON launchql_public.goals 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. tg_timestamps (  );

CREATE FUNCTION launchql_private.goals_search_tsv (  ) RETURNS trigger AS $EOFCODE$ 
 
BEGIN
NEW.search = setweight(to_tsvector('pg_catalog.english', COALESCE(array_to_string(NEW.tags::citext[], ' '), '')), 'C') || setweight(to_tsvector('pg_catalog.english', COALESCE(NEW.sub_head, '')), 'B') || setweight(to_tsvector('pg_catalog.simple', COALESCE(NEW.name, '')), 'A');
RETURN NEW;
END; 
 $EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER goals_search_tsv_insert_tg 
 BEFORE INSERT ON launchql_public.goals 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. goals_search_tsv (  );

CREATE TRIGGER goals_search_tsv_update_tg 
 BEFORE UPDATE ON launchql_public.goals 
 FOR EACH ROW
 WHEN ( (old.name IS DISTINCT FROM new.name OR old.sub_head IS DISTINCT FROM new.sub_head OR old.tags IS DISTINCT FROM new.tags) ) 
 EXECUTE PROCEDURE launchql_private. goals_search_tsv (  );

ALTER TABLE launchql_public.goals ADD CONSTRAINT goals_name_key UNIQUE ( name );

CREATE INDEX goals_vector_index ON launchql_public.goals USING GIN ( search );

ALTER TABLE launchql_public.goals ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_goals ON launchql_public.goals FOR SELECT TO authenticated USING ( (TRUE) );

GRANT SELECT ON TABLE launchql_public.goals TO authenticated;

CREATE TABLE launchql_public.organization_profiles (
  
);

ALTER TABLE launchql_public.organization_profiles DISABLE ROW LEVEL SECURITY;

ALTER TABLE launchql_public.organization_profiles ADD COLUMN  id uuid;

ALTER TABLE launchql_public.organization_profiles ALTER COLUMN id SET NOT NULL;

ALTER TABLE launchql_public.organization_profiles ALTER COLUMN id SET DEFAULT launchql_private.uuid_generate_v4();

ALTER TABLE launchql_public.organization_profiles ADD CONSTRAINT organization_profiles_pkey PRIMARY KEY ( id );

ALTER TABLE launchql_public.organization_profiles ADD COLUMN  name text;

ALTER TABLE launchql_public.organization_profiles ADD COLUMN  profile_picture image;

ALTER TABLE launchql_public.organization_profiles ADD COLUMN  description text;

ALTER TABLE launchql_public.organization_profiles ADD COLUMN  reputation numeric;

ALTER TABLE launchql_public.organization_profiles ALTER COLUMN reputation SET DEFAULT 0;

ALTER TABLE launchql_public.organization_profiles ADD COLUMN  tags citext[];

ALTER TABLE launchql_public.organization_profiles ADD COLUMN  created_by uuid;

ALTER TABLE launchql_public.organization_profiles ADD COLUMN  updated_by uuid;

CREATE TRIGGER tg_peoplestamps 
 BEFORE INSERT OR UPDATE ON launchql_public.organization_profiles 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. tg_peoplestamps (  );

ALTER TABLE launchql_public.organization_profiles ADD COLUMN  created_at timestamptz;

ALTER TABLE launchql_public.organization_profiles ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE launchql_public.organization_profiles ADD COLUMN  updated_at timestamptz;

ALTER TABLE launchql_public.organization_profiles ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER tg_timestamps 
 BEFORE INSERT OR UPDATE ON launchql_public.organization_profiles 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. tg_timestamps (  );

ALTER TABLE launchql_public.organization_profiles ADD COLUMN  organization_id uuid;

ALTER TABLE launchql_public.organization_profiles ALTER COLUMN organization_id SET NOT NULL;

ALTER TABLE launchql_public.organization_profiles ADD CONSTRAINT organization_profiles_organization_id_fkey FOREIGN KEY ( organization_id ) REFERENCES launchql_public.users ( id );

CREATE INDEX organization_profiles_organization_id_idx ON launchql_public.organization_profiles ( organization_id );

ALTER TABLE launchql_public.organization_profiles ADD CONSTRAINT organization_profiles_organization_id_key UNIQUE ( organization_id );

ALTER TABLE launchql_public.organization_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_insert_on_organization_profiles ON launchql_public.organization_profiles FOR INSERT TO authenticated WITH CHECK ( ((organization_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_update_on_organization_profiles ON launchql_public.organization_profiles FOR UPDATE TO authenticated USING ( ((organization_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_delete_on_organization_profiles ON launchql_public.organization_profiles FOR DELETE TO authenticated USING ( ((organization_id) = (launchql_public.get_current_user_id())) );

GRANT INSERT ON TABLE launchql_public.organization_profiles TO authenticated;

GRANT UPDATE ON TABLE launchql_public.organization_profiles TO authenticated;

GRANT DELETE ON TABLE launchql_public.organization_profiles TO authenticated;

CREATE POLICY authenticated_can_select_on_organization_profiles ON launchql_public.organization_profiles FOR SELECT TO authenticated USING ( (TRUE) );

GRANT SELECT ON TABLE launchql_public.organization_profiles TO authenticated;

ALTER TABLE collections_public.database ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_database ON collections_public.database FOR SELECT TO authenticated USING ( ((owner_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_insert_on_database ON collections_public.database FOR INSERT TO authenticated WITH CHECK ( ((owner_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_update_on_database ON collections_public.database FOR UPDATE TO authenticated USING ( ((owner_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_delete_on_database ON collections_public.database FOR DELETE TO authenticated USING ( ((owner_id) = (launchql_public.get_current_user_id())) );

GRANT SELECT ON TABLE collections_public.database TO authenticated;

GRANT INSERT ON TABLE collections_public.database TO authenticated;

GRANT UPDATE ON TABLE collections_public.database TO authenticated;

GRANT DELETE ON TABLE collections_public.database TO authenticated;

ALTER TABLE collections_public.schema ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_schema ON collections_public.schema FOR SELECT TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_insert_on_schema ON collections_public.schema FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_update_on_schema ON collections_public.schema FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_delete_on_schema ON collections_public.schema FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

GRANT SELECT ON TABLE collections_public.schema TO authenticated;

GRANT INSERT ON TABLE collections_public.schema TO authenticated;

GRANT UPDATE ON TABLE collections_public.schema TO authenticated;

GRANT DELETE ON TABLE collections_public.schema TO authenticated;

ALTER TABLE collections_public.foreign_key_constraint ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_foreign_key_constraint ON collections_public.foreign_key_constraint FOR SELECT TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_insert_on_foreign_key_constraint ON collections_public.foreign_key_constraint FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_update_on_foreign_key_constraint ON collections_public.foreign_key_constraint FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_delete_on_foreign_key_constraint ON collections_public.foreign_key_constraint FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

GRANT SELECT ON TABLE collections_public.foreign_key_constraint TO authenticated;

GRANT INSERT ON TABLE collections_public.foreign_key_constraint TO authenticated;

GRANT UPDATE ON TABLE collections_public.foreign_key_constraint TO authenticated;

GRANT DELETE ON TABLE collections_public.foreign_key_constraint TO authenticated;

ALTER TABLE collections_public.full_text_search ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_full_text_search ON collections_public.full_text_search FOR SELECT TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_insert_on_full_text_search ON collections_public.full_text_search FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_update_on_full_text_search ON collections_public.full_text_search FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_delete_on_full_text_search ON collections_public.full_text_search FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

GRANT SELECT ON TABLE collections_public.full_text_search TO authenticated;

GRANT INSERT ON TABLE collections_public.full_text_search TO authenticated;

GRANT UPDATE ON TABLE collections_public.full_text_search TO authenticated;

GRANT DELETE ON TABLE collections_public.full_text_search TO authenticated;

ALTER TABLE collections_public.index ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_index ON collections_public.index FOR SELECT TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_insert_on_index ON collections_public.index FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_update_on_index ON collections_public.index FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_delete_on_index ON collections_public.index FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

GRANT SELECT ON TABLE collections_public.index TO authenticated;

GRANT INSERT ON TABLE collections_public.index TO authenticated;

GRANT UPDATE ON TABLE collections_public.index TO authenticated;

GRANT DELETE ON TABLE collections_public.index TO authenticated;

ALTER TABLE collections_public.rls_function ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_rls_function ON collections_public.rls_function FOR SELECT TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_insert_on_rls_function ON collections_public.rls_function FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_update_on_rls_function ON collections_public.rls_function FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_delete_on_rls_function ON collections_public.rls_function FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

GRANT SELECT ON TABLE collections_public.rls_function TO authenticated;

GRANT INSERT ON TABLE collections_public.rls_function TO authenticated;

GRANT UPDATE ON TABLE collections_public.rls_function TO authenticated;

GRANT DELETE ON TABLE collections_public.rls_function TO authenticated;

ALTER TABLE collections_public.policy ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_policy ON collections_public.policy FOR SELECT TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_insert_on_policy ON collections_public.policy FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_update_on_policy ON collections_public.policy FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_delete_on_policy ON collections_public.policy FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

GRANT SELECT ON TABLE collections_public.policy TO authenticated;

GRANT INSERT ON TABLE collections_public.policy TO authenticated;

GRANT UPDATE ON TABLE collections_public.policy TO authenticated;

GRANT DELETE ON TABLE collections_public.policy TO authenticated;

ALTER TABLE collections_public.primary_key_constraint ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_primary_key_constraint ON collections_public.primary_key_constraint FOR SELECT TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_insert_on_primary_key_constraint ON collections_public.primary_key_constraint FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_update_on_primary_key_constraint ON collections_public.primary_key_constraint FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_delete_on_primary_key_constraint ON collections_public.primary_key_constraint FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

GRANT SELECT ON TABLE collections_public.primary_key_constraint TO authenticated;

GRANT INSERT ON TABLE collections_public.primary_key_constraint TO authenticated;

GRANT UPDATE ON TABLE collections_public.primary_key_constraint TO authenticated;

GRANT DELETE ON TABLE collections_public.primary_key_constraint TO authenticated;

ALTER TABLE collections_public.procedure ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_procedure ON collections_public.procedure FOR SELECT TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_insert_on_procedure ON collections_public.procedure FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_update_on_procedure ON collections_public.procedure FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_delete_on_procedure ON collections_public.procedure FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

GRANT SELECT ON TABLE collections_public.procedure TO authenticated;

GRANT INSERT ON TABLE collections_public.procedure TO authenticated;

GRANT UPDATE ON TABLE collections_public.procedure TO authenticated;

GRANT DELETE ON TABLE collections_public.procedure TO authenticated;

ALTER TABLE collections_public.schema_grant ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_schema_grant ON collections_public.schema_grant FOR SELECT TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_insert_on_schema_grant ON collections_public.schema_grant FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_update_on_schema_grant ON collections_public.schema_grant FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_delete_on_schema_grant ON collections_public.schema_grant FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

GRANT SELECT ON TABLE collections_public.schema_grant TO authenticated;

GRANT INSERT ON TABLE collections_public.schema_grant TO authenticated;

GRANT UPDATE ON TABLE collections_public.schema_grant TO authenticated;

GRANT DELETE ON TABLE collections_public.schema_grant TO authenticated;

ALTER TABLE collections_public.table_grant ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_table_grant ON collections_public.table_grant FOR SELECT TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_insert_on_table_grant ON collections_public.table_grant FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_update_on_table_grant ON collections_public.table_grant FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_delete_on_table_grant ON collections_public.table_grant FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

GRANT SELECT ON TABLE collections_public.table_grant TO authenticated;

GRANT INSERT ON TABLE collections_public.table_grant TO authenticated;

GRANT UPDATE ON TABLE collections_public.table_grant TO authenticated;

GRANT DELETE ON TABLE collections_public.table_grant TO authenticated;

ALTER TABLE collections_public.trigger ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_trigger ON collections_public.trigger FOR SELECT TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_insert_on_trigger ON collections_public.trigger FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_update_on_trigger ON collections_public.trigger FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_delete_on_trigger ON collections_public.trigger FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

GRANT SELECT ON TABLE collections_public.trigger TO authenticated;

GRANT INSERT ON TABLE collections_public.trigger TO authenticated;

GRANT UPDATE ON TABLE collections_public.trigger TO authenticated;

GRANT DELETE ON TABLE collections_public.trigger TO authenticated;

ALTER TABLE collections_public.trigger_function ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_trigger_function ON collections_public.trigger_function FOR SELECT TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_insert_on_trigger_function ON collections_public.trigger_function FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_update_on_trigger_function ON collections_public.trigger_function FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_delete_on_trigger_function ON collections_public.trigger_function FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

GRANT SELECT ON TABLE collections_public.trigger_function TO authenticated;

GRANT INSERT ON TABLE collections_public.trigger_function TO authenticated;

GRANT UPDATE ON TABLE collections_public.trigger_function TO authenticated;

GRANT DELETE ON TABLE collections_public.trigger_function TO authenticated;

ALTER TABLE collections_public.unique_constraint ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_unique_constraint ON collections_public.unique_constraint FOR SELECT TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_insert_on_unique_constraint ON collections_public.unique_constraint FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_update_on_unique_constraint ON collections_public.unique_constraint FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_delete_on_unique_constraint ON collections_public.unique_constraint FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

GRANT SELECT ON TABLE collections_public.unique_constraint TO authenticated;

GRANT INSERT ON TABLE collections_public.unique_constraint TO authenticated;

GRANT UPDATE ON TABLE collections_public.unique_constraint TO authenticated;

GRANT DELETE ON TABLE collections_public.unique_constraint TO authenticated;

ALTER TABLE collections_public.field ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_field ON collections_public.field FOR SELECT TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_insert_on_field ON collections_public.field FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_update_on_field ON collections_public.field FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

CREATE POLICY authenticated_can_delete_on_field ON collections_public.field FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY (launchql_public.get_current_role_ids()) FROM collections_public.database AS p WHERE ((p.id) = (database_id))) );

GRANT SELECT ON TABLE collections_public.field TO authenticated;

GRANT INSERT ON TABLE collections_public.field TO authenticated;

GRANT UPDATE ON TABLE collections_public.field TO authenticated;

GRANT DELETE ON TABLE collections_public.field TO authenticated;

CREATE SCHEMA launchql_jobs;

GRANT USAGE ON SCHEMA launchql_jobs TO authenticated;

GRANT USAGE ON SCHEMA launchql_jobs TO anonymous;

CREATE SCHEMA IF NOT EXISTS launchql_jobs;

GRANT USAGE ON SCHEMA launchql_jobs TO administrator;

ALTER DEFAULT PRIVILEGES IN SCHEMA launchql_jobs 
 GRANT EXECUTE ON FUNCTIONS  TO administrator;

CREATE FUNCTION launchql_jobs.json_build_object_apply ( arguments text[] ) RETURNS json AS $EOFCODE$
DECLARE
  arg text;
  _sql text;
  _res json;
  args text[];
BEGIN
  _sql = 'SELECT json_build_object(';
  FOR arg IN
  SELECT
    unnest(arguments)
    LOOP
      args = array_append(args, format('''%s''', arg));
    END LOOP;
  _sql = _sql || format('%s);', array_to_string(args, ','));
  EXECUTE _sql INTO _res;
  RETURN _res;
END;
$EOFCODE$ LANGUAGE plpgsql;

CREATE TABLE launchql_jobs.jobs (
 	id bigserial PRIMARY KEY,
	queue_name text DEFAULT ( public.gen_random_uuid()::text ),
	task_identifier text NOT NULL,
	payload json DEFAULT ( '{}'::json ) NOT NULL,
	priority int DEFAULT ( 0 ) NOT NULL,
	run_at timestamptz DEFAULT ( now() ) NOT NULL,
	attempts int DEFAULT ( 0 ) NOT NULL,
	max_attempts int DEFAULT ( 25 ) NOT NULL,
	key text,
	last_error text,
	locked_at timestamptz,
	locked_by text,
	CHECK ( ((length(key)) < (513)) ),
	CHECK ( ((length(task_identifier)) < (127)) ),
	CHECK ( ((max_attempts) > (0)) ),
	CHECK ( ((length(queue_name)) < (127)) ),
	CHECK ( ((length(locked_by)) > (3)) ),
	UNIQUE ( key ) 
);

CREATE TABLE launchql_jobs.job_queues (
 	queue_name text NOT NULL PRIMARY KEY,
	job_count int DEFAULT ( 0 ) NOT NULL,
	locked_at timestamptz,
	locked_by text 
);

CREATE FUNCTION launchql_jobs.add_job ( identifier text, payload json DEFAULT '{}'::json, job_key text DEFAULT NULL, queue_name text DEFAULT NULL, run_at timestamptz DEFAULT now(), max_attempts int DEFAULT 25, priority int DEFAULT 0 ) RETURNS launchql_jobs.jobs AS $EOFCODE$
DECLARE
  v_job "launchql_jobs".jobs;
BEGIN
  IF job_key IS NOT NULL THEN
    INSERT INTO "launchql_jobs".jobs (task_identifier, payload, queue_name, run_at, max_attempts, KEY, priority)
      VALUES (identifier, coalesce(payload, '{}'::json), queue_name, coalesce(run_at, now()), coalesce(max_attempts, 25), job_key, coalesce(priority, 0))
    ON CONFLICT (KEY)
      DO UPDATE SET
        task_identifier = excluded.task_identifier, payload = excluded.payload, queue_name = excluded.queue_name, max_attempts = excluded.max_attempts, run_at = excluded.run_at, priority = excluded.priority,
        attempts = 0, last_error = NULL
      WHERE
        jobs.locked_at IS NULL
      RETURNING
        * INTO v_job;
    IF NOT (v_job IS NULL) THEN
      RETURN v_job;
    END IF;
    UPDATE
      "launchql_jobs".jobs
    SET
      KEY = NULL,
      attempts = jobs.max_attempts
    WHERE
      KEY = job_key;
  END IF;
  INSERT INTO "launchql_jobs".jobs (task_identifier, payload, queue_name, run_at, max_attempts, priority)
    VALUES (identifier, payload, queue_name, run_at, max_attempts, priority)
  RETURNING
    * INTO v_job;
  RETURN v_job;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE TABLE launchql_jobs.scheduled_jobs (
 	id bigserial PRIMARY KEY,
	queue_name text DEFAULT ( public.gen_random_uuid()::text ),
	task_identifier text NOT NULL,
	payload json DEFAULT ( '{}'::json ) NOT NULL,
	priority int DEFAULT ( 0 ) NOT NULL,
	max_attempts int DEFAULT ( 25 ) NOT NULL,
	key text,
	locked_at timestamptz,
	locked_by text,
	schedule_info json NOT NULL,
	last_scheduled timestamptz,
	last_scheduled_id bigint,
	CHECK ( ((length(key)) < (513)) ),
	CHECK ( ((length(task_identifier)) < (127)) ),
	CHECK ( ((max_attempts) > (0)) ),
	CHECK ( ((length(queue_name)) < (127)) ),
	CHECK ( ((length(locked_by)) > (3)) ),
	UNIQUE ( key ) 
);

CREATE FUNCTION launchql_jobs.add_scheduled_job ( identifier text, payload json DEFAULT '{}'::json, schedule_info json DEFAULT '{}'::json, job_key text DEFAULT NULL, queue_name text DEFAULT NULL, max_attempts int DEFAULT 25, priority int DEFAULT 0 ) RETURNS launchql_jobs.scheduled_jobs AS $EOFCODE$
DECLARE
  v_job "launchql_jobs".scheduled_jobs;
BEGIN
  IF job_key IS NOT NULL THEN
    INSERT INTO "launchql_jobs".scheduled_jobs (task_identifier, payload, queue_name, schedule_info, max_attempts, KEY, priority)
      VALUES (identifier, coalesce(payload, '{}'::json), queue_name, schedule_info, coalesce(max_attempts, 25), job_key, coalesce(priority, 0))
    ON CONFLICT (KEY)
      DO UPDATE SET
        task_identifier = excluded.task_identifier, payload = excluded.payload, queue_name = excluded.queue_name, max_attempts = excluded.max_attempts, schedule_info = excluded.schedule_info, priority = excluded.priority
      WHERE
        scheduled_jobs.locked_at IS NULL
      RETURNING
        * INTO v_job;
    IF NOT (v_job IS NULL) THEN
      RETURN v_job;
    END IF;
    DELETE FROM "launchql_jobs".scheduled_jobs
    WHERE KEY = job_key;
  END IF;
  INSERT INTO "launchql_jobs".scheduled_jobs (task_identifier, payload, queue_name, schedule_info, max_attempts, priority)
    VALUES (identifier, payload, queue_name, schedule_info, max_attempts, priority)
  RETURNING
    * INTO v_job;
  RETURN v_job;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE FUNCTION launchql_jobs.complete_job ( worker_id text, job_id bigint ) RETURNS launchql_jobs.jobs LANGUAGE plpgsql AS $EOFCODE$
DECLARE
  v_row "launchql_jobs".jobs;
BEGIN
  DELETE FROM "launchql_jobs".jobs
  WHERE id = job_id
  RETURNING
    * INTO v_row;
  IF v_row.queue_name IS NOT NULL THEN
    UPDATE
      "launchql_jobs".job_queues
    SET
      locked_by = NULL,
      locked_at = NULL
    WHERE
      queue_name = v_row.queue_name
      AND locked_by = worker_id;
  END IF;
  RETURN v_row;
END;
$EOFCODE$;

CREATE FUNCTION launchql_jobs.complete_jobs ( job_ids bigint[] ) RETURNS SETOF launchql_jobs.jobs LANGUAGE sql AS $EOFCODE$
  DELETE FROM "launchql_jobs".jobs
  WHERE id = ANY (job_ids)
    AND (locked_by IS NULL
      OR locked_at < NOW() - interval '4 hours')
  RETURNING
    *;
$EOFCODE$;

CREATE FUNCTION launchql_jobs.do_notify (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  PERFORM
    pg_notify(TG_ARGV[0], '');
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql;

CREATE FUNCTION launchql_jobs.fail_job ( worker_id text, job_id bigint, error_message text ) RETURNS launchql_jobs.jobs LANGUAGE plpgsql STRICT AS $EOFCODE$
DECLARE
  v_row "launchql_jobs".jobs;
BEGIN
  UPDATE
    "launchql_jobs".jobs
  SET
    last_error = error_message,
    run_at = greatest (now(), run_at) + (exp(least (attempts, 10))::text || ' seconds')::interval,
    locked_by = NULL,
    locked_at = NULL
  WHERE
    id = job_id
    AND locked_by = worker_id
  RETURNING
    * INTO v_row;
  IF v_row.queue_name IS NOT NULL THEN
    UPDATE
      "launchql_jobs".job_queues
    SET
      locked_by = NULL,
      locked_at = NULL
    WHERE
      queue_name = v_row.queue_name
      AND locked_by = worker_id;
  END IF;
  RETURN v_row;
END;
$EOFCODE$;

CREATE FUNCTION launchql_jobs.get_job ( worker_id text, task_identifiers text[] DEFAULT NULL, job_expiry interval DEFAULT '4 hours' ) RETURNS launchql_jobs.jobs LANGUAGE plpgsql AS $EOFCODE$
DECLARE
  v_job_id bigint;
  v_queue_name text;
  v_row "launchql_jobs".jobs;
  v_now timestamptz = now();
BEGIN
  IF worker_id IS NULL THEN
    RAISE exception 'INVALID_WORKER_ID';
  END IF;
  SELECT
    jobs.queue_name,
    jobs.id INTO v_queue_name,
    v_job_id
  FROM
    "launchql_jobs".jobs
  WHERE (jobs.locked_at IS NULL
    OR jobs.locked_at < (v_now - job_expiry))
    AND (jobs.queue_name IS NULL
      OR EXISTS (
        SELECT
          1
        FROM
          "launchql_jobs".job_queues
        WHERE
          job_queues.queue_name = jobs.queue_name
          AND (job_queues.locked_at IS NULL
            OR job_queues.locked_at < (v_now - job_expiry))
        FOR UPDATE
          SKIP LOCKED))
    AND run_at <= v_now
    AND attempts < max_attempts
    AND (task_identifiers IS NULL
      OR task_identifier = ANY (task_identifiers))
  ORDER BY
    priority ASC,
    run_at ASC,
    id ASC
  LIMIT 1
  FOR UPDATE
    SKIP LOCKED;
  IF v_job_id IS NULL THEN
    RETURN NULL;
  END IF;
  IF v_queue_name IS NOT NULL THEN
    UPDATE
      "launchql_jobs".job_queues
    SET
      locked_by = worker_id,
      locked_at = v_now
    WHERE
      job_queues.queue_name = v_queue_name;
  END IF;
  UPDATE
    "launchql_jobs".jobs
  SET
    attempts = attempts + 1,
    locked_by = worker_id,
    locked_at = v_now
  WHERE
    id = v_job_id
  RETURNING
    * INTO v_row;
  RETURN v_row;
END;
$EOFCODE$;

CREATE FUNCTION launchql_jobs.get_scheduled_job ( worker_id text, task_identifiers text[] DEFAULT NULL ) RETURNS launchql_jobs.scheduled_jobs LANGUAGE plpgsql AS $EOFCODE$
DECLARE
  v_job_id bigint;
  v_row "launchql_jobs".scheduled_jobs;
BEGIN
  IF worker_id IS NULL THEN
    RAISE exception 'INVALID_WORKER_ID';
  END IF;
  SELECT
    scheduled_jobs.id INTO v_job_id
  FROM
    "launchql_jobs".scheduled_jobs
  WHERE (scheduled_jobs.locked_at IS NULL)
    AND (task_identifiers IS NULL
      OR task_identifier = ANY (task_identifiers))
  ORDER BY
    priority ASC,
    id ASC
  LIMIT 1
  FOR UPDATE
    SKIP LOCKED;
  IF v_job_id IS NULL THEN
    RETURN NULL;
  END IF;
  UPDATE
    "launchql_jobs".scheduled_jobs
  SET
    locked_by = worker_id,
    locked_at = NOW()
  WHERE
    id = v_job_id
  RETURNING
    * INTO v_row;
  RETURN v_row;
END;
$EOFCODE$;

CREATE FUNCTION launchql_jobs.permanently_fail_jobs ( job_ids bigint[], error_message text DEFAULT NULL ) RETURNS SETOF launchql_jobs.jobs LANGUAGE sql AS $EOFCODE$
  UPDATE
    "launchql_jobs".jobs
  SET
    last_error = coalesce(error_message, 'Manually marked as failed'),
    attempts = max_attempts
  WHERE
    id = ANY (job_ids)
    AND (locked_by IS NULL
      OR locked_at < NOW() - interval '4 hours')
  RETURNING
    *;
$EOFCODE$;

CREATE FUNCTION launchql_jobs.release_jobs ( worker_id text ) RETURNS void AS $EOFCODE$
DECLARE
BEGIN
  UPDATE
    "launchql_jobs".jobs
  SET
    locked_at = NULL,
    locked_by = NULL,
    attempts = GREATEST (attempts - 1, 0)
  WHERE
    locked_by = worker_id;
  UPDATE
    "launchql_jobs".job_queues
  SET
    locked_at = NULL,
    locked_by = NULL
  WHERE
    locked_by = worker_id;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION launchql_jobs.release_scheduled_jobs ( worker_id text, ids bigint[] DEFAULT NULL ) RETURNS void AS $EOFCODE$
DECLARE
BEGIN
  UPDATE
    "launchql_jobs".scheduled_jobs s
  SET
    locked_at = NULL,
    locked_by = NULL
  WHERE
    locked_by = worker_id
    AND (ids IS NULL
      OR s.id = ANY (ids));
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION launchql_jobs.reschedule_jobs ( job_ids bigint[], run_at timestamptz DEFAULT NULL, priority int DEFAULT NULL, attempts int DEFAULT NULL, max_attempts int DEFAULT NULL ) RETURNS SETOF launchql_jobs.jobs LANGUAGE sql AS $EOFCODE$
  UPDATE
    "launchql_jobs".jobs
  SET
    run_at = coalesce(reschedule_jobs.run_at, jobs.run_at),
    priority = coalesce(reschedule_jobs.priority, jobs.priority),
    attempts = coalesce(reschedule_jobs.attempts, jobs.attempts),
    max_attempts = coalesce(reschedule_jobs.max_attempts, jobs.max_attempts)
  WHERE
    id = ANY (job_ids)
    AND (locked_by IS NULL
      OR locked_at < NOW() - interval '4 hours')
  RETURNING
    *;
$EOFCODE$;

CREATE FUNCTION launchql_jobs.run_scheduled_job ( id bigint, job_expiry interval DEFAULT '1 hours' ) RETURNS launchql_jobs.jobs AS $EOFCODE$
DECLARE
  j "launchql_jobs".jobs;
  last_id bigint;
  lkd_by text;
BEGIN
  SELECT
    last_scheduled_id
  FROM
    "launchql_jobs".scheduled_jobs s
  WHERE
    s.id = run_scheduled_job.id INTO last_id;
  IF (last_id IS NOT NULL) THEN
    SELECT
      locked_by
    FROM
      "launchql_jobs".jobs js
    WHERE
      js.id = last_id
      AND (js.locked_at IS NULL -- never been run
        OR js.locked_at >= (NOW() - job_expiry)
) INTO lkd_by;
    IF (FOUND) THEN
      RAISE EXCEPTION 'ALREADY_SCHEDULED';
    END IF;
  END IF;
  INSERT INTO "launchql_jobs".jobs (queue_name, task_identifier, payload, priority, max_attempts, KEY)
  SELECT
    queue_name,
    task_identifier,
    payload,
    priority,
    max_attempts,
    KEY
  FROM
    "launchql_jobs".scheduled_jobs s
  WHERE
    s.id = run_scheduled_job.id
  RETURNING
    * INTO j;
  UPDATE
    "launchql_jobs".scheduled_jobs s
  SET
    last_scheduled = NOW(),
    last_scheduled_id = j.id
  WHERE
    s.id = run_scheduled_job.id;
  RETURN j;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE launchql_jobs.job_queues TO administrator;

CREATE INDEX job_queues_locked_by_idx ON launchql_jobs.job_queues ( locked_by );

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE launchql_jobs.jobs TO administrator;

CREATE INDEX jobs_locked_by_idx ON launchql_jobs.jobs ( locked_by );

CREATE INDEX priority_run_at_id_idx ON launchql_jobs.jobs ( priority, run_at, id );

CREATE FUNCTION launchql_jobs.tg_decrease_job_queue_count (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  v_new_job_count int;
BEGIN
  UPDATE
    "launchql_jobs".job_queues
  SET
    job_count = job_queues.job_count - 1
  WHERE
    queue_name = OLD.queue_name
  RETURNING
    job_count INTO v_new_job_count;
  IF v_new_job_count <= 0 THEN
    DELETE FROM "launchql_jobs".job_queues
    WHERE queue_name = OLD.queue_name
      AND job_count <= 0;
  END IF;
  RETURN OLD;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER decrease_job_queue_count_on_delete 
 AFTER DELETE ON launchql_jobs.jobs 
 FOR EACH ROW
 WHEN ( old.queue_name IS NOT NULL ) 
 EXECUTE PROCEDURE launchql_jobs. tg_decrease_job_queue_count (  );

CREATE TRIGGER decrease_job_queue_count_on_update 
 AFTER UPDATE OF queue_name ON launchql_jobs.jobs 
 FOR EACH ROW
 WHEN ( (new.queue_name IS DISTINCT FROM old.queue_name AND old.queue_name IS NOT NULL) ) 
 EXECUTE PROCEDURE launchql_jobs. tg_decrease_job_queue_count (  );

CREATE FUNCTION launchql_jobs.tg_increase_job_queue_count (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  INSERT INTO "launchql_jobs".job_queues (queue_name, job_count)
    VALUES (NEW.queue_name, 1)
  ON CONFLICT (queue_name)
    DO UPDATE SET
      job_count = job_queues.job_count + 1;
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER _500_increase_job_queue_count_on_insert 
 AFTER INSERT ON launchql_jobs.jobs 
 FOR EACH ROW
 WHEN ( new.queue_name IS NOT NULL ) 
 EXECUTE PROCEDURE launchql_jobs. tg_increase_job_queue_count (  );

CREATE TRIGGER _500_increase_job_queue_count_on_update 
 AFTER UPDATE OF queue_name ON launchql_jobs.jobs 
 FOR EACH ROW
 WHEN ( (new.queue_name IS DISTINCT FROM old.queue_name AND new.queue_name IS NOT NULL) ) 
 EXECUTE PROCEDURE launchql_jobs. tg_increase_job_queue_count (  );

CREATE TRIGGER _900_notify_worker 
 AFTER INSERT ON launchql_jobs.jobs 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_jobs. do_notify ( 'jobs:insert' );

CREATE FUNCTION launchql_jobs.tg_update_timestamps (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.created_at = NOW();
    NEW.updated_at = NOW();
  ELSIF TG_OP = 'UPDATE' THEN
    NEW.created_at = OLD.created_at;
    NEW.updated_at = greatest (now(), OLD.updated_at + interval '1 millisecond');
  END IF;
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql;

ALTER TABLE launchql_jobs.jobs ADD COLUMN  created_at timestamptz;

ALTER TABLE launchql_jobs.jobs ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE launchql_jobs.jobs ADD COLUMN  updated_at timestamptz;

ALTER TABLE launchql_jobs.jobs ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER _100_update_jobs_modtime_tg 
 BEFORE INSERT OR UPDATE ON launchql_jobs.jobs 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_jobs. tg_update_timestamps (  );

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE launchql_jobs.scheduled_jobs TO administrator;

CREATE INDEX scheduled_jobs_locked_by_idx ON launchql_jobs.scheduled_jobs ( locked_by );

CREATE INDEX scheduled_jobs_priority_id_idx ON launchql_jobs.scheduled_jobs ( priority, id );

CREATE TRIGGER _900_notify_scheduled_job 
 AFTER INSERT ON launchql_jobs.scheduled_jobs 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_jobs. do_notify ( 'scheduled_jobs:insert' );

CREATE FUNCTION launchql_jobs.trigger_job_with_fields (  ) RETURNS trigger AS $EOFCODE$
DECLARE
  arg text;
  fn text;
  i int;
  args text[];
BEGIN
  FOR i IN
  SELECT
    *
  FROM
    generate_series(1, TG_NARGS) g (i)
    LOOP
      IF (i = 1) THEN
        fn = TG_ARGV[i - 1];
      ELSE
        args = array_append(args, TG_ARGV[i - 1]);
        IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
          EXECUTE format('SELECT ($1).%s::text', TG_ARGV[i - 1])
          USING NEW INTO arg;
        END IF;
        IF (TG_OP = 'DELETE') THEN
          EXECUTE format('SELECT ($1).%s::text', TG_ARGV[i - 1])
          USING OLD INTO arg;
        END IF;
        args = array_append(args, arg);
      END IF;
    END LOOP;
  PERFORM
    "launchql_jobs".add_job (fn, "launchql_jobs".json_build_object_apply (args));
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    RETURN NEW;
  END IF;
  IF (TG_OP = 'DELETE') THEN
    RETURN OLD;
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE FUNCTION launchql_jobs.tg_add_job_with_row_id (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    PERFORM
      "launchql_jobs".add_job (tg_argv[0], json_build_object('id', NEW.id));
    RETURN NEW;
  END IF;
  IF (TG_OP = 'DELETE') THEN
    PERFORM
      "launchql_jobs".add_job (tg_argv[0], json_build_object('id', OLD.id));
    RETURN OLD;
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

COMMENT ON FUNCTION launchql_jobs.tg_add_job_with_row_id IS E'Useful shortcut to create a job on insert or update. Pass the task name as the trigger argument, and the record id will automatically be available on the JSON payload.';

CREATE FUNCTION launchql_jobs.tg_add_job_with_row (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    PERFORM
      "launchql_jobs".add_job (TG_ARGV[0], to_json(NEW));
    RETURN NEW;
  END IF;
  IF (TG_OP = 'DELETE') THEN
    PERFORM
      "launchql_jobs".add_job (TG_ARGV[0], to_json(OLD));
    RETURN OLD;
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

COMMENT ON FUNCTION launchql_jobs.tg_add_job_with_row IS E'Useful shortcut to create a job on insert or update. Pass the task name as the trigger argument, and the record data will automatically be available on the JSON payload.';

GRANT USAGE ON SCHEMA launchql_private TO authenticated;

GRANT USAGE ON SCHEMA launchql_private TO anonymous;

CREATE TABLE launchql_private.api_tokens (
  
);

ALTER TABLE launchql_private.api_tokens DISABLE ROW LEVEL SECURITY;

ALTER TABLE launchql_private.api_tokens ADD COLUMN  id uuid;

ALTER TABLE launchql_private.api_tokens ALTER COLUMN id SET NOT NULL;

ALTER TABLE launchql_private.api_tokens ALTER COLUMN id SET DEFAULT launchql_private.uuid_generate_v4();

ALTER TABLE launchql_private.api_tokens ADD COLUMN  user_id uuid;

ALTER TABLE launchql_private.api_tokens ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE launchql_private.api_tokens ADD COLUMN  access_token text;

ALTER TABLE launchql_private.api_tokens ALTER COLUMN access_token SET NOT NULL;

ALTER TABLE launchql_private.api_tokens ALTER COLUMN access_token SET DEFAULT encode(gen_random_bytes(48), 'hex');

ALTER TABLE launchql_private.api_tokens ADD COLUMN  access_token_expires_at timestamptz;

CREATE FUNCTION launchql_private.authenticate ( token_str text ) RETURNS SETOF launchql_private.api_tokens AS $EOFCODE$
SELECT
    tkn.*
FROM
    "launchql_private".api_tokens AS tkn
WHERE
    tkn.access_token = authenticate.token_str
    AND EXTRACT(EPOCH FROM (tkn.access_token_expires_at-NOW())) > 0;
$EOFCODE$ LANGUAGE sql STABLE SECURITY DEFINER;

CREATE FUNCTION launchql_private.uuid_generate_seeded_uuid ( seed text ) RETURNS uuid AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION launchql_private.seeded_uuid_related_trigger (  ) RETURNS trigger AS $EOFCODE$
DECLARE
    _seed_column text := to_json(NEW) ->> TG_ARGV[1];
BEGIN
    IF _seed_column IS NULL THEN
        RAISE EXCEPTION 'UUID seed is NULL on table %', TG_TABLE_NAME;
    END IF;
    NEW := NEW #= (TG_ARGV[0] || '=>' || "launchql_private".uuid_generate_seeded_uuid(_seed_column))::hstore;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

GRANT EXECUTE ON FUNCTION launchql_private.uuid_generate_v4 TO PUBLIC;

GRANT EXECUTE ON FUNCTION launchql_private.uuid_generate_seeded_uuid TO PUBLIC;

GRANT EXECUTE ON FUNCTION launchql_private.seeded_uuid_related_trigger TO PUBLIC;

CREATE TABLE launchql_private.user_encrypted_secrets (
  
);

ALTER TABLE launchql_private.user_encrypted_secrets DISABLE ROW LEVEL SECURITY;

ALTER TABLE launchql_private.user_encrypted_secrets ADD COLUMN  id uuid;

ALTER TABLE launchql_private.user_encrypted_secrets ALTER COLUMN id SET NOT NULL;

ALTER TABLE launchql_private.user_encrypted_secrets ALTER COLUMN id SET DEFAULT launchql_private.uuid_generate_v4();

ALTER TABLE launchql_private.user_encrypted_secrets ADD COLUMN  user_id uuid;

ALTER TABLE launchql_private.user_encrypted_secrets ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE launchql_private.user_encrypted_secrets ADD COLUMN  name text;

ALTER TABLE launchql_private.user_encrypted_secrets ALTER COLUMN name SET NOT NULL;

ALTER TABLE launchql_private.user_encrypted_secrets ADD COLUMN  value bytea;

ALTER TABLE launchql_private.user_encrypted_secrets ADD COLUMN  enc text;

ALTER TABLE launchql_private.user_encrypted_secrets ADD CONSTRAINT user_encrypted_secrets_pkey PRIMARY KEY ( id );

ALTER TABLE launchql_private.user_encrypted_secrets ADD CONSTRAINT user_encrypted_secrets_user_id_name_key UNIQUE ( user_id, name );

CREATE FUNCTION launchql_private.user_encrypted_secrets_hash (  ) RETURNS trigger AS $EOFCODE$
BEGIN
   
IF (NEW.enc = 'crypt') THEN
    NEW.value = crypt(NEW.value::text, gen_salt('bf'));
ELSIF (NEW.enc = 'pgp') THEN
    NEW.value = pgp_sym_encrypt(encode(NEW.value::bytea, 'hex'), NEW.user_id::text, 'compress-algo=1, cipher-algo=aes256');
ELSE
    NEW.enc = 'none';
END IF;
RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER user_encrypted_secrets_update_tg 
 BEFORE UPDATE ON launchql_private.user_encrypted_secrets 
 FOR EACH ROW
 WHEN ( NEW.value IS DISTINCT FROM OLD.value ) 
 EXECUTE PROCEDURE launchql_private. user_encrypted_secrets_hash (  );

CREATE TRIGGER user_encrypted_secrets_insert_tg 
 BEFORE INSERT ON launchql_private.user_encrypted_secrets 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_private. user_encrypted_secrets_hash (  );

CREATE FUNCTION launchql_private.user_encrypted_secrets_select ( user_id uuid, secret_name text, allow_null boolean DEFAULT (TRUE) ) RETURNS text AS $EOFCODE$
DECLARE
  v_secret "launchql_private".user_encrypted_secrets;
BEGIN
  SELECT
    *
  FROM
    "launchql_private".user_encrypted_secrets s
  WHERE
    s.name = user_encrypted_secrets_select.secret_name
    AND s.user_id = user_encrypted_secrets_select.user_id INTO v_secret;
  IF (NOT FOUND) THEN
    IF (user_encrypted_secrets_select.allow_null) THEN
      RETURN NULL;
    END IF;
    RAISE EXCEPTION 'GENERIC_NO_OBJECT_EXISTS';
  END IF;
  
  IF (v_secret.enc = 'crypt') THEN
    RETURN convert_from(v_secret.value, 'SQL_ASCII');
  ELSIF (v_secret.enc = 'pgp') THEN
    RETURN convert_from(decode(pgp_sym_decrypt(v_secret.value, v_secret.user_id::text), 'hex'), 'SQL_ASCII');
  END IF;
  RETURN convert_from(v_secret.value, 'SQL_ASCII');
END
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION launchql_private.user_encrypted_secrets_verify ( user_id uuid, secret_name text, secret_value text ) RETURNS boolean AS $EOFCODE$
DECLARE
  v_secret_text text;
  v_secret "launchql_private".user_encrypted_secrets;
BEGIN
  SELECT
    *
  FROM
    "launchql_private".user_encrypted_secrets_select (user_encrypted_secrets_verify.user_id, user_encrypted_secrets_verify.secret_name)
  INTO v_secret_text;
  SELECT
    *
  FROM
    "launchql_private".user_encrypted_secrets s
  WHERE
    s.name = user_encrypted_secrets_verify.secret_name
    AND s.user_id = user_encrypted_secrets_verify.user_id INTO v_secret;
  IF (v_secret.enc = 'crypt') THEN
    RETURN v_secret_text = crypt(user_encrypted_secrets_verify.secret_value::bytea::text, v_secret_text);
  ELSIF (v_secret.enc = 'pgp') THEN
    RETURN user_encrypted_secrets_verify.secret_value = v_secret_text;
  END IF;
  RETURN user_encrypted_secrets_verify.secret_value = v_secret_text;
END
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION launchql_private.user_encrypted_secrets_upsert ( v_user_id uuid, secret_name text, secret_value text, field_encoding text DEFAULT 'pgp' ) RETURNS boolean AS $EOFCODE$
BEGIN
  INSERT INTO "launchql_private".user_encrypted_secrets (user_id, name, value, enc)
    VALUES (v_user_id, user_encrypted_secrets_upsert.secret_name, user_encrypted_secrets_upsert.secret_value::bytea, user_encrypted_secrets_upsert.field_encoding)
    ON CONFLICT (user_id, name)
    DO
    UPDATE
    SET
      value = EXCLUDED.value;
  RETURN TRUE;
END
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

ALTER TABLE launchql_private.api_tokens ALTER COLUMN access_token_expires_at SET NOT NULL;

ALTER TABLE launchql_private.api_tokens ALTER COLUMN access_token_expires_at SET DEFAULT ((now()) + ('30 days'::interval));

ALTER TABLE launchql_private.api_tokens ADD CONSTRAINT api_tokens_pkey PRIMARY KEY ( id );

ALTER TABLE launchql_private.api_tokens ADD CONSTRAINT api_tokens_access_token_key UNIQUE ( access_token );

CREATE TABLE launchql_private.user_secrets (
  
);

ALTER TABLE launchql_public.users ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_insert_on_users ON launchql_public.users FOR INSERT TO authenticated WITH CHECK ( ((id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_update_on_users ON launchql_public.users FOR UPDATE TO authenticated USING ( ((id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_delete_on_users ON launchql_public.users FOR DELETE TO authenticated USING ( ((id) = (launchql_public.get_current_user_id())) );

GRANT INSERT ON TABLE launchql_public.users TO authenticated;

GRANT UPDATE ON TABLE launchql_public.users TO authenticated;

GRANT DELETE ON TABLE launchql_public.users TO authenticated;

CREATE POLICY authenticated_can_select_on_users ON launchql_public.users FOR SELECT TO authenticated USING ( (TRUE) );

GRANT SELECT ON TABLE launchql_public.users TO authenticated;

ALTER TABLE launchql_private.user_encrypted_secrets ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_user_encrypted_secrets ON launchql_private.user_encrypted_secrets FOR SELECT TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_insert_on_user_encrypted_secrets ON launchql_private.user_encrypted_secrets FOR INSERT TO authenticated WITH CHECK ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_update_on_user_encrypted_secrets ON launchql_private.user_encrypted_secrets FOR UPDATE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_delete_on_user_encrypted_secrets ON launchql_private.user_encrypted_secrets FOR DELETE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

GRANT SELECT ON TABLE launchql_private.user_encrypted_secrets TO authenticated;

GRANT INSERT ON TABLE launchql_private.user_encrypted_secrets TO authenticated;

GRANT UPDATE ON TABLE launchql_private.user_encrypted_secrets TO authenticated;

GRANT DELETE ON TABLE launchql_private.user_encrypted_secrets TO authenticated;

ALTER TABLE launchql_private.user_secrets ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_user_secrets ON launchql_private.user_secrets FOR SELECT TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_insert_on_user_secrets ON launchql_private.user_secrets FOR INSERT TO authenticated WITH CHECK ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_update_on_user_secrets ON launchql_private.user_secrets FOR UPDATE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_delete_on_user_secrets ON launchql_private.user_secrets FOR DELETE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

GRANT SELECT ON TABLE launchql_private.user_secrets TO authenticated;

GRANT INSERT ON TABLE launchql_private.user_secrets TO authenticated;

GRANT UPDATE ON TABLE launchql_private.user_secrets TO authenticated;

GRANT DELETE ON TABLE launchql_private.user_secrets TO authenticated;

ALTER TABLE launchql_private.api_tokens ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_api_tokens ON launchql_private.api_tokens FOR SELECT TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_insert_on_api_tokens ON launchql_private.api_tokens FOR INSERT TO authenticated WITH CHECK ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_update_on_api_tokens ON launchql_private.api_tokens FOR UPDATE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_delete_on_api_tokens ON launchql_private.api_tokens FOR DELETE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

GRANT SELECT ON TABLE launchql_private.api_tokens TO authenticated;

GRANT INSERT ON TABLE launchql_private.api_tokens TO authenticated;

GRANT UPDATE ON TABLE launchql_private.api_tokens TO authenticated;

GRANT DELETE ON TABLE launchql_private.api_tokens TO authenticated;

ALTER TABLE launchql_private.user_secrets DISABLE ROW LEVEL SECURITY;

ALTER TABLE launchql_private.user_secrets ADD COLUMN  id uuid;

ALTER TABLE launchql_private.user_secrets ALTER COLUMN id SET NOT NULL;

ALTER TABLE launchql_private.user_secrets ALTER COLUMN id SET DEFAULT launchql_private.uuid_generate_v4();

ALTER TABLE launchql_private.user_secrets ADD COLUMN  user_id uuid;

ALTER TABLE launchql_private.user_secrets ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE launchql_private.user_secrets ADD COLUMN  name text;

ALTER TABLE launchql_private.user_secrets ALTER COLUMN name SET NOT NULL;

ALTER TABLE launchql_private.user_secrets ADD COLUMN  value text;

ALTER TABLE launchql_private.user_secrets ADD CONSTRAINT user_secrets_pkey PRIMARY KEY ( id );

ALTER TABLE launchql_private.user_secrets ADD CONSTRAINT user_secrets_user_id_name_key UNIQUE ( user_id, name );

CREATE FUNCTION launchql_private.immutable_field_tg (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  IF TG_NARGS > 0 THEN
    RAISE EXCEPTION 'IMMUTABLE_PROPERTY %', TG_ARGV[0];
  END IF;
  RAISE EXCEPTION 'IMMUTABLE_PROPERTY';
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION launchql_public.get_current_user_id (  ) RETURNS uuid AS $EOFCODE$
DECLARE
  v_identifier_id uuid;
BEGIN
  IF current_setting('jwt.claims.user_id', TRUE)
    IS NOT NULL THEN
    BEGIN
      v_identifier_id = current_setting('jwt.claims.user_id', TRUE)::uuid;
    EXCEPTION
      WHEN OTHERS THEN
      RAISE NOTICE 'Invalid UUID value';
    RETURN NULL;
    END;
    RETURN v_identifier_id;
  ELSE
    RETURN NULL;
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

GRANT EXECUTE ON FUNCTION launchql_public.get_current_user_id TO authenticated;

CREATE FUNCTION launchql_public.get_current_role_ids (  ) RETURNS uuid[] AS $EOFCODE$
DECLARE
  v_identifier_ids uuid[];
BEGIN
  IF current_setting('jwt.claims.user_ids', TRUE)
    IS NOT NULL THEN
    BEGIN
      v_identifier_ids = current_setting('jwt.claims.user_ids', TRUE)::uuid[];
    EXCEPTION
      WHEN OTHERS THEN
      RAISE NOTICE 'Invalid UUID value';
    RETURN ARRAY[]::uuid[];
    END;
    RETURN v_identifier_ids;
  ELSE
    RETURN ARRAY[]::uuid[];
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

GRANT EXECUTE ON FUNCTION launchql_public.get_current_role_ids TO authenticated;

CREATE FUNCTION launchql_public.get_current_user (  ) RETURNS launchql_public.users AS $EOFCODE$
DECLARE
  v_user "launchql_public".users;
BEGIN
  IF "launchql_public".get_current_user_id() IS NOT NULL THEN
     SELECT * FROM "launchql_public".users WHERE id = "launchql_public".get_current_user_id() INTO v_user;
     RETURN v_user;
  ELSE
     RETURN NULL;
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

GRANT EXECUTE ON FUNCTION launchql_public.get_current_user TO authenticated;

CREATE TABLE launchql_public.user_emails (
  
);

CREATE FUNCTION launchql_public.login ( email text, password text ) RETURNS launchql_private.api_tokens AS $EOFCODE$
DECLARE
  v_token "launchql_private".api_tokens;
  v_email "launchql_public".user_emails;
  v_sign_in_attempt_window_duration interval = interval '6 hours';
  v_sign_in_max_attempts int = 10;
  first_failed_password_attempt timestamptz;
  password_attempts int;
BEGIN
  SELECT
    user_emails_alias.*
  FROM
    "launchql_public".user_emails AS user_emails_alias
  WHERE
    user_emails_alias.email = login.email::email INTO v_email;
  
  IF (NOT FOUND) THEN
    RETURN NULL;
  END IF;
  SELECT value FROM "launchql_private".user_secrets t 
    WHERE t.user_id = v_email.user_id
    AND t.name = 'first_failed_password_attempt'
  INTO first_failed_password_attempt;
  
  SELECT value FROM "launchql_private".user_secrets t 
    WHERE t.user_id = v_email.user_id
    AND t.name = 'password_attempts'
  INTO password_attempts;
  IF (
    first_failed_password_attempt IS NOT NULL
      AND
    first_failed_password_attempt > NOW() - v_sign_in_attempt_window_duration
      AND
    password_attempts >= v_sign_in_max_attempts
  ) THEN
    RAISE EXCEPTION 'ACCOUNT_LOCKED_EXCEED_ATTEMPTS';
  END IF;
  IF ("launchql_private".user_encrypted_secrets_verify(v_email.user_id, 'password_hash', PASSWORD)) THEN
    INSERT INTO "launchql_private".api_tokens (user_id)
      VALUES (v_email.user_id)
    RETURNING
      * INTO v_token;
    RETURN v_token;
  ELSE
    IF (password_attempts IS NULL) THEN
      password_attempts = 0;
    END IF;
    IF (
      first_failed_password_attempt IS NULL
        OR
      first_failed_password_attempt < NOW() - v_sign_in_attempt_window_duration
    ) THEN
      password_attempts = 1;
      first_failed_password_attempt = NOW();
    ELSE 
      password_attempts = password_attempts + 1;
    END IF;
    INSERT INTO "launchql_private".user_secrets 
      (user_id, name, value)
    VALUES (v_email.user_id, 'password_attempts', password_attempts)
    ON CONFLICT (user_id, name)
    DO UPDATE 
    SET value = EXCLUDED.value;
    INSERT INTO "launchql_private".user_secrets 
      (user_id, name, value)
    VALUES (v_email.user_id, 'first_failed_password_attempt', first_failed_password_attempt)
    ON CONFLICT (user_id, name)
    DO UPDATE 
    SET value = EXCLUDED.value;
    RETURN NULL;
  END IF;
END;
$EOFCODE$ LANGUAGE plpgsql STRICT SECURITY DEFINER;

CREATE FUNCTION launchql_public.register ( email text, password text ) RETURNS launchql_private.api_tokens AS $EOFCODE$
DECLARE
  v_user "launchql_public".users;
  v_email "launchql_public".user_emails;
  v_token "launchql_private".api_tokens;
BEGIN
  SELECT * FROM "launchql_public".user_emails t
    WHERE trim(register.email)::email = t.email
  INTO v_email;
  IF (NOT FOUND) THEN
    INSERT INTO "launchql_public".users
      DEFAULT VALUES
    RETURNING
      * INTO v_user;
    INSERT INTO "launchql_public".user_emails (user_id, email)
      VALUES (v_user.id, trim(register.email))
    RETURNING
      * INTO v_email;
    INSERT INTO "launchql_private".api_tokens (user_id)
      VALUES (v_user.id)
    RETURNING
      * INTO v_token;
    PERFORM "launchql_private".user_encrypted_secrets_upsert(v_user.id, 'password_hash', password, 'crypt');
    RETURN v_token;
  END IF;
  RAISE EXCEPTION 'ACCOUNT_EXISTS';
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION launchql_public.login TO anonymous;

GRANT EXECUTE ON FUNCTION launchql_public.register TO anonymous;

ALTER TABLE launchql_public.user_emails DISABLE ROW LEVEL SECURITY;

ALTER TABLE launchql_public.user_emails ADD COLUMN  id uuid;

ALTER TABLE launchql_public.user_emails ALTER COLUMN id SET NOT NULL;

ALTER TABLE launchql_public.user_emails ALTER COLUMN id SET DEFAULT launchql_private.uuid_generate_v4();

ALTER TABLE launchql_public.user_emails ADD COLUMN  user_id uuid;

ALTER TABLE launchql_public.user_emails ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE launchql_public.user_emails ADD COLUMN  email email;

ALTER TABLE launchql_public.user_emails ALTER COLUMN email SET NOT NULL;

ALTER TABLE launchql_public.user_emails ADD COLUMN  is_verified boolean;

ALTER TABLE launchql_public.user_emails ALTER COLUMN is_verified SET NOT NULL;

ALTER TABLE launchql_public.user_emails ALTER COLUMN is_verified SET DEFAULT (FALSE);

ALTER TABLE launchql_public.user_emails ADD CONSTRAINT user_emails_pkey PRIMARY KEY ( id );

ALTER TABLE launchql_public.user_emails ADD CONSTRAINT user_emails_email_key UNIQUE ( email );

ALTER TABLE launchql_public.user_emails ENABLE ROW LEVEL SECURITY;

CREATE POLICY authenticated_can_select_on_user_emails ON launchql_public.user_emails FOR SELECT TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_insert_on_user_emails ON launchql_public.user_emails FOR INSERT TO authenticated WITH CHECK ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_update_on_user_emails ON launchql_public.user_emails FOR UPDATE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

CREATE POLICY authenticated_can_delete_on_user_emails ON launchql_public.user_emails FOR DELETE TO authenticated USING ( ((user_id) = (launchql_public.get_current_user_id())) );

GRANT SELECT ON TABLE launchql_public.user_emails TO authenticated;

GRANT INSERT ON TABLE launchql_public.user_emails TO authenticated;

GRANT UPDATE ON TABLE launchql_public.user_emails TO authenticated;

GRANT DELETE ON TABLE launchql_public.user_emails TO authenticated;

ALTER TABLE launchql_public.user_emails ADD CONSTRAINT user_emails_user_id_fkey FOREIGN KEY ( user_id ) REFERENCES launchql_public.users ( id );

CREATE INDEX user_emails_user_id_idx ON launchql_public.user_emails ( user_id );

CREATE TRIGGER user_emails_insert_job_tg 
 AFTER INSERT ON launchql_public.user_emails 
 FOR EACH ROW
 EXECUTE PROCEDURE launchql_jobs. tg_add_job_with_row ( 'new-user-email' );

ALTER TABLE launchql_public.users ALTER COLUMN id SET NOT NULL;

ALTER TABLE launchql_public.users ALTER COLUMN id SET DEFAULT launchql_private.uuid_generate_v4();

ALTER TABLE launchql_public.users ADD COLUMN  type int;

ALTER TABLE launchql_public.users ALTER COLUMN type SET DEFAULT 0;

ALTER TABLE launchql_public.users ADD CONSTRAINT users_pkey PRIMARY KEY ( id );